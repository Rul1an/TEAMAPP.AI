import 'package:isar/isar.dart';
import 'training_period.dart';
import 'week_schedule.dart';

// part 'morphocycle.g.dart'; // Disabled for web compatibility

/// Training intensity levels based on Vítor Frade's Tactical Periodization
enum TrainingIntensity {
  recovery,     // Day +1: 30-40% intensity - Active recovery
  acquisition,  // Day +2: 85-95% intensity - High-intensity tactical work
  development,  // Day +3: 70-80% intensity - Medium-intensity technical-tactical
  activation,   // Day +4: 50-60% intensity - Low-intensity activation/set pieces
  competition   // Match Day: 100% intensity - Competition
}

/// Training focus areas for morphocycle days
enum TacticalFocus {
  recovery,           // Recovery and regeneration
  defensiveOrg,       // Defensive organization and pressing
  attackingOrg,       // Attacking organization and possession
  transitions,        // Attacking/defensive transitions
  setPieces,          // Set pieces and activation
  matchPreparation,   // Match-specific preparation
  gameModel,          // Overall game model implementation
  physicalConditioning, // Physical preparation when needed
  // Additional tactical focuses for enhanced filtering
  possession,         // Ball possession exercises
  pressing,           // Pressing and ball recovery
  counterAttack,      // Counter-attacking situations
  positionalPlay,     // Positional play development
  setpieces,          // Set pieces (alternative naming)
  defensive,          // General defensive work
  attacking,          // General attacking work
}

// Extension for TacticalFocus to provide display names
extension TacticalFocusExtension on TacticalFocus {
  String get displayName {
    switch (this) {
      case TacticalFocus.recovery:
        return 'Recovery';
      case TacticalFocus.defensiveOrg:
        return 'Defensive Organization';
      case TacticalFocus.attackingOrg:
        return 'Attacking Organization';
      case TacticalFocus.transitions:
        return 'Transitions';
      case TacticalFocus.setPieces:
        return 'Set Pieces';
      case TacticalFocus.matchPreparation:
        return 'Match Preparation';
      case TacticalFocus.gameModel:
        return 'Game Model';
      case TacticalFocus.physicalConditioning:
        return 'Physical Conditioning';
      case TacticalFocus.possession:
        return 'Possession';
      case TacticalFocus.pressing:
        return 'Pressing';
      case TacticalFocus.counterAttack:
        return 'Counter Attack';
      case TacticalFocus.positionalPlay:
        return 'Positional Play';
      case TacticalFocus.setpieces:
        return 'Set Pieces';
      case TacticalFocus.defensive:
        return 'Defensive';
      case TacticalFocus.attacking:
        return 'Attacking';
    }
  }
}

/// Injury risk assessment based on Acute:Chronic Workload Ratio
enum InjuryRisk {
  underloaded,  // ACWR < 0.8 - Risk of detraining
  optimal,      // ACWR 0.8-1.3 - Optimal training zone
  high,         // ACWR > 1.3 - High injury risk
  extreme       // ACWR > 1.5 - Extreme injury risk
}

// @Collection() // Disabled for web compatibility
class Morphocycle {
  Id id = Isar.autoIncrement;

  // Basic identification
  late int weekNumber;          // Week number in season (1-43)
  late String periodId;         // Link to training period
  late String seasonPlanId;     // Link to season plan

  // Morphocycle structure following Vítor Frade methodology
  String? recoverySessionId;     // Day +1: Recovery session
  String? acquisitionSessionId;  // Day +2: High-intensity acquisition
  String? developmentSessionId;  // Day +3: Medium-intensity development
  String? activationSessionId;   // Day +4: Low-intensity activation
  String? matchEventId;          // Competition day event

  // Load management
  late double weeklyLoad;                    // Total weekly training load (RPE × minutes)
  late Map<String, double> intensityDistribution; // Daily intensity percentages
  late double acuteChronicRatio;            // Injury risk indicator

  // Tactical focus
  late List<String> tacticalFocusAreas;     // Main tactical themes for the week
  late String primaryGameModelFocus;        // Main game model emphasis
  late String secondaryGameModelFocus;      // Secondary emphasis

  // Performance indicators
  late double expectedAdaptation;           // Predicted training adaptation (0-100%)
  late List<String> keyPerformanceIndicators; // Measurable outcomes
  late List<String> trainingObjectives;    // Weekly objectives

  // Load calculation parameters
  late int totalTrainingMinutes;           // Total planned training time
  late double averageRPE;                  // Average RPE for the week
  late int numberOfSessions;               // Number of training sessions

  // Metadata
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Constructor
  Morphocycle();

