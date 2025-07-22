// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamImpl _$$TeamImplFromJson(Map<String, dynamic> json) => _$TeamImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      ageCategory: $enumDecode(_$AgeCategoryEnumMap, json['ageCategory']),
      level: $enumDecode(_$TeamLevelEnumMap, json['level']),
      gender: $enumDecode(_$TeamGenderEnumMap, json['gender']),
      currentSeason: json['currentSeason'] as String,
      settings: TeamSettings.fromJson(json['settings'] as Map<String, dynamic>),
      status: $enumDecode(_$TeamStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      colors: json['colors'] as String?,
      league: json['league'] as String?,
      division: json['division'] as String?,
      staffIds: (json['staffIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      headCoachId: json['headCoachId'] as String?,
      assistantCoachId: json['assistantCoachId'] as String?,
      teamManagerId: json['teamManagerId'] as String?,
      playerIds: (json['playerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      captainIds: (json['captainIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$TeamImplToJson(_$TeamImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'name': instance.name,
      'shortName': instance.shortName,
      'ageCategory': _$AgeCategoryEnumMap[instance.ageCategory]!,
      'level': _$TeamLevelEnumMap[instance.level]!,
      'gender': _$TeamGenderEnumMap[instance.gender]!,
      'currentSeason': instance.currentSeason,
      'settings': instance.settings,
      'status': _$TeamStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'colors': instance.colors,
      'league': instance.league,
      'division': instance.division,
      'staffIds': instance.staffIds,
      'headCoachId': instance.headCoachId,
      'assistantCoachId': instance.assistantCoachId,
      'teamManagerId': instance.teamManagerId,
      'playerIds': instance.playerIds,
      'captainIds': instance.captainIds,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$AgeCategoryEnumMap = {
  AgeCategory.jo7: 'jo7',
  AgeCategory.jo8: 'jo8',
  AgeCategory.jo9: 'jo9',
  AgeCategory.jo10: 'jo10',
  AgeCategory.jo11: 'jo11',
  AgeCategory.jo12: 'jo12',
  AgeCategory.jo13: 'jo13',
  AgeCategory.jo14: 'jo14',
  AgeCategory.jo15: 'jo15',
  AgeCategory.jo16: 'jo16',
  AgeCategory.jo17: 'jo17',
  AgeCategory.jo18: 'jo18',
  AgeCategory.jo19: 'jo19',
  AgeCategory.senior: 'senior',
  AgeCategory.veteran: 'veteran',
};

const _$TeamLevelEnumMap = {
  TeamLevel.recreational: 'recreational',
  TeamLevel.competitive: 'competitive',
  TeamLevel.elite: 'elite',
  TeamLevel.academy: 'academy',
  TeamLevel.reserve: 'reserve',
  TeamLevel.first: 'first',
};

const _$TeamGenderEnumMap = {
  TeamGender.male: 'male',
  TeamGender.female: 'female',
  TeamGender.mixed: 'mixed',
};

const _$TeamStatusEnumMap = {
  TeamStatus.active: 'active',
  TeamStatus.inactive: 'inactive',
  TeamStatus.disbanded: 'disbanded',
  TeamStatus.suspended: 'suspended',
};

_$TeamSettingsImpl _$$TeamSettingsImplFromJson(Map<String, dynamic> json) =>
    _$TeamSettingsImpl(
      trainingsPerWeek: (json['trainingsPerWeek'] as num?)?.toInt() ?? 2,
      defaultTrainingDuration:
          (json['defaultTrainingDuration'] as num?)?.toInt() ?? 90,
      trainingDays: (json['trainingDays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Tuesday', 'Thursday'],
      matchDay: json['matchDay'] as String? ?? 'Saturday',
      defaultMatchDuration:
          (json['defaultMatchDuration'] as num?)?.toInt() ?? 90,
      allowParentCommunication:
          json['allowParentCommunication'] as bool? ?? true,
      sendTrainingReminders: json['sendTrainingReminders'] as bool? ?? true,
      sendMatchReminders: json['sendMatchReminders'] as bool? ?? true,
      trackPlayerPerformance: json['trackPlayerPerformance'] as bool? ?? true,
      enableVideoAnalysis: json['enableVideoAnalysis'] as bool? ?? true,
      enableGPSTracking: json['enableGPSTracking'] as bool? ?? false,
      requireMedicalCertificate:
          json['requireMedicalCertificate'] as bool? ?? true,
      requireInsurance: json['requireInsurance'] as bool? ?? true,
      requireVOG: json['requireVOG'] as bool? ?? false,
    );

Map<String, dynamic> _$$TeamSettingsImplToJson(_$TeamSettingsImpl instance) =>
    <String, dynamic>{
      'trainingsPerWeek': instance.trainingsPerWeek,
      'defaultTrainingDuration': instance.defaultTrainingDuration,
      'trainingDays': instance.trainingDays,
      'matchDay': instance.matchDay,
      'defaultMatchDuration': instance.defaultMatchDuration,
      'allowParentCommunication': instance.allowParentCommunication,
      'sendTrainingReminders': instance.sendTrainingReminders,
      'sendMatchReminders': instance.sendMatchReminders,
      'trackPlayerPerformance': instance.trackPlayerPerformance,
      'enableVideoAnalysis': instance.enableVideoAnalysis,
      'enableGPSTracking': instance.enableGPSTracking,
      'requireMedicalCertificate': instance.requireMedicalCertificate,
      'requireInsurance': instance.requireInsurance,
      'requireVOG': instance.requireVOG,
    };
