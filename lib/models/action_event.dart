class ActionEvent {
  ActionEvent({
    required this.id,
    required this.matchId,
    required this.x,
    required this.y,
    required this.type,
    required this.timestamp,
  });

  final String id;
  final String matchId;
  final double x; // 0-1 normalized pitch coordinates
  final double y;
  final ActionType type;
  final DateTime timestamp;
}

enum ActionType { touch, shot, passKey, tackle, interception }