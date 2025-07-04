import 'dart:io';

import '../core/result.dart';
import '../data/supabase_club_data_source.dart';
import '../hive/hive_club_cache.dart';
import '../models/club/club.dart';
import 'club_repository.dart';

class ClubRepositoryImpl implements ClubRepository {
  ClubRepositoryImpl(
      {required SupabaseClubDataSource remote, required HiveClubCache cache})
      : _remote = remote,
        _cache = cache;

  final SupabaseClubDataSource _remote;
  final HiveClubCache _cache;

  AppFailure _map(Object e) => e is SocketException
      ? NetworkFailure(e.message)
      : CacheFailure(e.toString());

  Future<List<Club>?> _cached({Duration? ttl}) => _cache.read(ttl: ttl);

  @override
  Future<Result<Club?>> getById(String id) async {
    try {
      final club = await _remote.fetchById(id);
      if (club != null) {
        final cached = (await _cached()) ?? <Club>[];
        final idx = cached.indexWhere((c) => c.id == club.id);
        if (idx == -1) {
          cached.add(club);
        } else {
          cached[idx] = club;
        }
        await _cache.write(cached);
      }
      return Success(club);
    } catch (e) {
      final cached = await _cached();
      Club? found;
      if (cached != null) {
        try {
          found = cached.firstWhere((c) => c.id == id);
        } catch (_) {
          found = null;
        }
      }
      return found != null ? Success(found) : Failure(_map(e));
    }
  }

  @override
  Future<Result<List<Club>>> getAll() async {
    try {
      final clubs = await _remote.fetchAll();
      await _cache.write(clubs);
      return Success(clubs);
    } catch (e) {
      final cached = await _cached();
      return cached != null ? Success(cached) : Failure(_map(e));
    }
  }

  Future<Result<void>> _wrapMutation(Future<void> Function() fn) async {
    try {
      await fn();
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      return Failure(_map(e));
    }
  }

  @override
  Future<Result<void>> add(Club club) => _wrapMutation(() => _remote.add(club));

  @override
  Future<Result<void>> update(Club club) =>
      _wrapMutation(() => _remote.update(club));

  @override
  Future<Result<void>> delete(String id) =>
      _wrapMutation(() => _remote.delete(id));
}
