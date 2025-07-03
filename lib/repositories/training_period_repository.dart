import '../core/result.dart';
import '../models/annual_planning/training_period.dart';

// ignore_for_file: one_member_abstracts

abstract interface class TrainingPeriodRepository {
  Future<Result<List<TrainingPeriod>>> getAll();
}
