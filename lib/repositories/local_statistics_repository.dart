// Project imports:
import '../core/result.dart';
import '../hive/hive_statistics_cache.dart';
import 'statistics_repository.dart';

class LocalStatisticsRepository implements StatisticsRepository {
  LocalStatisticsRepository({HiveStatisticsCache? cache})
      : _cache = cache ?? HiveStatisticsCache();

  final HiveStatisticsCache _cache;

  @override
  Future<Result<Map<String, dynamic>>> getStatistics() async {
    try {
      final stats = await _cache.read() ?? {};
      return Success(stats);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
