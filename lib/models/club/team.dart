import 'package:freezed_annotation/freezed_annotation.dart';
import 'club.dart';
part 'team.freezed.dart';
part 'team.g.dart';
/// ⚽ Team Model
/// Represents a team within a club with age category, level, and staff
@freezed
class Team with _$Team {
  const factory Team({
    required String id,
    required String clubId,
    required String name,
    required String shortName,
    // Team Classification
    required AgeCategory ageCategory,
    required TeamLevel level,
    required TeamGender gender,
    // Details
    String? description,
    String? logoUrl,
    String? colors,
    // Season Information
    required String currentSeason,
    String? league,
    String? division,
    // Settings
    required TeamSettings settings,
    // Staff
    @Default([]) List<String> staffIds,
    String? headCoachId,
    String? assistantCoachId,
    String? teamManagerId,
    // Players
    @Default([]) List<String> playerIds,
    @Default([]) List<String> captainIds,
    // Status
    required TeamStatus status,
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _Team;
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
@freezed
class TeamSettings with _$TeamSettings {
  const factory TeamSettings({
    // Training
    @Default(2) int trainingsPerWeek,
    @Default(90) int defaultTrainingDuration,
    @Default(['Tuesday', 'Thursday']) List<String> trainingDays,
    // Match
    @Default('Saturday') String matchDay,
    @Default(90) int defaultMatchDuration,
    // Communication
    @Default(true) bool allowParentCommunication,
    @Default(true) bool sendTrainingReminders,
    @Default(true) bool sendMatchReminders,
    // Performance
    @Default(true) bool trackPlayerPerformance,
    @Default(true) bool enableVideoAnalysis,
    @Default(false) bool enableGPSTracking,
    // Administrative
    @Default(true) bool requireMedicalCertificate,
    @Default(true) bool requireInsurance,
    @Default(false) bool requireVOG,
  }) = _TeamSettings;
  factory TeamSettings.fromJson(Map<String, dynamic> json) => _$TeamSettingsFromJson(json);
}
enum TeamLevel {
  recreational,
  competitive,
  elite,
  academy,
  reserve,
  first,
}
enum TeamGender {
  male,
  female,
  mixed,
}
enum TeamStatus {
  active,
  inactive,
  disbanded,
  suspended,
}
extension TeamLevelExtension on TeamLevel {
  String get displayName {
    switch (this) {
      case TeamLevel.recreational:
        return 'Recreatief';
      case TeamLevel.competitive:
        return 'Competitief';
      case TeamLevel.elite:
        return 'Elite';
      case TeamLevel.academy:
        return 'Academie';
      case TeamLevel.reserve:
        return 'Reserve';
      case TeamLevel.first:
        return 'Eerste Elftal';
    }
  }
  int get priority {
    switch (this) {
      case TeamLevel.first:
        return 1;
      case TeamLevel.elite:
        return 2;
      case TeamLevel.competitive:
        return 3;
      case TeamLevel.academy:
        return 4;
      case TeamLevel.reserve:
        return 5;
      case TeamLevel.recreational:
        return 6;
    }
  }
}
extension TeamGenderExtension on TeamGender {
  String get displayName {
    switch (this) {
      case TeamGender.male:
        return 'Heren';
      case TeamGender.female:
        return 'Dames';
      case TeamGender.mixed:
        return 'Gemengd';
    }
  }
  String get shortName {
    switch (this) {
      case TeamGender.male:
        return 'H';
      case TeamGender.female:
        return 'D';
      case TeamGender.mixed:
        return 'M';
    }
  }
}
