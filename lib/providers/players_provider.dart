// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../data/supabase_player_data_source.dart';
import '../hive/hive_player_cache.dart';
import '../models/player.dart';
import '../repositories/player_repository.dart';
import '../repositories/player_repository_impl.dart';

// Low-level singletons -----------------------------------------------------

final playerCacheProvider = Provider<HivePlayerCache>((_) => HivePlayerCache());

final playerRemoteProvider = Provider<SupabasePlayerDataSource>(
  (_) => SupabasePlayerDataSource(),
);

// Repository --------------------------------------------------------------

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepositoryImpl(
    remote: ref.read(playerRemoteProvider),
    cache: ref.read(playerCacheProvider),
  );
});

final playersProvider = FutureProvider<List<Player>>((ref) async {
  final repo = ref.read(playerRepositoryProvider);
  try {
    final res = await repo
        .getAll()
        .timeout(const Duration(seconds: 4)); // hard ceiling to avoid spinners
    return res.dataOrNull ?? [];
  } catch (_) {
    return [];
  }
});

final playerByIdProvider = FutureProvider.family<Player?, String>((
  ref,
  id,
) async {
  final repo = ref.read(playerRepositoryProvider);
  final res = await repo.getById(id);
  return res.dataOrNull;
});

final playersByPositionProvider = FutureProvider.family<List<Player>, Position>(
  (ref, position) async {
    final repo = ref.read(playerRepositoryProvider);
    final res = await repo.getByPosition(position);
    return res.dataOrNull ?? [];
  },
);

final playersNotifierProvider =
    StateNotifierProvider<PlayersNotifier, AsyncValue<List<Player>>>(
  PlayersNotifier.new,
);

class PlayersNotifier extends StateNotifier<AsyncValue<List<Player>>> {
  PlayersNotifier(this._ref) : super(const AsyncValue.loading()) {
    loadPlayers();
  }

  final Ref _ref;

  PlayerRepository get _repo => _ref.read(playerRepositoryProvider);

  Future<void> loadPlayers() async {
    state = const AsyncValue.loading();
    final res = await _repo.getAll();
    state = res.when(
      success: AsyncValue.data,
      failure: (err) => AsyncValue.error(err, StackTrace.current),
    );
  }

  Future<void> addPlayer(Player player) async {
    state = const AsyncValue.loading();
    final res = await _repo.add(player);
    if (res.isSuccess) {
      await loadPlayers();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }

  Future<void> updatePlayer(Player player) async {
    state = const AsyncValue.loading();
    final res = await _repo.update(player);
    if (res.isSuccess) {
      await loadPlayers();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }

  Future<void> deletePlayer(String id) async {
    state = const AsyncValue.loading();
    final res = await _repo.delete(id);
    if (res.isSuccess) {
      await loadPlayers();
    } else {
      state = AsyncValue.error(res.errorOrNull!, StackTrace.current);
    }
  }
}
