import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/analytics/heatmap_aggregator.dart';

void main() {
  group('HeatmapAggregator', () {
    test('bins normalized points into grid cells', () {
      final agg = HeatmapAggregator(rows: 10, cols: 10);
      agg.addPoint(x: 0.05, y: 0.05); // (0,0)
      agg.addPoint(x: 0.99, y: 0.99); // (9,9)
      final grid = agg.asGrid();
      expect(grid[0][0], 1);
      expect(grid[9][9], 1);
    });

    test('clamps coordinates and increments counts', () {
      final agg = HeatmapAggregator(rows: 4, cols: 4);
      agg.addPoint(x: -1.0, y: -1.0); // clamps to (0,0)
      agg.addPoint(x: 1.5, y: 1.5); // clamps to (3,3)
      agg.addPoint(x: 1.5, y: 1.5); // again
      final grid = agg.asGrid();
      expect(grid[0][0], 1);
      expect(grid[3][3], 2);
    });

    test('sampling rate drops points deterministically with seeded RNG', () {
      final aggA = HeatmapAggregator(
          rows: 2, cols: 2, sampleRate: 0.5, random: Random(42));
      final aggB = HeatmapAggregator(
          rows: 2, cols: 2, sampleRate: 0.5, random: Random(42));
      for (int i = 0; i < 100; i++) {
        final double x = (i % 10) / 10.0;
        final double y = (i % 10) / 10.0;
        aggA.addPoint(x: x, y: y);
        aggB.addPoint(x: x, y: y);
      }
      expect(aggA.asSparseCounts(), equals(aggB.asSparseCounts()));
    });

    test('json round-trip preserves counts', () {
      final agg = HeatmapAggregator(rows: 3, cols: 3);
      agg.addPoint(x: 0.1, y: 0.1);
      agg.addPoint(x: 0.8, y: 0.8);
      final json = agg.toJson();
      final rebuilt = HeatmapAggregator.fromJson(json);
      expect(rebuilt.rows, 3);
      expect(rebuilt.cols, 3);
      expect(rebuilt.asSparseCounts(), agg.asSparseCounts());
    });
  });
}
