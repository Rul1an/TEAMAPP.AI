import '../core/result.dart';
import '../models/annual_planning/training_period.dart';
import '../services/database_service.dart';
import 'training_period_repository.dart';

class LocalTrainingPeriodRepository implements TrainingPeriodRepository {
  LocalTrainingPeriodRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<List<TrainingPeriod>>> getAll() async {
    try {
      final periods = await _service.getAllTrainingPeriods();
      return Success(periods);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
