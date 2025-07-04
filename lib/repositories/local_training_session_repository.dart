import '../core/result.dart';
import '../hive/hive_training_session_cache.dart';
import '../models/training_session/training_session.dart';
import 'training_session_repository.dart';

class LocalTrainingSessionRepository implements TrainingSessionRepository {
  LocalTrainingSessionRepository({HiveTrainingSessionCache? cache})
      : _cache = cache ?? HiveTrainingSessionCache();

  final HiveTrainingSessionCache _cache;

  @override
  Future<Result<List<TrainingSession>>> getAll() async {
    try {
      final sessions = await _cache.read() ?? [];
      return Success(sessions);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TrainingSession>>> getUpcoming() async {
    try {
      final sessions = (await _cache.read() ?? [])
          .where((s) => s.date.isAfter(DateTime.now()))
          .toList();
      return Success(sessions);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(TrainingSession session) async {
    try {
      final list = await _cache.read() ?? [];
      final idx = list.indexWhere((s) => s.id == session.id);
      if (idx == -1) {
        list.add(session);
      } else {
        list[idx] = session;
      }
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
