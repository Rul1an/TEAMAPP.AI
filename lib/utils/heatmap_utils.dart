import '../models/action_event.dart';
import '../analytics/heatmap_aggregator.dart';

/// Bins events into gridX × gridY matrix counts.
List<List<int>> binEvents({
  required List<ActionEvent> events,
  int gridX = 30,
  int gridY = 20,
}) {
  final HeatmapAggregator aggregator =
      HeatmapAggregator(rows: gridY, cols: gridX);
  for (final ActionEvent ev in events) {
    aggregator.addPoint(x: ev.x, y: ev.y);
  }
  // aggregator.asGrid returns [rows][cols] shape; our original util used [gridX][gridY].
  // Normalize to the original orientation [gridX][gridY] expected by painter/tests.
  final List<List<int>> grid =
      aggregator.asGrid(); // rows x cols = gridY x gridX
  final List<List<int>> matrix = List<List<int>>.generate(
    gridX,
    (int x) => List<int>.generate(gridY, (int y) => grid[y][x]),
  );
  return matrix;
}

/// Applies k-anonymity thresholding by zeroing any cell with a count below
/// [minCount]. This avoids rendering highly identifying sparse cells.
List<List<int>> applyKAnonymityThreshold(
  List<List<int>> matrix, {
  int minCount = 5,
}) {
  if (minCount <= 1) return matrix;
  final int width = matrix.length;
  if (width == 0) return matrix;
  final int height = matrix.first.length;
  for (int x = 0; x < width; x += 1) {
    for (int y = 0; y < height; y += 1) {
      if (matrix[x][y] > 0 && matrix[x][y] < minCount) {
        matrix[x][y] = 0;
      }
    }
  }
  return matrix;
}
