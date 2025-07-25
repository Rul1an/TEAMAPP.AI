#!/usr/bin/env bash
# impeller_benchmark.sh — quick-and-dirty helper to benchmark Impeller vs Skia on Android devices.
#
# USAGE
#   ./tools/impeller_benchmark.sh [impeller|vanilla|all]
#
#   impeller  → builds release APK (Impeller default) and runs a profile session, dumps metrics JSON
#   vanilla   → same but with Impeller disabled via --dart-define=DISABLE_IMPELLER=true
#   all (default) → run both variants sequentially
#
# DEPENDENCIES
#   • Android SDK + adb in $PATH
#   • At least one Android device/emulator connected + authorised.
#   • Flutter stable channel >= 3.22
#
# OUTPUT
#   For every run a metrics file is written to build/benchmarks/ with pattern
#   {variant}-{device_serial}.json containing FPS, 99% FPS, CPU%, GPU%, mem.
#
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$APP_DIR"

VARIANT="${1:-all}"

run_single() {
  local variant="$1"
  local build_name="app-${variant}.apk"
  local build_dir="build/benchmarks"
  mkdir -p "$build_dir"

  echo "🏗  Building $variant APK…"
  if [[ "$variant" == "vanilla" ]]; then
    flutter build apk --release --dart-define=DISABLE_IMPELLER=true -t lib/main.dart -o build/app/outputs/flutter_apk/${build_name}
  else
    flutter build apk --release -t lib/main.dart -o build/app/outputs/flutter_apk/${build_name}
  fi

  # Find first connected device (use ANDROID_SERIAL to override)
  local device="${ANDROID_SERIAL:-$(adb devices | awk 'NR==2 {print $1}') }"
  if [[ -z "$device" ]]; then
    echo "❌  No Android device/emulator detected via adb. Aborting benchmarking."
    exit 1
  fi
  echo "📱  Using device: $device"

  # Install APK
  adb -s "$device" install -r "build/app/outputs/flutter_apk/${build_name}" >/dev/null

  # Profile run – capture benchmark JSON (Flutter writes to stdout)
  echo "🚀  Launching profile run – this will take ~30s…"
  flutter run --profile --trace-systrace --device-id "$device" -t lib/main.dart \
    ${variant:+--dart-define=DISABLE_IMPELLER=true} \
    --no-resident --benchmark "${build_dir}/${variant}-${device}.json"

  echo "✅  Metrics saved to ${build_dir}/${variant}-${device}.json"
}

case "$VARIANT" in
  impeller)
    run_single impeller
    ;;
  vanilla)
    run_single vanilla
    ;;
  all)
    run_single impeller
    run_single vanilla
    ;;
  *)
    echo "Unknown variant: $VARIANT (expected impeller | vanilla | all)" >&2
    exit 2
    ;;
esac
