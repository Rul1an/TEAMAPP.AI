# Impeller Renderer Benchmark – Q3 2025

This document tracks the performance impact of Flutter’s Impeller renderer on JO17 Tactical Manager.

> **Goal**  Quantify FPS and memory differences between Skia (legacy) and Impeller on real devices, and decide if Impeller should remain enabled by default.

## Methodology

| Device Tier | HW & OS | Build Variant | Command | Metrics |
|-------------|---------|---------------|---------|---------|
| Low-end | e.g. Samsung A21s (Android 12) | `flutter run --profile` **w/ Impeller** | `flutter run --profile --android` | Average FPS, 99th-percentile FPS, CPU %, GPU %, Mem (MB) |
| Mid-range | Pixel 6a (Android 14) | **w/o Impeller** | `--dart-define=DISABLE_IMPELLER=true` | … |
| High-end | Pixel 8 Pro (Android 14) | **w/ Impeller** | | … |

Steps:

1. Build profile APKs:
   ```bash
   flutter build apk --profile # Impeller ON (default)
   flutter build apk --profile --dart-define=DISABLE_IMPELLER=true # Impeller OFF
   ```
2. Install & run on device while recording systrace:
   ```bash
   flutter run --profile --trace-systrace
   ```
3. Capture timeline summary (`flutter screenshot --profile`) and memory (`adb shell dumpsys meminfo <package>`).
4. Repeat 3× per scenario; take median.

## Results

| Device | Impeller | Avg FPS | 99p FPS | CPU % | GPU % | Mem (MB) |
|--------|----------|---------|---------|-------|-------|----------|
| _TBD_ | ON |  |  |  |  |  |
| _TBD_ | OFF |  |  |  |  |  |

## Conclusion

*TODO after data collection*

---

_Update scripted by Performance-plan PM5. Remove this banner when finalized._
