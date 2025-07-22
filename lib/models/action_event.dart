class ActionEvent {
  ActionEvent({
    required this.id,
    required this.matchId,
    required this.x,
    required this.y,
    required this.type,
    required this.timestamp,
  });

  factory ActionEvent.fromJson(Map<String, dynamic> json) => ActionEvent(
        id: json['id'] as String,
        matchId: json['matchId'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        type: ActionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ActionType.touch,
        ),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  final String id;
  final String matchId;
  final double x; // 0-1 normalized pitch coordinates
  final double y;
  final ActionType type;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'matchId': matchId,
        'x': x,
        'y': y,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
      };
}

enum ActionType { touch, shot, passKey, tackle, interception }
