import '../core/result.dart';
import '../models/annual_planning/training_period.dart';

abstract interface class TrainingPeriodRepository {
  Future<Result<List<TrainingPeriod>>> getAll();
}
