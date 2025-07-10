import '../models/action_event.dart';

/// Bins events into gridX × gridY matrix counts.
List<List<int>> binEvents({
  required List<ActionEvent> events,
  int gridX = 30,
  int gridY = 20,
}) {
  final matrix = List.generate(gridX, (_) => List.filled(gridY, 0));
  for (final ev in events) {
    final xIdx = (ev.x.clamp(0, 0.9999) * gridX).floor();
    final yIdx = (ev.y.clamp(0, 0.9999) * gridY).floor();
    matrix[xIdx][yIdx] += 1;
  }
  return matrix;
}