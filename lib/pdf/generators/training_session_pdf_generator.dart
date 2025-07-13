// ignore_for_file: always_put_required_named_parameters_first

import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/player.dart';
import '../../models/training_session/player_attendance.dart';
import '../../models/training_session/session_phase.dart';
import '../../models/training_session/training_session.dart';
import '../pdf_generator.dart';

/// Generates a VOAB-style PDF report for a single [TrainingSession].
///
/// Note: This logic was extracted from the legacy `PDFService.generateTrainingSessionReport`
/// to follow the single-responsibility principle (2025 best practices).
class TrainingSessionPdfGenerator
    extends PdfGenerator<(TrainingSession, List<Player>)> {
  const TrainingSessionPdfGenerator();

  @override
  Future<Uint8List> generate((TrainingSession, List<Player>) input) async {
    final (session, players) = input;

    final pdf = pw.Document();

    // VOAB color palette
    const primaryColor = PdfColor.fromInt(0xFF1976D2);
    const backgroundColor = PdfColor.fromInt(0xFFF5F5F5);
    const greyColor = PdfColor.fromInt(0xFF757575);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildTrainingHeader(session, primaryColor),
          pw.SizedBox(height: 20),
          _buildTrainingInfoSection(session, primaryColor, backgroundColor),
          pw.SizedBox(height: 16),
          _buildPlayersSection(session, players, primaryColor, backgroundColor),
          pw.SizedBox(height: 16),
          _buildObjectivesSection(session, primaryColor, backgroundColor),
          pw.SizedBox(height: 16),
          _buildTrainingPhasesSection(session, primaryColor, backgroundColor),
          pw.Spacer(),
          _buildTrainingFooter(session, greyColor),
        ],
      ),
    );

    return pdf.save();
  }

  // ---------------------------------------------------------------------------
  // Widget builders (ported from legacy PDFService)
  // ---------------------------------------------------------------------------

  pw.Widget _buildTrainingHeader(
    TrainingSession session,
    PdfColor primaryColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: primaryColor,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'VOAB TRAININGSVOORBEREIDING',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'JO17 Tactical Manager',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(16),
                ),
                child: pw.Text(
                  'Training ${session.trainingNumber}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            '${DateFormat('EEEE d MMMM yyyy').format(session.date)} | ${session.sessionDuration.inMinutes} minuten',
            style: const pw.TextStyle(fontSize: 14, color: PdfColors.white),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTrainingInfoSection(
    TrainingSession session,
    PdfColor primaryColor,
    PdfColor backgroundColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: primaryColor),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(width: 4, height: 16, color: primaryColor),
              pw.SizedBox(width: 8),
              pw.Text(
                'TRAINING INFORMATIE',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      'Datum:',
                      DateFormat('dd-MM-yyyy').format(session.date),
                    ),
                    pw.SizedBox(height: 6),
                    _buildInfoRow(
                      'Training Nr:',
                      session.trainingNumber.toString(),
                    ),
                    pw.SizedBox(height: 6),
                    _buildInfoRow('Type:', _getTrainingTypeText(session.type)),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Tijd:', '18:00 - 20:10 (130 min)'),
                    pw.SizedBox(height: 6),
                    _buildInfoRow(
                      'Fasen:',
                      '${session.phases.length} training fasen',
                    ),
                    pw.SizedBox(height: 6),
                    _buildInfoRow('Status:', 'VOAB Compliant ✓'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPlayersSection(
    TrainingSession session,
    List<Player> allPlayers,
    PdfColor primaryColor,
    PdfColor backgroundColor,
  ) {
    final presentPlayers = allPlayers
        .where(
          (p) => session.playerAttendance.values.any(
            (a) => a.playerId == p.id && a.status == AttendanceStatus.present,
          ),
        )
        .toList();
    final absentPlayers = allPlayers
        .where(
          (p) => session.playerAttendance.values.any(
            (a) => a.playerId == p.id && a.status == AttendanceStatus.absent,
          ),
        )
        .toList();

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: primaryColor),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(width: 4, height: 16, color: primaryColor),
              pw.SizedBox(width: 8),
              pw.Text(
                'SPELERS AANWEZIGHEID',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: const PdfColor.fromInt(0xFF4CAF50),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        'AANWEZIG (${presentPlayers.length})',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    ...presentPlayers.map(
                      (player) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 3),
                        child: pw.Text(
                          '${player.jerseyNumber}. ${player.firstName} ${player.lastName} (${_getPositionAbbreviation(player.position)})',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: const PdfColor.fromInt(0xFFF44336),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        'AFWEZIG (${absentPlayers.length})',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    ...absentPlayers.map(
                      (player) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 3),
                        child: pw.Text(
                          '${player.jerseyNumber}. ${player.firstName} ${player.lastName}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildObjectivesSection(
    TrainingSession session,
    PdfColor primaryColor,
    PdfColor backgroundColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: primaryColor),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(width: 4, height: 16, color: primaryColor),
              pw.SizedBox(width: 8),
              pw.Text(
                'DOELSTELLINGEN & ACCENT',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          _buildObjectiveItem(
            'Training Doelstelling:',
            session.sessionObjective ?? 'Technisch-tactische ontwikkeling',
          ),
          pw.SizedBox(height: 8),
          _buildObjectiveItem(
            'Team Functie:',
            session.teamFunction ?? 'Positiespel en samenwerking',
          ),
          pw.SizedBox(height: 8),
          _buildObjectiveItem(
            'Coaching Accent:',
            session.coachingAccent ?? 'Individuele begeleiding',
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTrainingPhasesSection(
    TrainingSession session,
    PdfColor primaryColor,
    PdfColor backgroundColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: backgroundColor,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: primaryColor),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(width: 4, height: 16, color: primaryColor),
              pw.SizedBox(width: 8),
              pw.Text(
                'TRAINING FASEN PLANNING',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          ...session.phases.map((phase) {
            final startTime = DateFormat('HH:mm').format(phase.startTime);
            final endTime = DateFormat('HH:mm').format(phase.endTime);

            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _getPhaseColor(phase.type)),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _getPhaseColor(phase.type),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      '$startTime-$endTime',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          phase.name,
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (phase.description?.isNotEmpty ?? false) ...[
                          pw.SizedBox(height: 3),
                          pw.Text(
                            phase.description!,
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        ],
                      ],
                    ),
                  ),
                  pw.Text(
                    '${phase.durationMinutes}m',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildTrainingFooter(TrainingSession session, PdfColor greyColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: greyColor)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Training aangemaakt: ${DateFormat('dd-MM-yyyy HH:mm').format(session.createdAt)}',
                style: pw.TextStyle(fontSize: 9, color: greyColor),
              ),
              pw.Text(
                'VOAB rapport gegenereerd: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 9, color: greyColor),
              ),
            ],
          ),
          pw.Text(
            'JO17 Tactical Manager',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper methods
  // ---------------------------------------------------------------------------

  pw.Widget _buildInfoRow(String label, String value) => pw.Row(
    children: [
      pw.SizedBox(
        width: 60,
        child: pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.Expanded(
        child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
      ),
    ],
  );

  pw.Widget _buildObjectiveItem(String label, String content) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 3),
      pw.Text(content, style: const pw.TextStyle(fontSize: 10)),
    ],
  );

  String _getTrainingTypeText(TrainingType type) {
    switch (type) {
      case TrainingType.regularTraining:
        return 'Reguliere Training';
      case TrainingType.matchPreparation:
        return 'Wedstrijd Voorbereiding';
      case TrainingType.tacticalSession:
        return 'Tactische Sessie';
      case TrainingType.technicalSession:
        return 'Technische Sessie';
      case TrainingType.fitnessSession:
        return 'Fitness Sessie';
      case TrainingType.recoverySession:
        return 'Herstel Training';
      case TrainingType.teamBuilding:
        return 'Teambuilding';
    }
  }

  String _getPositionAbbreviation(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return 'K';
      case Position.defender:
        return 'V';
      case Position.midfielder:
        return 'M';
      case Position.forward:
        return 'A';
    }
  }

  PdfColor _getPhaseColor(PhaseType type) {
    switch (type) {
      case PhaseType.preparation:
        return const PdfColor.fromInt(0xFF9C27B0);
      case PhaseType.warmup:
        return const PdfColor.fromInt(0xFFFF9800);
      case PhaseType.technical:
        return const PdfColor.fromInt(0xFF2196F3);
      case PhaseType.tactical:
        return const PdfColor.fromInt(0xFF4CAF50);
      case PhaseType.main:
        return const PdfColor.fromInt(0xFFF44336);
      case PhaseType.evaluation:
        return const PdfColor.fromInt(0xFF607D8B);
      default:
        return const PdfColor.fromInt(0xFF757575);
    }
  }
}
