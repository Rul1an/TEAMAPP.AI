#!/usr/bin/env python3
"""YOLOv9 fine-tuning script – VEO-147
=====================================

This helper automates fine-tuning of a pre-trained YOLOv9 model on the
2024/25 football-match dataset.

Key features
------------
1. Uses the **ultralytics** package (>=8.2) for training/inference.
2. Extends the default YOLO augmentations with an *albumentations* stack:
   – HorizontalFlip / VerticalFlip
   – RandomBrightnessContrast
   – RGBShift
   – MotionBlur
   – RandomShadow
3. CLI flags **or** environment variables configure dataset/weights/epochs.
4. Automatically logs metrics to the local *runs/train* folder *and* OpenTelemetry
   (if `OTLP_ENDPOINT` is set) via the lightweight *otel_helper* util.

Example:
    python3 ai/train_yolov9.py \
        --data ./data/match_2024_25.yaml \
        --weights yolov9c.pt \
        --epochs 120 \
        --batch 16 \
        --img 1280
"""
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path
from typing import Any, Dict

# Third-party imports – make sure to add to requirements.txt
try:
    from ultralytics import YOLO  # type: ignore
except ImportError as exc:  # pragma: no cover
    print("[ERROR] ultralytics not installed. Run `pip install -r ai/requirements.txt`.")
    raise exc

# Albumentations is *optional* – script falls back to default aug if missing.
try:
    import albumentations as A  # type: ignore
except ImportError:  # pragma: no cover
    A = None  # type: ignore

# Lightweight OTEL helper (optional)
try:
    from otel_helper import otc  # type: ignore – local util may not exist yet
except Exception:  # pragma: no cover
    otc = None  # type: ignore


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Fine-tune YOLOv9 on football dataset")
    p.add_argument("--data", type=str, default=os.getenv("DATA_YAML"), help="dataset YAML path")
    p.add_argument("--weights", type=str, default=os.getenv("WEIGHTS", "yolov9c.pt"))
    p.add_argument("--epochs", type=int, default=int(os.getenv("EPOCHS", "100")))
    p.add_argument("--batch", type=int, default=int(os.getenv("BATCH", "16")))
    p.add_argument("--img", type=int, default=int(os.getenv("IMG", "1280")), help="img size")
    p.add_argument("--device", type=str, default=os.getenv("DEVICE", "cuda:0"))
    p.add_argument("--project", type=str, default=os.getenv("OUTPUT_DIR", "runs/train"))
    p.add_argument("--name", type=str, default="yolov9_finetune")
    p.add_argument("--cache", action="store_true", help="cache images for speed")
    return p


def default_overrides() -> Dict[str, Any]:
    """Return new-augmentation overrides compatible with Ultralytics."""
    return {
        # Color / geometric aug
        "hsv_h": 0.015,
        "hsv_s": 0.7,
        "hsv_v": 0.4,
        "degrees": 5.0,
        "translate": 0.05,
        "scale": 0.1,
        "shear": 2.0,
        "perspective": 0.0005,
        "flipud": 0.1,
        "fliplr": 0.5,
        # MixUp & Mosaic probabilities
        "mosaic": 1.0,
        "mixup": 0.2,
    }


def build_albumentations() -> "A.Compose | None":  # type: ignore
    if A is None:
        print("[WARN] albumentations not available – skipping extra aug.")
        return None

    return A.Compose(
        [
            A.HorizontalFlip(p=0.5),
            A.VerticalFlip(p=0.1),
            A.RandomBrightnessContrast(p=0.3),
            A.RGBShift(r_shift_limit=15, g_shift_limit=15, b_shift_limit=15, p=0.2),
            A.MotionBlur(blur_limit=5, p=0.1),
            A.RandomShadow(p=0.1),
        ],
        bbox_params=A.BboxParams(format="yolo", label_fields=["class_labels"]),
    )


def main(argv: list[str] | None = None) -> None:
    args = build_parser().parse_args(argv)

    if args.data is None:
        print("[ERROR] --data not specified and DATA_YAML env missing.")
        sys.exit(1)

    data_path = Path(args.data).expanduser().resolve()
    if not data_path.exists():
        print(f"[ERROR] dataset yaml not found: {data_path}")
        sys.exit(1)

    output_dir = Path(args.project).expanduser().resolve()

    # Load model
    model = YOLO(args.weights)

    overrides = default_overrides()
    overrides.update(
        {
            "cache": args.cache,
            "device": args.device,
            "epochs": args.epochs,
            "batch": args.batch,
            "imgsz": args.img,
        }
    )

    # Hook albumentations if available – Ultralytics accepts custom transforms via callbacks.
    albumentations_tf = build_albumentations()
    if albumentations_tf is not None:
        # Register callback – Ultralytics uses dict key 'augment' in overrides as callable
        overrides["augment"] = albumentations_tf  # type: ignore

    print("[INFO] Starting training…")
    results = model.train(
        data=str(data_path),
        project=str(output_dir),
        name=args.name,
        exist_ok=True,
        **overrides,
    )

    print(results)

    if otc is not None and (span := otc.start_span("yolov9.train")):
        span.set_attribute("epochs", args.epochs)
        span.set_attribute("batch", args.batch)
        span.end()


if __name__ == "__main__":
    main()