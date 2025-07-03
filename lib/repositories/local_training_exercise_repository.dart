import '../core/result.dart';
import '../models/training_session/training_exercise.dart';
import '../services/database_service.dart';
import 'training_exercise_repository.dart';

class LocalTrainingExerciseRepository implements TrainingExerciseRepository {
  LocalTrainingExerciseRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<TrainingExercise>>> getAll() async {
    try {
      final exercises = await _service.getAllTrainingExercises();
      return Success(exercises);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TrainingExercise>>> getBySession(String sessionId) async {
    try {
      final exercises = await _service.getTrainingExercisesBySession(sessionId);
      return Success(exercises);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(TrainingExercise exercise) async {
    try {
      await _service.saveTrainingExercise(exercise);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
