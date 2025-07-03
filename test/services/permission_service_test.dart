import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/organization.dart';
import 'package:jo17_tactical_manager/services/permission_service.dart';

void main() {
  group('PermissionService view-only helpers', () {
    test('Players and parents are view-only users', () {
      expect(PermissionService.isViewOnlyUser('speler'), isTrue);
      expect(PermissionService.isViewOnlyUser('ouder'), isTrue);
    });

    test('Coach is NOT view-only', () {
      expect(PermissionService.isViewOnlyUser('hoofdcoach'), isFalse);
    });
  });

  group('Field-diagram editor access', () {
    const allowed = ['bestuurder', 'hoofdcoach', 'assistent', 'admin'];
    const disallowed = ['speler', 'ouder', null];

    for (final role in allowed) {
      test('Role "$role" has access', () {
        expect(PermissionService.canAccessFieldDiagramEditor(role), isTrue);
      });
    }

    for (final role in disallowed) {
      test('Role "$role" has NO access', () {
        expect(PermissionService.canAccessFieldDiagramEditor(role), isFalse);
      });
    }
  });

  group('SVS access per tier', () {
    test('Basic tier never grants SVS', () {
      expect(
        PermissionService.canAccessSVS('bestuurder', OrganizationTier.basic),
        isFalse,
      );
    });

    test('Pro tier grants SVS for coach/admin roles', () {
      expect(
        PermissionService.canAccessSVS('hoofdcoach', OrganizationTier.pro),
        isTrue,
      );
      expect(
        PermissionService.canAccessSVS('bestuurder', OrganizationTier.pro),
        isTrue,
      );
      expect(
        PermissionService.canAccessSVS('speler', OrganizationTier.pro),
        isFalse,
      );
    });
  });

  group('Accessible routes', () {
    test('Player gets only view routes', () {
      final routes = PermissionService.getAccessibleRoutes(
        'speler',
        OrganizationTier.basic,
      );
      expect(
        routes,
        containsAll(['/dashboard', '/players', '/training', '/matches']),
      );
      expect(routes, isNot(contains('/admin')));
    });

    test('Admin gets admin route', () {
      final routes = PermissionService.getAccessibleRoutes(
        'bestuurder',
        OrganizationTier.basic,
      );
      expect(routes, contains('/admin'));
    });
  });
}
