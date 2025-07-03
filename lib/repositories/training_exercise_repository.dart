import '../core/result.dart';
import '../models/training_session/training_exercise.dart';

/// Repository for TrainingExercise entities.
abstract interface class TrainingExerciseRepository {
  /// Returns all exercises (library).
  Future<Result<List<TrainingExercise>>> getAll();

  /// Returns exercises belonging to a given training session.
  Future<Result<List<TrainingExercise>>> getBySession(String sessionId);

  /// Saves (insert or update) an exercise.
  Future<Result<void>> save(TrainingExercise exercise);
}
