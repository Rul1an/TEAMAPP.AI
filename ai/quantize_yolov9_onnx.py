#!/usr/bin/env python3
"""YOLOv9 → ONNX INT8 export & benchmark – VEO-149
=================================================

This script converts a trained YOLO-V9 PyTorch checkpoint to INT8-quantised
ONNX and optionally benchmarks inference latency on the current machine.

Features
--------
1. Uses **ultralytics** `YOLO.export()` for base ONNX graph generation.
2. Applies **onnxruntime.quantization** (`QOperator` INT8) for weight + activation
   dynamic quantisation.
3. Optionally measures median / p95 latency via **onnxruntime**.
4. Auto-generates model metadata (`model.json`) with SHA256 + metrics – handy for
   supply-chain attestation & drift tracking.

Usage
-----
```bash
python ai/quantize_yolov9_onnx.py \
    --weights runs/train/yolov9_finetune/weights/best.pt \
    --img 1280 \
    --batch 1 \
    --quant int8 \
    --benchmark 100
```
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import tempfile
from datetime import datetime
from pathlib import Path
from statistics import median
from time import perf_counter
from typing import List

import numpy as np
from PIL import Image

from ultralytics import YOLO  # type: ignore
from ultralytics.utils import yaml_load  # type: ignore

from onnxruntime import InferenceSession, SessionOptions  # type: ignore
from onnxruntime.quantization import (  # type: ignore
    QuantType,
    quantize_dynamic,
)


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Export YOLOv9 to quantised ONNX")
    p.add_argument("--weights", required=True, type=str, help="Path to .pt checkpoint")
    p.add_argument("--out", type=str, default="onnx", help="Output dir name")
    p.add_argument("--img", type=int, default=1280, help="Image size (square)")
    p.add_argument("--batch", type=int, default=1, help="Batch size for static shape")
    p.add_argument("--quant", choices=["fp16", "int8", "none"], default="int8")
    p.add_argument("--benchmark", type=int, default=0, help="Run latency benchmark with N random images")
    p.add_argument("--data", type=str, help="dataset yaml to sample benchmark images")
    return p.parse_args()


def export_onnx(pt_path: Path, img: int, batch: int, out_dir: Path) -> Path:
    model = YOLO(str(pt_path))
    onnx_path = model.export(
        format="onnx",
        imgsz=img,
        batch=batch,
        dynamic=False,
        simplify=True,
        project=str(out_dir.parent),
        name=out_dir.name,
        exist_ok=True,
    )  # returns Path
    return Path(onnx_path)


def quantize(model_path: Path, quant: str) -> Path:
    if quant == "none":
        return model_path

    quant_path = model_path.with_stem(model_path.stem + f"_{quant}")

    if quant == "fp16":
        # FP16 conversion via onnxruntime-tools deprecated; use ultralytics built-in.
        import onnxconverter_common  # type: ignore  # noqa: WPS433 – optional dep

        shutil.copy(model_path, quant_path)
        # FP16 graph cast op – fallback to half-precision nodes (quick way)
        from onnxconverter_common.float16 import convert_float_to_float16  # type: ignore

        import onnx  # type: ignore

        model_proto = onnx.load(model_path)
        model_fp16 = convert_float_to_float16(model_proto)
        onnx.save(model_fp16, quant_path)
    else:  # INT8 dynamic
        quantize_dynamic(
            model_input=str(model_path),
            model_output=str(quant_path),
            per_channel=True,
            weight_type=QuantType.QInt8,
            optimize_model=True,
        )

    return quant_path


def _load_random_images(dataset_yaml: Path, img_size: int, n: int) -> List[np.ndarray]:
    ds = yaml_load(str(dataset_yaml))
    imgs_dir = Path(ds["val"])  # use val split for benchmarking
    img_paths = list(imgs_dir.glob("**/*.jpg")) + list(imgs_dir.glob("**/*.png"))
    np.random.shuffle(img_paths)
    imgs = []
    for p in img_paths[:n]:
        img = Image.open(p).convert("RGB").resize((img_size, img_size))
        imgs.append(np.asarray(img, dtype=np.float32) / 255.0)
    return imgs


def benchmark(model_path: Path, img_size: int, n: int, dataset_yaml: Path | None) -> dict:
    so = SessionOptions()
    so.intra_op_num_threads = os.cpu_count() or 1
    sess = InferenceSession(str(model_path), so, providers=["CPUExecutionProvider"])

    in_name = sess.get_inputs()[0].name

    # Build random data if dataset not supplied.
    if dataset_yaml and dataset_yaml.exists():
        inputs = _load_random_images(dataset_yaml, img_size, n)
    else:
        inputs = [np.random.rand(1, 3, img_size, img_size).astype(np.float32) for _ in range(n)]

    times: List[float] = []
    for inp in inputs:
        start = perf_counter()
        sess.run(None, {in_name: inp})
        times.append(perf_counter() - start)

    return {
        "median_ms": median(times) * 1000,
        "p95_ms": np.percentile(times, 95) * 1000,
        "samples": n,
    }


def sha256(file_path: Path) -> str:
    h = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def write_metadata(out_dir: Path, model_file: Path, metrics: dict | None) -> None:
    meta = {
        "file": model_file.name,
        "sha256": sha256(model_file),
        "created": datetime.utcnow().isoformat() + "Z",
        "metrics": metrics or {},
    }
    with open(out_dir / "model.json", "w", encoding="utf-8") as fp:
        json.dump(meta, fp, indent=2)


if __name__ == "__main__":
    args = parse_args()

    weights = Path(args.weights).expanduser().resolve()
    out_dir = Path(args.out).expanduser().resolve()
    out_dir.mkdir(parents=True, exist_ok=True)

    print("[1/4] Exporting ONNX …")
    onnx_file = export_onnx(weights, args.img, args.batch, out_dir)

    print(f"[2/4] Quantising to {args.quant.upper()} …")
    quant_file = quantize(onnx_file, args.quant)

    bench_metrics = None
    if args.benchmark > 0:
        print("[3/4] Benchmarking …")
        ds_yaml = Path(args.data) if args.data else None
        bench_metrics = benchmark(quant_file, args.img, args.benchmark, ds_yaml)
        print("Latency:", bench_metrics)

    print("[4/4] Writing metadata …")
    write_metadata(out_dir, quant_file, bench_metrics)

    print("✅ Done – output:", quant_file)