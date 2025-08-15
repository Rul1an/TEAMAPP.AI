// Native implementation wrapper for share_plus providing a stable API used by the app.
// This file is used on non-web (io) builds.

// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:share_plus/share_plus.dart' as sp;

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
    final List<sp.XFile> xfiles = params.files.map((f) {
      if (f.path != null) {
        return sp.XFile(f.path!);
      }
      return sp.XFile.fromData(
        f.bytes ?? Uint8List(0),
        name: f.name ?? 'file',
        mimeType: f.mimeType,
      );
    }).toList(growable: false);

    final sp.ShareParams nativeParams = sp.ShareParams(files: xfiles);
    await sp.SharePlus.instance.share(nativeParams);
  }
}
