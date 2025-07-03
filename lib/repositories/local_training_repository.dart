import '../core/result.dart';
import '../models/training.dart';
import '../services/database_service.dart';
import 'training_repository.dart';

class LocalTrainingRepository implements TrainingRepository {
  LocalTrainingRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<void>> add(Training training) async {
    try {
      await _service.saveTraining(training);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Training training) async {
    try {
      await _service.saveTraining(training);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Training>>> getAll() async {
    try {
      final trainings = await _service.getAllTrainings();
      return Success(trainings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Training>>> getUpcoming() async {
    try {
      final trainings = await _service.getUpcomingTrainings();
      return Success(trainings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Training>>> getByDateRange(
      DateTime start, DateTime end) async {
    try {
      final trainings = await _service.getTrainingsForDateRange(start, end);
      return Success(trainings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
