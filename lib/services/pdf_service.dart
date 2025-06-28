import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/assessment.dart';
import '../models/player.dart';
import '../models/training_session/player_attendance.dart';
import '../models/training_session/session_phase.dart';
import '../models/training_session/training_session.dart';

class PDFService {
  // Generate VOAB-style Training Session PDF
  static Future<Uint8List> generateTrainingSessionReport(
    TrainingSession session,
    List<Player> allPlayers,
  ) async {
    final pdf = pw.Document();

    // VOAB Color scheme
    const primaryColor = PdfColor.fromInt(0xFF1976D2);
    const backgroundColor = PdfColor.fromInt(0xFFF5F5F5);
    const greyColor = PdfColor.fromInt(0xFF757575);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) => [
          _buildTrainingHeader(session, primaryColor),
          pw.SizedBox(height: 20),
          _buildTrainingInfoSection(session, primaryColor, backgroundColor),
          pw.SizedBox(height: 16),
          _buildPlayersSection(
              session, allPlayers, primaryColor, backgroundColor,),
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

  static pw.Widget _buildTrainingHeader(
          TrainingSession session, PdfColor primaryColor,) =>
      pw.Container(
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
                      horizontal: 12, vertical: 6,),
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
              '${DateFormat('EEEE d MMMM yyyy', 'nl_NL').format(session.date)} | ${session.sessionDuration.inMinutes} minuten',
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColors.white,
              ),
            ),
          ],
        ),
      );

  static pw.Widget _buildTrainingInfoSection(TrainingSession session,
          PdfColor primaryColor, PdfColor backgroundColor,) =>
      pw.Container(
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
                      _buildInfoRow('Datum:',
                          DateFormat('dd-MM-yyyy').format(session.date),),
                      pw.SizedBox(height: 6),
                      _buildInfoRow(
                          'Training Nr:', session.trainingNumber.toString(),),
                      pw.SizedBox(height: 6),
                      _buildInfoRow(
                          'Type:', _getTrainingTypeText(session.type),),
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
                          'Fasen:', '${session.phases.length} training fasen',),
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

  static pw.Widget _buildPlayersSection(
      TrainingSession session,
      List<Player> allPlayers,
      PdfColor primaryColor,
      PdfColor backgroundColor,) {
    final presentPlayers = allPlayers
        .where((p) => session.playerAttendance.values.any((a) =>
            a.playerId == p.id.toString() &&
            a.status == AttendanceStatus.present,),)
        .toList();
    final absentPlayers = allPlayers
        .where((p) => session.playerAttendance.values.any((a) =>
            a.playerId == p.id.toString() &&
            a.status == AttendanceStatus.absent,),)
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
                          horizontal: 8, vertical: 4,),
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
                          horizontal: 8, vertical: 4,),
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

  static pw.Widget _buildObjectivesSection(TrainingSession session,
          PdfColor primaryColor, PdfColor backgroundColor,) =>
      pw.Container(
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
            _buildObjectiveItem('Training Doelstelling:',
                session.sessionObjective ?? 'Technisch-tactische ontwikkeling',),
            pw.SizedBox(height: 8),
            _buildObjectiveItem('Team Functie:',
                session.teamFunction ?? 'Positiespel en samenwerking',),
            pw.SizedBox(height: 8),
            _buildObjectiveItem('Coaching Accent:',
                session.coachingAccent ?? 'Individuele begeleiding',),
          ],
        ),
      );

  static pw.Widget _buildTrainingPhasesSection(TrainingSession session,
          PdfColor primaryColor, PdfColor backgroundColor,) =>
      pw.Container(
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
                          horizontal: 8, vertical: 4,),
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
                          if (phase.description?.isNotEmpty == true) ...[
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

  static pw.Widget _buildTrainingFooter(
          TrainingSession session, PdfColor greyColor,) =>
      pw.Container(
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

  // Helper methods for training sessions
  static pw.Widget _buildInfoRow(String label, String value) => pw.Row(
        children: [
          pw.SizedBox(
            width: 60,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      );

  static pw.Widget _buildObjectiveItem(String label, String content) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            content,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      );

  static String _getTrainingTypeText(TrainingType type) {
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

  static String _getPositionAbbreviation(Position position) {
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

  static PdfColor _getPhaseColor(PhaseType type) {
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

  static Future<Uint8List> generateAssessmentReport(
    Player player,
    PlayerAssessment assessment,
  ) async {
    final pdf = pw.Document();

    // Color scheme
    const primaryColor = PdfColor.fromInt(0xFF1976D2);
    const backgroundColor = PdfColor.fromInt(0xFFF5F5F5);
    const greyColor = PdfColor.fromInt(0xFF757575);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => [
          _buildHeader(player, assessment, primaryColor),
          pw.SizedBox(height: 24),
          _buildPlayerInfoCard(player, primaryColor, backgroundColor),
          pw.SizedBox(height: 20),
          _buildAssessmentOverviewCard(
              assessment, primaryColor, backgroundColor,),
          pw.SizedBox(height: 20),
          _buildSkillsBreakdownCard(assessment, primaryColor, backgroundColor),
          pw.SizedBox(height: 20),
          _buildTextFeedbackCard(assessment, primaryColor, backgroundColor),
          pw.Spacer(),
          _buildFooter(assessment, greyColor),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
          Player player, PlayerAssessment assessment, PdfColor primaryColor,) =>
      pw.Container(
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
                      'SPELERASSESSMENT RAPPORT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'JO17 Tactical Manager',
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8,),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.Text(
                    DateFormat('dd-MM-yyyy').format(assessment.assessmentDate),
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              '${player.firstName} ${player.lastName}',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ],
        ),
      );

  static pw.Widget _buildPlayerInfoCard(
          Player player, PdfColor primaryColor, PdfColor backgroundColor,) =>
      pw.Container(
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
                pw.Container(
                  width: 4,
                  height: 20,
                  color: primaryColor,
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  'SPELERSINFORMATIE',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      _buildInfoItem('Rugnummer', '#${player.jerseyNumber}'),
                      pw.SizedBox(height: 8),
                      _buildInfoItem(
                          'Positie', _getPositionName(player.position),),
                      pw.SizedBox(height: 8),
                      _buildInfoItem('Leeftijd', '${player.age} jaar'),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      _buildInfoItem('Geboortedatum',
                          DateFormat('dd-MM-yyyy').format(player.birthDate),),
                      pw.SizedBox(height: 8),
                      _buildInfoItem('Lengte', '${player.height} cm'),
                      pw.SizedBox(height: 8),
                      _buildInfoItem(
                          'Voorkeurvoet',
                          player.preferredFoot == PreferredFoot.left
                              ? 'Links'
                              : 'Rechts',),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  static pw.Widget _buildInfoItem(String label, String value) => pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF757575),
              ),
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromInt(0xFF212121),
            ),
          ),
        ],
      );

  static pw.Widget _buildAssessmentOverviewCard(PlayerAssessment assessment,
          PdfColor primaryColor, PdfColor backgroundColor,) =>
      pw.Container(
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
                pw.Container(
                  width: 4,
                  height: 20,
                  color: primaryColor,
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  'ASSESSMENT OVERZICHT',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Type: ${_getAssessmentTypeText(assessment.type)}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                      pw.SizedBox(height: 12),
                      _buildOverallRatingBox(assessment.overallAverage),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      _buildCategoryRating(
                          'Technisch',
                          assessment.technicalAverage,
                          const PdfColor.fromInt(0xFF2196F3),),
                      pw.SizedBox(height: 8),
                      _buildCategoryRating(
                          'Tactisch',
                          assessment.tacticalAverage,
                          const PdfColor.fromInt(0xFF4CAF50),),
                      pw.SizedBox(height: 8),
                      _buildCategoryRating('Fysiek', assessment.physicalAverage,
                          const PdfColor.fromInt(0xFFFF9800),),
                      pw.SizedBox(height: 8),
                      _buildCategoryRating('Mentaal', assessment.mentalAverage,
                          const PdfColor.fromInt(0xFF9C27B0),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  static pw.Widget _buildOverallRatingBox(double rating) {
    final color = rating >= 4.0
        ? const PdfColor.fromInt(0xFF4CAF50)
        : rating >= 3.0
            ? const PdfColor.fromInt(0xFFFF9800)
            : const PdfColor.fromInt(0xFFF44336);

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'ALGEMEEN',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.Text(
            '${rating.toStringAsFixed(1)}/5.0',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCategoryRating(
          String category, double rating, PdfColor color,) =>
      pw.Row(
        children: [
          pw.Container(
            width: 12,
            height: 12,
            decoration: pw.BoxDecoration(
              color: color,
              shape: pw.BoxShape.circle,
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Text(
              category,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          pw.Text(
            '${rating.toStringAsFixed(1)}/5',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      );

  static pw.Widget _buildSkillsBreakdownCard(PlayerAssessment assessment,
          PdfColor primaryColor, PdfColor backgroundColor,) =>
      pw.Container(
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
                pw.Container(
                  width: 4,
                  height: 20,
                  color: primaryColor,
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  'GEDETAILLEERDE VAARDIGHEDEN',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      _buildSkillCategory(
                          'Technische Vaardigheden',
                          assessment.technicalSkills,
                          const PdfColor.fromInt(0xFF2196F3),),
                      pw.SizedBox(height: 16),
                      _buildSkillCategory(
                          'Tactische Vaardigheden',
                          assessment.tacticalSkills,
                          const PdfColor.fromInt(0xFF4CAF50),),
                    ],
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      _buildSkillCategory(
                          'Fysieke Eigenschappen',
                          assessment.physicalAttributes,
                          const PdfColor.fromInt(0xFFFF9800),),
                      pw.SizedBox(height: 16),
                      _buildSkillCategory(
                          'Mentale Eigenschappen',
                          assessment.mentalAttributes,
                          const PdfColor.fromInt(0xFF9C27B0),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  static pw.Widget _buildSkillCategory(
          String categoryName, Map<String, int> skills, PdfColor color,) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              categoryName,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          ...skills.entries.map(
            (entry) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      entry.key,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  _buildStarRating(entry.value),
                  pw.SizedBox(width: 4),
                  pw.Text(
                    '${entry.value}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  static pw.Widget _buildStarRating(int rating) => pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: List.generate(
          5,
          (index) => pw.Container(
            width: 8,
            height: 8,
            margin: const pw.EdgeInsets.only(right: 1),
            decoration: pw.BoxDecoration(
              color: index < rating
                  ? const PdfColor.fromInt(0xFFFFD700)
                  : const PdfColor.fromInt(0xFFE0E0E0),
              shape: pw.BoxShape.circle,
            ),
          ),
        ),
      );

  static pw.Widget _buildTextFeedbackCard(PlayerAssessment assessment,
      PdfColor primaryColor, PdfColor backgroundColor,) {
    final hasTextContent = (assessment.strengths?.isNotEmpty ?? false) ||
        (assessment.areasForImprovement?.isNotEmpty ?? false) ||
        (assessment.developmentGoals?.isNotEmpty ?? false) ||
        (assessment.coachNotes?.isNotEmpty ?? false);

    if (!hasTextContent) {
      return pw.SizedBox.shrink();
    }

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
              pw.Container(
                width: 4,
                height: 20,
                color: primaryColor,
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                'EVALUATIE & FEEDBACK',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          if (assessment.strengths?.isNotEmpty ?? false)
            _buildTextSection('Sterke Punten', assessment.strengths!,
                const PdfColor.fromInt(0xFF4CAF50),),
          if (assessment.areasForImprovement?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 12),
            _buildTextSection('Verbeterpunten', assessment.areasForImprovement!,
                const PdfColor.fromInt(0xFFFF9800),),
          ],
          if (assessment.developmentGoals?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 12),
            _buildTextSection(
                'Ontwikkelingsdoelen',
                assessment.developmentGoals!,
                const PdfColor.fromInt(0xFF2196F3),),
          ],
          if (assessment.coachNotes?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 12),
            _buildTextSection('Coach Notities', assessment.coachNotes!,
                const PdfColor.fromInt(0xFF9C27B0),),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildTextSection(
          String title, String content, PdfColor color,) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: color),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              content,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      );

  static pw.Widget _buildFooter(
          PlayerAssessment assessment, PdfColor greyColor,) =>
      pw.Container(
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
                  'Assessment uitgevoerd: ${DateFormat('dd-MM-yyyy HH:mm').format(assessment.createdAt)}',
                  style: pw.TextStyle(fontSize: 9, color: greyColor),
                ),
                pw.Text(
                  'Rapport gegenereerd: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
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

  // Helper methods

  static String _getPositionName(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return 'Keeper';
      case Position.defender:
        return 'Verdediger';
      case Position.midfielder:
        return 'Middenvelder';
      case Position.forward:
        return 'Aanvaller';
    }
  }

  static String _getAssessmentTypeText(AssessmentType type) {
    switch (type) {
      case AssessmentType.monthly:
        return 'Maandelijkse Assessment';
      case AssessmentType.quarterly:
        return 'Kwartaal Assessment';
      case AssessmentType.biannual:
        return 'Halfjaarlijkse Assessment';
    }
  }
}
