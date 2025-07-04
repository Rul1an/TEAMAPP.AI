// Project imports:
import '../core/result.dart';

abstract interface class PermissionRepository {
  /// Returns a map actionKey -> hasAccess for a given role.
  Future<Result<Map<String, bool>>> getPermissionsForRole(String role);
}
