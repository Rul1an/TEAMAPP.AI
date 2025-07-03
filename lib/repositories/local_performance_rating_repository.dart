import '../core/result.dart';
import '../models/performance_rating.dart';
import '../services/database_service.dart';
import 'performance_rating_repository.dart';

/// Local in-memory implementation backed by [DatabaseService].
class LocalPerformanceRatingRepository implements PerformanceRatingRepository {
  LocalPerformanceRatingRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<void>> save(PerformanceRating rating) async {
    try {
      await _service.savePerformanceRating(rating);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PerformanceRating>>> getPlayerRatings(String playerId) async {
    try {
      final ratings = await _service.getPlayerRatings(playerId);
      return Success(ratings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<double>> getPlayerAverageRating(String playerId, {int? lastNRatings}) async {
    try {
      final avg = await _service.getPlayerAverageRating(playerId, lastNRatings: lastNRatings);
      return Success(avg);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<PerformanceTrend>> getPlayerPerformanceTrend(String playerId) async {
    try {
      final trend = await _service.getPlayerPerformanceTrend(playerId);
      return Success(trend);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
