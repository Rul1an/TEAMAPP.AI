import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'tag_type.dart';

part 'video_tag.g.dart';

@JsonSerializable()
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

  final String id;
  final String videoId;
  final int timestamp; // seconds
  final String label;
  final TagType type;
  final String? playerId;
  final String? description;

  factory VideoTag.fromJson(Map<String, dynamic> json) =>
      _$VideoTagFromJson(json);
  Map<String, dynamic> toJson() => _$VideoTagToJson(this);

  @override
  List<Object?> get props =>
      [id, videoId, timestamp, label, type, playerId, description];
}
