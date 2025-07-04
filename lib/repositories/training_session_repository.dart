// Project imports:
import '../core/result.dart';
import '../models/training_session/training_session.dart';

/// Repository for complex TrainingSession entity.
abstract interface class TrainingSessionRepository {
  Future<Result<List<TrainingSession>>> getAll();
  Future<Result<List<TrainingSession>>> getUpcoming();
  Future<Result<void>> save(TrainingSession session);
}
