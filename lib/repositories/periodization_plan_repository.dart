// Project imports:
import '../core/result.dart';
import '../models/annual_planning/periodization_plan.dart';

// ignore_for_file: one_member_abstracts

abstract interface class PeriodizationPlanRepository {
  Future<Result<List<PeriodizationPlan>>> getAll();
}
