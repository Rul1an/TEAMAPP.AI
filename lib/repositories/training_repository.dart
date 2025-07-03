import '../core/result.dart';
import '../models/training.dart';

abstract interface class TrainingRepository {
  Future<Result<List<Training>>> getAll();
  Future<Result<List<Training>>> getUpcoming();
  Future<Result<List<Training>>> getByDateRange(DateTime start, DateTime end);
  Future<Result<void>> add(Training training);
  Future<Result<void>> update(Training training);
  Future<Result<void>> delete(String id);
}
