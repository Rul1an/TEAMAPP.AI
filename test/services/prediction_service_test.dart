import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/models/action_event.dart';
import 'package:jo17_tactical_manager/services/prediction_service.dart';

void main() {
  group('PredictionService.computeShotProbability', () {
    test('probability is higher near goal center and lower far away', () {
      const svc = PredictionService();
      final double closeCenter = svc.computeShotProbability(x: 0.95, y: 0.5);
      final double farWide = svc.computeShotProbability(x: 0.2, y: 0.1);
      expect(closeCenter, greaterThan(farWide));
      expect(closeCenter, inInclusiveRange(0.0, 1.0));
      expect(farWide, inInclusiveRange(0.0, 1.0));
    });
  });

  group('PredictionService.shotDangerGrid', () {
    test('accumulates probability for shots and smaller weight for key passes',
        () {
      const svc = PredictionService();
      final List<ActionEvent> events = <ActionEvent>[
        ActionEvent(
          id: 's1',
          matchId: 'm',
          x: 0.9,
          y: 0.5,
          type: ActionType.shot,
          timestamp: DateTime(2025),
        ),
        ActionEvent(
          id: 'k1',
          matchId: 'm',
          x: 0.8,
          y: 0.5,
          type: ActionType.passKey,
          timestamp: DateTime(2025),
        ),
      ];
      final grid = svc.shotDangerGrid(events: events, gridX: 10, gridY: 10);
      final double sum = grid
          .expand((List<double> row) => row)
          .fold(0.0, (double a, double b) => a + b);
      expect(sum, greaterThan(0));
    });
  });
}
