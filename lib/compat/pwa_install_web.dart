// Wasm-safe PWA install compatibility layer (no-op)
// This avoids using package:js or unsafe interop during Wasm builds.

import 'dart:async';

Future<bool> isPwaInstallAvailable() async => false;

Future<bool> triggerPwaInstall() async => false;

void ensurePwaInstallSupport() {}
