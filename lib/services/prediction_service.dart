import 'dart:math';

import '../models/action_event.dart';

/// Lightweight, wasm-safe prediction utilities for analytics heatmaps.
///
/// 2025 baseline: simple xG-like heuristic using distance & angle to goal.
/// Inputs use normalized pitch coordinates: x ∈ [0,1] (attacking → 1), y ∈ [0,1].
class PredictionService {
  const PredictionService();

  /// Computes a naive probability that an event at (x,y) results in a goal
  /// if it were a shot. This is NOT a trained model; it's a deterministic
  /// baseline for UX/analytics that can be replaced later.
  double computeShotProbability({required double x, required double y}) {
    final double clampedX = x.clamp(0.0, 1.0);
    final double clampedY = y.clamp(0.0, 1.0);

    // Goal assumed centered at x=1, y=0.5 in normalized pitch space.
    final double dx = 1.0 - clampedX; // distance to goal line along x
    final double dy = (clampedY - 0.5).abs(); // vertical offset from center
    final double distance =
        sqrt(dx * dx + dy * dy); // Euclidean in normalized coords

    // Angle proxy: narrower when farther from center line
    // Using atan2 of goal width proxy relative to distance
    final double angle = atan2(0.36,
        max(1e-6, distance)); // 0.36 ~ half-goal width proxy in norm units

    // Logistic baseline with tuned constants (heuristic)
    const double bias = -2.2; // base difficulty
    const double wDist = -3.0; // farther distance → lower prob
    const double wAng = 2.5; // wider angle → higher prob
    final double z = bias + wDist * distance + wAng * angle;
    return _sigmoid(z);
  }

  /// Produces a heatmap grid [gridX][gridY] where each cell contains the
  /// accumulated shot probability from the provided events. Only events of
  /// type [ActionType.shot] are considered by default; set [includeKeyPass]
  /// to accumulate a small fraction for key passes too.
  List<List<double>> shotDangerGrid({
    required List<ActionEvent> events,
    int gridX = 30,
    int gridY = 20,
    bool includeKeyPass = true,
  }) {
    final List<List<double>> grid = List<List<double>>.generate(
      gridX,
      (_) => List<double>.filled(gridY, 0.0),
    );
    for (final ActionEvent ev in events) {
      if (ev.type != ActionType.shot &&
          !(includeKeyPass && ev.type == ActionType.passKey)) {
        continue;
      }
      final int xIdx = (ev.x.clamp(0.0, 0.9999) * gridX).floor();
      final int yIdx = (ev.y.clamp(0.0, 0.9999) * gridY).floor();
      final double p = computeShotProbability(x: ev.x, y: ev.y) *
          (ev.type == ActionType.shot ? 1.0 : 0.25);
      grid[xIdx][yIdx] += p;
    }
    return grid;
  }

  double _sigmoid(double z) => 1.0 / (1.0 + exp(-z));
}
