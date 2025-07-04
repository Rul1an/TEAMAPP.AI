// Project imports:
import '../core/result.dart';
import '../models/player.dart';

abstract interface class PlayerRepository {
  Future<Result<List<Player>>> getAll();
  Future<Result<Player?>> getById(String id);
  Future<Result<List<Player>>> getByPosition(Position position);
  Future<Result<void>> add(Player player);
  Future<Result<void>> update(Player player);
  Future<Result<void>> delete(String id);
}
