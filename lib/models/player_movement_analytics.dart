/// Aggregated movement metrics for a player within a single match.
class PlayerMovementAnalytics {
  const PlayerMovementAnalytics({
    required this.heatmap,
    required this.distanceMeters,
  });

  /// 2D heatmap matrix representing counts per cell.
  /// Example: 20x12 pitch grid → heatmap[row][col]
  final List<List<int>> heatmap;

  /// Total distance covered in meters.
  final double distanceMeters;

  // ------------------------- Serialization ------------------------- //
  factory PlayerMovementAnalytics.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawMatrix = json['heatmap'] as List<dynamic>;
    final matrix = rawMatrix
        .map((row) => (row as List<dynamic>).map((e) => e as int).toList())
        .toList();

    return PlayerMovementAnalytics(
      heatmap: matrix,
      distanceMeters: (json['distance_m'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'heatmap': heatmap,
        'distance_m': distanceMeters,
      };
}