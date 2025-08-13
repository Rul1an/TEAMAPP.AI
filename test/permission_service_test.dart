import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/permission_service.dart';
import 'package:jo17_tactical_manager/constants/roles.dart';
import 'package:jo17_tactical_manager/models/organization.dart';

void main() {
  group('PermissionService', () {
    test('identifies player & parent as view-only users', () {
      expect(PermissionService.isViewOnlyUser(Roles.speler), isTrue);
      expect(PermissionService.isViewOnlyUser(Roles.ouder), isTrue);
      expect(PermissionService.isViewOnlyUser(Roles.hoofdcoach), isFalse);
    });

    test('canManagePlayers for roles', () {
      expect(PermissionService.canManagePlayers(Roles.bestuurder), isTrue);
      expect(PermissionService.canManagePlayers(Roles.hoofdcoach), isTrue);
      expect(PermissionService.canManagePlayers(Roles.admin), isTrue);
      expect(PermissionService.canManagePlayers(Roles.speler), isFalse);
    });

    test('access SVS depends on tier and role', () {
      expect(
        PermissionService.canAccessSVS(
            Roles.hoofdcoach, OrganizationTier.basic),
        isFalse,
      );
      expect(
        PermissionService.canAccessSVS(Roles.hoofdcoach, OrganizationTier.pro),
        isTrue,
      );
    });
  });
}
