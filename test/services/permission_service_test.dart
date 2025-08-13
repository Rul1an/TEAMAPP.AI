import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/permission_service.dart';
import 'package:jo17_tactical_manager/models/organization.dart';

void main() {
  group('PermissionService - role capabilities', () {
    test('View-only roles (speler, ouder) can only view', () {
      for (final role in ['speler', 'ouder']) {
        // Allowed views
        expect(PermissionService.canPerformAction('view_player', role, null),
            isTrue);
        expect(PermissionService.canPerformAction('view_training', role, null),
            isTrue);
        expect(PermissionService.canPerformAction('view_match', role, null),
            isTrue);

        // Forbidden modifications
        for (final action in [
          'create_player',
          'edit_player',
          'delete_player',
          'create_training',
          'edit_training',
          'delete_training',
          'create_match',
          'edit_match',
          'delete_match',
          'manage_training_sessions',
          'manage_exercise_library',
          'access_field_diagram_editor',
          'access_exercise_designer',
          'manage_organization',
          'view_analytics',
          'access_annual_planning',
        ]) {
          expect(
              PermissionService.canPerformAction(action, role, null), isFalse,
              reason: 'role=$role should not be able to $action');
        }
      }
    });

    test('Assistent has limited management access', () {
      const role = 'assistent';
      expect(
          PermissionService.canPerformAction(
              'manage_training_sessions', role, null),
          isTrue);
      expect(
          PermissionService.canPerformAction(
              'manage_exercise_library', role, null),
          isTrue);
      expect(
          PermissionService.canPerformAction(
              'access_field_diagram_editor', role, null),
          isTrue);
      expect(
          PermissionService.canPerformAction(
              'access_exercise_designer', role, null),
          isTrue);

      // Cannot create/edit players or matches
      for (final action in [
        'create_player',
        'edit_player',
        'delete_player',
        'create_match',
        'edit_match',
        'delete_match',
        'manage_organization',
        'view_analytics',
        'access_annual_planning',
      ]) {
        expect(PermissionService.canPerformAction(action, role, null), isFalse);
      }
    });

    test('Hoofdcoach can manage players, training, matches', () {
      const role = 'hoofdcoach';
      for (final action in [
        'create_player',
        'edit_player',
        'delete_player',
        'create_training',
        'edit_training',
        'delete_training',
        'manage_training_sessions',
        'create_match',
        'edit_match',
        'delete_match',
        'manage_exercise_library',
        'access_field_diagram_editor',
        'access_exercise_designer',
        'view_analytics',
        'access_annual_planning',
      ]) {
        expect(
            PermissionService.canPerformAction(
                action, role, OrganizationTier.pro),
            isTrue);
      }
      // No org management
      expect(
          PermissionService.canPerformAction('manage_organization', role, null),
          isFalse);
    });

    test('Bestuurder/Admin have full management access', () {
      for (final role in ['bestuurder', 'admin']) {
        for (final action in [
          'create_player',
          'edit_player',
          'delete_player',
          'create_training',
          'edit_training',
          'delete_training',
          'manage_training_sessions',
          'create_match',
          'edit_match',
          'delete_match',
          'manage_exercise_library',
          'access_field_diagram_editor',
          'access_exercise_designer',
          'manage_organization',
          'view_analytics',
          'access_annual_planning',
        ]) {
          expect(
              PermissionService.canPerformAction(
                  action, role, OrganizationTier.enterprise),
              isTrue,
              reason: 'role=$role should be able to $action');
        }
      }
    });

    test('SVS requires tier > basic', () {
      for (final tier in OrganizationTier.values) {
        final can = PermissionService.canAccessSVS('hoofdcoach', tier);
        expect(can, tier == OrganizationTier.basic ? isFalse : isTrue);
      }
    });
  });
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
