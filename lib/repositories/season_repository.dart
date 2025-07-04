// Project imports:
import '../core/result.dart';
import '../models/annual_planning/season_plan.dart';

abstract interface class SeasonRepository {
  Future<Result<List<SeasonPlan>>> getAll();
  Future<Result<SeasonPlan?>> getActive();
}
