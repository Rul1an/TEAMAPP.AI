import '../core/result.dart';
import '../models/annual_planning/periodization_plan.dart';

abstract interface class PeriodizationPlanRepository {
  Future<Result<List<PeriodizationPlan>>> getAll();
}
