// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../models/player.dart';
import '../repositories/player_repository.dart';
import '../utils/duplicate_detector.dart';

class ImportService {
  ImportService(this._playerRepository);

  final PlayerRepository _playerRepository;

  // Import players from Excel or CSV
  Future<ImportResult> importPlayers() async {
    try {
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(
          success: false,
          message: 'Geen bestand geselecteerd',
        );
      }

      final file = result.files.first;
      final bytes = file.bytes;

      if (bytes == null) {
        return ImportResult(success: false, message: 'Kon bestand niet lezen');
      }

      // Process based on file type
      if (file.extension == 'csv') {
        return await _importPlayersFromCSV(bytes);
      } else {
        return await _importPlayersFromExcel(bytes);
      }
    } catch (e) {
      return ImportResult(success: false, message: 'Fout bij importeren: $e');
    }
  }

  Future<ImportResult> _importPlayersFromCSV(Uint8List bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      final rows = const CsvToListConverter().convert(csvString);

      if (rows.isEmpty) {
        return ImportResult(success: false, message: 'CSV bestand is leeg');
      }

      // Skip header row
      final dataRows = rows.skip(1).toList();
      return await _processPlayerRows(dataRows);
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Fout bij verwerken CSV: $e',
      );
    }
  }

  Future<ImportResult> _importPlayersFromExcel(Uint8List bytes) async {
    try {
      final excel = Excel.decodeBytes(bytes);

      // Get first sheet
      final sheet = excel.tables.values.first;
      final rows = sheet.rows;

      if (rows.isEmpty) {
        return ImportResult(success: false, message: 'Excel bestand is leeg');
      }

      // Convert to list and skip header
      final dataRows = rows
          .skip(1)
          .map((row) => row.map((cell) => cell?.value).toList())
          .toList();

      return await _processPlayerRows(dataRows);
    } catch (e) {
      return ImportResult(
        success: false,
        message: 'Fout bij verwerken Excel: $e',
      );
    }
  }

  Future<ImportResult> _processPlayerRows(List<List<dynamic>> rows) async {
    var imported = 0;
    var skipped = 0;
    final errors = <String>[];

    // Fetch existing players once to seed duplicate detection
    final existingPlayersResult = await _playerRepository.getAll();
    final existingPlayers = existingPlayersResult.when(
      success: (players) => players,
      failure: (_) => <Player>[],
    );

    final existingHashes = existingPlayers
        .map((p) => _playerHash(p.firstName, p.lastName, p.birthDate))
        .toSet();

    final duplicateDetector =
        DuplicateDetector<String>(initialHashes: existingHashes);

    for (var i = 0; i < rows.length; i++) {
      try {
        final row = rows[i];

        // Expected format: FirstName, LastName, JerseyNumber, BirthDate, Position, Height, Weight, PreferredFoot
        if (row.length < 8) {
          errors.add('Rij ${i + 2}: Onvoldoende kolommen');
          skipped++;
          continue;
        }

        final firstName = row[0].toString().trim();
        final lastName = row[1].toString().trim();
        final birthDate = _parseDate(row[3].toString());

        // Duplicate detection
        final playerKey = _playerHash(firstName, lastName, birthDate);
        if (duplicateDetector.isDuplicate(playerKey)) {
          errors.add('Rij ${i + 2}: Dubbele speler – overgeslagen');
          skipped++;
          continue;
        }

        final player = Player()
          ..firstName = firstName
          ..lastName = lastName
          ..jerseyNumber = int.tryParse(row[2].toString()) ?? 0
          ..birthDate = birthDate
          ..position = _parsePosition(row[4].toString())
          ..height = double.tryParse(row[5].toString()) ?? 0
          ..weight = double.tryParse(row[6].toString()) ?? 0
          ..preferredFoot = _parsePreferredFoot(row[7].toString());

        // Validate required fields
        if (player.firstName.isEmpty ||
            player.lastName.isEmpty ||
            player.jerseyNumber == 0) {
          errors.add('Rij ${i + 2}: Verplichte velden ontbreken');
          skipped++;
          continue;
        }

        // Save player
        await _playerRepository.add(player);
        imported++;
      } catch (e) {
        errors.add('Rij ${i + 2}: $e');
        skipped++;
      }
    }

    return ImportResult(
      success: imported > 0,
      message:
          'Import voltooid: $imported spelers geïmporteerd, $skipped overgeslagen',
      imported: imported,
      skipped: skipped,
      errors: errors,
    );
  }

  DateTime _parseDate(String dateStr) {
    try {
      // Try different date formats
      final formats = ['dd-MM-yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd', 'MM/dd/yyyy'];

      for (final format in formats) {
        try {
          return DateFormat(format).parse(dateStr);
        } catch (_) {
          continue;
        }
      }

      // Default to today minus 16 years
      return DateTime.now().subtract(const Duration(days: 16 * 365));
    } catch (_) {
      return DateTime.now().subtract(const Duration(days: 16 * 365));
    }
  }

  Position _parsePosition(String positionStr) {
    final pos = positionStr.toLowerCase().trim();

    if (pos.contains('keeper') ||
        pos.contains('goalkeeper') ||
        pos == 'gk' ||
        pos == 'k') {
      return Position.goalkeeper;
    } else if (pos.contains('verdedig') ||
        pos.contains('defender') ||
        pos == 'def' ||
        pos == 'v') {
      return Position.defender;
    } else if (pos.contains('middenvel') ||
        pos.contains('midfielder') ||
        pos == 'mid' ||
        pos == 'm') {
      return Position.midfielder;
    } else if (pos.contains('aanval') ||
        pos.contains('forward') ||
        pos == 'fw' ||
        pos == 'a') {
      return Position.forward;
    }

    return Position.midfielder; // Default
  }

  PreferredFoot _parsePreferredFoot(String footStr) {
    final foot = footStr.toLowerCase().trim();

    if (foot.contains('links') || foot.contains('left') || foot == 'l') {
      return PreferredFoot.left;
    }

    return PreferredFoot.right; // Default
  }

  String _playerHash(String firstName, String lastName, DateTime birthDate) {
    return '${firstName.trim().toLowerCase()}|${lastName.trim().toLowerCase()}|${DateFormat('yyyy-MM-dd').format(birthDate)}';
  }

  // Generate template for player import
  Future<void> generatePlayerTemplate() async {
    final excel = Excel.createExcel();
    final sheet = excel['Spelers'];

    // Headers
    final headers = [
      'Voornaam',
      'Achternaam',
      'Rugnummer',
      'Geboortedatum (dd-mm-jjjj)',
      'Positie (Keeper/Verdediger/Middenvelder/Aanvaller)',
      'Lengte (cm)',
      'Gewicht (kg)',
      'Voorkeursbeen (Links/Rechts)',
      'Email (optioneel)',
      'Telefoon (optioneel)',
    ];

    // Add headers
    for (var i = 0; i < headers.length; i++) {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        TextCellValue(headers[i]),
      );
    }

    // Add example row
    final example = [
      'Jan',
      'Jansen',
      '10',
      '15-03-2008',
      'Middenvelder',
      '175',
      '65',
      'Rechts',
      'jan.jansen@email.com',
      '06-12345678',
    ];

    for (var i = 0; i < example.length; i++) {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1),
        TextCellValue(example[i]),
      );
    }

    // Save file
    final bytes = excel.save();
    if (bytes != null) {
      await FileSaver.instance.saveFile(
        name: 'spelers_import_template',
        bytes: Uint8List.fromList(bytes),
        ext: 'xlsx',
        mimeType: MimeType.microsoftExcel,
      );
    }
  }
}

class ImportResult {
  ImportResult({
    required this.success,
    required this.message,
    this.imported = 0,
    this.skipped = 0,
    this.errors = const [],
  });
  final bool success;
  final String message;
  final int imported;
  final int skipped;
  final List<String> errors;
}
