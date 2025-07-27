#!/usr/bin/env bash
# Quickly builds the web app (CanvasKit) and prints bundle size.
# Usage: ./scripts/dev/measure_bundle.sh
set -euo pipefail
if [ -f "jo17_tactical_manager/pubspec.yaml" ]; then
  cd jo17_tactical_manager
fi
flutter build web --release --no-tree-shake-icons --dart-define=ENVIRONMENT=profile

BUNDLE_SIZE=$(du -sh build/web | cut -f1)
JS_SIZE=$(du -h build/web/flutter.js | cut -f1)
echo "📦 Total build/web size: ${BUNDLE_SIZE} (flutter.js ${JS_SIZE})"
