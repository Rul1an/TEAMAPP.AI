// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticsImpl _$$StatisticsImplFromJson(Map<String, dynamic> json) =>
    _$StatisticsImpl(
      totalPlayers: (json['totalPlayers'] as num?)?.toInt() ?? 0,
      totalMatches: (json['totalMatches'] as num?)?.toInt() ?? 0,
      totalTrainings: (json['totalTrainings'] as num?)?.toInt() ?? 0,
      winPercentage: (json['winPercentage'] as num?)?.toDouble() ?? 0.0,
      avgGoalsFor: (json['avgGoalsFor'] as num?)?.toDouble() ?? 0.0,
      avgGoalsAgainst: (json['avgGoalsAgainst'] as num?)?.toDouble() ?? 0.0,
      totalWins: (json['totalWins'] as num?)?.toInt() ?? 0,
      totalLosses: (json['totalLosses'] as num?)?.toInt() ?? 0,
      totalDraws: (json['totalDraws'] as num?)?.toInt() ?? 0,
      attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$StatisticsImplToJson(_$StatisticsImpl instance) =>
    <String, dynamic>{
      'totalPlayers': instance.totalPlayers,
      'totalMatches': instance.totalMatches,
      'totalTrainings': instance.totalTrainings,
      'winPercentage': instance.winPercentage,
      'avgGoalsFor': instance.avgGoalsFor,
      'avgGoalsAgainst': instance.avgGoalsAgainst,
      'totalWins': instance.totalWins,
      'totalLosses': instance.totalLosses,
      'totalDraws': instance.totalDraws,
      'attendanceRate': instance.attendanceRate,
    };
