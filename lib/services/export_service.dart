import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import '../models/player.dart';
import '../models/match.dart';
import '../models/training.dart';
import '../services/database_service.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final _dbService = DatabaseService();

  // Export Players to PDF
  Future<void> exportPlayersToPDF() async {
    final players = await _dbService.getAllPlayers();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'JO17 Spelers Overzicht',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: [
              'Nr',
              'Naam',
              'Positie',
              'Leeftijd',
              'Wedstrijden',
              'Goals',
              'Assists',
              'Speelminuten %',
            ],
            data: players.map((player) {
              final age = DateTime.now().difference(player.birthDate).inDays ~/ 365;
              final speelminutenPercentage = player.matchesInSelection > 0
                  ? ((player.minutesPlayed / (player.matchesInSelection * 80)) * 100).toStringAsFixed(1)
                  : '0.0';

              return [
                player.jerseyNumber.toString(),
                '${player.firstName} ${player.lastName}',
                _getPositionText(player.position),
                age.toString(),
                player.matchesPlayed.toString(),
                player.goals.toString(),
                player.assists.toString(),
                '$speelminutenPercentage%',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Gegenereerd op: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    await _savePDF(pdf, 'spelers_overzicht');
  }

  // Export Players to Excel
  Future<void> exportPlayersToExcel(List<Player> players) async {
    final excel = Excel.createExcel();
    final sheet = excel['Spelers'];

    // Headers
    sheet.appendRow([
      TextCellValue('Nr'),
      TextCellValue('Voornaam'),
      TextCellValue('Achternaam'),
      TextCellValue('Positie'),
      TextCellValue('Geboortedatum'),
      TextCellValue('Lengte (cm)'),
      TextCellValue('Gewicht (kg)'),
      TextCellValue('Voorkeursbeen'),
      TextCellValue('Wedstrijden'),
      TextCellValue('Goals'),
      TextCellValue('Assists'),
      TextCellValue('Trainingen'),
      TextCellValue('Speelminuten %'),
    ]);

    // Data
    for (final player in players) {
      final speelminutenPercentage = player.matchesInSelection > 0
          ? ((player.minutesPlayed / (player.matchesInSelection * 80)) * 100).toStringAsFixed(1)
          : '0.0';

      sheet.appendRow([
        IntCellValue(player.jerseyNumber),
        TextCellValue(player.firstName),
        TextCellValue(player.lastName),
        TextCellValue(_getPositionText(player.position)),
        TextCellValue(DateFormat('dd-MM-yyyy').format(player.birthDate)),
        DoubleCellValue(player.height),
        DoubleCellValue(player.weight),
        TextCellValue(player.preferredFoot == PreferredFoot.left ? 'Links' : 'Rechts'),
        IntCellValue(player.matchesPlayed),
        IntCellValue(player.goals),
        IntCellValue(player.assists),
        TextCellValue('${player.trainingsAttended}/${player.trainingsTotal}'),
        TextCellValue('$speelminutenPercentage%'),
      ]);
    }

    await _saveExcel(excel, 'spelers_overzicht');
  }

  // Export Matches to PDF
  Future<void> exportMatchesToPDF() async {
    final matches = await _dbService.getAllMatches();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'JO17 Wedstrijden Overzicht',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: [
              'Datum',
              'Tegenstander',
              'Thuis/Uit',
              'Score',
              'Resultaat',
              'Competitie',
              'Status',
            ],
            data: matches.map((match) {
              final score = match.teamScore != null && match.opponentScore != null
                  ? '${match.teamScore} - ${match.opponentScore}'
                  : '-';
              final result = match.result != null
                  ? _getResultText(match.result!)
                  : '-';

              return [
                DateFormat('dd-MM-yyyy').format(match.date),
                match.opponent,
                match.location == Location.home ? 'Thuis' : 'Uit',
                score,
                result,
                _getCompetitionText(match.competition),
                _getStatusText(match.status),
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Gegenereerd op: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    await _savePDF(pdf, 'wedstrijden_overzicht');
  }

  // Export Training Attendance to Excel
  Future<void> exportTrainingAttendanceToExcel() async {
    final trainings = await _dbService.getAllTrainings();
    final players = await _dbService.getAllPlayers();
    final excel = Excel.createExcel();
    final sheet = excel['Trainingen'];

    // Headers
    final headers = ['Datum', 'Focus', 'Intensiteit', 'Status'];
    for (final player in players) {
      headers.add('${player.jerseyNumber}. ${player.lastName}');
    }
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    // Data
    for (final training in trainings) {
      final row = [
        TextCellValue(DateFormat('dd-MM-yyyy').format(training.date)),
        TextCellValue(_getFocusText(training.focus)),
        TextCellValue(_getIntensityText(training.intensity)),
        TextCellValue(_getTrainingStatusText(training.status)),
      ];

      for (final player in players) {
        final playerId = player.id.toString();
        String status = '-';
        if (training.presentPlayerIds.contains(playerId)) {
          status = 'A';
        } else if (training.absentPlayerIds.contains(playerId)) {
          status = 'X';
        } else if (training.injuredPlayerIds.contains(playerId)) {
          status = 'G';
        } else if (training.latePlayerIds.contains(playerId)) {
          status = 'L';
        }
        row.add(TextCellValue(status));
      }

      sheet.appendRow(row);
    }

    // Legend
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue('Legenda:')]);
    sheet.appendRow([TextCellValue('A = Aanwezig')]);
    sheet.appendRow([TextCellValue('X = Afwezig')]);
    sheet.appendRow([TextCellValue('G = Geblesseerd')]);
    sheet.appendRow([TextCellValue('L = Te laat')]);

    await _saveExcel(excel, 'training_aanwezigheid');
  }

  // Helper methods - Web compatible
  Future<void> _savePDF(pw.Document pdf, String filename) async {
    try {
      final bytes = await pdf.save();
      await FileSaver.instance.saveFile(
        name: filename,
        bytes: Uint8List.fromList(bytes),
        ext: 'pdf',
        mimeType: MimeType.pdf,
      );
    } catch (e) {
      // Error saving PDF: $e
      rethrow;
    }
  }

  Future<void> _saveExcel(Excel excel, String filename) async {
    try {
      final bytes = excel.save();
      if (bytes != null) {
        await FileSaver.instance.saveFile(
          name: filename,
          bytes: Uint8List.fromList(bytes),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );
      }
    } catch (e) {
      // Error saving Excel: $e
      rethrow;
    }
  }

  String _getPositionText(Position position) {
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

  String _getResultText(MatchResult result) {
    switch (result) {
      case MatchResult.win:
        return 'Gewonnen';
      case MatchResult.draw:
        return 'Gelijk';
      case MatchResult.loss:
        return 'Verloren';
    }
  }

  String _getCompetitionText(Competition competition) {
    switch (competition) {
      case Competition.league:
        return 'Competitie';
      case Competition.cup:
        return 'Beker';
      case Competition.friendly:
        return 'Vriendschappelijk';
      case Competition.tournament:
        return 'Toernooi';
    }
  }

  String _getStatusText(MatchStatus status) {
    switch (status) {
      case MatchStatus.scheduled:
        return 'Gepland';
      case MatchStatus.inProgress:
        return 'Bezig';
      case MatchStatus.completed:
        return 'Afgelopen';
      case MatchStatus.cancelled:
        return 'Geannuleerd';
      case MatchStatus.postponed:
        return 'Uitgesteld';
    }
  }

  String _getFocusText(TrainingFocus focus) {
    switch (focus) {
      case TrainingFocus.technical:
        return 'Techniek';
      case TrainingFocus.tactical:
        return 'Tactiek';
      case TrainingFocus.physical:
        return 'Fysiek';
      case TrainingFocus.mental:
        return 'Mentaal';
      case TrainingFocus.matchPrep:
        return 'Wedstrijdvoorbereiding';
    }
  }

  String _getIntensityText(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.low:
        return 'Laag';
      case TrainingIntensity.medium:
        return 'Gemiddeld';
      case TrainingIntensity.high:
        return 'Hoog';
      case TrainingIntensity.recovery:
        return 'Herstel';
    }
  }

  String _getTrainingStatusText(TrainingStatus status) {
    switch (status) {
      case TrainingStatus.planned:
        return 'Gepland';
      case TrainingStatus.completed:
        return 'Afgerond';
      case TrainingStatus.cancelled:
        return 'Geannuleerd';
    }
  }
}
