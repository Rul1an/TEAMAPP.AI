import '../core/result.dart';
import '../hive/hive_periodization_cache.dart';
import '../models/annual_planning/periodization_plan.dart';
import 'periodization_plan_repository.dart';

class LocalPeriodizationPlanRepository implements PeriodizationPlanRepository {
  LocalPeriodizationPlanRepository({HivePeriodizationCache? cache})
      : _cache = cache ?? HivePeriodizationCache();

  final HivePeriodizationCache _cache;

  @override
  Future<Result<List<PeriodizationPlan>>> getAll() async {
    try {
      final list = await _cache.read() ?? [];
      return Success(list);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
