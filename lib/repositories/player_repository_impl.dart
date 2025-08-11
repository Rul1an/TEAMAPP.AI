// Dart imports:
import 'dart:io';

// Project imports:
import '../core/result.dart';
import '../data/supabase_player_data_source.dart';
import '../hive/hive_player_cache.dart';
import '../models/player.dart';
import 'player_repository.dart';

/// Repository that serves `Player` data using a read-through cache.
///
/// * `getAll` – fetch remote, cache on success; on failure return cached list
///   if present.
/// * `getById` / `getByPosition` – use remote when possible, otherwise derive
///   from cached list.
/// * Mutations (`add`, `update`, `delete`) clear the cache after a successful
///   remote call to force refresh on next read.
class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl({
    required SupabasePlayerDataSource remote,
    required HivePlayerCache cache,
  })  : _remote = remote,
        _cache = cache;

  final SupabasePlayerDataSource _remote;
  final HivePlayerCache _cache;

  // region Helpers ---------------------------------------------------------

  AppFailure _mapError(Object e) {
    if (e is SocketException) return NetworkFailure(e.message);
    return CacheFailure(e.toString());
  }

  Future<List<Player>?> _tryGetCached() => _cache.read();

  // endregion --------------------------------------------------------------

  @override
  Future<Result<List<Player>>> getAll() async {
    try {
      final players = await _remote.fetchAll();
      await _cache.write(players);
      return Success(players);
    } catch (e) {
      final cached = await _tryGetCached();
      return cached != null ? Success(cached) : Failure(_mapError(e));
    }
  }

  @override
  Future<Result<Player?>> getById(String id) async {
    try {
      final player = await _remote.fetchById(id);
      if (player != null) {
        // Update cache entry.
        final cached = await _tryGetCached() ?? <Player>[];
        final idx = cached.indexWhere((p) => p.id == id);
        if (idx == -1) {
          cached.add(player);
        } else {
          cached[idx] = player;
        }
        await _cache.write(cached);
      }
      return Success(player);
    } catch (e) {
      final cached = await _tryGetCached();
      Player? player;
      if (cached != null) {
        try {
          player = cached.firstWhere((p) => p.id == id);
        } catch (_) {
          player = null;
        }
      }
      return player != null ? Success(player) : Failure(_mapError(e));
    }
  }

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async {
    final all = await getAll();
    return all.when(
      success: (players) =>
          Success(players.where((p) => p.position == position).toList()),
      failure: Failure.new,
    );
  }

  @override
  Future<Result<void>> add(Player player) async {
    try {
      await _remote.add(player);
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      // In standalone mode, fallback to cache-only operation
      try {
        final cached = await _tryGetCached() ?? <Player>[];
        // Generate a unique ID if not set without mutating the original
        final Player playerToAdd = player.id.isEmpty
            ? (() {
                final clone = Player.fromJson(player.toJson());
                clone.id = DateTime.now().millisecondsSinceEpoch.toString();
                return clone;
              })()
            : player;
        cached.add(playerToAdd);
        await _cache.write(cached);
        return const Success(null);
      } catch (cacheError) {
        return Failure(_mapError(cacheError));
      }
    }
  }

  @override
  Future<Result<void>> update(Player player) async {
    try {
      await _remote.update(player);
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      return Failure(_mapError(e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      return Failure(_mapError(e));
    }
  }
}
