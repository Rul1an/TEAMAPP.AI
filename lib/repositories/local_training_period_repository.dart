// Project imports:
import '../core/result.dart';
import '../hive/hive_training_period_cache.dart';
import '../models/annual_planning/training_period.dart';
import 'training_period_repository.dart';

class LocalTrainingPeriodRepository implements TrainingPeriodRepository {
  LocalTrainingPeriodRepository({HiveTrainingPeriodCache? cache})
    : _cache = cache ?? HiveTrainingPeriodCache();

  final HiveTrainingPeriodCache _cache;

  @override
  Future<Result<List<TrainingPeriod>>> getAll() async {
    try {
      final periods = await _cache.read() ?? [];
      return Success(periods);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
