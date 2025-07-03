import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training.dart';
import '../repositories/local_training_repository.dart';
import '../repositories/training_repository.dart';

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return LocalTrainingRepository();
});

final trainingsProvider = FutureProvider<List<Training>>((ref) async {
  final repo = ref.read(trainingRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});

final upcomingTrainingsProvider = FutureProvider<List<Training>>((ref) async {
  final repo = ref.read(trainingRepositoryProvider);
  final res = await repo.getUpcoming();
  return res.dataOrNull ?? [];
});

final trainingsByDateRangeProvider =
    FutureProvider.family<List<Training>, DateRange>((ref, range) async {
  final repo = ref.read(trainingRepositoryProvider);
  final res = await repo.getByDateRange(range.start, range.end);
  return res.dataOrNull ?? [];
});

final trainingsNotifierProvider =
    StateNotifierProvider<TrainingsNotifier, AsyncValue<List<Training>>>(
  TrainingsNotifier.new,
);

class TrainingsNotifier extends StateNotifier<AsyncValue<List<Training>>> {
  TrainingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadTrainings();
  }

  final Ref _ref;

  TrainingRepository get _repo => _ref.read(trainingRepositoryProvider);

  Future<void> loadTrainings() async {
    state = const AsyncValue.loading();
    final res = await _repo.getAll();
    state = res.when(
      success: AsyncValue.data,
      failure: (err) => AsyncValue.error(err, StackTrace.current),
    );
  }

  Future<void> addTraining(Training training) async {
    state = const AsyncValue.loading();
    final res = await _repo.add(training);
    if (res.isSuccess) {
      await loadTrainings();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }

  Future<void> updateTraining(Training training) async {
    state = const AsyncValue.loading();
    final res = await _repo.update(training);
    if (res.isSuccess) {
      await loadTrainings();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }
}

class DateRange {
  DateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}
