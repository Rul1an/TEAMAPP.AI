import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/match.dart';
import '../core/pdf_theme.dart';
import '../core/pdf_utils.dart';
import '../pdf_generator.dart';

/// Generates a basic match-report PDF for a single [Match].
class MatchReportPdfGenerator extends PdfGenerator<Match> {
  const MatchReportPdfGenerator();

  @override
  Future<Uint8List> generate(Match match) async {
    final regular = await fonts.regular;
    final bold = await fonts.bold;

    // Create a new PDF document (defaults are fine).
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildHeader(match, bold),
          pw.SizedBox(height: 16),
          _buildMatchInfo(match, regular, bold),
          pw.SizedBox(height: 24),
          pw.Text(
            '— Eind van het voorlopige rapport —',
            style: pw.TextStyle(
              font: regular,
              fontSize: 10,
              color: PdfTheme.grey,
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  // Header -------------------------------------------------------------------
  pw.Widget _buildHeader(Match match, pw.Font bold) => pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfTheme.primary,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Wedstrijd Rapport',
              style: pw.TextStyle(
                  font: bold, fontSize: 18, color: PdfColors.white),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '${match.opponent} – ${PdfUtils.formatDate(match.date)}',
              style: pw.TextStyle(
                  font: bold, fontSize: 12, color: PdfColors.white),
            ),
          ],
        ),
      );

  // Match Info ----------------------------------------------------------------
  pw.Widget _buildMatchInfo(Match match, pw.Font regular, pw.Font bold) {
    final rows = <pw.Widget>[
      _infoRow('Datum', PdfUtils.formatDate(match.date), regular, bold),
      _infoRow('Tijd', DateFormat('HH:mm').format(match.date), regular, bold),
      _infoRow('Locatie', match.location.displayName, regular, bold),
      _infoRow('Tegenstander', match.opponent, regular, bold),
      if (match.teamScore != null && match.opponentScore != null)
        _infoRow(
          'Score',
          '${match.teamScore}-${match.opponentScore}',
          regular,
          bold,
        ),
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfTheme.background,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfTheme.primary),
      ),
      child: pw.Column(children: rows),
    );
  }

  // Helper --------------------------------------------------------------------
  pw.Widget _infoRow(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                '$label:',
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 10,
                  color: PdfTheme.primary,
                ),
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                value,
                style: pw.TextStyle(font: regular, fontSize: 10),
              ),
            ),
          ],
        ),
      );
}
