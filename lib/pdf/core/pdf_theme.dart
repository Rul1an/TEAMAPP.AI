import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Shared VOAB colour palette & text styles for PDF generators.
class PdfTheme {
  PdfTheme._();

  // Colours
  static const PdfColor primary = PdfColor.fromInt(0xFF1976D2);
  static const PdfColor background = PdfColor.fromInt(0xFFF5F5F5);
  static const PdfColor grey = PdfColor.fromInt(0xFF757575);

  // Text styles (will be completed by generators when fonts loaded)
  static pw.TextStyle header(pw.Font bold) => pw.TextStyle(
        font: bold,
        fontSize: 18,
        color: PdfColors.white,
      );

  static pw.TextStyle body(pw.Font regular) => pw.TextStyle(
        font: regular,
        fontSize: 10,
        color: PdfColors.black,
      );
}
