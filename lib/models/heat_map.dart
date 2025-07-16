/// Represents a pitch heat-map for a player or team within a match.
class HeatMap {
  const HeatMap({
    required this.id,
    required this.matrix,
  });

  /// Stable identifier (e.g., <matchId>_<playerId>).
  final String id;

  /// 2-D grid with counts per cell.
  final List<List<int>> matrix;

  // ------------------------- JSON ------------------------- //
  factory HeatMap.fromJson(Map<String, dynamic> json) => HeatMap(
        id: json['id'] as String,
        matrix: (json['matrix'] as List<dynamic>)
            .map((row) => (row as List<dynamic>).map((e) => e as int).toList())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'matrix': matrix,
      };
}