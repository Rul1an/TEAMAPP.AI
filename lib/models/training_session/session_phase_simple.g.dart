// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_phase_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionPhase _$SessionPhaseFromJson(Map<String, dynamic> json) => SessionPhase(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: $enumDecode(_$PhaseTypeEnumMap, json['type']),
  orderIndex: (json['orderIndex'] as num).toInt(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  exerciseIds: (json['exerciseIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SessionPhaseToJson(SessionPhase instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'name': instance.name,
      'description': instance.description,
      'type': _$PhaseTypeEnumMap[instance.type]!,
      'orderIndex': instance.orderIndex,
      'durationMinutes': instance.durationMinutes,
      'exerciseIds': instance.exerciseIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PhaseTypeEnumMap = {
  PhaseType.warmup: 'warmup',
  PhaseType.technical: 'technical',
  PhaseType.tactical: 'tactical',
  PhaseType.physical: 'physical',
  PhaseType.smallSidedGames: 'smallSidedGames',
  PhaseType.match: 'match',
  PhaseType.cooldown: 'cooldown',
  PhaseType.discussion: 'discussion',
};
