import 'dart:typed_data';

// ignore_for_file: require_trailing_commas, no_leading_underscores_for_local_identifiers

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/assessment.dart';
import '../core/pdf_theme.dart';
import '../core/pdf_utils.dart';
import '../pdf_generator.dart';

/// Generates an assessment report PDF for a single player.
///
/// MVP version – focuses on displaying scores and free-text notes.
class PlayerAssessmentPdfGenerator extends PdfGenerator<PlayerAssessment> {
  const PlayerAssessmentPdfGenerator();

  @override
  Future<Uint8List> generate(PlayerAssessment assessment) async {
    final regular = await fonts.regular;
    final bold = await fonts.bold;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildHeader(assessment, bold),
          pw.SizedBox(height: 16),
          _buildOverview(assessment, regular, bold),
          pw.SizedBox(height: 16),
          _buildSkillsSection(
            'Technisch',
            assessment.technicalSkills,
            regular,
            bold,
          ),
          pw.SizedBox(height: 12),
          _buildSkillsSection(
            'Tactisch',
            assessment.tacticalSkills,
            regular,
            bold,
          ),
          pw.SizedBox(height: 12),
          _buildSkillsSection(
            'Fysiek',
            assessment.physicalAttributes,
            regular,
            bold,
          ),
          pw.SizedBox(height: 12),
          _buildSkillsSection(
            'Mentaal',
            assessment.mentalAttributes,
            regular,
            bold,
          ),
          if (assessment.strengths != null ||
              assessment.areasForImprovement != null ||
              assessment.developmentGoals != null) ...[
            pw.SizedBox(height: 16),
            _buildNotesSection(assessment, regular, bold),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  // --------------------------------------------------------------------------
  // Header
  // --------------------------------------------------------------------------
  pw.Widget _buildHeader(PlayerAssessment a, pw.Font bold) => pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: PdfTheme.primary,
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Spelersbeoordeling', style: PdfTheme.header(bold)),
        pw.SizedBox(height: 4),
        pw.Text(
          'Speler ID: ${a.playerId}',
          style: pw.TextStyle(font: bold, fontSize: 12, color: PdfColors.white),
        ),
      ],
    ),
  );

  // --------------------------------------------------------------------------
  // Overview block (date, type, averages)
  // --------------------------------------------------------------------------
  pw.Widget _buildOverview(PlayerAssessment a, pw.Font regular, pw.Font bold) {
    final rows = <pw.Widget>[
      _infoRow('Datum', PdfUtils.formatDate(a.assessmentDate), regular, bold),
      _infoRow('Type', a.type.displayName, regular, bold),
      _infoRow(
        'Totaalscore',
        a.overallAverage.toStringAsFixed(1),
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

  // --------------------------------------------------------------------------
  // Skills Table Section
  // --------------------------------------------------------------------------
  pw.Widget _buildSkillsSection(
    String title,
    Map<String, int> skills,
    pw.Font regular,
    pw.Font bold,
  ) {
    final rows = skills.entries
        .map(
          (e) => pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Text(
                  e.key,
                  style: pw.TextStyle(font: regular, fontSize: 10),
                ),
              ),
              pw.Text(
                e.value.toString(),
                style: pw.TextStyle(font: bold, fontSize: 10),
              ),
            ],
          ),
        )
        .toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: bold,
            fontSize: 12,
            color: PdfTheme.primary,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Table(
          columnWidths: {1: const pw.FixedColumnWidth(30)},
          border: pw.TableBorder.all(color: PdfTheme.grey, width: 0.5),
          children: rows,
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Free-text notes
  // --------------------------------------------------------------------------
  pw.Widget _buildNotesSection(
    PlayerAssessment a,
    pw.Font regular,
    pw.Font bold,
  ) {
    pw.Widget _note(String heading, String? text) =>
        text == null || text.isEmpty
        ? pw.Container()
        : pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                heading,
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 12,
                  color: PdfTheme.primary,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(text, style: pw.TextStyle(font: regular, fontSize: 10)),
              pw.SizedBox(height: 8),
            ],
          );

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfTheme.background,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfTheme.primary),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _note('Sterke punten', a.strengths),
          _note('Verbeterpunten', a.areasForImprovement),
          _note('Ontwikkeldoelen', a.developmentGoals),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Helper row
  // --------------------------------------------------------------------------
  pw.Widget _infoRow(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold,
  ) => pw.Padding(
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
