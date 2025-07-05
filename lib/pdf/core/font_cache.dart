import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

import '../pdf_assets.dart';

/// Caches fonts so they are loaded only once per application run.
class FontCache {
  FontCache._();
  static final FontCache instance = FontCache._();

  pw.Font? _regular;
  pw.Font? _bold;

  Future<pw.Font> get regular async {
    return _regular ??= await _loadFont(PdfAssets.fontRegular);
  }

  Future<pw.Font> get bold async {
    return _bold ??= await _loadFont(PdfAssets.fontBold);
  }

  Future<pw.Font> _loadFont(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      return pw.Font.ttf(ByteData.view(data.buffer));
    } catch (_) {
      // Fallback for test environments where assets aren't bundled.
      return assetPath == PdfAssets.fontBold
          ? pw.Font.helveticaBold()
          : pw.Font.helvetica();
    }
  }
}
