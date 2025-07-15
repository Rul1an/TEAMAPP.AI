// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';

// Project imports:
import '../models/match.dart';
import '../repositories/match_repository.dart';
import '../utils/duplicate_detector.dart';
import '../core/result.dart';
import '../parsers/match_schedule_csv_parser.dart';
import '../models/dto/match_schedule_dto.dart';
import '../utils/streaming_csv_parser.dart' as sp;

/// State of a row during preview – used by the wizard UI to colour-code rows.
enum ImportRowState { newRecord, duplicate, error }

class ImportRowPreview {
  ImportRowPreview({
    required this.rowNumber,
    this.match,
    required this.state,
    this.error,
  });

  final int rowNumber;
  final Match? match;
  final ImportRowState state;
  final String? error;
}

class ImportPreview {
  ImportPreview({required this.rows});

  final List<ImportRowPreview> rows;

  int get newCount =>
      rows.where((r) => r.state == ImportRowState.newRecord).length;
  int get duplicateCount =>
      rows.where((r) => r.state == ImportRowState.duplicate).length;
  int get errorCount =>
      rows.where((r) => r.state == ImportRowState.error).length;
}

/// Service that parses CSV/XLSX schedules, detects duplicates and optionally
/// persists them. Designed to be UI-agnostic so the wizard can display a
/// preview first.
class MatchScheduleImportService {
  MatchScheduleImportService(this._matchRepository);

  final MatchRepository _matchRepository;

  // region Public API -----------------------------------------------------

  Future<ImportPreview> previewCsv(Uint8List bytes) async {
    final csvString = utf8.decode(bytes);

    final parser = MatchScheduleCsvParser();
    var parseResult;

    final lineCount = '\n'.allMatches(csvString).length + 1;
    if (lineCount > 5000) {
      // Use streaming parser for large files to avoid UI jank.
      parseResult = await sp.StreamingCsvParser.parse<MatchScheduleDto>(bytes,
          mapper: (m) => parser.mapRow(m),
          notifyEveryLines: 1000);
    } else {
      parseResult = parser.parse(csvString);
    }

    if (parseResult.items.isEmpty && parseResult.errors.isEmpty) {
      return ImportPreview(rows: <ImportRowPreview>[]);
    }

    // Prepare duplicate detector seeded with existing matches.
    final existingResult = await _matchRepository.getAll();
    final existingMatches = existingResult.when(
      success: (list) => list,
      failure: (_) => <Match>[],
    );

    final existingHashes = existingMatches
        .map((m) => _matchHash(m.date, m.opponent, m.venue ?? '', m.id))
        .toSet();
    final detector = DuplicateDetector<String>(initialHashes: existingHashes);

    final previews = <ImportRowPreview>[];

    // Handle parse errors first (row numbers already encoded in message)
    for (final err in parseResult.errors) {
      // Expect format 'Row X: message'
      final match = RegExp(r'Row (\d+): (.*)').firstMatch(err);
      if (match != null) {
        previews.add(
          ImportRowPreview(
            rowNumber: int.parse(match.group(1)!)+0, // row number as parsed
            state: ImportRowState.error,
            error: match.group(2),
          ),
        );
      } else {
        previews.add(
          ImportRowPreview(rowNumber: -1, state: ImportRowState.error, error: err),
        );
      }
    }

    for (var i = 0; i < parseResult.items.length; i++) {
      final dto = parseResult.items[i];
      final rowIndex = i + 2; // assuming same order as CSV rows (header skipped)

      try {
        final hash = _matchHash(dto.date, dto.opponent, dto.venue, dto.teamId);
        final isDup = detector.isDuplicate(hash);

        final match = Match()
          ..date = dto.date
          ..opponent = dto.opponent
          ..venue = dto.venue
          ..location = _determineLocation(dto.venue)
          ..competition = Competition.league; // Default – can be updated later

        previews.add(
          ImportRowPreview(
            rowNumber: rowIndex,
            match: match,
            state: isDup ? ImportRowState.duplicate : ImportRowState.newRecord,
          ),
        );
      } catch (e) {
        previews.add(
          ImportRowPreview(
            rowNumber: rowIndex,
            state: ImportRowState.error,
            error: e.toString(),
          ),
        );
      }
    }

    return ImportPreview(rows: previews);
  }

  /// Persist all NEW matches from the preview. Duplicate or error rows are
  /// skipped. Returns counts for feedback.
  Future<Result<int>> persist(ImportPreview preview) async {
    var saved = 0;
    for (final row in preview.rows) {
      if (row.state != ImportRowState.newRecord || row.match == null) continue;
      final result = await _matchRepository.add(row.match!);
      if (result is Success) saved++;
    }
    return Success(saved);
  }

  /// Convenience wrapper that routes to the correct preview method based on
  /// file extension.
  Future<ImportPreview> previewFile(Uint8List bytes, String extension) {
    switch (extension.toLowerCase()) {
      case 'csv':
        return previewCsv(bytes);
      case 'xlsx':
      case 'xls':
        return previewExcel(bytes);
      default:
        throw UnsupportedError('Bestandstype .$extension wordt niet ondersteund');
    }
  }

  Future<ImportPreview> previewExcel(Uint8List bytes) async {
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;
    final rows = sheet.rows;
    if (rows.isEmpty || rows.length == 1) {
      return ImportPreview(rows: <ImportRowPreview>[]);
    }

    final dataRows = rows
        .skip(1)
        .map((row) => row.map((cell) => cell?.value).toList())
        .toList();

    // Reuse CSV preview logic by converting to CSV-compatible List<List>.
    final csvBytes = const ListToCsvConverter().convert([
      ['match_date', 'opponent', 'venue', 'team_id'],
      ...dataRows,
    ]).codeUnits;

    return previewCsv(Uint8List.fromList(csvBytes));
  }

  // endregion -------------------------------------------------------------

  // region Helpers --------------------------------------------------------

  DateTime _parseDate(String dateStr) {
    final formats = ['yyyy-MM-dd', 'dd-MM-yyyy', 'dd/MM/yyyy', 'MM/dd/yyyy'];
    for (final fmt in formats) {
      try {
        return DateFormat(fmt).parse(dateStr);
      } catch (_) {
        // continue
      }
    }
    throw FormatException('Ongeldig datumformaat: $dateStr');
  }

  Location _determineLocation(String venue) {
    final v = venue.toLowerCase();
    if (v.contains('uit') || v.contains('away')) return Location.away;
    return Location.home;
  }

  String _matchHash(
    DateTime date,
    String opponent,
    String venue,
    String teamId,
  ) {
    return '${DateFormat('yyyy-MM-dd').format(date)}|${opponent.toLowerCase().trim()}|${venue.toLowerCase().trim()}|$teamId';
  }

  // endregion -------------------------------------------------------------
}