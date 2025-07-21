// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

// Project imports:
import '../core/result.dart';
import '../repositories/match_schedule_repository.dart';
import 'duplicate_schedule_detector.dart';
import 'schedule_csv_parser.dart';

class ScheduleImportState {
  const ScheduleImportState({
    this.parseResult,
    this.duplicateResult,
    this.status = ImportStatus.idle,
  });

  final ScheduleCsvParseResult? parseResult;
  final DuplicateScheduleResult? duplicateResult;
  final ImportStatus status;

  ScheduleImportState copyWith({
    ScheduleCsvParseResult? parseResult,
    DuplicateScheduleResult? duplicateResult,
    ImportStatus? status,
  }) =>
      ScheduleImportState(
        parseResult: parseResult ?? this.parseResult,
        duplicateResult: duplicateResult ?? this.duplicateResult,
        status: status ?? this.status,
      );
}

enum ImportStatus { idle, picking, parsing, ready, importing, done, error }

class ScheduleImportService {
  ScheduleImportService({
    required MatchScheduleRepository repository,
    ScheduleCsvParser? parser,
    DuplicateScheduleDetector? detector,
  })  : _repo = repository,
        _parser = parser ?? ScheduleCsvParser(),
        _detector = detector ?? DuplicateScheduleDetector();

  final MatchScheduleRepository _repo;
  final ScheduleCsvParser _parser;
  final DuplicateScheduleDetector _detector;

  Future<Result<ScheduleImportState>> pickAndParse() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (res == null || res.files.isEmpty) {
        return const Success(ScheduleImportState(status: ImportStatus.idle));
      }
      final file = res.files.first;
      final csvContent = file.bytes != null
          ? String.fromCharCodes(file.bytes!)
          : String.fromCharCodes(
              (await file.readStream!.toList()).expand((e) => e).toList(),
            );

      final parseRes = await _parser.parse(csvContent);
      if (!parseRes.isSuccess) return Failure(parseRes.errorOrNull!);
      final schedules = parseRes.dataOrNull!.schedules;

      // existing schedules from repo
      final existingRes = await _repo.getAll();
      final existing = existingRes.dataOrNull ?? [];

      final dupRes = _detector.detect(schedules, existing);

      return Success(
        ScheduleImportState(
          status: ImportStatus.ready,
          parseResult: parseRes.dataOrNull,
          duplicateResult: dupRes,
        ),
      );
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  Future<Result<void>> importSchedules(List schedules) async {
    try {
      for (final s in schedules) {
        final res = await _repo.add(s);
        if (!res.isSuccess) {
          return Failure(res.errorOrNull!);
        }
      }
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
