// Project imports:
import '../core/result.dart';
import '../hive/hive_training_cache.dart';
import '../models/training.dart';
import 'training_repository.dart';

class LocalTrainingRepository implements TrainingRepository {
  LocalTrainingRepository({HiveTrainingCache? cache})
    : _cache = cache ?? HiveTrainingCache();

  final HiveTrainingCache _cache;

  @override
  Future<Result<void>> add(Training training) async {
    try {
      final list = await _cache.read() ?? [];
      list.add(training);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Training training) async {
    try {
      final list = await _cache.read() ?? [];
      final idx = list.indexWhere((t) => t.id == training.id);
      if (idx == -1) {
        list.add(training);
      } else {
        list[idx] = training;
      }
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final list = await _cache.read() ?? [];
      list.removeWhere((t) => t.id == id);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Training>>> getAll() async {
    try {
      final trainings = await _cache.read() ?? [];
      return Success(trainings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Training>>> getUpcoming() async {
    try {
      final trainings = (await _cache.read() ?? [])
          .where((t) => t.date.isAfter(DateTime.now()))
          .toList();
      return Success(trainings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Training>>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final trainings = (await _cache.read() ?? [])
          .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
          .toList();
      return Success(trainings);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Training?>> getById(String id) async {
    try {
      final list = await _cache.read() ?? [];
      Training? found;
      for (final t in list) {
        if (t.id == id) {
          found = t;
          break;
        }
      }
      return Success(found);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