  // Named constructor for standard KNVB morphocycle
  Morphocycle.knvbStandard({
    required this.weekNumber,
    required this.periodId,
    required this.seasonPlanId,
    TrainingPeriod? period,
  }) {
    // Set standard KNVB intensity distribution
    intensityDistribution = {
      'recovery': 35.0,      // Day +1
      'acquisition': 90.0,   // Day +2
      'development': 75.0,   // Day +3
      'activation': 55.0,    // Day +4
    };

    // Set tactical focus based on period
    _setTacticalFocusForPeriod(period);

    // Calculate standard load
    totalTrainingMinutes = 240; // 4 sessions × 60 minutes average
    averageRPE = 6.5;
    numberOfSessions = 4;
    weeklyLoad = _calculateWeeklyLoad();
    acuteChronicRatio = 1.0; // Will be calculated based on history

    // Set performance indicators
    expectedAdaptation = _calculateExpectedAdaptation(period);
    keyPerformanceIndicators = _getKPIsForPeriod(period);
    trainingObjectives = _getObjectivesForPeriod(period);
  }

  // Named constructor for tactical periodization morphocycle
  Morphocycle.tacticalPeriodization({
    required this.weekNumber,
    required this.periodId,
    required this.seasonPlanId,
    required String gameModelFocus,
    TrainingPeriod? period,
  }) {
    primaryGameModelFocus = gameModelFocus;

    // Set Vítor Frade intensity distribution
    intensityDistribution = {
      'recovery': 35.0,      // Day +1: Active recovery
      'acquisition': 92.0,   // Day +2: Maximum tactical intensity
      'development': 78.0,   // Day +3: Technical-tactical development
      'activation': 52.0,    // Day +4: Activation and set pieces
    };

    // Set tactical focus for tactical periodization
    _setTacticalFocusForGameModel(gameModelFocus);

    // Calculate load with higher intensity for tactical periodization
    totalTrainingMinutes = 270; // 4.5 hours total
    averageRPE = 7.2;
    numberOfSessions = 4;
    weeklyLoad = _calculateWeeklyLoad();
    acuteChronicRatio = 1.0;

    // Set advanced performance indicators
    expectedAdaptation = _calculateExpectedAdaptation(period) * 1.15; // Higher for tactical periodization
    keyPerformanceIndicators = _getTacticalKPIs(gameModelFocus);
    trainingObjectives = _getTacticalObjectives(gameModelFocus);
  }

  // Load calculation methods
  double _calculateWeeklyLoad() {
    return averageRPE * totalTrainingMinutes;
  }

  static double calculateSessionLoad(int rpeScore, int durationMinutes) {
    return rpeScore * durationMinutes.toDouble();
  }

  static double calculateACWR(List<double> last28DaysLoads) {
    if (last28DaysLoads.length < 28) return 1.0;

    final acute = last28DaysLoads.take(7).reduce((a, b) => a + b) / 7;
    final chronic = last28DaysLoads.reduce((a, b) => a + b) / 28;

    return chronic > 0 ? acute / chronic : 1.0;
  }

  static InjuryRisk assessInjuryRisk(double acwr) {
    if (acwr < 0.8) return InjuryRisk.underloaded;
    if (acwr > 1.5) return InjuryRisk.extreme;
    if (acwr > 1.3) return InjuryRisk.high;
    return InjuryRisk.optimal;
  }

  // Tactical focus setting methods
  void _setTacticalFocusForPeriod(TrainingPeriod? period) {
    if (period == null) {
      tacticalFocusAreas = ['Technical Skills', 'Basic Passing', 'Movement'];
      primaryGameModelFocus = 'Ball Possession';
      secondaryGameModelFocus = 'Technical Development';
      return;
    }

    switch (period.type) {
      case PeriodType.preparation:
        tacticalFocusAreas = ['Ball Control', 'Passing Accuracy', 'Physical Conditioning'];
        primaryGameModelFocus = 'Ball Possession';
        secondaryGameModelFocus = 'Individual Skills';
        break;
      case PeriodType.competitionEarly:
        tacticalFocusAreas = ['Positional Play', 'Defensive Shape', 'Team Coordination'];
        primaryGameModelFocus = 'Defensive Organization';
        secondaryGameModelFocus = 'Pressing Triggers';
        break;
      case PeriodType.competitionPeak:
        tacticalFocusAreas = ['Match Preparation', 'Set Pieces', 'Game Management'];
        primaryGameModelFocus = 'Match Preparation';
        secondaryGameModelFocus = 'Performance Optimization';
        break;
      case PeriodType.competitionMaintenance:
        tacticalFocusAreas = ['Consistency', 'Rotation Management', 'Tactical Variations'];
        primaryGameModelFocus = 'Performance Maintenance';
        secondaryGameModelFocus = 'Squad Development';
        break;
      case PeriodType.transition:
        tacticalFocusAreas = ['Creativity', 'Individual Expression', 'New Concepts'];
        primaryGameModelFocus = 'Creative Play';
        secondaryGameModelFocus = 'Skill Development';
        break;
      case PeriodType.tournamentPrep:
        tacticalFocusAreas = ['Tournament Tactics', 'Mental Preparation', 'Squad Unity'];
        primaryGameModelFocus = 'Tournament Tactics';
        secondaryGameModelFocus = 'Mental Readiness';
        break;
    }
  }

