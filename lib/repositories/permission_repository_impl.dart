// Dart imports:
import 'dart:io';

// Project imports:
import '../core/result.dart';
import '../data/supabase_permission_data_source.dart';
import '../hive/hive_permission_cache.dart';
import 'permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  PermissionRepositoryImpl({
    required SupabasePermissionDataSource remote,
    required HivePermissionCache cache,
  }) : _remote = remote,
       _cache = cache;

  final SupabasePermissionDataSource _remote;
  final HivePermissionCache _cache;

  AppFailure _map(Object e) => e is SocketException
      ? NetworkFailure(e.message)
      : CacheFailure(e.toString());

  @override
  Future<Result<Map<String, bool>>> getPermissionsForRole(String role) async {
    try {
      final data = await _remote.fetchPermissions(role);
      await _cache.write(data);
      return Success(data);
    } catch (e) {
      final cached = await _cache.read();
      return cached != null ? Success(cached) : Failure(_map(e));
    }
  }
}
