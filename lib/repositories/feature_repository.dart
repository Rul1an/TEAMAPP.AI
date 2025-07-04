import '../core/result.dart';
import '../models/organization.dart';

abstract interface class FeatureRepository {
  /// Returns a map featureKey -> enabled for given tier.
  Future<Result<Map<String, bool>>> getFeaturesForTier(OrganizationTier tier);
}
