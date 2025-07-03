import '../core/result.dart';
import '../models/match.dart';

abstract interface class MatchRepository {
  Future<Result<List<Match>>> getAll();
  Future<Result<List<Match>>> getUpcoming();
  Future<Result<List<Match>>> getRecent();
  Future<Result<Match?>> getById(String id);
  Future<Result<void>> add(Match match);
  Future<Result<void>> update(Match match);
}
