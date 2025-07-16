import 'package:uuid/uuid.dart';

/// Supported event types that can be detected from video tags or ML inference.
/// Only the first three are required for Sprint 10 – extend as needed later.
enum VideoEventType {
  goal,
  corner,
  foul,
}

/// Domain model representing a single tactical event detected in a match video.
class VideoEvent {
  VideoEvent({
    required this.id,
    required this.matchId,
    required this.timestampMs,
    required this.type,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  /// Stable UUID (generated client-side to support offline mode)
  final String id;

  /// FK → `matches.id`
  final String matchId;

  /// Position in the video (milliseconds since kick-off)
  final int timestampMs;

  /// The kind of event (goal, corner, …)
  final VideoEventType type;

  /// Creation timestamp – synced with server clock once online
  final DateTime createdAt;

  // ------------------------- JSON helpers ------------------------- //

  factory VideoEvent.fromJson(Map<String, dynamic> json) => VideoEvent(
        id: json['id'] as String? ?? const Uuid().v4(),
        matchId: json['match_id'] as String,
        timestampMs: json['timestamp_ms'] as int,
        type: _stringToType(json['type'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'match_id': matchId,
        'timestamp_ms': timestampMs,
        'type': type.name,
        'created_at': createdAt.toIso8601String(),
      };

  // ------------------------- Helpers ------------------------- //

  static VideoEventType _stringToType(String raw) {
    switch (raw) {
      case 'goal':
        return VideoEventType.goal;
      case 'corner':
        return VideoEventType.corner;
      case 'foul':
        return VideoEventType.foul;
      default:
        throw ArgumentError('Unsupported video event type: $raw');
    }
  }
}