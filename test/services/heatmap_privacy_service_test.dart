import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/analytics/heatmap_aggregator.dart';
import 'package:jo17_tactical_manager/services/heatmap_privacy_service.dart';

void main() {
  test(
      'prepareUpload applies k-anonymity and optional DP noise deterministically',
      () {
    final agg = HeatmapAggregator(rows: 4, cols: 4);
    // Put sparse points into several cells
    agg.addPoint(x: 0.1, y: 0.1); // (0,0)
    agg.addPoint(x: 0.1, y: 0.1); // (0,0) -> count 2
    agg.addPoint(x: 0.6, y: 0.6); // (2,2) -> count 1 (will be dropped by k)

    final svc = HeatmapPrivacyService();
    final payloadNoDp = svc.prepareUpload(
      aggregator: agg,
      minCount: 2,
    );
    expect(payloadNoDp['rows'], 4);
    expect(payloadNoDp['cols'], 4);
    final entriesNoDp = payloadNoDp['entries'] as List<dynamic>;
    // Only one entry should remain ((0,0),2)
    expect(entriesNoDp.length, 1);
    expect(entriesNoDp.first[0], 0);
    expect(entriesNoDp.first[1], 0);
    expect(entriesNoDp.first[2], greaterThanOrEqualTo(2));

    // With DP noise and fixed seed, result must be deterministic
    final payloadDpA = svc.prepareUpload(
      aggregator: agg,
      minCount: 2,
      epsilon: 1.0,
      seed: 42,
    );
    final payloadDpB = svc.prepareUpload(
      aggregator: agg,
      minCount: 2,
      epsilon: 1.0,
      seed: 42,
    );
    expect(payloadDpA, equals(payloadDpB));
  });
}
