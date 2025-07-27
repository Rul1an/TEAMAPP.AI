// ignore_for_file: avoid_unused_constructor_parameters
import 'dart:typed_data';
import 'dart:ui' show Rect;

// Minimal stub for Share Plus API on unsupported platforms (e.g. Wasm).
class XFile {
  XFile(this.path) : bytes = null;
  XFile.fromData(Uint8List data, {required String name, String? mimeType})
      : path = name,
        bytes = data;

  final String path;
  final Uint8List? bytes;
}

class Share {
  static Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {}

  static Future<void> shareXFiles(
    List<XFile> files, {
    String? text,
    String? subject,
    String? chooserTitle,
    Rect? sharePositionOrigin,
  }) async {}
}

// For API compatibility
typedef SharePositionOrigin = Rect;
