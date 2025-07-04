// Project imports:
import '../core/result.dart';
import '../models/club/club.dart';

abstract interface class ClubRepository {
  Future<Result<Club?>> getById(String id);
  Future<Result<List<Club>>> getAll();
  Future<Result<void>> add(Club club);
  Future<Result<void>> update(Club club);
  Future<Result<void>> delete(String id);
}
