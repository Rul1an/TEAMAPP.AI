import 'dart:io';

import '../core/result.dart';
import '../data/supabase_organization_data_source.dart';
import '../hive/hive_organization_cache.dart';
import '../models/organization.dart';
import 'organization_repository.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl({
    required SupabaseOrganizationDataSource remote,
    required HiveOrganizationCache cache,
  })  : _remote = remote,
        _cache = cache;

  final SupabaseOrganizationDataSource _remote;
  final HiveOrganizationCache _cache;

  AppFailure _map(Object e) => e is SocketException
      ? NetworkFailure(e.message)
      : CacheFailure(e.toString());

  Future<List<Organization>?> _cached() => _cache.read();

  @override
  Future<Result<Organization?>> getById(String id) async {
    try {
      final org = await _remote.fetchById(id);
      return Success(org);
    } catch (e) {
      return Failure(_map(e));
    }
  }

  @override
  Future<Result<List<Organization>>> getUserOrganizations(String userId) async {
    try {
      final list = await _remote.fetchByUser(userId);
      await _cache.write(list);
      return Success(list);
    } catch (e) {
      final cached = await _cached();
      return cached != null ? Success(cached) : Failure(_map(e));
    }
  }

  @override
  Future<Result<void>> create(Organization org) async {
    try {
      await _remote.insert(org);
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      return Failure(_map(e));
    }
  }

  @override
  Future<Result<void>> update(Organization org) async {
    try {
      await _remote.update(org);
      await _cache.clear();
      return const Success(null);
    } catch (e) {
      return Failure(_map(e));
    }
  }

  @override
  Future<Result<bool>> isSlugAvailable(String slug) async {
    try {
      final available = await _remote.slugAvailable(slug);
      return Success(available);
    } catch (e) {
      return Failure(_map(e));
    }
  }
}
