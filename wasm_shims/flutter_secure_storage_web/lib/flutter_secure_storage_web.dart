// Minimal no-op web plugin shim for WASM builds to avoid dart:html/js

// ignore_for_file: avoid_print

class FlutterSecureStorageWeb {
  static void registerWith([dynamic registrar]) {
    // No-op: wasm-safe shim to satisfy plugin registration without imports
    print('flutter_secure_storage_web wasm shim registered');
  }
}
