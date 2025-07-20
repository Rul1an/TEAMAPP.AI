import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/permission_service.dart';
import 'package:jo17_tactical_manager/models/organization.dart';

void main() {
  group('PermissionService', () {
    test('identifies player & parent as view-only users', () {
      expect(PermissionService.isViewOnlyUser('speler'), isTrue);
      expect(PermissionService.isViewOnlyUser('ouder'), isTrue);
      expect(PermissionService.isViewOnlyUser('hoofdcoach'), isFalse);
    });

    test('canManagePlayers for roles', () {
      expect(PermissionService.canManagePlayers('bestuurder'), isTrue);
      expect(PermissionService.canManagePlayers('hoofdcoach'), isTrue);
      expect(PermissionService.canManagePlayers('admin'), isTrue);
      expect(PermissionService.canManagePlayers('speler'), isFalse);
    });

    test('access SVS depends on tier and role', () {
      expect(
        PermissionService.canAccessSVS('hoofdcoach', OrganizationTier.basic),
        isFalse,
      );
      expect(
        PermissionService.canAccessSVS('hoofdcoach', OrganizationTier.pro),
        isTrue,
      );
    });
  });
}
