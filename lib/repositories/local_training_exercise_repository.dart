import '../core/result.dart';
import '../models/training_session/training_exercise.dart';
import '../hive/hive_training_exercise_cache.dart';
import 'training_exercise_repository.dart';

class LocalTrainingExerciseRepository implements TrainingExerciseRepository {
  LocalTrainingExerciseRepository({HiveTrainingExerciseCache? cache})
      : _cache = cache ?? HiveTrainingExerciseCache();

  final HiveTrainingExerciseCache _cache;

  @override
  Future<Result<List<TrainingExercise>>> getAll() async {
    try {
      final exercises = await _cache.read() ?? [];
      return Success(exercises);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TrainingExercise>>> getBySession(String sessionId) async {
    try {
      final exercises = (await _cache.read() ?? [])
          .where((e) => e.sessionId == sessionId)
          .toList();
      return Success(exercises);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(TrainingExercise exercise) async {
    try {
      final list = await _cache.read() ?? [];
      final idx = list.indexWhere((e) => e.id == exercise.id);
      if (idx == -1) {
        list.add(exercise);
      } else {
        list[idx] = exercise;
      }
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
