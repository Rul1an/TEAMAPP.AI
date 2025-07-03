import '../core/result.dart';
import '../models/annual_planning/season_plan.dart';
import '../services/database_service.dart';
import 'season_repository.dart';

class LocalSeasonRepository implements SeasonRepository {
  LocalSeasonRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<SeasonPlan>>> getAll() async {
    try {
      final seasons = await _service.getAllSeasonPlans();
      return Success(seasons);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<SeasonPlan?>> getActive() async {
    try {
      final seasons = await _service.getAllSeasonPlans();
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
