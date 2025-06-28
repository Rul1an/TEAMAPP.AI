import 'package:freezed_annotation/freezed_annotation.dart';
part 'player_performance_data.freezed.dart';
part 'player_performance_data.g.dart';
@freezed
class PlayerPerformanceData with _$PlayerPerformanceData {
  const factory PlayerPerformanceData({
    required String id,
    required String playerId,
    required DateTime date,
    required PerformanceType type, // training, match, test
    // Physical Performance Metrics
    PhysicalMetrics? physicalMetrics,
    // Technical Performance Metrics
    TechnicalMetrics? technicalMetrics,
    // Tactical Performance Metrics
    TacticalMetrics? tacticalMetrics,
    // Mental/Psychological Metrics
    MentalMetrics? mentalMetrics,
    // Match Specific Metrics
    MatchMetrics? matchMetrics,
    // Training Load & Recovery
    TrainingLoadMetrics? trainingLoad,
    // Wellness & Health
    WellnessMetrics? wellness,
    // Coach Evaluation
    CoachEvaluation? coachEvaluation,
    // AI-Generated Insights
    List<PerformanceInsight>? insights,
    // Metadata
    required DateTime createdAt,
    DateTime? updatedAt,
    String? notes,
  }) = _PlayerPerformanceData;
  factory PlayerPerformanceData.fromJson(Map<String, dynamic> json) =>
      _$PlayerPerformanceDataFromJson(json);
}
enum PerformanceType {
  training,
  match,
  test,
  assessment,
}
@freezed
class PhysicalMetrics with _$PhysicalMetrics {
  const factory PhysicalMetrics({
    // Distance & Speed
    double? totalDistance, // meters
    double? highSpeedRunning, // meters >19.8 km/h
    double? sprints, // count >25.2 km/h
    double? maxSpeed, // km/h
    double? averageSpeed, // km/h
    // Acceleration & Deceleration
    int? accelerations, // count >3 m/s²
    int? decelerations, // count <-3 m/s²
    // Heart Rate
    int? maxHeartRate, // bpm
    int? averageHeartRate, // bpm
    int? timeInZone1, // seconds (50-60% max HR)
    int? timeInZone2, // seconds (60-70% max HR)
    int? timeInZone3, // seconds (70-80% max HR)
    int? timeInZone4, // seconds (80-90% max HR)
    int? timeInZone5, // seconds (90-100% max HR)
    // Power & Explosiveness
    double? jumpHeight, // cm
    double? sprintTime10m, // seconds
    double? sprintTime30m, // seconds
    double? agility505, // seconds
    // Endurance
    double? yoyoTestDistance, // meters
    double? vo2Max, // ml/kg/min
    // Recovery Metrics
    double? hrvScore, // Heart Rate Variability
    int? restingHeartRate, // bpm
    double? sleepQuality, // 0-10
    int? sleepHours, // hours
  }) = _PhysicalMetrics;
  factory PhysicalMetrics.fromJson(Map<String, dynamic> json) =>
      _$PhysicalMetricsFromJson(json);
}
@freezed
class TechnicalMetrics with _$TechnicalMetrics {
  const factory TechnicalMetrics({
    // Ball Control
    int? touches, // total touches
    int? firstTouchSuccess, // successful first touches
    int? firstTouchTotal, // total first touches
    // Passing
    int? passesCompleted,
    int? passesAttempted,
    int? keyPasses, // passes leading to shot
    int? throughBalls,
    int? longBallsCompleted,
    int? longBallsAttempted,
    // Dribbling
    int? dribblesCompleted,
    int? dribblesAttempted,
    int? nutmegs,
    // Shooting
    int? shots,
    int? shotsOnTarget,
    int? goals,
    double? xG, // expected goals
    // Defending
    int? tackles,
    int? tacklesWon,
    int? interceptions,
    int? blocks,
    int? clearances,
    int? aerialDuelsWon,
    int? aerialDuelsTotal,
    // Goalkeeping (if applicable)
    int? saves,
    int? savePercentage,
    int? cleanSheets,
  }) = _TechnicalMetrics;
  factory TechnicalMetrics.fromJson(Map<String, dynamic> json) =>
      _$TechnicalMetricsFromJson(json);
}
@freezed
class TacticalMetrics with _$TacticalMetrics {
  const factory TacticalMetrics({
    // Positioning
    double? averagePositionX, // field percentage 0-100
    double? averagePositionY, // field percentage 0-100
    double? heatmapCoverage, // percentage of field covered
    // Team Play
    int? combinationPlays,
    int? supportRuns,
    int? defensiveActions,
    double? pressingIntensity, // 0-10
    // Decision Making
    double? decisionAccuracy, // percentage
    int? correctDecisions,
    int? poorDecisions,
    // Formation Discipline
    double? positionAdherence, // percentage
    double? compactness, // team shape metric
    // Transition Play
    int? counterAttacks,
    int? recoveryRuns,
    double? transitionSpeed, // seconds
  }) = _TacticalMetrics;
  factory TacticalMetrics.fromJson(Map<String, dynamic> json) =>
      _$TacticalMetricsFromJson(json);
}
@freezed
class MentalMetrics with _$MentalMetrics {
  const factory MentalMetrics({
    // Self Assessment
    double? confidence, // 0-10
    double? motivation, // 0-10
    double? focus, // 0-10
    double? stressLevel, // 0-10
    // Coach Assessment
    double? leadership, // 0-10
    double? communication, // 0-10
    double? workRate, // 0-10
    double? coachability, // 0-10
    double? teamwork, // 0-10
    // Performance Under Pressure
    double? pressureHandling, // 0-10
    int? mistakesUnderPressure,
    // Learning & Development
    double? learningRate, // 0-10
    double? adaptability, // 0-10
  }) = _MentalMetrics;
  factory MentalMetrics.fromJson(Map<String, dynamic> json) =>
      _$MentalMetricsFromJson(json);
}
@freezed
class MatchMetrics with _$MatchMetrics {
  const factory MatchMetrics({
    required String matchId,
    int? minutesPlayed,
    String? position,
    double? rating, // 0-10
    // Match Events
    int? goals,
    int? assists,
    int? yellowCards,
    int? redCards,
    // Advanced Stats
    double? xG, // expected goals
    double? xA, // expected assists
    double? xGChain, // expected goals from moves involved in
    double? xGBuildup, // expected goals from buildup play
  }) = _MatchMetrics;
  factory MatchMetrics.fromJson(Map<String, dynamic> json) =>
      _$MatchMetricsFromJson(json);
}
@freezed
class TrainingLoadMetrics with _$TrainingLoadMetrics {
  const factory TrainingLoadMetrics({
    // Acute:Chronic Workload Ratio
    double? acwr, // optimal: 0.8-1.3
    double? weeklyLoad,
    double? monthlyLoad,
    // Training Intensity
    double? sessionRPE, // Rate of Perceived Exertion 0-10
    double? trainingLoad, // RPE * duration
    // Monotony & Strain
    double? trainingMonotony,
    double? trainingStrain,
    // Recovery Status
    double? recoveryScore, // 0-100
    String? fatigueLevel, // low, moderate, high
    // Injury Risk
    double? injuryRiskScore, // 0-100
    List<String>? riskFactors,
  }) = _TrainingLoadMetrics;
  factory TrainingLoadMetrics.fromJson(Map<String, dynamic> json) =>
      _$TrainingLoadMetricsFromJson(json);
}
@freezed
class WellnessMetrics with _$WellnessMetrics {
  const factory WellnessMetrics({
    // Daily Wellness
    double? sleepQuality, // 0-10
    double? sleepHours,
    double? fatigue, // 0-10
    double? soreness, // 0-10
    double? stress, // 0-10
    double? mood, // 0-10
    // Nutrition & Hydration
    double? hydrationLevel, // 0-10
    double? nutritionQuality, // 0-10
    // Health Indicators
    double? bodyWeight, // kg
    double? bodyFat, // percentage
    double? muscleMass, // kg
    // Injury Status
    bool? isInjured,
    String? injuryType,
    int? daysUntilReturn,
  }) = _WellnessMetrics;
  factory WellnessMetrics.fromJson(Map<String, dynamic> json) =>
      _$WellnessMetricsFromJson(json);
}
@freezed
class CoachEvaluation with _$CoachEvaluation {
  const factory CoachEvaluation({
    required String coachId,
    required DateTime evaluationDate,
    // Performance Rating
    double? overallRating, // 0-10
    double? technicalRating, // 0-10
    double? tacticalRating, // 0-10
    double? physicalRating, // 0-10
    double? mentalRating, // 0-10
    // Development Areas
    List<String>? strengths,
    List<String>? weaknesses,
    List<String>? developmentGoals,
    // Comments
    String? generalComments,
    String? improvementAdvice,
  }) = _CoachEvaluation;
  factory CoachEvaluation.fromJson(Map<String, dynamic> json) =>
      _$CoachEvaluationFromJson(json);
}
@freezed
class PerformanceInsight with _$PerformanceInsight {
  const factory PerformanceInsight({
    required String id,
    required InsightType type,
    required String title,
    required String description,
    required InsightPriority priority,
    required DateTime generatedAt,
    // Actionable Recommendations
    List<String>? recommendations,
    // Related Metrics
    Map<String, dynamic>? relatedData,
    // Trend Analysis
    String? trend, // improving, stable, declining
    double? changePercentage,
  }) = _PerformanceInsight;
  factory PerformanceInsight.fromJson(Map<String, dynamic> json) =>
      _$PerformanceInsightFromJson(json);
}
enum InsightType {
  performance,
  health,
  development,
  warning,
  achievement,
}
enum InsightPriority {
  low,
  medium,
  high,
  critical,
}
