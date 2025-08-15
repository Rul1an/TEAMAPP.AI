import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/widgets/common/main_scaffold.dart';

void main() {
  group('Navigation Fix Verification Tests 2025', () {
    test('routeToNavIndex maps routes correctly after fix', () {
      // Mapping aligned with nav order: 0 Dashboard, 1 Players, 2 Matches, 3 Training, 4 Insights
      expect(MainScaffold.routeToNavIndex('/season'), equals(0),
          reason: 'Season routes map to dashboard (index 0)');

      expect(MainScaffold.routeToNavIndex('/annual-planning'), equals(0),
          reason: 'Annual planning routes map to dashboard (index 0)');

      expect(MainScaffold.routeToNavIndex('/training'), equals(3),
          reason: 'Training route should map to index 3');

      expect(MainScaffold.routeToNavIndex('/matches'), equals(2),
          reason: 'Matches route should map to index 2');

      expect(MainScaffold.routeToNavIndex('/players'), equals(1),
          reason: 'Players route should map to index 1');

      expect(MainScaffold.routeToNavIndex('/insights'), equals(4),
          reason: 'Insights route should map to index 4');

      // Test dashboard (should remain unchanged)
      expect(MainScaffold.routeToNavIndex('/dashboard'), equals(0),
          reason: 'Dashboard route should map to index 0');

      // Test unknown route (should default to 0)
      expect(MainScaffold.routeToNavIndex('/unknown-route'), equals(0),
          reason: 'Unknown routes should default to index 0');
    });

    test('sub-routes map correctly', () {
      // Training-related
      expect(MainScaffold.routeToNavIndex('/exercise-library'), equals(3));
      expect(MainScaffold.routeToNavIndex('/training-sessions'), equals(3));
      expect(MainScaffold.routeToNavIndex('/field-diagram-editor'), equals(3));
      expect(MainScaffold.routeToNavIndex('/exercise-designer'), equals(3));

      // Lineup maps to Matches
      expect(MainScaffold.routeToNavIndex('/lineup'), equals(2));

      // Analytics maps to Insights
      expect(MainScaffold.routeToNavIndex('/analytics'), equals(4));
      expect(MainScaffold.routeToNavIndex('/svs'), equals(4));
    });

    test('all navigation indices are valid', () {
      final testRoutes = [
        '/dashboard',
        '/season',
        '/annual-planning',
        '/training',
        '/matches',
        '/players',
        '/insights',
        '/analytics'
      ];

      for (final route in testRoutes) {
        final index = MainScaffold.routeToNavIndex(route);
        expect(index, greaterThanOrEqualTo(0),
            reason: 'Route $route should have non-negative index');
        expect(index, lessThanOrEqualTo(4),
            reason:
                'Route $route should have index <= 4 (max navigation items)');
      }
    });
  });
}
