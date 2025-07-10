// Dart imports:
import 'dart:async';
import 'dart:io';

// Project imports:
import '../core/result.dart';
import '../data/supabase_profile_data_source.dart';
import '../hive/hive_profile_cache.dart';
import '../models/profile.dart';
import 'profile_repository.dart';

/// Combines Supabase data-source with encrypted Hive cache to serve profiles.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required SupabaseProfileDataSource remote,
    required HiveProfileCache cache,
  }) : _remote = remote,
       _cache = cache;

  final SupabaseProfileDataSource _remote;
  final HiveProfileCache _cache;

  /// Helper to map [Object] → [AppFailure].
  AppFailure _mapError(Object e) {
    if (e is StateError) {
      return const UnauthorizedFailure();
    }
    if (e is SocketException) {
      return NetworkFailure(e.message);
    }
    return CacheFailure(e.toString());
  }

  @override
  Future<Result<Profile?>> getCurrent() async {
    try {
      final profile = await _remote.fetchCurrent();
      if (profile != null) await _cache.write(profile);
      return Success(profile);
    } catch (e) {
      final cached = await _cache.read();
      return cached != null ? Success(cached) : Failure(_mapError(e));
    }
  }

  @override
  Future<Result<Profile>> update({
    String? username,
    String? avatarUrl,
    String? website,
  }) async {
    try {
      final profile = await _remote.update(
        username: username,
        avatarUrl: avatarUrl,
        website: website,
      );
      await _cache.write(profile);
      return Success(profile);
    } catch (e) {
      return Failure(_mapError(e));
    }
  }

  @override
  Future<Result<Profile>> uploadAvatar(File file) async {
    try {
      final profile = await _remote.uploadAvatar(file);
      await _cache.write(profile);
      return Success(profile);
    } catch (e) {
      return Failure(_mapError(e));
    }
  }

  @override
  Stream<Profile> watch() => _watchGenerator();

  /// Combines initial cache value (if present) with remote realtime updates.
  Stream<Profile> _watchGenerator() async* {
    final cached = await _cache.read();
    if (cached != null) yield cached;

    await for (final profile in _remote.subscribe()) {
      await _cache.write(profile);
      yield profile;
    }
  }
}
