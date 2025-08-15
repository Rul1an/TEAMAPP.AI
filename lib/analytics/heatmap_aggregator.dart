import 'dart:math';

/// Aggregates normalized interaction points (0..1, 0..1) into a fixed grid.
///
/// 2025 best-practice notes:
/// - Use normalized coordinates to avoid leaking screen resolution specifics
/// - Keep data sparse (row,col -> count) for efficient transmission
/// - Support deterministic sampling (seeded RNG) to control volume/privacy
/// - Provide JSON round-trip for storage/transport
class HeatmapAggregator {
  HeatmapAggregator({
    required this.rows,
    required this.cols,
    double sampleRate = 1.0,
    Random? random,
  })  : assert(rows > 0 && cols > 0),
        assert(sampleRate >= 0 && sampleRate <= 1),
        _sampleRate = sampleRate,
        _random = random ?? Random(0),
        _counts = <String, int>{};

  final int rows;
  final int cols;
  final double _sampleRate;
  final Random _random;
  final Map<String, int> _counts;

  /// Adds a normalized point. Values are clamped to [0,1].
  void addPoint({required double x, required double y}) {
    if (_sampleRate < 1.0 && _random.nextDouble() > _sampleRate) {
      return; // sampled out
    }
    final double clampedX = x.clamp(0.0, 1.0);
    final double clampedY = y.clamp(0.0, 1.0);
    final int col = min((clampedX * cols).floor(), cols - 1);
    final int row = min((clampedY * rows).floor(), rows - 1);
    final String key = _key(row, col);
    _counts.update(key, (value) => value + 1, ifAbsent: () => 1);
  }

  /// Returns a sparse map keyed by "r,c" to count.
  Map<String, int> asSparseCounts() => Map<String, int>.unmodifiable(_counts);

  /// Returns a dense rows x cols grid of counts.
  List<List<int>> asGrid() {
    final List<List<int>> grid =
        List<List<int>>.generate(rows, (_) => List<int>.filled(cols, 0));
    _counts.forEach((key, count) {
      final List<String> parts = key.split(',');
      final int r = int.parse(parts[0]);
      final int c = int.parse(parts[1]);
      grid[r][c] = count;
    });
    return grid;
  }

  void reset() => _counts.clear();

  Map<String, dynamic> toJson() {
    final List<List<int>> entries = <List<int>>[];
    _counts.forEach((key, count) {
      final List<String> parts = key.split(',');
      entries.add(<int>[int.parse(parts[0]), int.parse(parts[1]), count]);
    });
    return <String, dynamic>{
      'rows': rows,
      'cols': cols,
      'entries': entries,
    };
  }

  static HeatmapAggregator fromJson(
    Map<String, dynamic> json, {
    double sampleRate = 1.0,
    Random? random,
  }) {
    final int rows = json['rows'] as int;
    final int cols = json['cols'] as int;
    final HeatmapAggregator agg = HeatmapAggregator(
      rows: rows,
      cols: cols,
      sampleRate: sampleRate,
      random: random,
    );
    final List<dynamic> entries =
        json['entries'] as List<dynamic>? ?? <dynamic>[];
    for (final dynamic e in entries) {
      if (e is List && e.length == 3) {
        final int r = e[0] as int;
        final int c = e[1] as int;
        final int count = e[2] as int;
        final String key = _key(r, c);
        agg._counts[key] = count;
      }
    }
    return agg;
  }

  static String _key(int r, int c) => '$r,$c';
}
