import '../core/result.dart';
import '../hive/hive_performance_rating_cache.dart';
import '../models/performance_rating.dart';
import 'performance_rating_repository.dart';

/// Local implementation backed by [HivePerformanceRatingCache].
class LocalPerformanceRatingRepository implements PerformanceRatingRepository {
  LocalPerformanceRatingRepository({HivePerformanceRatingCache? cache})
      : _cache = cache ?? HivePerformanceRatingCache();

  final HivePerformanceRatingCache _cache;

  Future<List<PerformanceRating>> _all() async => await _cache.read() ?? [];

  Future<void> _saveAll(List<PerformanceRating> list) => _cache.write(list);

  @override
  Future<Result<void>> save(PerformanceRating rating) async {
    try {
      final list = await _all();
      final idx = list.indexWhere((r) => r.id == rating.id);
      if (idx == -1) {
        list.add(rating);
      } else {
        list[idx] = rating;
      }
      await _saveAll(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PerformanceRating>>> getPlayerRatings(
    String playerId,
  ) async {
    try {
      final list = await _all();
      return Success(list.where((r) => r.playerId == playerId).toList());
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<double>> getPlayerAverageRating(
    String playerId, {
    int? lastNRatings,
  }) async {
    try {
      final ratings =
          (await _all()).where((r) => r.playerId == playerId).toList();
      if (ratings.isEmpty) return const Success(0);
      ratings.sort((a, b) => b.date.compareTo(a.date));
      final considered = lastNRatings != null && lastNRatings < ratings.length
          ? ratings.take(lastNRatings)
          : ratings;
      final avg =
          considered.map((r) => r.overallRating).reduce((a, b) => a + b) /
              considered.length;
      return Success(avg);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<PerformanceTrend>> getPlayerPerformanceTrend(
    String playerId,
  ) async {
    try {
      final ratings =
          (await _all()).where((r) => r.playerId == playerId).toList();
      final trendStr = PerformanceRating.calculateTrend(ratings);
      final trend = trendStr == '↗️'
          ? PerformanceTrend.improving
          : trendStr == '↘️'
              ? PerformanceTrend.declining
              : PerformanceTrend.stable;
      return Success(trend);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
