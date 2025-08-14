// Provides `FlutterSecureStorage` on platforms that support it, and a
// no-op in-memory stub for Wasm builds where `dart:html` / platform
// channels are unavailable.

export 'package:flutter_secure_storage/flutter_secure_storage.dart'
    if (dart.library.io) 'package/flutter_secure_storage/flutter_secure_storage.dart'
    // For browser JS runtime (CanvasKit), allow the official web plugin (still dart2js)
    if (dart.library.html) 'package:flutter_secure_storage/flutter_secure_storage.dart'
    if (dart.library.js) 'package:flutter_secure_storage/flutter_secure_storage.dart'
    // For wasm runtimes (no dart:html/js), use the internal stub
    if (dart.library.js_interop) 'secure_storage_stub.dart';
