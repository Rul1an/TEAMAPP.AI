// Dart imports:
import 'dart:io';

// Project imports:
import '../core/result.dart';
import '../data/supabase_feature_data_source.dart';
import '../hive/hive_feature_cache.dart';
import '../models/organization.dart';
import 'feature_repository.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  FeatureRepositoryImpl({
    required SupabaseFeatureDataSource remote,
    required HiveFeatureCache cache,
  }) : _remote = remote,
       _cache = cache;

  final SupabaseFeatureDataSource _remote;
  final HiveFeatureCache _cache;

  AppFailure _map(Object e) => e is SocketException
      ? NetworkFailure(e.message)
      : CacheFailure(e.toString());

  @override
  Future<Result<Map<String, bool>>> getFeaturesForTier(
    OrganizationTier tier,
  ) async {
    try {
      final data = await _remote.fetchFeatures(tier);
      await _cache.write(data);
      return Success(data);
    } catch (e) {
      final cached = await _cache.read();
      return cached != null ? Success(cached) : Failure(_map(e));
    }
  }
}
