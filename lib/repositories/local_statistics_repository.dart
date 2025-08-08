// Project imports:
import '../core/result.dart';
import '../hive/hive_statistics_cache.dart';
import '../models/statistics.dart';
import 'statistics_repository.dart';

/// 2025 Best Practice: Type-safe Statistics Repository
class LocalStatisticsRepository implements StatisticsRepository {
  LocalStatisticsRepository({HiveStatisticsCache? cache})
      : _cache = cache ?? HiveStatisticsCache();

  final HiveStatisticsCache _cache;

  @override
  Future<Result<Map<String, dynamic>>> getStatistics() async {
    try {
      // Get raw data from cache
      final rawStats = await _cache.read();

      // Convert to type-safe Statistics model and back to Map for compatibility
      final statistics = Statistics.fromLegacyMap(rawStats);
      final legacyMap = statistics.toLegacyMap();

      return Success(legacyMap);
    } catch (e) {
      // Return safe defaults on any error
      const defaultStats = Statistics();
      return Success(defaultStats.toLegacyMap());
    }
  }

  /// 2025 Best Practice: Type-safe method for getting Statistics object
  Future<Result<Statistics>> getTypeSafeStatistics() async {
    try {
      final rawStats = await _cache.read();
      final statistics = Statistics.fromLegacyMap(rawStats);
      return Success(statistics);
    } catch (e) {
      // Always return safe defaults, never fail
      const defaultStats = Statistics();
      return Success(defaultStats);
    }
  }

  /// 2025 Best Practice: Type-safe method for updating Statistics
  Future<Result<void>> updateStatistics(Statistics statistics) async {
    try {
      final legacyMap = statistics.toLegacyMap();
      await _cache.write(legacyMap);
      return const Success(null);
    } catch (e) {
      return Failure(
          CacheFailure('Failed to save statistics: ${e.toString()}'));
    }
  }
}
