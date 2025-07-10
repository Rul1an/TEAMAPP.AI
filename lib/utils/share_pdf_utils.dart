import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:web/web.dart' as web;

import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

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
