# YOLO-V9 Fine-Tuning Pipeline (VEO-147)

This document describes how to reproduce the fine-tuning run for YOLO-V9 on the **2024/25 match-footage** dataset.

## 1 – Setup

```bash
# Create a virtualenv (recommended)
python -m venv .venv
source .venv/bin/activate

# Install reqs
pip install -r ai/requirements.txt
```

> **GPU note**   Training is optimised for **A100 80 GB** but falls back to CPU if no GPU is found (⚠️ very slow).

## 2 – Dataset Layout

```
match_dataset/
 ├─ images/
 │   ├─ train/  # 31 k JPGs 1280×720
 │   ├─ val/    # 2 k  JPGs
 │   └─ test/   # 1 k  JPGs
 ├─ labels/
 │   ├─ train/  # YOLO txt
 │   ├─ val/
 │   └─ test/
 └─ match_2024_25.yaml  # dataset definition
```

Sample `match_2024_25.yaml`:
```yaml
train: ./images/train
val:   ./images/val
test:  ./images/test

nc: 8  # number of classes
names: [player, ball, referee, goal, line, corner_flag, coach, crowd]
```

## 3 – Augmentation Stack ⤵︎
| Stage | Prob.| Description |
|-------|------|-------------|
| Horizontal / Vertical Flip | 0.5 / 0.1 | Base orientation aug |
| RandomBrightnessContrast   | 0.3 | Lighting variability |
| RGBShift                   | 0.2 | Camera white-balance drift |
| MotionBlur                 | 0.1 | Match camera panning |
| RandomShadow               | 0.1 | Flood-light + shadow artefacts |
| Mosaic / MixUp (Ultralytics) | 1.0 / 0.2 | Contextual augmentation |

Parameters live in `ai/train_yolov9.py` → `default_overrides()`.

## 4 – Running Training

```bash
python ai/train_yolov9.py \
  --data ./match_dataset/match_2024_25.yaml \
  --weights yolov9c.pt \
  --epochs 120 \
  --batch 16 \
  --img 1280 \
  --device cuda:0
```

Flags may be provided via env-vars (`DATA_YAML`, `WEIGHTS`, …) to simplify CI jobs.

## 5 – Outputs
* Checkpoints under `runs/train/yolov9_finetune/weights/`
  * `best.pt` – best mAP@0.5 model
  * `last.pt` – last epoch
* TensorBoard → `runs/train/yolov9_finetune/`  (*ultralytics* auto-logs)
* OpenTelemetry spans (if `OTLP_ENDPOINT` set) for **training.duration** & **epoch metrics**.

## 6 – Quality Gate
The model is considered **ready to integrate** when:

| Metric                    | Target |
|---------------------------|--------|
| mAP@0.5 (val)             | ≥ 0.92 |
| Top-5 accuracy (val)      | +8 pp  vs baseline |
| Training budget           | ≤ 18 GPU-hrs |

## 7 – Troubleshooting

* **CUDA OOM** → Reduce `--batch` or `--img`.
* **Albumentations import error** → `pip install -r ai/requirements.txt`.
* **Slow IO** → Pass `--cache` to cache images in RAM/SSD.
* **OpenTelemetry export fails** → Check `OTLP_ENDPOINT` and network ACL.

## 8 – Next Steps

1. Export best checkpoint to **ONNX** for real-time inference (VEO-149).
2. Benchmark latency on **C7g-metal** & **iOS** targets.
3. Shadow-deploy & monitor drift via Observability stack.