  void _setTacticalFocusForGameModel(String gameModel) {
    primaryGameModelFocus = gameModel;

    switch (gameModel.toLowerCase()) {
      case 'possession':
        tacticalFocusAreas = ['Ball Retention', 'Positional Play', 'Build-up Play'];
        secondaryGameModelFocus = 'Creating Numerical Superiority';
        break;
      case 'pressing':
        tacticalFocusAreas = ['High Pressing', 'Compactness', 'Ball Recovery'];
        secondaryGameModelFocus = 'Transition to Attack';
        break;
      case 'counter attack':
        tacticalFocusAreas = ['Quick Transitions', 'Direct Play', 'Vertical Runs'];
        secondaryGameModelFocus = 'Defensive Stability';
        break;
      case 'positional play':
        tacticalFocusAreas = ['Space Occupation', 'Player Movement', 'Passing Networks'];
        secondaryGameModelFocus = 'Creating Overloads';
        break;
      default:
        tacticalFocusAreas = ['Balanced Development', 'Game Understanding'];
        secondaryGameModelFocus = 'Technical Skills';
    }
  }

  // Performance calculation methods
  double _calculateExpectedAdaptation(TrainingPeriod? period) {
    if (period == null) return 50.0;

    double baseAdaptation = period.intensityPercentage;

    // Adjust based on morphocycle structure
    if (acuteChronicRatio > 1.2) {
      return (baseAdaptation * 1.15).clamp(0.0, 100.0); // High load = higher adaptation
    } else if (acuteChronicRatio < 0.8) {
      return (baseAdaptation * 0.85).clamp(0.0, 100.0); // Low load = lower adaptation
    }

    return baseAdaptation.clamp(0.0, 100.0);
  }

  List<String> _getKPIsForPeriod(TrainingPeriod? period) {
    if (period == null) {
      return ['Basic Skills Development', 'Fitness Improvement'];
    }

    switch (period.type) {
      case PeriodType.preparation:
        return ['Fitness Test Improvements', 'Technical Skill Assessments', 'Team Chemistry'];
      case PeriodType.competitionEarly:
        return ['Match Performance', 'Tactical Understanding Tests', 'Injury Prevention'];
      case PeriodType.competitionPeak:
        return ['Win Rate', 'Goal Difference', 'Individual Player Ratings'];
      case PeriodType.competitionMaintenance:
        return ['Consistency Metrics', 'Squad Rotation Success', 'Performance Stability'];
      case PeriodType.transition:
        return ['Skill Development Progress', 'Creativity Measures', 'Player Satisfaction'];
      case PeriodType.tournamentPrep:
        return ['Tournament Readiness', 'Mental Preparation Scores', 'Squad Cohesion'];
    }
  }

  List<String> _getObjectivesForPeriod(TrainingPeriod? period) {
    if (period == null) {
      return ['Develop basic skills', 'Improve team coordination'];
    }

    switch (period.type) {
      case PeriodType.preparation:
        return [
          'Build aerobic endurance base',
          'Establish technical fundamentals',
          'Develop team communication'
        ];
      case PeriodType.competitionEarly:
        return [
          'Implement game model principles',
          'Establish defensive organization',
          'Build match rhythm'
        ];
      case PeriodType.competitionPeak:
        return [
          'Optimize match performance',
          'Fine-tune tactical execution',
          'Maintain peak physical condition'
        ];
      case PeriodType.competitionMaintenance:
        return [
          'Maintain performance levels',
          'Manage player loads',
          'Develop squad depth'
        ];
      case PeriodType.transition:
        return [
          'Encourage creative expression',
          'Develop individual skills',
          'Prepare for next phase'
        ];
      case PeriodType.tournamentPrep:
        return [
          'Prepare mentally for tournament',
          'Refine set piece execution',
          'Strengthen squad unity'
        ];
    }
  }

  List<String> _getTacticalKPIs(String gameModelFocus) {
    return [
      'Game Model Understanding Score',
      'Tactical Decision Speed',
      'Positional Discipline Rating',
      'Collective Action Success Rate',
      '$gameModelFocus Specific Metrics'
    ];
  }

  List<String> _getTacticalObjectives(String gameModelFocus) {
    return [
      'Master $gameModelFocus principles',
      'Improve collective understanding',
      'Enhance decision making speed',
      'Perfect tactical execution',
      'Develop game intelligence'
    ];
  }

