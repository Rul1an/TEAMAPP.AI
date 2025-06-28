import 'package:freezed_annotation/freezed_annotation.dart';
import 'team.dart';
import 'staff_member.dart';

part 'club.freezed.dart';
part 'club.g.dart';

/// User Role Enum for SaaS permissions
enum UserRole {
  bestuurder,
  hoofdcoach,
  assistentCoach,
  speler,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.bestuurder:
        return 'Bestuurder';
      case UserRole.hoofdcoach:
        return 'Hoofdcoach';
      case UserRole.assistentCoach:
        return 'Assistent Coach';
      case UserRole.speler:
        return 'Speler';
    }
  }
}

/// 🏆 Club Model
/// Central entity for managing multiple teams, staff, and facilities
@freezed
class Club with _$Club {
  const factory Club({
    required String id,
    required String name,
    required String shortName,
    String? description,
    String? logoUrl,
    String? website,
    String? email,
    String? phone,
    // Address
    String? street,
    String? city,
    String? postalCode,
    String? country,
    // Club Details
    required DateTime foundedDate,
    String? colors,
    String? motto,
    // SaaS Properties
    @Default(ClubTier.basic) ClubTier tier,
    @Default([]) List<Team> teams,
    @Default([]) List<StaffMember> staff,
    // Settings
    required ClubSettings settings,
    // Status
    required ClubStatus status,
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Club;

  // Add computed property for foundedYear
  const Club._();

  int get foundedYear => foundedDate.year;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
}

// SaaS Tier Enum
enum ClubTier {
  basic,
  pro,
  enterprise,
}

extension ClubTierExtension on ClubTier {
  String get displayName {
    switch (this) {
      case ClubTier.basic:
        return 'Basic';
      case ClubTier.pro:
        return 'Pro';
      case ClubTier.enterprise:
        return 'Enterprise';
    }
  }

  String get description {
    switch (this) {
      case ClubTier.basic:
        return 'Basis functionaliteiten voor kleine clubs';
      case ClubTier.pro:
        return 'Uitgebreide tools voor professionele clubs';
      case ClubTier.enterprise:
        return 'Volledige suite voor grote organisaties';
    }
  }
}

@freezed
class ClubSettings with _$ClubSettings {
  const factory ClubSettings({
    // General
    @Default('nl') String defaultLanguage,
    @Default('EUR') String currency,
    @Default('Europe/Amsterdam') String timezone,
    // Features
    @Default(true) bool enablePlayerTracking,
    @Default(true) bool enableCommunication,
    @Default(false) bool enableFinancialManagement,
    @Default(false) bool enableAdvancedAnalytics,
    // Privacy
    @Default(true) bool allowParentAccess,
    @Default(false) bool allowPlayerSelfRegistration,
    @Default(true) bool requireVOGForStaff,
    // Notifications
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(false) bool smsNotifications,
    // Training
    @Default(90) int defaultTrainingDuration,
    @Default(90) int defaultMatchDuration,
    // Data Retention
    @Default(7) int dataRetentionYears,
  }) = _ClubSettings;
  factory ClubSettings.fromJson(Map<String, dynamic> json) => _$ClubSettingsFromJson(json);
}

enum ClubStatus {
  active,
  inactive,
  suspended,
  dissolved,
}

enum ClubType {
  amateur,
  semiProfessional,
  professional,
  academy,
}

enum AgeCategory {
  jo7,
  jo8,
  jo9,
  jo10,
  jo11,
  jo12,
  jo13,
  jo14,
  jo15,
  jo16,
  jo17,
  jo18,
  jo19,
  senior,
  veteran,
}

extension AgeCategoryExtension on AgeCategory {
  String get displayName {
    switch (this) {
      case AgeCategory.jo7:
        return 'JO7';
      case AgeCategory.jo8:
        return 'JO8';
      case AgeCategory.jo9:
        return 'JO9';
      case AgeCategory.jo10:
        return 'JO10';
      case AgeCategory.jo11:
        return 'JO11';
      case AgeCategory.jo12:
        return 'JO12';
      case AgeCategory.jo13:
        return 'JO13';
      case AgeCategory.jo14:
        return 'JO14';
      case AgeCategory.jo15:
        return 'JO15';
      case AgeCategory.jo16:
        return 'JO16';
      case AgeCategory.jo17:
        return 'JO17';
      case AgeCategory.jo18:
        return 'JO18';
      case AgeCategory.jo19:
        return 'JO19';
      case AgeCategory.senior:
        return 'Senioren';
      case AgeCategory.veteran:
        return 'Veteranen';
    }
  }
  int get minAge {
    switch (this) {
      case AgeCategory.jo7:
        return 6;
      case AgeCategory.jo8:
        return 7;
      case AgeCategory.jo9:
        return 8;
      case AgeCategory.jo10:
        return 9;
      case AgeCategory.jo11:
        return 10;
      case AgeCategory.jo12:
        return 11;
      case AgeCategory.jo13:
        return 12;
      case AgeCategory.jo14:
        return 13;
      case AgeCategory.jo15:
        return 14;
      case AgeCategory.jo16:
        return 15;
      case AgeCategory.jo17:
        return 16;
      case AgeCategory.jo18:
        return 17;
      case AgeCategory.jo19:
        return 18;
      case AgeCategory.senior:
        return 18;
      case AgeCategory.veteran:
        return 35;
    }
  }
  int get maxAge {
    switch (this) {
      case AgeCategory.jo7:
        return 7;
      case AgeCategory.jo8:
        return 8;
      case AgeCategory.jo9:
        return 9;
      case AgeCategory.jo10:
        return 10;
      case AgeCategory.jo11:
        return 11;
      case AgeCategory.jo12:
        return 12;
      case AgeCategory.jo13:
        return 13;
      case AgeCategory.jo14:
        return 14;
      case AgeCategory.jo15:
        return 15;
      case AgeCategory.jo16:
        return 16;
      case AgeCategory.jo17:
        return 17;
      case AgeCategory.jo18:
        return 18;
      case AgeCategory.jo19:
        return 19;
      case AgeCategory.senior:
        return 34;
      case AgeCategory.veteran:
        return 99;
    }
  }
}
