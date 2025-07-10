import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // only used on web

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
        final blob = html.Blob([data], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getTemporaryDirectory();
        final file = io.File('${dir.path}/$filename');
        await file.writeAsBytes(data, flush: true);
        await Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kan PDF niet delen: $e')),
        );
      }
    }
  }
}