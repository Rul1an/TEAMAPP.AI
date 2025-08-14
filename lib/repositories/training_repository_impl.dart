// Dart imports:
import 'dart:io';

// Project imports:
import '../core/result.dart';
import 'cache_policy.dart';
import '../data/supabase_training_data_source.dart';
import '../hive/hive_training_cache.dart';
import '../models/training.dart';
import 'training_repository.dart';
import '../services/analytics_events.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  TrainingRepositoryImpl({
    required SupabaseTrainingDataSource remote,
    required HiveTrainingCache cache,
  })  : _remote = remote,
        _cache = cache;

  final SupabaseTrainingDataSource _remote;
  final HiveTrainingCache _cache;
  final AnalyticsLogger _analytics = const AnalyticsLogger();

  AppFailure _mapError(Object e) {
    if (e is SocketException) return NetworkFailure(e.message);
    return CacheFailure(e.toString());
  }

  Future<List<Training>?> _tryGetCached() => _cache.read();

  @override
  Future<Result<List<Training>>> getAll() async {
    return CachePolicy.getSWR<List<Training>>(
      fetchRemote: _remote.fetchAll,
      readCache: _tryGetCached,
      writeCache: _cache.write,
      mapError: _mapError,
    );
  }

  @override
  Future<Result<Training?>> getById(String id) async {
    try {
      final t = await _remote.fetchById(id);
      if (t != null) {
        final cached = await _tryGetCached() ?? <Training>[];
        final idx = cached.indexWhere((x) => x.id == id);
        if (idx == -1) {
          cached.add(t);
        } else {
          cached[idx] = t;
        }
        await _cache.write(cached);
      }
      return Success(t);
    } catch (e) {
      final cached = await _tryGetCached();
      Training? t;
      if (cached != null) {
        try {
          t = cached.firstWhere((x) => x.id == id);
        } catch (_) {
          t = null;
        }
      }
      return t != null ? Success(t) : Failure(_mapError(e));
    }
  }

  @override
  Future<Result<void>> add(Training training) async {
    return CachePolicy.mutate(
      remoteCall: () async {
        await _remote.add(training);
        await _analytics.log(
          AnalyticsEvent.trainingCreate,
          parameters: {'id': training.id},
        );
      },
      clearCache: _cache.clear,
      mapError: _mapError,
    );
  }

  @override
  Future<Result<void>> update(Training training) async {
    return CachePolicy.mutate(
      remoteCall: () => _remote.update(training),
      clearCache: _cache.clear,
      mapError: _mapError,
    );
  }

  @override
  Future<Result<void>> delete(String id) async {
    return CachePolicy.mutate(
      remoteCall: () => _remote.delete(id),
      clearCache: _cache.clear,
      mapError: _mapError,
    );
  }

  @override
  Future<Result<List<Training>>> getUpcoming() async {
    final now = DateTime.now();
    final res = await getAll();
    return res.when(
      success: (list) =>
          Success(list.where((t) => t.date.isAfter(now)).toList()),
      failure: Failure.new,
    );
  }

  @override
  Future<Result<List<Training>>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final res = await getAll();
    return res.when(
      success: (list) => Success(
        list
            .where(
              (t) =>
                  (t.date.isAtSameMomentAs(start) || t.date.isAfter(start)) &&
                  (t.date.isAtSameMomentAs(end) || t.date.isBefore(end)),
            )
            .toList(),
      ),
      failure: Failure.new,
    );
  }
}
