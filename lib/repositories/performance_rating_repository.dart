// Project imports:
import '../core/result.dart';
import '../models/performance_rating.dart';

/// Repository interface for managing [PerformanceRating] data.
abstract interface class PerformanceRatingRepository {
  Future<Result<void>> save(PerformanceRating rating);
  Future<Result<List<PerformanceRating>>> getPlayerRatings(String playerId);
  Future<Result<double>> getPlayerAverageRating(
    String playerId, {
    int? lastNRatings,
  });
  Future<Result<PerformanceTrend>> getPlayerPerformanceTrend(String playerId);
}
