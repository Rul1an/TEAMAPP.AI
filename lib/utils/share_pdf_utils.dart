import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// Conditionally import a thin wrapper around `dart:html` on web.
// ignore: conditional_uri_does_not_exist
import 'share_pdf_web.dart'
    if (dart.library.io) 'web_stub.dart' as web;

import 'package:path_provider/path_provider.dart';
// Conditionally import dart:io only on non-web platforms.
// ignore: conditional_uri_does_not_exist
import 'dart:io' as io if (dart.library.html) 'io_stub.dart';

/// Helper to share or download PDF bytes across platforms.
class SharePdfUtils {
  static Future<void> sharePdf(
    Uint8List data,
    String filename,
    BuildContext context,
  ) async {
    try {
      if (kIsWeb) {
        final blob = web.Blob([data], 'application/pdf');
        final url = web.Url.createObjectUrlFromBlob(blob);
        final anchor = web.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        web.Url.revokeObjectUrl(url);
      } else {
        final dir = await getTemporaryDirectory();
        final file = io.File('${dir.path}/$filename');
        await file.writeAsBytes(data, flush: true);
        await Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kan PDF niet delen: $e')));
      }
    }
  }
}
