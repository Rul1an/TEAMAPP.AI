// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffMemberImpl _$$StaffMemberImplFromJson(Map<String, dynamic> json) =>
    _$StaffMemberImpl(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      nickname: json['nickname'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      primaryRole: $enumDecode(_$StaffRoleEnumMap, json['primaryRole']),
      additionalRoles:
          (json['additionalRoles'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StaffRoleEnumMap, e))
              .toList() ??
          const [],
      employeeNumber: json['employeeNumber'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      qualifications:
          (json['qualifications'] as List<dynamic>?)
              ?.map((e) => Qualification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      certificates:
          (json['certificates'] as List<dynamic>?)
              ?.map((e) => Certificate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      permissions: StaffPermissions.fromJson(
        json['permissions'] as Map<String, dynamic>,
      ),
      teamIds:
          (json['teamIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      primaryTeamIds:
          (json['primaryTeamIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availability: StaffAvailability.fromJson(
        json['availability'] as Map<String, dynamic>,
      ),
      hasVOG: json['hasVOG'] as bool?,
      vogExpiryDate: json['vogExpiryDate'] == null
          ? null
          : DateTime.parse(json['vogExpiryDate'] as String),
      hasMedicalCertificate: json['hasMedicalCertificate'] as bool?,
      medicalCertificateExpiry: json['medicalCertificateExpiry'] == null
          ? null
          : DateTime.parse(json['medicalCertificateExpiry'] as String),
      hasInsurance: json['hasInsurance'] as bool?,
      status: $enumDecode(_$StaffStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$StaffMemberImplToJson(_$StaffMemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'nickname': instance.nickname,
      'email': instance.email,
      'phone': instance.phone,
      'emergencyContact': instance.emergencyContact,
      'emergencyPhone': instance.emergencyPhone,
      'street': instance.street,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'primaryRole': _$StaffRoleEnumMap[instance.primaryRole]!,
      'additionalRoles': instance.additionalRoles
          .map((e) => _$StaffRoleEnumMap[e]!)
          .toList(),
      'employeeNumber': instance.employeeNumber,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'qualifications': instance.qualifications,
      'certificates': instance.certificates,
      'permissions': instance.permissions,
      'teamIds': instance.teamIds,
      'primaryTeamIds': instance.primaryTeamIds,
      'availability': instance.availability,
      'hasVOG': instance.hasVOG,
      'vogExpiryDate': instance.vogExpiryDate?.toIso8601String(),
      'hasMedicalCertificate': instance.hasMedicalCertificate,
      'medicalCertificateExpiry': instance.medicalCertificateExpiry
          ?.toIso8601String(),
      'hasInsurance': instance.hasInsurance,
      'status': _$StaffStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

const _$StaffRoleEnumMap = {
  StaffRole.headCoach: 'headCoach',
  StaffRole.assistantCoach: 'assistantCoach',
  StaffRole.goalkeepingCoach: 'goalkeepingCoach',
  StaffRole.fitnessCoach: 'fitnessCoach',
  StaffRole.youthCoach: 'youthCoach',
  StaffRole.teamManager: 'teamManager',
  StaffRole.clubManager: 'clubManager',
  StaffRole.technicalDirector: 'technicalDirector',
  StaffRole.physiotherapist: 'physiotherapist',
  StaffRole.doctor: 'doctor',
  StaffRole.masseur: 'masseur',
  StaffRole.secretary: 'secretary',
  StaffRole.treasurer: 'treasurer',
  StaffRole.coordinator: 'coordinator',
  StaffRole.analyst: 'analyst',
  StaffRole.scoutingCoordinator: 'scoutingCoordinator',
  StaffRole.equipmentManager: 'equipmentManager',
  StaffRole.volunteer: 'volunteer',
  StaffRole.parent: 'parent',
  StaffRole.boardMember: 'boardMember',
};

const _$StaffStatusEnumMap = {
  StaffStatus.active: 'active',
  StaffStatus.inactive: 'inactive',
  StaffStatus.suspended: 'suspended',
  StaffStatus.terminated: 'terminated',
  StaffStatus.onLeave: 'onLeave',
};

_$StaffPermissionsImpl _$$StaffPermissionsImplFromJson(
  Map<String, dynamic> json,
) => _$StaffPermissionsImpl(
  canManageClub: json['canManageClub'] as bool? ?? false,
  canManageTeams: json['canManageTeams'] as bool? ?? false,
  canManageStaff: json['canManageStaff'] as bool? ?? false,
  canManagePlayers: json['canManagePlayers'] as bool? ?? false,
  canCreateTraining: json['canCreateTraining'] as bool? ?? false,
  canEditTraining: json['canEditTraining'] as bool? ?? false,
  canDeleteTraining: json['canDeleteTraining'] as bool? ?? false,
  canManageMatches: json['canManageMatches'] as bool? ?? false,
  canViewPlayerData: json['canViewPlayerData'] as bool? ?? false,
  canEditPlayerData: json['canEditPlayerData'] as bool? ?? false,
  canViewAnalytics: json['canViewAnalytics'] as bool? ?? false,
  canExportData: json['canExportData'] as bool? ?? false,
  canSendMessages: json['canSendMessages'] as bool? ?? false,
  canManageCommunication: json['canManageCommunication'] as bool? ?? false,
  canAccessParentPortal: json['canAccessParentPortal'] as bool? ?? false,
  canViewFinancials: json['canViewFinancials'] as bool? ?? false,
  canManagePayments: json['canManagePayments'] as bool? ?? false,
  canGenerateInvoices: json['canGenerateInvoices'] as bool? ?? false,
  canManageSettings: json['canManageSettings'] as bool? ?? false,
  canViewLogs: json['canViewLogs'] as bool? ?? false,
  canManageIntegrations: json['canManageIntegrations'] as bool? ?? false,
);

Map<String, dynamic> _$$StaffPermissionsImplToJson(
  _$StaffPermissionsImpl instance,
) => <String, dynamic>{
  'canManageClub': instance.canManageClub,
  'canManageTeams': instance.canManageTeams,
  'canManageStaff': instance.canManageStaff,
  'canManagePlayers': instance.canManagePlayers,
  'canCreateTraining': instance.canCreateTraining,
  'canEditTraining': instance.canEditTraining,
  'canDeleteTraining': instance.canDeleteTraining,
  'canManageMatches': instance.canManageMatches,
  'canViewPlayerData': instance.canViewPlayerData,
  'canEditPlayerData': instance.canEditPlayerData,
  'canViewAnalytics': instance.canViewAnalytics,
  'canExportData': instance.canExportData,
  'canSendMessages': instance.canSendMessages,
  'canManageCommunication': instance.canManageCommunication,
  'canAccessParentPortal': instance.canAccessParentPortal,
  'canViewFinancials': instance.canViewFinancials,
  'canManagePayments': instance.canManagePayments,
  'canGenerateInvoices': instance.canGenerateInvoices,
  'canManageSettings': instance.canManageSettings,
  'canViewLogs': instance.canViewLogs,
  'canManageIntegrations': instance.canManageIntegrations,
};

_$StaffAvailabilityImpl _$$StaffAvailabilityImplFromJson(
  Map<String, dynamic> json,
) => _$StaffAvailabilityImpl(
  availableDays:
      (json['availableDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  preferredTimeSlot: json['preferredTimeSlot'] as String?,
  unavailablePeriods:
      (json['unavailablePeriods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  maxHoursPerWeek: (json['maxHoursPerWeek'] as num?)?.toInt(),
  availableForMatches: json['availableForMatches'] as bool?,
  availableForTraining: json['availableForTraining'] as bool?,
  availableForEvents: json['availableForEvents'] as bool?,
);

Map<String, dynamic> _$$StaffAvailabilityImplToJson(
  _$StaffAvailabilityImpl instance,
) => <String, dynamic>{
  'availableDays': instance.availableDays,
  'preferredTimeSlot': instance.preferredTimeSlot,
  'unavailablePeriods': instance.unavailablePeriods,
  'maxHoursPerWeek': instance.maxHoursPerWeek,
  'availableForMatches': instance.availableForMatches,
  'availableForTraining': instance.availableForTraining,
  'availableForEvents': instance.availableForEvents,
};

_$QualificationImpl _$$QualificationImplFromJson(Map<String, dynamic> json) =>
    _$QualificationImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      issuingBody: json['issuingBody'] as String,
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      certificateNumber: json['certificateNumber'] as String?,
      level: json['level'] as String?,
      isValid: json['isValid'] as bool?,
    );

Map<String, dynamic> _$$QualificationImplToJson(_$QualificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'issuingBody': instance.issuingBody,
      'issuedDate': instance.issuedDate.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'certificateNumber': instance.certificateNumber,
      'level': instance.level,
      'isValid': instance.isValid,
    };

_$CertificateImpl _$$CertificateImplFromJson(Map<String, dynamic> json) =>
    _$CertificateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      issuedDate: DateTime.parse(json['issuedDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      issuingBody: json['issuingBody'] as String?,
      documentUrl: json['documentUrl'] as String?,
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$$CertificateImplToJson(_$CertificateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'issuedDate': instance.issuedDate.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'issuingBody': instance.issuingBody,
      'documentUrl': instance.documentUrl,
      'isVerified': instance.isVerified,
    };
