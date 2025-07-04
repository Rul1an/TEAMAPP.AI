import '../core/result.dart';
import '../hive/hive_match_cache.dart';
import '../models/match.dart';
import 'match_repository.dart';

class LocalMatchRepository implements MatchRepository {
  LocalMatchRepository({HiveMatchCache? cache})
      : _cache = cache ?? HiveMatchCache();

  final HiveMatchCache _cache;

  @override
  Future<Result<void>> add(Match match) async {
    try {
      final list = await _cache.read() ?? [];
      list.add(match);
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Match match) async {
    try {
      final list = await _cache.read() ?? [];
      final idx = list.indexWhere((m) => m.id == match.id);
      if (idx == -1) {
        list.add(match);
      } else {
        list[idx] = match;
      }
      await _cache.write(list);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getAll() async {
    try {
      final matches = await _cache.read() ?? [];
      return Success(matches);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getUpcoming() async {
    try {
      final matches = (await _cache.read() ?? [])
          .where((m) => m.date.isAfter(DateTime.now()))
          .toList();
      return Success(matches);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getRecent() async {
    try {
      final now = DateTime.now();
      final matches = (await _cache.read() ?? [])
          .where((m) => m.date.isBefore(now))
          .toList();
      return Success(matches);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Match?>> getById(String id) async {
    try {
      final list = await _cache.read() ?? [];
      Match? m;
      for (final match in list) {
        if (match.id == id) {
          m = match;
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
