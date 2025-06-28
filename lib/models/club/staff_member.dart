import 'package:freezed_annotation/freezed_annotation.dart';
part 'staff_member.freezed.dart';
part 'staff_member.g.dart';
/// 👨‍🏫 Staff Member Model
/// Represents staff members with roles, permissions, and qualifications
@freezed
class StaffMember with _$StaffMember {
  const factory StaffMember({
    required String id,
    required String clubId,
    // Personal Information
    required String firstName,
    required String lastName,
    String? middleName,
    String? nickname,
    // Contact Information
    required String email,
    String? phone,
    String? emergencyContact,
    String? emergencyPhone,
    // Address
    String? street,
    String? city,
    String? postalCode,
    String? country,
    // Professional Information
    required StaffRole primaryRole,
    @Default([]) List<StaffRole> additionalRoles,
    String? employeeNumber,
    DateTime? startDate,
    DateTime? endDate,
    // Qualifications
    @Default([]) List<Qualification> qualifications,
    @Default([]) List<Certificate> certificates,
    // Permissions
    required StaffPermissions permissions,
    // Teams
    @Default([]) List<String> teamIds,
    @Default([]) List<String> primaryTeamIds,
    // Availability
    required StaffAvailability availability,
    // Documents
    bool? hasVOG,
    DateTime? vogExpiryDate,
    bool? hasMedicalCertificate,
    DateTime? medicalCertificateExpiry,
    bool? hasInsurance,
    // Status
    required StaffStatus status,
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _StaffMember;
  factory StaffMember.fromJson(Map<String, dynamic> json) => _$StaffMemberFromJson(json);
}
@freezed
class StaffPermissions with _$StaffPermissions {
  const factory StaffPermissions({
    // Administrative
    @Default(false) bool canManageClub,
    @Default(false) bool canManageTeams,
    @Default(false) bool canManageStaff,
    @Default(false) bool canManagePlayers,
    // Training & Matches
    @Default(false) bool canCreateTraining,
    @Default(false) bool canEditTraining,
    @Default(false) bool canDeleteTraining,
    @Default(false) bool canManageMatches,
    // Performance & Analytics
    @Default(false) bool canViewPlayerData,
    @Default(false) bool canEditPlayerData,
    @Default(false) bool canViewAnalytics,
    @Default(false) bool canExportData,
    // Communication
    @Default(false) bool canSendMessages,
    @Default(false) bool canManageCommunication,
    @Default(false) bool canAccessParentPortal,
    // Financial
    @Default(false) bool canViewFinancials,
    @Default(false) bool canManagePayments,
    @Default(false) bool canGenerateInvoices,
    // System
    @Default(false) bool canManageSettings,
    @Default(false) bool canViewLogs,
    @Default(false) bool canManageIntegrations,
  }) = _StaffPermissions;
  factory StaffPermissions.fromJson(Map<String, dynamic> json) => _$StaffPermissionsFromJson(json);
}
@freezed
class StaffAvailability with _$StaffAvailability {
  const factory StaffAvailability({
    @Default([]) List<String> availableDays,
    String? preferredTimeSlot,
    @Default([]) List<String> unavailablePeriods,
    int? maxHoursPerWeek,
    bool? availableForMatches,
    bool? availableForTraining,
    bool? availableForEvents,
  }) = _StaffAvailability;
  factory StaffAvailability.fromJson(Map<String, dynamic> json) => _$StaffAvailabilityFromJson(json);
}
@freezed
class Qualification with _$Qualification {
  const factory Qualification({
    required String id,
    required String name,
    required String type,
    required String issuingBody,
    required DateTime issuedDate,
    DateTime? expiryDate,
    String? certificateNumber,
    String? level,
    bool? isValid,
  }) = _Qualification;
  factory Qualification.fromJson(Map<String, dynamic> json) => _$QualificationFromJson(json);
}
@freezed
class Certificate with _$Certificate {
  const factory Certificate({
    required String id,
    required String name,
    required String type,
    required DateTime issuedDate,
    DateTime? expiryDate,
    String? issuingBody,
    String? documentUrl,
    bool? isVerified,
  }) = _Certificate;
  factory Certificate.fromJson(Map<String, dynamic> json) => _$CertificateFromJson(json);
}
enum StaffRole {
  // Coaching
  headCoach,
  assistantCoach,
  goalkeepingCoach,
  fitnessCoach,
  youthCoach,
  // Management
  teamManager,
  clubManager,
  technicalDirector,
  // Medical
  physiotherapist,
  doctor,
  masseur,
  // Administrative
  secretary,
  treasurer,
  coordinator,
  // Technical
  analyst,
  scoutingCoordinator,
  equipmentManager,
  // Other
  volunteer,
  parent,
  boardMember,
}
enum StaffStatus {
  active,
  inactive,
  suspended,
  terminated,
  onLeave,
}
extension StaffRoleExtension on StaffRole {
  String get displayName {
    switch (this) {
      case StaffRole.headCoach:
        return 'Hoofdtrainer';
      case StaffRole.assistantCoach:
        return 'Assistent-trainer';
      case StaffRole.goalkeepingCoach:
        return 'Keeperstrainer';
      case StaffRole.fitnessCoach:
        return 'Fitnesscoach';
      case StaffRole.youthCoach:
        return 'Jeugdtrainer';
      case StaffRole.teamManager:
        return 'Teammanager';
      case StaffRole.clubManager:
        return 'Clubmanager';
      case StaffRole.technicalDirector:
        return 'Technisch Directeur';
      case StaffRole.physiotherapist:
        return 'Fysiotherapeut';
      case StaffRole.doctor:
        return 'Arts';
      case StaffRole.masseur:
        return 'Masseur';
      case StaffRole.secretary:
        return 'Secretaris';
      case StaffRole.treasurer:
        return 'Penningmeester';
      case StaffRole.coordinator:
        return 'Coördinator';
      case StaffRole.analyst:
        return 'Analist';
      case StaffRole.scoutingCoordinator:
        return 'Scouting Coördinator';
      case StaffRole.equipmentManager:
        return 'Materiaalmeester';
      case StaffRole.volunteer:
        return 'Vrijwilliger';
      case StaffRole.parent:
        return 'Ouder';
      case StaffRole.boardMember:
        return 'Bestuurslid';
    }
  }
  List<StaffRole> get compatibleRoles {
    switch (this) {
      case StaffRole.headCoach:
        return [StaffRole.assistantCoach, StaffRole.youthCoach];
      case StaffRole.assistantCoach:
        return [StaffRole.headCoach, StaffRole.goalkeepingCoach, StaffRole.fitnessCoach];
      case StaffRole.teamManager:
        return [StaffRole.coordinator, StaffRole.volunteer];
      case StaffRole.parent:
        return [StaffRole.volunteer, StaffRole.teamManager];
      default:
        return [];
    }
  }
  int get permissionLevel {
    switch (this) {
      case StaffRole.technicalDirector:
      case StaffRole.clubManager:
        return 10;
      case StaffRole.headCoach:
        return 8;
      case StaffRole.teamManager:
        return 6;
      case StaffRole.assistantCoach:
      case StaffRole.goalkeepingCoach:
      case StaffRole.fitnessCoach:
        return 5;
      case StaffRole.coordinator:
        return 4;
      case StaffRole.youthCoach:
        return 3;
      case StaffRole.volunteer:
      case StaffRole.parent:
        return 2;
      default:
        return 1;
    }
  }
}
