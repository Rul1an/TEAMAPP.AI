import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training.dart';
import '../services/database_service.dart';

final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final db = DatabaseService();
  return db.getAllTrainings();
});

final upcomingTrainingsProvider = FutureProvider<List<Training>>((ref) async {
  final db = DatabaseService();
  return db.getUpcomingTrainings();
});

final trainingsByDateRangeProvider =
    FutureProvider.family<List<Training>, DateRange>((ref, range) async {
  final db = DatabaseService();
  return db.getTrainingsForDateRange(range.start, range.end);
});

final trainingsNotifierProvider =
    StateNotifierProvider<TrainingsNotifier, AsyncValue<List<Training>>>(
        (ref) => TrainingsNotifier(),);

class TrainingsNotifier extends StateNotifier<AsyncValue<List<Training>>> {
  TrainingsNotifier() : super(const AsyncValue.loading()) {
    loadTrainings();
  }

  final _db = DatabaseService();

  Future<void> loadTrainings() async {
    state = const AsyncValue.loading();
    try {
      final trainings = await _db.getAllTrainings();
      state = AsyncValue.data(trainings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTraining(Training training) async {
    try {
      await _db.saveTraining(training);
      await loadTrainings();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTraining(Training training) async {
    try {
      await _db.saveTraining(training);
      await loadTrainings();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class DateRange {
  DateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}
