import '../core/result.dart';
import '../models/match.dart';
import '../services/database_service.dart';
import 'match_repository.dart';

class LocalMatchRepository implements MatchRepository {
  LocalMatchRepository({DatabaseService? service})
      : _service = service ?? DatabaseService();

  final DatabaseService _service;

  @override
  Future<Result<void>> add(Match match) async {
    try {
      await _service.saveMatch(match);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Match match) async {
    try {
      await _service.saveMatch(match);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getAll() async {
    try {
      final matches = await _service.getAllMatches();
      return Success(matches);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getUpcoming() async {
    try {
      final matches = await _service.getUpcomingMatches();
      return Success(matches);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getRecent() async {
    try {
      final matches = await _service.getRecentMatches();
      return Success(matches);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Match?>> getById(String id) async {
    try {
      final match = await _service.getMatch(id);
      return Success(match);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _service.deleteMatch(id);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }
}
