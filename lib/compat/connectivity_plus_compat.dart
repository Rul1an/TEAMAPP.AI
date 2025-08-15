// Provides a unified API for connectivity across platforms.
// - Web/Wasm: exports stub (no-ops)
// - Native: wraps connectivity_plus into a simplified API
export 'connectivity_plus_impl.dart'
    if (dart.library.js_interop) 'connectivity_plus_stub.dart';
