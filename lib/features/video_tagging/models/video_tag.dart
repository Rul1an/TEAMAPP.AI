import 'package:equatable/equatable.dart';
import 'tag_type.dart';

class VideoTag extends Equatable {
  const VideoTag({
    required this.id,
    required this.videoId,
    required this.timestamp,
    required this.label,
    required this.type,
    this.playerId,
    this.description,
  });

  factory VideoTag.fromJson(Map<String, dynamic> json) => VideoTag(
        id: json['id'] as String,
        videoId: json['video_id'] as String,
        timestamp: json['timestamp'] as int,
        label: json['label'] as String,
        type: TagType.values.firstWhere((e) => e.name == json['type']),
        playerId: json['player_id'] as String?,
        description: json['description'] as String?,
      );

  final String id;
  final String videoId;
  final int timestamp; // seconds
  final String label;
  final TagType type;
  final String? playerId;
  final String? description;

  Map<String, dynamic> toJson() => {
        'id': id,
        'video_id': videoId,
        'timestamp': timestamp,
        'label': label,
        'type': type.name,
        if (playerId != null) 'player_id': playerId,
        if (description != null) 'description': description,
      };

  @override
  List<Object?> get props =>
      [id, videoId, timestamp, label, type, playerId, description];
}
