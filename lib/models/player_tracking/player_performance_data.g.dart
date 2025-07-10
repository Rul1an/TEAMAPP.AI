// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_performance_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerPerformanceDataImpl _$$PlayerPerformanceDataImplFromJson(
  Map<String, dynamic> json,
) => _$PlayerPerformanceDataImpl(
  id: json['id'] as String,
  playerId: json['playerId'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$PerformanceTypeEnumMap, json['type']),
  physicalMetrics: json['physicalMetrics'] == null
      ? null
      : PhysicalMetrics.fromJson(
          json['physicalMetrics'] as Map<String, dynamic>,
        ),
  technicalMetrics: json['technicalMetrics'] == null
      ? null
      : TechnicalMetrics.fromJson(
          json['technicalMetrics'] as Map<String, dynamic>,
        ),
  tacticalMetrics: json['tacticalMetrics'] == null
      ? null
      : TacticalMetrics.fromJson(
          json['tacticalMetrics'] as Map<String, dynamic>,
        ),
  mentalMetrics: json['mentalMetrics'] == null
      ? null
      : MentalMetrics.fromJson(json['mentalMetrics'] as Map<String, dynamic>),
  matchMetrics: json['matchMetrics'] == null
      ? null
      : MatchMetrics.fromJson(json['matchMetrics'] as Map<String, dynamic>),
  trainingLoad: json['trainingLoad'] == null
      ? null
      : TrainingLoadMetrics.fromJson(
          json['trainingLoad'] as Map<String, dynamic>,
        ),
  wellness: json['wellness'] == null
      ? null
      : WellnessMetrics.fromJson(json['wellness'] as Map<String, dynamic>),
  coachEvaluation: json['coachEvaluation'] == null
      ? null
      : CoachEvaluation.fromJson(
          json['coachEvaluation'] as Map<String, dynamic>,
        ),
  insights: (json['insights'] as List<dynamic>?)
      ?.map((e) => PerformanceInsight.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$PlayerPerformanceDataImplToJson(
  _$PlayerPerformanceDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'playerId': instance.playerId,
  'date': instance.date.toIso8601String(),
  'type': _$PerformanceTypeEnumMap[instance.type]!,
  'physicalMetrics': instance.physicalMetrics,
  'technicalMetrics': instance.technicalMetrics,
  'tacticalMetrics': instance.tacticalMetrics,
  'mentalMetrics': instance.mentalMetrics,
  'matchMetrics': instance.matchMetrics,
  'trainingLoad': instance.trainingLoad,
  'wellness': instance.wellness,
  'coachEvaluation': instance.coachEvaluation,
  'insights': instance.insights,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'notes': instance.notes,
};

const _$PerformanceTypeEnumMap = {
  PerformanceType.training: 'training',
  PerformanceType.match: 'match',
  PerformanceType.test: 'test',
  PerformanceType.assessment: 'assessment',
};

_$PhysicalMetricsImpl _$$PhysicalMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$PhysicalMetricsImpl(
  totalDistance: (json['totalDistance'] as num?)?.toDouble(),
  highSpeedRunning: (json['highSpeedRunning'] as num?)?.toDouble(),
  sprints: (json['sprints'] as num?)?.toDouble(),
  maxSpeed: (json['maxSpeed'] as num?)?.toDouble(),
  averageSpeed: (json['averageSpeed'] as num?)?.toDouble(),
  accelerations: (json['accelerations'] as num?)?.toInt(),
  decelerations: (json['decelerations'] as num?)?.toInt(),
  maxHeartRate: (json['maxHeartRate'] as num?)?.toInt(),
  averageHeartRate: (json['averageHeartRate'] as num?)?.toInt(),
  timeInZone1: (json['timeInZone1'] as num?)?.toInt(),
  timeInZone2: (json['timeInZone2'] as num?)?.toInt(),
  timeInZone3: (json['timeInZone3'] as num?)?.toInt(),
  timeInZone4: (json['timeInZone4'] as num?)?.toInt(),
  timeInZone5: (json['timeInZone5'] as num?)?.toInt(),
  jumpHeight: (json['jumpHeight'] as num?)?.toDouble(),
  sprintTime10m: (json['sprintTime10m'] as num?)?.toDouble(),
  sprintTime30m: (json['sprintTime30m'] as num?)?.toDouble(),
  agility505: (json['agility505'] as num?)?.toDouble(),
  yoyoTestDistance: (json['yoyoTestDistance'] as num?)?.toDouble(),
  vo2Max: (json['vo2Max'] as num?)?.toDouble(),
  hrvScore: (json['hrvScore'] as num?)?.toDouble(),
  restingHeartRate: (json['restingHeartRate'] as num?)?.toInt(),
  sleepQuality: (json['sleepQuality'] as num?)?.toDouble(),
  sleepHours: (json['sleepHours'] as num?)?.toInt(),
);

Map<String, dynamic> _$$PhysicalMetricsImplToJson(
  _$PhysicalMetricsImpl instance,
) => <String, dynamic>{
  'totalDistance': instance.totalDistance,
  'highSpeedRunning': instance.highSpeedRunning,
  'sprints': instance.sprints,
  'maxSpeed': instance.maxSpeed,
  'averageSpeed': instance.averageSpeed,
  'accelerations': instance.accelerations,
  'decelerations': instance.decelerations,
  'maxHeartRate': instance.maxHeartRate,
  'averageHeartRate': instance.averageHeartRate,
  'timeInZone1': instance.timeInZone1,
  'timeInZone2': instance.timeInZone2,
  'timeInZone3': instance.timeInZone3,
  'timeInZone4': instance.timeInZone4,
  'timeInZone5': instance.timeInZone5,
  'jumpHeight': instance.jumpHeight,
  'sprintTime10m': instance.sprintTime10m,
  'sprintTime30m': instance.sprintTime30m,
  'agility505': instance.agility505,
  'yoyoTestDistance': instance.yoyoTestDistance,
  'vo2Max': instance.vo2Max,
  'hrvScore': instance.hrvScore,
  'restingHeartRate': instance.restingHeartRate,
  'sleepQuality': instance.sleepQuality,
  'sleepHours': instance.sleepHours,
};

_$TechnicalMetricsImpl _$$TechnicalMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicalMetricsImpl(
  touches: (json['touches'] as num?)?.toInt(),
  firstTouchSuccess: (json['firstTouchSuccess'] as num?)?.toInt(),
  firstTouchTotal: (json['firstTouchTotal'] as num?)?.toInt(),
  passesCompleted: (json['passesCompleted'] as num?)?.toInt(),
  passesAttempted: (json['passesAttempted'] as num?)?.toInt(),
  keyPasses: (json['keyPasses'] as num?)?.toInt(),
  throughBalls: (json['throughBalls'] as num?)?.toInt(),
  longBallsCompleted: (json['longBallsCompleted'] as num?)?.toInt(),
  longBallsAttempted: (json['longBallsAttempted'] as num?)?.toInt(),
  dribblesCompleted: (json['dribblesCompleted'] as num?)?.toInt(),
  dribblesAttempted: (json['dribblesAttempted'] as num?)?.toInt(),
  nutmegs: (json['nutmegs'] as num?)?.toInt(),
  shots: (json['shots'] as num?)?.toInt(),
  shotsOnTarget: (json['shotsOnTarget'] as num?)?.toInt(),
  goals: (json['goals'] as num?)?.toInt(),
  xG: (json['xG'] as num?)?.toDouble(),
  tackles: (json['tackles'] as num?)?.toInt(),
  tacklesWon: (json['tacklesWon'] as num?)?.toInt(),
  interceptions: (json['interceptions'] as num?)?.toInt(),
  blocks: (json['blocks'] as num?)?.toInt(),
  clearances: (json['clearances'] as num?)?.toInt(),
  aerialDuelsWon: (json['aerialDuelsWon'] as num?)?.toInt(),
  aerialDuelsTotal: (json['aerialDuelsTotal'] as num?)?.toInt(),
  saves: (json['saves'] as num?)?.toInt(),
  savePercentage: (json['savePercentage'] as num?)?.toInt(),
  cleanSheets: (json['cleanSheets'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TechnicalMetricsImplToJson(
  _$TechnicalMetricsImpl instance,
) => <String, dynamic>{
  'touches': instance.touches,
  'firstTouchSuccess': instance.firstTouchSuccess,
  'firstTouchTotal': instance.firstTouchTotal,
  'passesCompleted': instance.passesCompleted,
  'passesAttempted': instance.passesAttempted,
  'keyPasses': instance.keyPasses,
  'throughBalls': instance.throughBalls,
  'longBallsCompleted': instance.longBallsCompleted,
  'longBallsAttempted': instance.longBallsAttempted,
  'dribblesCompleted': instance.dribblesCompleted,
  'dribblesAttempted': instance.dribblesAttempted,
  'nutmegs': instance.nutmegs,
  'shots': instance.shots,
  'shotsOnTarget': instance.shotsOnTarget,
  'goals': instance.goals,
  'xG': instance.xG,
  'tackles': instance.tackles,
  'tacklesWon': instance.tacklesWon,
  'interceptions': instance.interceptions,
  'blocks': instance.blocks,
  'clearances': instance.clearances,
  'aerialDuelsWon': instance.aerialDuelsWon,
  'aerialDuelsTotal': instance.aerialDuelsTotal,
  'saves': instance.saves,
  'savePercentage': instance.savePercentage,
  'cleanSheets': instance.cleanSheets,
};

_$TacticalMetricsImpl _$$TacticalMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$TacticalMetricsImpl(
  averagePositionX: (json['averagePositionX'] as num?)?.toDouble(),
  averagePositionY: (json['averagePositionY'] as num?)?.toDouble(),
  heatmapCoverage: (json['heatmapCoverage'] as num?)?.toDouble(),
  combinationPlays: (json['combinationPlays'] as num?)?.toInt(),
  supportRuns: (json['supportRuns'] as num?)?.toInt(),
  defensiveActions: (json['defensiveActions'] as num?)?.toInt(),
  pressingIntensity: (json['pressingIntensity'] as num?)?.toDouble(),
  decisionAccuracy: (json['decisionAccuracy'] as num?)?.toDouble(),
  correctDecisions: (json['correctDecisions'] as num?)?.toInt(),
  poorDecisions: (json['poorDecisions'] as num?)?.toInt(),
  positionAdherence: (json['positionAdherence'] as num?)?.toDouble(),
  compactness: (json['compactness'] as num?)?.toDouble(),
  counterAttacks: (json['counterAttacks'] as num?)?.toInt(),
  recoveryRuns: (json['recoveryRuns'] as num?)?.toInt(),
  transitionSpeed: (json['transitionSpeed'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$TacticalMetricsImplToJson(
  _$TacticalMetricsImpl instance,
) => <String, dynamic>{
  'averagePositionX': instance.averagePositionX,
  'averagePositionY': instance.averagePositionY,
  'heatmapCoverage': instance.heatmapCoverage,
  'combinationPlays': instance.combinationPlays,
  'supportRuns': instance.supportRuns,
  'defensiveActions': instance.defensiveActions,
  'pressingIntensity': instance.pressingIntensity,
  'decisionAccuracy': instance.decisionAccuracy,
  'correctDecisions': instance.correctDecisions,
  'poorDecisions': instance.poorDecisions,
  'positionAdherence': instance.positionAdherence,
  'compactness': instance.compactness,
  'counterAttacks': instance.counterAttacks,
  'recoveryRuns': instance.recoveryRuns,
  'transitionSpeed': instance.transitionSpeed,
};

_$MentalMetricsImpl _$$MentalMetricsImplFromJson(Map<String, dynamic> json) =>
    _$MentalMetricsImpl(
      confidence: (json['confidence'] as num?)?.toDouble(),
      motivation: (json['motivation'] as num?)?.toDouble(),
      focus: (json['focus'] as num?)?.toDouble(),
      stressLevel: (json['stressLevel'] as num?)?.toDouble(),
      leadership: (json['leadership'] as num?)?.toDouble(),
      communication: (json['communication'] as num?)?.toDouble(),
      workRate: (json['workRate'] as num?)?.toDouble(),
      coachability: (json['coachability'] as num?)?.toDouble(),
      teamwork: (json['teamwork'] as num?)?.toDouble(),
      pressureHandling: (json['pressureHandling'] as num?)?.toDouble(),
      mistakesUnderPressure: (json['mistakesUnderPressure'] as num?)?.toInt(),
      learningRate: (json['learningRate'] as num?)?.toDouble(),
      adaptability: (json['adaptability'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MentalMetricsImplToJson(_$MentalMetricsImpl instance) =>
    <String, dynamic>{
      'confidence': instance.confidence,
      'motivation': instance.motivation,
      'focus': instance.focus,
      'stressLevel': instance.stressLevel,
      'leadership': instance.leadership,
      'communication': instance.communication,
      'workRate': instance.workRate,
      'coachability': instance.coachability,
      'teamwork': instance.teamwork,
      'pressureHandling': instance.pressureHandling,
      'mistakesUnderPressure': instance.mistakesUnderPressure,
      'learningRate': instance.learningRate,
      'adaptability': instance.adaptability,
    };

_$MatchMetricsImpl _$$MatchMetricsImplFromJson(Map<String, dynamic> json) =>
    _$MatchMetricsImpl(
      matchId: json['matchId'] as String,
      minutesPlayed: (json['minutesPlayed'] as num?)?.toInt(),
      position: json['position'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      goals: (json['goals'] as num?)?.toInt(),
      assists: (json['assists'] as num?)?.toInt(),
      yellowCards: (json['yellowCards'] as num?)?.toInt(),
      redCards: (json['redCards'] as num?)?.toInt(),
      xG: (json['xG'] as num?)?.toDouble(),
      xA: (json['xA'] as num?)?.toDouble(),
      xGChain: (json['xGChain'] as num?)?.toDouble(),
      xGBuildup: (json['xGBuildup'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MatchMetricsImplToJson(_$MatchMetricsImpl instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'minutesPlayed': instance.minutesPlayed,
      'position': instance.position,
      'rating': instance.rating,
      'goals': instance.goals,
      'assists': instance.assists,
      'yellowCards': instance.yellowCards,
      'redCards': instance.redCards,
      'xG': instance.xG,
      'xA': instance.xA,
      'xGChain': instance.xGChain,
      'xGBuildup': instance.xGBuildup,
    };

_$TrainingLoadMetricsImpl _$$TrainingLoadMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$TrainingLoadMetricsImpl(
  acwr: (json['acwr'] as num?)?.toDouble(),
  weeklyLoad: (json['weeklyLoad'] as num?)?.toDouble(),
  monthlyLoad: (json['monthlyLoad'] as num?)?.toDouble(),
  sessionRPE: (json['sessionRPE'] as num?)?.toDouble(),
  trainingLoad: (json['trainingLoad'] as num?)?.toDouble(),
  trainingMonotony: (json['trainingMonotony'] as num?)?.toDouble(),
  trainingStrain: (json['trainingStrain'] as num?)?.toDouble(),
  recoveryScore: (json['recoveryScore'] as num?)?.toDouble(),
  fatigueLevel: json['fatigueLevel'] as String?,
  injuryRiskScore: (json['injuryRiskScore'] as num?)?.toDouble(),
  riskFactors: (json['riskFactors'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$TrainingLoadMetricsImplToJson(
  _$TrainingLoadMetricsImpl instance,
) => <String, dynamic>{
  'acwr': instance.acwr,
  'weeklyLoad': instance.weeklyLoad,
  'monthlyLoad': instance.monthlyLoad,
  'sessionRPE': instance.sessionRPE,
  'trainingLoad': instance.trainingLoad,
  'trainingMonotony': instance.trainingMonotony,
  'trainingStrain': instance.trainingStrain,
  'recoveryScore': instance.recoveryScore,
  'fatigueLevel': instance.fatigueLevel,
  'injuryRiskScore': instance.injuryRiskScore,
  'riskFactors': instance.riskFactors,
};

_$WellnessMetricsImpl _$$WellnessMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$WellnessMetricsImpl(
  sleepQuality: (json['sleepQuality'] as num?)?.toDouble(),
  sleepHours: (json['sleepHours'] as num?)?.toDouble(),
  fatigue: (json['fatigue'] as num?)?.toDouble(),
  soreness: (json['soreness'] as num?)?.toDouble(),
  stress: (json['stress'] as num?)?.toDouble(),
  mood: (json['mood'] as num?)?.toDouble(),
  hydrationLevel: (json['hydrationLevel'] as num?)?.toDouble(),
  nutritionQuality: (json['nutritionQuality'] as num?)?.toDouble(),
  bodyWeight: (json['bodyWeight'] as num?)?.toDouble(),
  bodyFat: (json['bodyFat'] as num?)?.toDouble(),
  muscleMass: (json['muscleMass'] as num?)?.toDouble(),
  isInjured: json['isInjured'] as bool?,
  injuryType: json['injuryType'] as String?,
  daysUntilReturn: (json['daysUntilReturn'] as num?)?.toInt(),
);

Map<String, dynamic> _$$WellnessMetricsImplToJson(
  _$WellnessMetricsImpl instance,
) => <String, dynamic>{
  'sleepQuality': instance.sleepQuality,
  'sleepHours': instance.sleepHours,
  'fatigue': instance.fatigue,
  'soreness': instance.soreness,
  'stress': instance.stress,
  'mood': instance.mood,
  'hydrationLevel': instance.hydrationLevel,
  'nutritionQuality': instance.nutritionQuality,
  'bodyWeight': instance.bodyWeight,
  'bodyFat': instance.bodyFat,
  'muscleMass': instance.muscleMass,
  'isInjured': instance.isInjured,
  'injuryType': instance.injuryType,
  'daysUntilReturn': instance.daysUntilReturn,
};

_$CoachEvaluationImpl _$$CoachEvaluationImplFromJson(
  Map<String, dynamic> json,
) => _$CoachEvaluationImpl(
  coachId: json['coachId'] as String,
  evaluationDate: DateTime.parse(json['evaluationDate'] as String),
  overallRating: (json['overallRating'] as num?)?.toDouble(),
  technicalRating: (json['technicalRating'] as num?)?.toDouble(),
  tacticalRating: (json['tacticalRating'] as num?)?.toDouble(),
  physicalRating: (json['physicalRating'] as num?)?.toDouble(),
  mentalRating: (json['mentalRating'] as num?)?.toDouble(),
  strengths: (json['strengths'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  weaknesses: (json['weaknesses'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  developmentGoals: (json['developmentGoals'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  generalComments: json['generalComments'] as String?,
  improvementAdvice: json['improvementAdvice'] as String?,
);

Map<String, dynamic> _$$CoachEvaluationImplToJson(
  _$CoachEvaluationImpl instance,
) => <String, dynamic>{
  'coachId': instance.coachId,
  'evaluationDate': instance.evaluationDate.toIso8601String(),
  'overallRating': instance.overallRating,
  'technicalRating': instance.technicalRating,
  'tacticalRating': instance.tacticalRating,
  'physicalRating': instance.physicalRating,
  'mentalRating': instance.mentalRating,
  'strengths': instance.strengths,
  'weaknesses': instance.weaknesses,
  'developmentGoals': instance.developmentGoals,
  'generalComments': instance.generalComments,
  'improvementAdvice': instance.improvementAdvice,
};

_$PerformanceInsightImpl _$$PerformanceInsightImplFromJson(
  Map<String, dynamic> json,
) => _$PerformanceInsightImpl(
  id: json['id'] as String,
  type: $enumDecode(_$InsightTypeEnumMap, json['type']),
  title: json['title'] as String,
  description: json['description'] as String,
  priority: $enumDecode(_$InsightPriorityEnumMap, json['priority']),
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  recommendations: (json['recommendations'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  relatedData: json['relatedData'] as Map<String, dynamic>?,
  trend: json['trend'] as String?,
  changePercentage: (json['changePercentage'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$PerformanceInsightImplToJson(
  _$PerformanceInsightImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$InsightTypeEnumMap[instance.type]!,
  'title': instance.title,
  'description': instance.description,
  'priority': _$InsightPriorityEnumMap[instance.priority]!,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'recommendations': instance.recommendations,
  'relatedData': instance.relatedData,
  'trend': instance.trend,
  'changePercentage': instance.changePercentage,
};

const _$InsightTypeEnumMap = {
  InsightType.performance: 'performance',
  InsightType.health: 'health',
  InsightType.development: 'development',
  InsightType.warning: 'warning',
  InsightType.achievement: 'achievement',
};

const _$InsightPriorityEnumMap = {
  InsightPriority.low: 'low',
  InsightPriority.medium: 'medium',
  InsightPriority.high: 'high',
  InsightPriority.critical: 'critical',
};
