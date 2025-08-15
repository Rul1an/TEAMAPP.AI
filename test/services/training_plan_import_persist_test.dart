// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/repositories/training_repository.dart';
import 'package:jo17_tactical_manager/services/training_plan_import_service.dart';

class _FakeTrainingRepository implements TrainingRepository {
  final List<Training> added = [];

  @override
  Future<Result<void>> add(Training training) async {
    added.add(training);
    return const Success<void>(null);
  }

  // Unused in this test suite
  @override
  Future<Result<void>> delete(String id) =>
      Future.value(const Failure<void>(GenericFailure('unused')));
  @override
  Future<Result<List<Training>>> getAll() =>
      Future.value(const Failure<List<Training>>(GenericFailure('unused')));
  @override
  Future<Result<Training?>> getById(String id) =>
      Future.value(const Failure<Training?>(GenericFailure('unused')));
  @override
  Future<Result<List<Training>>> getByDateRange(DateTime start, DateTime end) =>
      Future.value(const Failure<List<Training>>(GenericFailure('unused')));
  @override
  Future<Result<List<Training>>> getUpcoming() =>
      Future.value(const Failure<List<Training>>(GenericFailure('unused')));
  @override
  Future<Result<void>> update(Training training) =>
      Future.value(const Failure<void>(GenericFailure('unused')));
}

void main() {
  group('TrainingPlanImportService.persistImported', () {
    test('applies fixed offset minutes to computed start DateTime', () async {
      final svc = TrainingPlanImportService();
      final repo = _FakeTrainingRepository();

      final items = [
        PlannedTrainingDto(
          date: DateTime(2025, 9, 21),
          startTime: '18:30',
          durationMinutes: 90,
          focus: 'Techniek',
          intensity: 'Gemiddeld',
        ),
      ];

      final res = await svc.persistImported(
        items,
        repo,
        fixedOffsetMinutes: 60, // +1h
      );

      expect(res.success, isTrue);
      expect(repo.added.length, 1);
      final start = repo.added.first.date;
      expect(start.hour, 19); // 18:30 + 60min → 19:30
      expect(start.minute, 30);
    });

    test('applies Europe/Amsterdam DST-aware offset when enabled', () async {
      final svc = TrainingPlanImportService();
      final repo = _FakeTrainingRepository();

      // A date in summer time (DST) → expect +120 minutes
      final items = [
        PlannedTrainingDto(
          date: DateTime(2025, 7, 10),
          startTime: '10:00',
          durationMinutes: 60,
          focus: 'Techniek',
          intensity: 'Gemiddeld',
        ),
      ];

      final res = await svc.persistImported(
        items,
        repo,
        applyEuropeAmsterdamDst: true,
      );

      expect(res.success, isTrue);
      expect(repo.added.length, 1);
      final start = repo.added.first.date;
      expect(start.hour, 12); // 10:00 + 120min DST
      expect(start.minute, 0);
    });
  });
}
