// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoTag _$VideoTagFromJson(Map<String, dynamic> json) => VideoTag(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      label: json['label'] as String,
      type: $enumDecode(_$TagTypeEnumMap, json['type']),
      playerId: json['playerId'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$VideoTagToJson(VideoTag instance) => <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'timestamp': instance.timestamp,
      'label': instance.label,
      'type': _$TagTypeEnumMap[instance.type]!,
      'playerId': instance.playerId,
      'description': instance.description,
    };

const _$TagTypeEnumMap = {
  TagType.goal: 'goal',
  TagType.assist: 'assist',
  TagType.save: 'save',
  TagType.tactical: 'tactical',
  TagType.technique: 'technique',
};
