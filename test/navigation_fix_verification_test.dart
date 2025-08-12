import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/widgets/common/main_scaffold.dart';

void main() {
  group('Navigation Fix Verification Tests 2025', () {
    test('routeToNavIndex maps routes correctly after fix', () {
      // Test the exact mappings that were failing according to comprehensive test failure analysis
      expect(MainScaffold.routeToNavIndex('/season'), equals(1),
          reason: 'Season route should map to index 1');

      expect(MainScaffold.routeToNavIndex('/annual-planning'), equals(1),
          reason: 'Annual planning route should map to index 1');

      expect(MainScaffold.routeToNavIndex('/training'), equals(2),
          reason: 'Training route should map to index 2');

      expect(MainScaffold.routeToNavIndex('/matches'), equals(3),
          reason: 'Matches route should map to index 3');

      expect(MainScaffold.routeToNavIndex('/players'), equals(4),
          reason: 'Players route should map to index 4');

      expect(MainScaffold.routeToNavIndex('/insights'), equals(5),
          reason: 'Insights route should map to index 5');

      // Test dashboard (should remain unchanged)
      expect(MainScaffold.routeToNavIndex('/dashboard'), equals(0),
          reason: 'Dashboard route should map to index 0');

      // Test unknown route (should default to 0)
      expect(MainScaffold.routeToNavIndex('/unknown-route'), equals(0),
          reason: 'Unknown routes should default to index 0');
    });

    test('sub-routes map correctly', () {
      // Test exercise library routes (should map to training index 2)
      expect(MainScaffold.routeToNavIndex('/exercise-library'), equals(2));
      expect(MainScaffold.routeToNavIndex('/training-sessions'), equals(2));
      expect(MainScaffold.routeToNavIndex('/field-diagram-editor'), equals(2));
      expect(MainScaffold.routeToNavIndex('/exercise-designer'), equals(2));

      // Test lineup routes (should map to matches index 3)
      expect(MainScaffold.routeToNavIndex('/lineup'), equals(3));

      // Test analytics routes (should map to insights index 5)
      expect(MainScaffold.routeToNavIndex('/analytics'), equals(5));
      expect(MainScaffold.routeToNavIndex('/svs'), equals(5));
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
        expect(index, lessThanOrEqualTo(5),
            reason:
                'Route $route should have index <= 5 (max navigation items)');
      }
    });
  });
}
