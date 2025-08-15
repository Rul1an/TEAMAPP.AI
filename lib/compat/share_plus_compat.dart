// Provides a unified API `SharePlus`/`ShareParams`/`XFile` across platforms.
// - Web/Wasm: exports stub (no-op)
// - Native (Android/iOS/macOS/Windows/Linux): wraps share_plus
export 'share_plus_impl.dart'
    if (dart.library.js_interop) 'share_plus_stub.dart';
