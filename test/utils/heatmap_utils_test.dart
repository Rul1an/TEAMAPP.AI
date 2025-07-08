import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/action_event.dart';
import 'package:jo17_tactical_manager/utils/heatmap_utils.dart';

void main() {
  test('binEvents counts correctly', () {
    final events = [
      ActionEvent(
        id: '1',
        matchId: 'm',
        x: 0.1,
        y: 0.1,
        type: ActionType.touch,
        timestamp: DateTime.now(),
      ),
      ActionEvent(
        id: '2',
        matchId: 'm',
        x: 0.1,
        y: 0.1,
        type: ActionType.touch,
        timestamp: DateTime.now(),
      ),
      ActionEvent(
        id: '3',
        matchId: 'm',
        x: 0.9,
        y: 0.9,
        type: ActionType.shot,
        timestamp: DateTime.now(),
      ),
    ];
    final matrix = binEvents(events: events, gridX: 10, gridY: 10);
    expect(matrix[1][1], 2); // first two events
    expect(matrix[9][9], 1);
  });
}