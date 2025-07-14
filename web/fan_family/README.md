# Fan & Family Web Flavour

This folder contains flavour-specific web assets used when building the `fan_family` flavour.

Build via:

```bash
flutter build web --release --dart-define=FLAVOR=fan_family -t lib/main_fan.dart --web-renderer canvaskit --output web_build/fan_family
```

> **Note**: Icons currently reuse the base `web/icons/` set. Once marketing delivers fan-specific assets, update the paths in `manifest.json` and `index.html`.