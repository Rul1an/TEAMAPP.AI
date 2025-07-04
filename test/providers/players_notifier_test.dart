import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/players_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jo17_tactical_manager/repositories/player_repository.dart';

class _FakeRepo extends Mock implements PlayerRepository {
  final List<Player> _players;
  _FakeRepo(this._players);

  @override
  Future<Result<List<Player>>> getAll() async => Success(_players);

  @override
  Future<Result<void>> add(Player player) async {
    return const Success(null);
  }

  @override
  Future<Result<void>> update(Player player) async => const Success(null);

  // ignore: no-empty-block
  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<Player?>> getById(String id) async => Success(_players.first);

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async =>
      Success(_players);
}

void main() {
  test('PlayersNotifier loads data successfully', () async {
    final players = [Player()..id = '1'];
    final repo = _FakeRepo(players);
    final container = ProviderContainer(overrides: [
      playerRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(playersNotifierProvider.notifier);
    await notifier.loadPlayers();
    final state = container.read(playersNotifierProvider);
    expect(state.asData?.value, players);
  });
}
