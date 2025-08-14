// Provides `FlutterSecureStorage` on platforms that support it, and a
// no-op in-memory stub for Wasm builds (no dart:html/js available).

// Use the official package by default; switch to stub only for Wasm runtimes.
export 'package:flutter_secure_storage/flutter_secure_storage.dart'
    if (dart.library.js_interop) 'secure_storage_stub.dart';
