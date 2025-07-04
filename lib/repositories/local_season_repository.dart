// Project imports:
import '../core/result.dart';
import '../hive/hive_season_cache.dart';
import '../models/annual_planning/season_plan.dart';
import 'season_repository.dart';

class LocalSeasonRepository implements SeasonRepository {
  LocalSeasonRepository({HiveSeasonCache? cache})
      : _cache = cache ?? HiveSeasonCache();

  final HiveSeasonCache _cache;

  @override
  Future<Result<List<SeasonPlan>>> getAll() async {
    try {
      final seasons = await _cache.read() ?? [];
      return Success(seasons);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<SeasonPlan?>> getActive() async {
    try {
      final seasons = await _cache.read() ?? [];
      if (seasons.isEmpty) return const Success(null);

      try {
        final active =
            seasons.firstWhere((s) => s.status == SeasonStatus.active);
        return Success(active);
      } catch (_) {
        return Success(seasons.first);
      }
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
