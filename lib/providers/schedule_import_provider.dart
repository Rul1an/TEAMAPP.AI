// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../repositories/local_match_schedule_repository.dart';
import '../services/schedule_import_service.dart';

final scheduleImportServiceProvider = Provider<ScheduleImportService>((ref) {
  return ScheduleImportService(
    repository: LocalMatchScheduleRepository(),
  );
});

final scheduleImportNotifierProvider =
    StateNotifierProvider<ScheduleImportNotifier, ScheduleImportState>(
  (ref) => ScheduleImportNotifier(ref.read),
);

class ScheduleImportNotifier extends StateNotifier<ScheduleImportState> {
  ScheduleImportNotifier(this._read) : super(const ScheduleImportState());

  final Reader _read;

  ScheduleImportService get _svc => _read(scheduleImportServiceProvider);

  Future<void> pickFileAndParse() async {
    state = state.copyWith(status: ImportStatus.parsing);
    final res = await _svc.pickAndParse();
    state = res.when(
      success: (data) => data,
      failure: (err) => state.copyWith(status: ImportStatus.error),
    );
  }

  Future<void> importUnique() async {
    final unique = state.duplicateResult?.unique ?? [];
    if (unique.isEmpty) return;
    state = state.copyWith(status: ImportStatus.importing);
    final res = await _svc.importSchedules(unique);
    state = res.when(
      success: (_) => state.copyWith(status: ImportStatus.done),
      failure: (err) => state.copyWith(status: ImportStatus.error),
    );
  }
}