// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubImpl _$$ClubImplFromJson(Map<String, dynamic> json) => _$ClubImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      foundedDate: DateTime.parse(json['foundedDate'] as String),
      settings: ClubSettings.fromJson(json['settings'] as Map<String, dynamic>),
      status: $enumDecode(_$ClubStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      colors: json['colors'] as String?,
      motto: json['motto'] as String?,
      tier: $enumDecodeNullable(_$ClubTierEnumMap, json['tier']) ??
          ClubTier.basic,
      teams: (json['teams'] as List<dynamic>?)
              ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      staff: (json['staff'] as List<dynamic>?)
              ?.map((e) => StaffMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$ClubImplToJson(_$ClubImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'foundedDate': instance.foundedDate.toIso8601String(),
      'settings': instance.settings,
      'status': _$ClubStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'website': instance.website,
      'email': instance.email,
      'phone': instance.phone,
      'street': instance.street,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'colors': instance.colors,
      'motto': instance.motto,
      'tier': _$ClubTierEnumMap[instance.tier]!,
      'teams': instance.teams,
      'staff': instance.staff,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$ClubStatusEnumMap = {
  ClubStatus.active: 'active',
  ClubStatus.inactive: 'inactive',
  ClubStatus.suspended: 'suspended',
  ClubStatus.dissolved: 'dissolved',
};

const _$ClubTierEnumMap = {
  ClubTier.basic: 'basic',
  ClubTier.pro: 'pro',
  ClubTier.enterprise: 'enterprise',
};

_$ClubSettingsImpl _$$ClubSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ClubSettingsImpl(
      defaultLanguage: json['defaultLanguage'] as String? ?? 'nl',
      currency: json['currency'] as String? ?? 'EUR',
      timezone: json['timezone'] as String? ?? 'Europe/Amsterdam',
      enablePlayerTracking: json['enablePlayerTracking'] as bool? ?? true,
      enableCommunication: json['enableCommunication'] as bool? ?? true,
      enableFinancialManagement:
          json['enableFinancialManagement'] as bool? ?? false,
      enableAdvancedAnalytics:
          json['enableAdvancedAnalytics'] as bool? ?? false,
      allowParentAccess: json['allowParentAccess'] as bool? ?? true,
      allowPlayerSelfRegistration:
          json['allowPlayerSelfRegistration'] as bool? ?? false,
      requireVOGForStaff: json['requireVOGForStaff'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      defaultTrainingDuration:
          (json['defaultTrainingDuration'] as num?)?.toInt() ?? 90,
      defaultMatchDuration:
          (json['defaultMatchDuration'] as num?)?.toInt() ?? 90,
      dataRetentionYears: (json['dataRetentionYears'] as num?)?.toInt() ?? 7,
    );

Map<String, dynamic> _$$ClubSettingsImplToJson(_$ClubSettingsImpl instance) =>
    <String, dynamic>{
      'defaultLanguage': instance.defaultLanguage,
      'currency': instance.currency,
      'timezone': instance.timezone,
      'enablePlayerTracking': instance.enablePlayerTracking,
      'enableCommunication': instance.enableCommunication,
      'enableFinancialManagement': instance.enableFinancialManagement,
      'enableAdvancedAnalytics': instance.enableAdvancedAnalytics,
      'allowParentAccess': instance.allowParentAccess,
      'allowPlayerSelfRegistration': instance.allowPlayerSelfRegistration,
      'requireVOGForStaff': instance.requireVOGForStaff,
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'smsNotifications': instance.smsNotifications,
      'defaultTrainingDuration': instance.defaultTrainingDuration,
      'defaultMatchDuration': instance.defaultMatchDuration,
      'dataRetentionYears': instance.dataRetentionYears,
    };
