import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/models/action_event.dart';
import 'package:jo17_tactical_manager/utils/heatmap_utils.dart';

void main() {
  group('binEvents', () {
    test('bins events into correct grid cells', () {
      final events = [
        // Center point
        ActionEvent(
          id: '1',
          matchId: 'm1',
          x: 0.5,
          y: 0.5,
          type: ActionType.touch,
          timestamp: DateTime(2025),
        ),
        // Near top-left corner
        ActionEvent(
          id: '2',
          matchId: 'm1',
          x: 0.01,
          y: 0.02,
          type: ActionType.touch,
          timestamp: DateTime(2025),
        ),
      ];

      final matrix = binEvents(events: events, gridX: 10, gridY: 10);

      expect(matrix[5][5], 1); // center
      expect(matrix[0][0], 1); // corner
      // All other cells zero
      final total = matrix.expand((r) => r).reduce((a, b) => a + b);
      expect(total, 2);
    });
  });

  test('applyKAnonymityThreshold zeros sparse cells below minCount', () {
    final matrix = <List<int>>[
      <int>[0, 1, 2, 3, 4, 5],
      <int>[6, 0, 1, 2, 3, 4],
    ];
    final filtered = applyKAnonymityThreshold(matrix, minCount: 3);
    // Values 1 and 2 become 0; 3+ stay
    expect(filtered[0], <int>[0, 0, 0, 3, 4, 5]);
    expect(filtered[1], <int>[6, 0, 0, 0, 3, 4]);
  });

  test('normalizeToIntMatrix scales values to 0..scale', () {
    final grid = <List<double>>[
      <double>[0.0, 0.5, 1.0],
      <double>[0.25, 0.75, 0.0],
    ];
    final norm = normalizeToIntMatrix(grid, scale: 10);
    expect(norm.length, 2);
    expect(norm[0].length, 3);
    // Max 1.0 → 10, 0.5 → 5, 0.25 → 2 or 3 depending on rounding
    expect(norm[0][0], 0);
    expect(norm[0][1], 5);
    expect(norm[0][2], 10);
    expect(norm[1][0], inInclusiveRange(2, 3));
  });
}
