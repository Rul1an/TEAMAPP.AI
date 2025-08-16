import 'dart:math';

import '../analytics/heatmap_aggregator.dart';

/// Prepares privacy-preserving heatmap payloads for upload.
///
/// Best practices 2025 applied:
/// - Consent gating is handled by caller (see HeatMapController)
/// - K-anonymity: cells below [minCount] are zeroed out
/// - Differential privacy (optional): Laplace noise with parameter [epsilon]
/// - Deterministic seeding for reproducibility in tests
class HeatmapPrivacyService {
  const HeatmapPrivacyService();

  Map<String, dynamic> prepareUpload({
    required HeatmapAggregator aggregator,
    int minCount = 4,
    double? epsilon,
    int? seed,
    Map<String, String>? metadata,
  }) {
    final Map<String, int> counts =
        Map<String, int>.from(aggregator.asSparseCounts());

    // Apply k-anonymity threshold
    counts.removeWhere((String _, int c) => c > 0 && c < minCount);

    // Optional differential privacy: add Laplace noise to each cell
    if (epsilon != null && epsilon > 0) {
      final Random rng = Random(seed ?? 0);
      final double b = 1.0 / epsilon; // Laplace scale parameter
      counts.updateAll((String _, int c) {
        final double u = rng.nextDouble() - 0.5; // (-0.5, 0.5)
        final double noise = -b *
            (u.isNegative ? -1 : 1) *
            (1.0 - (1.0 - 2.0 * u.abs()).clamp(0.0, 1.0)).log();
        // Clamp to non-negative integer counts
        final int noisy = max(0, (c + noise).round());
        return noisy;
      });
    }

    // Serialize to compact payload
    final List<List<int>> entries = <List<int>>[];
    counts.forEach((String key, int value) {
      final List<String> parts = key.split(',');
      entries.add(<int>[int.parse(parts[0]), int.parse(parts[1]), value]);
    });

    return <String, dynamic>{
      'rows': aggregator.rows,
      'cols': aggregator.cols,
      'entries': entries,
      'k_min': minCount,
      if (epsilon != null) 'epsilon': epsilon,
      if (metadata != null && metadata.isNotEmpty) 'meta': metadata,
    };
  }
}

extension on num {
  // Natural log helper (avoids importing dart:math everywhere)
  double log() => logBase(this, e);
}

double logBase(num x, num base) {
  return log(x) / log(base);
}
