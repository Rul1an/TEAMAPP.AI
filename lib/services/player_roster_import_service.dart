// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../models/player.dart';
import '../repositories/player_repository.dart';
import '../utils/duplicate_detector.dart';
import '../parsers/player_roster_csv_parser.dart';
import '../models/dto/player_roster_dto.dart';
import '../core/result.dart';

enum ImportRowState { newRecord, duplicate, error }

class PlayerImportRowPreview {
  PlayerImportRowPreview({
    required this.rowNumber,
    required this.state,
    this.player,
    this.error,
  });

  final int rowNumber;
  final Player? player;
  final ImportRowState state;
  final String? error;
}

class PlayerImportPreview {
  PlayerImportPreview({required this.rows});

  final List<PlayerImportRowPreview> rows;

  int get newCount => rows.where((r) => r.state == ImportRowState.newRecord).length;
  int get dupCount => rows.where((r) => r.state == ImportRowState.duplicate).length;
  int get errorCount => rows.where((r) => r.state == ImportRowState.error).length;
}

class PlayerRosterImportService {
  PlayerRosterImportService(this._repo);

  final PlayerRepository _repo;

  // ---------------- Preview CSV ----------------
  Future<PlayerImportPreview> previewCsv(Uint8List bytes) async {
    final csvStr = utf8.decode(bytes);
    final parser = PlayerRosterCsvParser();
    final parseRes = parser.parse(csvStr);

    if (parseRes.items.isEmpty && parseRes.errors.isEmpty) {
      return PlayerImportPreview(rows: []);
    }

    // DuplicateDetector seeded with existing players
    final existingRes = await _repo.getAll();
    final existing = existingRes.when(success: (l) => l, failure: (_) => <Player>[]);
    final seen = existing.map((p) => _hash(p.firstName, p.lastName, p.birthDate)).toSet();
    final detector = DuplicateDetector<String>(initialHashes: seen);

    final rows = <PlayerImportRowPreview>[];

    // Errors first
    for (final err in parseRes.errors) {
      final m = RegExp(r'Row (\d+): (.*)').firstMatch(err);
      rows.add(PlayerImportRowPreview(
        rowNumber: m != null ? int.parse(m.group(1)!) : -1,
        state: ImportRowState.error,
        error: m != null ? m.group(2) : err,
      ));
    }

    // Items
    for (var i = 0; i < parseRes.items.length; i++) {
      final dto = parseRes.items[i];
      final rowIdx = i + 2;
      final key = _hash(dto.firstName, dto.lastName, dto.birthDate);
      final isDup = detector.isDuplicate(key);

      final player = Player()
        ..firstName = dto.firstName
        ..lastName = dto.lastName
        ..birthDate = dto.birthDate
        ..jerseyNumber = dto.jerseyNumber
        ..position = dto.position
        ..preferredFoot = PreferredFoot.right;

      rows.add(PlayerImportRowPreview(
        rowNumber: rowIdx,
        player: player,
        state: isDup ? ImportRowState.duplicate : ImportRowState.newRecord,
      ));
    }

    return PlayerImportPreview(rows: rows);
  }

  // ---------------- Preview Excel ----------------
  Future<PlayerImportPreview> previewExcel(Uint8List bytes) async {
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;
    final rows = sheet.rows;
    if (rows.length <= 1) return PlayerImportPreview(rows: []);

    final csvStr = const ListToCsvConverter().convert([
      ['first_name','last_name','jersey_number','birth_date','position'],
      ...rows.skip(1).map((r)=>r.map((c)=>c?.value).toList()),
    ]);
    return previewCsv(Uint8List.fromList(csvStr.codeUnits));
  }

  Future<PlayerImportPreview> previewFile(Uint8List bytes,String ext){
    switch(ext.toLowerCase()){
      case 'csv': return previewCsv(bytes);
      case 'xlsx':
      case 'xls': return previewExcel(bytes);
      default: throw UnsupportedError('Unsupported extension .$ext');
    }
  }

  // ---------------- Persist ----------------
  Future<Result<int>> persist(PlayerImportPreview preview) async {
    var saved=0;
    for(final row in preview.rows){
      if(row.state!=ImportRowState.newRecord || row.player==null) continue;
      final res = await _repo.add(row.player!);
      if(res is Success) saved++;
    }
    return Success(saved);
  }

  String _hash(String f,String l,DateTime d)=>'${f.toLowerCase()}|${l.toLowerCase()}|${DateFormat('yyyy-MM-dd').format(d)}';
}