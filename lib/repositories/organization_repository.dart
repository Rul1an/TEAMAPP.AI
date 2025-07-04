// Project imports:
import '../core/result.dart';
import '../models/organization.dart';

abstract interface class OrganizationRepository {
  Future<Result<Organization?>> getById(String id);
  Future<Result<List<Organization>>> getUserOrganizations(String userId);
  Future<Result<void>> create(Organization org);
  Future<Result<void>> update(Organization org);
  Future<Result<bool>> isSlugAvailable(String slug);
}
