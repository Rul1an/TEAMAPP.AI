import '../core/result.dart';
import '../models/training_session/training_session.dart';
import '../services/database_service.dart';
import 'training_session_repository.dart';

class LocalTrainingSessionRepository implements TrainingSessionRepository {
  LocalTrainingSessionRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<TrainingSession>>> getAll() async {
    try {
      final sessions = await _service.getAllTrainingSessions();
      return Success(sessions);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TrainingSession>>> getUpcoming() async {
    try {
      final sessions = await _service.getUpcomingTrainingSessions();
      return Success(sessions);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(TrainingSession session) async {
    try {
      await _service.saveTrainingSession(session);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
