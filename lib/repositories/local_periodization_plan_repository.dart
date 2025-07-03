import '../core/result.dart';
import '../models/annual_planning/periodization_plan.dart';
import '../services/database_service.dart';
import 'periodization_plan_repository.dart';

class LocalPeriodizationPlanRepository implements PeriodizationPlanRepository {
  LocalPeriodizationPlanRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<PeriodizationPlan>>> getAll() async {
    try {
      final plans = await _service.getAllPeriodizationPlans();
      return Success(plans);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
