import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/widgets/common/main_scaffold.dart';

void main() {
  group('MainScaffold.routeToNavIndex', () {
    test('maps dashboard routes to index 0', () {
      expect(MainScaffold.routeToNavIndex('/dashboard'), 0);
      expect(MainScaffold.routeToNavIndex('/dashboard/stats'), 0);
    });

    test('maps season & annual planning routes to dashboard (index 0)', () {
      expect(MainScaffold.routeToNavIndex('/season'), 0);
      expect(MainScaffold.routeToNavIndex('/annual-planning'), 0);
    });

    test('maps training related routes to index 3', () {
      final routes = [
        '/training',
        '/exercise-library',
        '/training-sessions',
        '/exercise-designer',
        '/field-diagram-editor',
      ];
      for (final r in routes) {
        expect(MainScaffold.routeToNavIndex(r), 3, reason: 'route $r');
      }
    });

    test('maps matches related routes to index 2', () {
      expect(MainScaffold.routeToNavIndex('/matches'), 2);
      expect(MainScaffold.routeToNavIndex('/lineup'), 2);
    });

    test('maps players route to index 1', () {
      expect(MainScaffold.routeToNavIndex('/players'), 1);
    });

    test('maps insights & legacy analytics routes to index 4', () {
      expect(MainScaffold.routeToNavIndex('/insights'), 4);
      expect(MainScaffold.routeToNavIndex('/analytics'), 4);
      expect(MainScaffold.routeToNavIndex('/svs'), 4);
    });

    test('defaults to 0 for unknown routes', () {
      expect(MainScaffold.routeToNavIndex('/unknown'), 0);
    });
  });
}
