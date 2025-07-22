// Project imports:
import '../core/result.dart';
import '../hive/hive_match_schedule_cache.dart';
import '../models/match_schedule.dart';
import 'match_schedule_repository.dart';

class LocalMatchScheduleRepository implements MatchScheduleRepository {
  LocalMatchScheduleRepository({HiveMatchScheduleCache? cache})
      : _cache = cache ?? HiveMatchScheduleCache();

  final HiveMatchScheduleCache _cache;

  @override
  Future<Result<void>> add(MatchSchedule schedule) async {
    try {
      final list = await _cache.read() ?? [];
      list.add(schedule);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(MatchSchedule schedule) async {
    try {
      final list = await _cache.read() ?? [];
      final idx = list.indexWhere((m) => m.id == schedule.id);
      if (idx == -1) {
        list.add(schedule);
      } else {
        list[idx] = schedule;
      }
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MatchSchedule>>> getAll() async {
    try {
      final schedules = await _cache.read() ?? [];
      return Success(schedules);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MatchSchedule>>> getUpcoming() async {
    try {
      final schedules = (await _cache.read() ?? [])
          .where((m) => m.dateTime.isAfter(DateTime.now()))
          .toList();
      return Success(schedules);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MatchSchedule>>> getRecent() async {
    try {
      final now = DateTime.now();
      final schedules = (await _cache.read() ?? [])
          .where((m) => m.dateTime.isBefore(now))
          .toList();
      return Success(schedules);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<MatchSchedule?>> getById(String id) async {
    try {
      final list = await _cache.read() ?? [];
      MatchSchedule? m;
      for (final schedule in list) {
        if (schedule.id == id) {
          m = schedule;
          break;
        }
      }
      return Success(m);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final list = await _cache.read() ?? [];
      list.removeWhere((m) => m.id == id);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