  // Utility methods
  bool get isHighLoadWeek => weeklyLoad > 1400;
  bool get isRecoveryWeek => weeklyLoad < 800;
  bool get isOptimalLoad => weeklyLoad >= 800 && weeklyLoad <= 1400;

  InjuryRisk get currentInjuryRisk => assessInjuryRisk(acuteChronicRatio);

  String get weekDescription {
    if (isRecoveryWeek) return 'Recovery Week';
    if (isHighLoadWeek) return 'High Load Week';
    return 'Standard Training Week';
  }

  // Get training intensity for specific day
  TrainingIntensity getIntensityForDay(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0: // Sunday - Day +1
        return TrainingIntensity.recovery;
      case 2: // Tuesday - Day +2
        return TrainingIntensity.acquisition;
      case 4: // Thursday - Day +3
        return TrainingIntensity.development;
      case 5: // Friday - Day +4
        return TrainingIntensity.activation;
      case 6: // Saturday - Match Day
        return TrainingIntensity.competition;
      default:
        return TrainingIntensity.recovery;
    }
  }

  // Get tactical focus for specific day
  TacticalFocus getTacticalFocusForDay(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0: // Sunday
        return TacticalFocus.recovery;
      case 2: // Tuesday
        return TacticalFocus.defensiveOrg;
      case 4: // Thursday
        return TacticalFocus.attackingOrg;
      case 5: // Friday
        return TacticalFocus.setPieces;
      case 6: // Saturday
        return TacticalFocus.matchPreparation;
      default:
        return TacticalFocus.gameModel;
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'weekNumber': weekNumber,
    'periodId': periodId,
    'seasonPlanId': seasonPlanId,
    'weeklyLoad': weeklyLoad,
    'intensityDistribution': intensityDistribution,
    'acuteChronicRatio': acuteChronicRatio,
    'tacticalFocusAreas': tacticalFocusAreas,
    'primaryGameModelFocus': primaryGameModelFocus,
    'secondaryGameModelFocus': secondaryGameModelFocus,
    'expectedAdaptation': expectedAdaptation,
    'keyPerformanceIndicators': keyPerformanceIndicators,
    'trainingObjectives': trainingObjectives,
    'totalTrainingMinutes': totalTrainingMinutes,
    'averageRPE': averageRPE,
    'numberOfSessions': numberOfSessions,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Morphocycle.fromJson(Map<String, dynamic> json) {
    final morphocycle = Morphocycle();
    morphocycle.id = json['id'] ?? Isar.autoIncrement;
    morphocycle.weekNumber = json['weekNumber'] ?? 1;
    morphocycle.periodId = json['periodId'] ?? '';
    morphocycle.seasonPlanId = json['seasonPlanId'] ?? '';
    morphocycle.weeklyLoad = json['weeklyLoad']?.toDouble() ?? 0.0;
    morphocycle.intensityDistribution = Map<String, double>.from(json['intensityDistribution'] ?? {});
    morphocycle.acuteChronicRatio = json['acuteChronicRatio']?.toDouble() ?? 1.0;
    morphocycle.tacticalFocusAreas = List<String>.from(json['tacticalFocusAreas'] ?? []);
    morphocycle.primaryGameModelFocus = json['primaryGameModelFocus'] ?? '';
    morphocycle.secondaryGameModelFocus = json['secondaryGameModelFocus'] ?? '';
    morphocycle.expectedAdaptation = json['expectedAdaptation']?.toDouble() ?? 60.0;
    morphocycle.keyPerformanceIndicators = List<String>.from(json['keyPerformanceIndicators'] ?? []);
    morphocycle.trainingObjectives = List<String>.from(json['trainingObjectives'] ?? []);
    morphocycle.totalTrainingMinutes = json['totalTrainingMinutes'] ?? 240;
    morphocycle.averageRPE = json['averageRPE']?.toDouble() ?? 6.0;
    morphocycle.numberOfSessions = json['numberOfSessions'] ?? 3;
    morphocycle.createdAt = DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now();
    morphocycle.updatedAt = DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now();
    return morphocycle;
  }
}

/// Extension to add morphocycle helpers to WeekSchedule
extension WeekScheduleMorphocycle on WeekSchedule {
  Morphocycle? get morphocycle {
    // This would be populated when morphocycles are integrated
    return null;
  }

  TrainingIntensity get weekIntensityLevel {
    if (trainingSessions.isEmpty) return TrainingIntensity.recovery;

    // Calculate average intensity based on session count and type
    if (trainingSessions.length >= 4) return TrainingIntensity.acquisition;
    if (trainingSessions.length >= 3) return TrainingIntensity.development;
    if (trainingSessions.length >= 2) return TrainingIntensity.activation;
    return TrainingIntensity.recovery;
  }
}
