// Dart imports:
import 'dart:io';

// Project imports:
import '../core/result.dart';
import '../data/supabase_match_data_source.dart';
import '../hive/hive_match_cache.dart';
import '../models/match.dart';
import 'match_repository.dart';

class MatchRepositoryImpl implements MatchRepository {
  MatchRepositoryImpl({
    required SupabaseMatchDataSource remote,
    required HiveMatchCache cache,
  }) : _remote = remote,
       _cache = cache;

  final SupabaseMatchDataSource _remote;
  final HiveMatchCache _cache;

  AppFailure _map(Object e) => e is SocketException
      ? NetworkFailure(e.message)
      : CacheFailure(e.toString());

  Future<List<Match>?> _cached() => _cache.read();

  @override
  Future<Result<List<Match>>> getAll() async {
    try {
      final matches = await _remote.fetchAll();
      await _cache.write(matches);
      return Success(matches);
    } catch (e) {
      final cache = await _cached();
      return cache != null ? Success(cache) : Failure(_map(e));
    }
  }

  @override
  Future<Result<List<Match>>> getUpcoming() async {
    final all = await getAll();
    return all.when(
      success: (list) =>
          Success(list.where((m) => m.date.isAfter(DateTime.now())).toList()),
      failure: Failure.new,
    );
  }

  @override
  Future<Result<List<Match>>> getRecent() async {
    final all = await getAll();
    return all.when(
      success: (list) =>
          Success(list.where((m) => m.date.isBefore(DateTime.now())).toList()),
      failure: Failure.new,
    );
  }

  @override
  Future<Result<Match?>> getById(String id) async {
    try {
      final match = await _remote.fetchById(id);
      return Success(match);
    } catch (e) {
      final cache = await _cached();
      Match? match;
      if (cache != null) {
        try {
          match = cache.firstWhere((m) => m.id == id);
        } catch (_) {
          match = null;
        }
      }
      return match != null ? Success(match) : Failure(_map(e));
    }
  }

  // mutations
  Future<Result<void>> _wrapMutation(Future<void> Function() fn) async {
    try {
      await fn();
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      return Failure(_map(e));
    }
  }

  @override
  Future<Result<void>> add(Match match) =>
      _wrapMutation(() => _remote.add(match));

  @override
  Future<Result<void>> update(Match match) =>
      _wrapMutation(() => _remote.update(match));

  @override
  Future<Result<void>> delete(String id) =>
      _wrapMutation(() => _remote.delete(id));
}
