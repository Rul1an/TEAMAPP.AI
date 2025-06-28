import 'package:freezed_annotation/freezed_annotation.dart';
part 'player_progress.freezed.dart';
part 'player_progress.g.dart';
/// 📈 Player Progress Model
/// Tracks player development across seasons and teams
@freezed
class PlayerProgress with _$PlayerProgress {
  const factory PlayerProgress({
    required String id,
    required String playerId,
    required String teamId,
    required String clubId,
    required String season,
    // Assessment Period
    required DateTime startDate,
    DateTime? endDate,
    // Technical Skills (1-10 scale)
    required TechnicalSkills technicalSkills,
    // Physical Attributes (1-10 scale)
    required PhysicalAttributes physicalAttributes,
    // Tactical Understanding (1-10 scale)
    required TacticalSkills tacticalSkills,
    // Mental Attributes (1-10 scale)
    required MentalAttributes mentalAttributes,
    // Performance Metrics
    required PerformanceMetrics performanceMetrics,
    // Development Goals
    @Default([]) List<DevelopmentGoal> goals,
    // Assessments
    @Default([]) List<ProgressAssessment> assessments,
    // Overall Ratings
    required OverallRating overallRating,
    // Notes & Recommendations
    String? coachNotes,
    String? developmentPlan,
    @Default([]) List<String> recommendations,
    // Status
    required ProgressStatus status,
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
    String? assessedBy,
  }) = _PlayerProgress;
  factory PlayerProgress.fromJson(Map<String, dynamic> json) => _$PlayerProgressFromJson(json);
}
@freezed
class TechnicalSkills with _$TechnicalSkills {
  const factory TechnicalSkills({
    @Default(5.0) double ballControl,
    @Default(5.0) double firstTouch,
    @Default(5.0) double passing,
    @Default(5.0) double shooting,
    @Default(5.0) double crossing,
    @Default(5.0) double dribbling,
    @Default(5.0) double heading,
    @Default(5.0) double finishing,
    @Default(5.0) double longPassing,
    @Default(5.0) double setPlays,
    // Goalkeeping (if applicable)
    double? shotStopping,
    double? distribution,
    double? positioning,
    double? handling,
    double? communication,
  }) = _TechnicalSkills;
  factory TechnicalSkills.fromJson(Map<String, dynamic> json) => _$TechnicalSkillsFromJson(json);
}
@freezed
class PhysicalAttributes with _$PhysicalAttributes {
  const factory PhysicalAttributes({
    @Default(5.0) double speed,
    @Default(5.0) double acceleration,
    @Default(5.0) double agility,
    @Default(5.0) double balance,
    @Default(5.0) double strength,
    @Default(5.0) double stamina,
    @Default(5.0) double jumping,
    @Default(5.0) double coordination,
    @Default(5.0) double flexibility,
    @Default(5.0) double powerEndurance,
    // Measurements
    double? height,
    double? weight,
    double? bodyFatPercentage,
    // Performance Tests
    double? sprintTime40m,
    double? maxSpeed,
    double? verticalJump,
    double? vo2Max,
  }) = _PhysicalAttributes;
  factory PhysicalAttributes.fromJson(Map<String, dynamic> json) => _$PhysicalAttributesFromJson(json);
}
@freezed
class TacticalSkills with _$TacticalSkills {
  const factory TacticalSkills({
    @Default(5.0) double positioning,
    @Default(5.0) double decisionMaking,
    @Default(5.0) double gameReading,
    @Default(5.0) double anticipation,
    @Default(5.0) double teamWork,
    @Default(5.0) double defensiveAwareness,
    @Default(5.0) double offensiveMovement,
    @Default(5.0) double pressureHandling,
    @Default(5.0) double adaptability,
    @Default(5.0) double gameIntelligence,
  }) = _TacticalSkills;
  factory TacticalSkills.fromJson(Map<String, dynamic> json) => _$TacticalSkillsFromJson(json);
}
@freezed
class MentalAttributes with _$MentalAttributes {
  const factory MentalAttributes({
    @Default(5.0) double motivation,
    @Default(5.0) double concentration,
    @Default(5.0) double confidence,
    @Default(5.0) double resilience,
    @Default(5.0) double leadership,
    @Default(5.0) double communication,
    @Default(5.0) double discipline,
    @Default(5.0) double learningAbility,
    @Default(5.0) double competitiveness,
    @Default(5.0) double emotionalControl,
  }) = _MentalAttributes;
  factory MentalAttributes.fromJson(Map<String, dynamic> json) => _$MentalAttributesFromJson(json);
}
@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    // Match Statistics
    @Default(0) int matchesPlayed,
    @Default(0) int matchesStarted,
    @Default(0) int minutesPlayed,
    @Default(0) int goals,
    @Default(0) int assists,
    @Default(0) int yellowCards,
    @Default(0) int redCards,
    // Training Statistics
    @Default(0) int trainingsAttended,
    @Default(0) int totalTrainings,
    @Default(0.0) double attendancePercentage,
    @Default(0.0) double trainingRating,
    // Development Metrics
    @Default(0.0) double improvementRate,
    @Default(0.0) double consistencyScore,
    @Default(0.0) double potentialRating,
  }) = _PerformanceMetrics;
  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => _$PerformanceMetricsFromJson(json);
}
@freezed
class DevelopmentGoal with _$DevelopmentGoal {
  const factory DevelopmentGoal({
    required String id,
    required String title,
    required String description,
    required GoalCategory category,
    required GoalPriority priority,
    required DateTime targetDate,
    // Progress
    @Default(0.0) double currentValue,
    required double targetValue,
    String? unit,
    // Status
    required GoalStatus status,
    // Tracking
    @Default([]) List<GoalMilestone> milestones,
    // Metadata
    required DateTime createdAt,
    DateTime? completedAt,
    String? createdBy,
  }) = _DevelopmentGoal;
  factory DevelopmentGoal.fromJson(Map<String, dynamic> json) => _$DevelopmentGoalFromJson(json);
}
@freezed
class GoalMilestone with _$GoalMilestone {
  const factory GoalMilestone({
    required String id,
    required String description,
    required DateTime targetDate,
    required bool isCompleted,
    DateTime? completedAt,
    String? notes,
  }) = _GoalMilestone;
  factory GoalMilestone.fromJson(Map<String, dynamic> json) => _$GoalMilestoneFromJson(json);
}
@freezed
class ProgressAssessment with _$ProgressAssessment {
  const factory ProgressAssessment({
    required String id,
    required DateTime assessmentDate,
    required String assessorId,
    required AssessmentType type,
    // Scores
    required Map<String, double> scores,
    // Feedback
    String? strengths,
    String? weaknesses,
    String? recommendations,
    String? generalNotes,
    // Next Steps
    @Default([]) List<String> actionPoints,
    DateTime? nextAssessmentDate,
  }) = _ProgressAssessment;
  factory ProgressAssessment.fromJson(Map<String, dynamic> json) => _$ProgressAssessmentFromJson(json);
}
@freezed
class OverallRating with _$OverallRating {
  const factory OverallRating({
    @Default(5.0) double current,
    @Default(5.0) double potential,
    @Default(5.0) double technical,
    @Default(5.0) double physical,
    @Default(5.0) double tactical,
    @Default(5.0) double mental,
    // Trend
    @Default(0.0) double improvement,
    @Default(0.0) double consistency,
    // Comparison
    @Default(5.0) double peerComparison,
    @Default(5.0) double ageGroupComparison,
  }) = _OverallRating;
  factory OverallRating.fromJson(Map<String, dynamic> json) => _$OverallRatingFromJson(json);
}
enum ProgressStatus {
  active,
  completed,
  onHold,
  cancelled,
}
enum GoalCategory {
  technical,
  physical,
  tactical,
  mental,
  behavioral,
  academic,
}
enum GoalPriority {
  low,
  medium,
  high,
  critical,
}
enum GoalStatus {
  notStarted,
  inProgress,
  completed,
  overdue,
  cancelled,
}
enum AssessmentType {
  monthly,
  quarterly,
  seasonal,
  annual,
  special,
  injury,
  development,
}
extension GoalCategoryExtension on GoalCategory {
  String get displayName {
    switch (this) {
      case GoalCategory.technical:
        return 'Technisch';
      case GoalCategory.physical:
        return 'Fysiek';
      case GoalCategory.tactical:
        return 'Tactisch';
      case GoalCategory.mental:
        return 'Mentaal';
      case GoalCategory.behavioral:
        return 'Gedrag';
      case GoalCategory.academic:
        return 'Academisch';
    }
  }
}
extension GoalPriorityExtension on GoalPriority {
  String get displayName {
    switch (this) {
      case GoalPriority.low:
        return 'Laag';
      case GoalPriority.medium:
        return 'Gemiddeld';
      case GoalPriority.high:
        return 'Hoog';
      case GoalPriority.critical:
        return 'Kritiek';
    }
  }
  int get value {
    switch (this) {
      case GoalPriority.low:
        return 1;
      case GoalPriority.medium:
        return 2;
      case GoalPriority.high:
        return 3;
      case GoalPriority.critical:
        return 4;
    }
  }
}
