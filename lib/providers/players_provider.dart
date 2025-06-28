import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player.dart';
import '../services/database_service.dart';

final playersProvider = FutureProvider<List<Player>>((ref) async {
  final db = DatabaseService();
  return db.getAllPlayers();
});

final playerByIdProvider =
    FutureProvider.family<Player?, String>((ref, id) async {
  final db = DatabaseService();
  return db.getPlayer(id);
});

final playersByPositionProvider =
    FutureProvider.family<List<Player>, Position>((ref, position) async {
  final db = DatabaseService();
  return db.getPlayersByPosition(position);
});

final playersNotifierProvider =
    StateNotifierProvider<PlayersNotifier, AsyncValue<List<Player>>>(
        (ref) => PlayersNotifier(),);

class PlayersNotifier extends StateNotifier<AsyncValue<List<Player>>> {
  PlayersNotifier() : super(const AsyncValue.loading()) {
    loadPlayers();
  }

  final _db = DatabaseService();

  Future<void> loadPlayers() async {
    state = const AsyncValue.loading();
    try {
      final players = await _db.getAllPlayers();
      state = AsyncValue.data(players);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addPlayer(Player player) async {
    state = const AsyncValue.loading();
    try {
      await _db.savePlayer(player);
      await loadPlayers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updatePlayer(Player player) async {
    state = const AsyncValue.loading();
    try {
      await _db.savePlayer(player);
      await loadPlayers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deletePlayer(String id) async {
    state = const AsyncValue.loading();
    try {
      await _db.deletePlayer(id);
      await loadPlayers();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
