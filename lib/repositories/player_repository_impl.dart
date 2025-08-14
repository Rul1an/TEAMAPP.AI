// Dart imports:
import 'dart:io';

// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import '../core/result.dart';
import 'cache_policy.dart';
import '../data/supabase_player_data_source.dart';
import '../hive/hive_player_cache.dart';
import '../models/player.dart';
import 'player_repository.dart';
import '../services/analytics_events.dart';

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
  final AnalyticsLogger _analytics = const AnalyticsLogger();

  // region Helpers ---------------------------------------------------------

  AppFailure _mapError(Object e) {
    if (e is SocketException) return NetworkFailure(e.message);
    return CacheFailure(e.toString());
  }

  Future<List<Player>?> _tryGetCached() => _cache.read();

  // endregion --------------------------------------------------------------

  @override
  Future<Result<List<Player>>> getAll() async {
    return CachePolicy.getSWR<List<Player>>(
      fetchRemote: _remote.fetchAll,
      readCache: _tryGetCached,
      writeCache: _cache.write,
      mapError: _mapError,
    );
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
      await _analytics.log(
        AnalyticsEvent.playerCreate,
        parameters: {'id': player.id},
      );
      return const Success(null);
    } catch (e) {
      // In standalone mode, fallback to cache-only operation
      try {
        final cached = await _tryGetCached() ?? <Player>[];
        // Generate a unique ID if not set; prefer UUID v4 to avoid collisions
        final Player playerToAdd = player.id.isEmpty
            ? (() {
                try {
                  final clone = Player.fromJson(player.toJson());
                  clone.id = const Uuid().v4();
                  return clone;
                } catch (_) {
                  // If toJson fails due to uninitialized fields, construct safely
                  final newPlayer = Player()
                    ..id = const Uuid().v4()
                    ..firstName = player.firstName
                    ..lastName = player.lastName
                    ..jerseyNumber = player.jerseyNumber
                    ..birthDate = player.birthDate
                    ..position = player.position
                    ..preferredFoot = player.preferredFoot
                    ..height = player.height
                    ..weight = player.weight
                    ..phoneNumber = player.phoneNumber
                    ..email = player.email
                    ..parentContact = player.parentContact
                    ..matchesPlayed = player.matchesPlayed
                    ..matchesInSelection = player.matchesInSelection
                    ..minutesPlayed = player.minutesPlayed
                    ..goals = player.goals
                    ..assists = player.assists
                    ..yellowCards = player.yellowCards
                    ..redCards = player.redCards
                    ..trainingsAttended = player.trainingsAttended
                    ..trainingsTotal = player.trainingsTotal
                    ..createdAt = player.createdAt
                    ..updatedAt = player.updatedAt;
                  return newPlayer;
                }
              })()
            : player;
        cached.add(playerToAdd);
        await _cache.write(cached);
        await _analytics.log(
          AnalyticsEvent.playerCreate,
          parameters: {'id': playerToAdd.id, 'offline': true},
        );
        return const Success(null);
      } catch (cacheError) {
        return Failure(_mapError(cacheError));
      }
    }
  }

  @override
  Future<Result<void>> update(Player player) async {
    return CachePolicy.mutate(
      remoteCall: () async {
        await _remote.update(player);
        await _analytics.log(
          AnalyticsEvent.playerUpdate,
          parameters: {'id': player.id},
        );
      },
      clearCache: _cache.clear,
      mapError: _mapError,
    );
  }

  @override
  Future<Result<void>> delete(String id) async {
    return CachePolicy.mutate(
      remoteCall: () async {
        await _remote.delete(id);
        await _analytics.log(
          AnalyticsEvent.playerDelete,
          parameters: {'id': id},
        );
      },
      clearCache: _cache.clear,
      mapError: _mapError,
    );
  }
}
