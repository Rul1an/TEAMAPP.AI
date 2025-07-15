// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../models/training_session/training_session.dart';
import '../repositories/training_session_repository.dart';
import '../utils/duplicate_detector.dart';
import '../parsers/training_session_csv_parser.dart';
import '../models/dto/training_session_dto.dart';
import '../core/result.dart';

enum ImportRowState { newRecord, duplicate, error }

class TrainingImportRowPreview {
  TrainingImportRowPreview({
    required this.rowNumber,
    this.session,
    required this.state,
    this.error,
  });

  final int rowNumber;
  final TrainingSession? session;
  final ImportRowState state;
  final String? error;
}

class TrainingImportPreview {
  TrainingImportPreview({required this.rows});

  final List<TrainingImportRowPreview> rows;

  int get newCount => rows.where((r) => r.state==ImportRowState.newRecord).length;
  int get dupCount => rows.where((r)=>r.state==ImportRowState.duplicate).length;
  int get errorCount => rows.where((r)=>r.state==ImportRowState.error).length;
}

class TrainingSessionImportService{
  TrainingSessionImportService(this._repo);
  final TrainingSessionRepository _repo;

  Future<TrainingImportPreview> previewCsv(Uint8List bytes) async {
    final csv= utf8.decode(bytes);
    final parser = TrainingSessionCsvParser();
    final res = parser.parse(csv);
    if(res.items.isEmpty && res.errors.isEmpty) return TrainingImportPreview(rows: []);

    final existingRes = await _repo.getAll();
    final existing = existingRes.when(success:(l)=>l,failure: (_)=><TrainingSession>[]);
    final seen = existing.map((t)=>_hash(t.date, t.startTime, t.teamId)).toSet();
    final detector = DuplicateDetector<String>(initialHashes: seen);

    final rows=<TrainingImportRowPreview>[];
    for(final err in res.errors){
      final m=RegExp(r'Row (\d+): (.*)').firstMatch(err);
      rows.add(TrainingImportRowPreview(rowNumber: m!=null?int.parse(m.group(1)!):-1,state:ImportRowState.error,error:m!=null?m.group(2):err));
    }

    for(var i=0;i<res.items.length;i++){
      final dto=res.items[i];
      final rowIdx=i+2;
      final key=_hash(dto.date, dto.startTime, dto.teamId);
      final dup=detector.isDuplicate(key);
      final session=TrainingSession()
        ..date=dto.date
        ..startTime=dto.startTime
        ..endTime=dto.endTime
        ..teamId=dto.teamId;
      rows.add(TrainingImportRowPreview(rowNumber: rowIdx, session: session, state: dup?ImportRowState.duplicate:ImportRowState.newRecord));
    }
    return TrainingImportPreview(rows: rows);
  }

  Future<TrainingImportPreview> previewExcel(Uint8List bytes) async {
    final excel=Excel.decodeBytes(bytes);
    final sheet=excel.tables.values.first;
    if(sheet.rows.length<=1) return TrainingImportPreview(rows: []);
    final csvStr= const ListToCsvConverter().convert([
      ['date','start_time','end_time','team_id'],
      ...sheet.rows.skip(1).map((r)=>r.map((c)=>c?.value).toList()),
    ]);
    return previewCsv(Uint8List.fromList(csvStr.codeUnits));
  }

  Future<TrainingImportPreview> previewFile(Uint8List bytes,String ext){
    switch(ext.toLowerCase()){
      case 'csv':return previewCsv(bytes);
      case 'xlsx':
      case 'xls':return previewExcel(bytes);
      default:throw UnsupportedError('Unsupported .$ext');
    }
  }

  Future<Result<int>> persist(TrainingImportPreview preview) async {
    var saved=0;
    for(final row in preview.rows){
      if(row.state!=ImportRowState.newRecord||row.session==null) continue;
      final res=await _repo.add(row.session!);
      if(res is Success) saved++;
    }
    return Success(saved);
  }

  String _hash(DateTime d,String st,String team)=>'${DateFormat('yyyy-MM-dd').format(d)}|$st|$team';
}