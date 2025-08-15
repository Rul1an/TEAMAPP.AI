// Wasm-safe stub for share_plus (no-ops). 2025 best practice: compile-time stub.
import 'dart:typed_data';

class XFile {
  final String? path;
  final Uint8List? bytes;
  final String? name;
  final String? mimeType;

  XFile(this.path)
      : bytes = null,
        name = null,
        mimeType = null;

  XFile.fromData(this.bytes, {required this.name, this.mimeType}) : path = null;
}

class ShareParams {
  final List<XFile> files;
  const ShareParams({this.files = const []});
}

class SharePlus {
  SharePlus._();
  static final SharePlus instance = SharePlus._();

  Future<void> share(ShareParams params) async {
    // No-op on wasm; consider adding download fallback upstream.
  }
}
