import '../core/result.dart';
import '../models/player.dart';
import '../services/database_service.dart';
import 'player_repository.dart';

/// A simple repository that proxies calls to [DatabaseService].
/// This keeps legacy in-memory data source working while aligning to the
/// new repository abstraction.
class LocalPlayerRepository implements PlayerRepository {
  LocalPlayerRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<void>> add(Player player) async {
    try {
      await _service.savePlayer(player);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _service.deletePlayer(id);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Player>>> getAll() async {
    try {
      final players = await _service.getAllPlayers();
      return Success(players);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Player?>> getById(String id) async {
    try {
      final player = await _service.getPlayer(id);
      return Success(player);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async {
    try {
      final players = await _service.getPlayersByPosition(position);
      return Success(players);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Player player) async {
    try {
      await _service.savePlayer(player);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
