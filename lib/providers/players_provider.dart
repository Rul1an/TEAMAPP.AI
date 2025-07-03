import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../repositories/local_player_repository.dart';
import '../repositories/player_repository.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return LocalPlayerRepository();
});

final playersProvider = FutureProvider<List<Player>>((ref) async {
  final repo = ref.read(playerRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});

final playerByIdProvider =
    FutureProvider.family<Player?, String>((ref, id) async {
  final repo = ref.read(playerRepositoryProvider);
  final res = await repo.getById(id);
  return res.dataOrNull;
});

final playersByPositionProvider =
    FutureProvider.family<List<Player>, Position>((ref, position) async {
  final repo = ref.read(playerRepositoryProvider);
  final res = await repo.getByPosition(position);
  return res.dataOrNull ?? [];
});

final playersNotifierProvider =
    StateNotifierProvider<PlayersNotifier, AsyncValue<List<Player>>>(
  (ref) => PlayersNotifier(ref),
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
      success: (data) => AsyncValue.data(data),
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
