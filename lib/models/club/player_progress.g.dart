// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerProgressImpl _$$PlayerProgressImplFromJson(Map<String, dynamic> json) =>
    _$PlayerProgressImpl(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      teamId: json['teamId'] as String,
      clubId: json['clubId'] as String,
      season: json['season'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      technicalSkills: TechnicalSkills.fromJson(
          json['technicalSkills'] as Map<String, dynamic>),
      physicalAttributes: PhysicalAttributes.fromJson(
          json['physicalAttributes'] as Map<String, dynamic>),
      tacticalSkills: TacticalSkills.fromJson(
          json['tacticalSkills'] as Map<String, dynamic>),
      mentalAttributes: MentalAttributes.fromJson(
          json['mentalAttributes'] as Map<String, dynamic>),
      performanceMetrics: PerformanceMetrics.fromJson(
          json['performanceMetrics'] as Map<String, dynamic>),
      goals: (json['goals'] as List<dynamic>?)
              ?.map((e) => DevelopmentGoal.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      assessments: (json['assessments'] as List<dynamic>?)
              ?.map(
                  (e) => ProgressAssessment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      overallRating:
          OverallRating.fromJson(json['overallRating'] as Map<String, dynamic>),
      coachNotes: json['coachNotes'] as String?,
      developmentPlan: json['developmentPlan'] as String?,
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      assessedBy: json['assessedBy'] as String?,
    );

Map<String, dynamic> _$$PlayerProgressImplToJson(
        _$PlayerProgressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'teamId': instance.teamId,
      'clubId': instance.clubId,
      'season': instance.season,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'technicalSkills': instance.technicalSkills,
      'physicalAttributes': instance.physicalAttributes,
      'tacticalSkills': instance.tacticalSkills,
      'mentalAttributes': instance.mentalAttributes,
      'performanceMetrics': instance.performanceMetrics,
      'goals': instance.goals,
      'assessments': instance.assessments,
      'overallRating': instance.overallRating,
      'coachNotes': instance.coachNotes,
      'developmentPlan': instance.developmentPlan,
      'recommendations': instance.recommendations,
      'status': _$ProgressStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'assessedBy': instance.assessedBy,
    };

const _$ProgressStatusEnumMap = {
  ProgressStatus.active: 'active',
  ProgressStatus.completed: 'completed',
  ProgressStatus.onHold: 'onHold',
  ProgressStatus.cancelled: 'cancelled',
};

_$TechnicalSkillsImpl _$$TechnicalSkillsImplFromJson(
        Map<String, dynamic> json) =>
    _$TechnicalSkillsImpl(
      ballControl: (json['ballControl'] as num?)?.toDouble() ?? 5.0,
      firstTouch: (json['firstTouch'] as num?)?.toDouble() ?? 5.0,
      passing: (json['passing'] as num?)?.toDouble() ?? 5.0,
      shooting: (json['shooting'] as num?)?.toDouble() ?? 5.0,
      crossing: (json['crossing'] as num?)?.toDouble() ?? 5.0,
      dribbling: (json['dribbling'] as num?)?.toDouble() ?? 5.0,
      heading: (json['heading'] as num?)?.toDouble() ?? 5.0,
      finishing: (json['finishing'] as num?)?.toDouble() ?? 5.0,
      longPassing: (json['longPassing'] as num?)?.toDouble() ?? 5.0,
      setPlays: (json['setPlays'] as num?)?.toDouble() ?? 5.0,
      shotStopping: (json['shotStopping'] as num?)?.toDouble(),
      distribution: (json['distribution'] as num?)?.toDouble(),
      positioning: (json['positioning'] as num?)?.toDouble(),
      handling: (json['handling'] as num?)?.toDouble(),
      communication: (json['communication'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TechnicalSkillsImplToJson(
        _$TechnicalSkillsImpl instance) =>
    <String, dynamic>{
      'ballControl': instance.ballControl,
      'firstTouch': instance.firstTouch,
      'passing': instance.passing,
      'shooting': instance.shooting,
      'crossing': instance.crossing,
      'dribbling': instance.dribbling,
      'heading': instance.heading,
      'finishing': instance.finishing,
      'longPassing': instance.longPassing,
      'setPlays': instance.setPlays,
      'shotStopping': instance.shotStopping,
      'distribution': instance.distribution,
      'positioning': instance.positioning,
      'handling': instance.handling,
      'communication': instance.communication,
    };

_$PhysicalAttributesImpl _$$PhysicalAttributesImplFromJson(
        Map<String, dynamic> json) =>
    _$PhysicalAttributesImpl(
      speed: (json['speed'] as num?)?.toDouble() ?? 5.0,
      acceleration: (json['acceleration'] as num?)?.toDouble() ?? 5.0,
      agility: (json['agility'] as num?)?.toDouble() ?? 5.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 5.0,
      strength: (json['strength'] as num?)?.toDouble() ?? 5.0,
      stamina: (json['stamina'] as num?)?.toDouble() ?? 5.0,
      jumping: (json['jumping'] as num?)?.toDouble() ?? 5.0,
      coordination: (json['coordination'] as num?)?.toDouble() ?? 5.0,
      flexibility: (json['flexibility'] as num?)?.toDouble() ?? 5.0,
      powerEndurance: (json['powerEndurance'] as num?)?.toDouble() ?? 5.0,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
      sprintTime40m: (json['sprintTime40m'] as num?)?.toDouble(),
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble(),
      verticalJump: (json['verticalJump'] as num?)?.toDouble(),
      vo2Max: (json['vo2Max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PhysicalAttributesImplToJson(
        _$PhysicalAttributesImpl instance) =>
    <String, dynamic>{
      'speed': instance.speed,
      'acceleration': instance.acceleration,
      'agility': instance.agility,
      'balance': instance.balance,
      'strength': instance.strength,
      'stamina': instance.stamina,
      'jumping': instance.jumping,
      'coordination': instance.coordination,
      'flexibility': instance.flexibility,
      'powerEndurance': instance.powerEndurance,
      'height': instance.height,
      'weight': instance.weight,
      'bodyFatPercentage': instance.bodyFatPercentage,
      'sprintTime40m': instance.sprintTime40m,
      'maxSpeed': instance.maxSpeed,
      'verticalJump': instance.verticalJump,
      'vo2Max': instance.vo2Max,
    };

_$TacticalSkillsImpl _$$TacticalSkillsImplFromJson(Map<String, dynamic> json) =>
    _$TacticalSkillsImpl(
      positioning: (json['positioning'] as num?)?.toDouble() ?? 5.0,
      decisionMaking: (json['decisionMaking'] as num?)?.toDouble() ?? 5.0,
      gameReading: (json['gameReading'] as num?)?.toDouble() ?? 5.0,
      anticipation: (json['anticipation'] as num?)?.toDouble() ?? 5.0,
      teamWork: (json['teamWork'] as num?)?.toDouble() ?? 5.0,
      defensiveAwareness:
          (json['defensiveAwareness'] as num?)?.toDouble() ?? 5.0,
      offensiveMovement: (json['offensiveMovement'] as num?)?.toDouble() ?? 5.0,
      pressureHandling: (json['pressureHandling'] as num?)?.toDouble() ?? 5.0,
      adaptability: (json['adaptability'] as num?)?.toDouble() ?? 5.0,
      gameIntelligence: (json['gameIntelligence'] as num?)?.toDouble() ?? 5.0,
    );

Map<String, dynamic> _$$TacticalSkillsImplToJson(
        _$TacticalSkillsImpl instance) =>
    <String, dynamic>{
      'positioning': instance.positioning,
      'decisionMaking': instance.decisionMaking,
      'gameReading': instance.gameReading,
      'anticipation': instance.anticipation,
      'teamWork': instance.teamWork,
      'defensiveAwareness': instance.defensiveAwareness,
      'offensiveMovement': instance.offensiveMovement,
      'pressureHandling': instance.pressureHandling,
      'adaptability': instance.adaptability,
      'gameIntelligence': instance.gameIntelligence,
    };

_$MentalAttributesImpl _$$MentalAttributesImplFromJson(
        Map<String, dynamic> json) =>
    _$MentalAttributesImpl(
      motivation: (json['motivation'] as num?)?.toDouble() ?? 5.0,
      concentration: (json['concentration'] as num?)?.toDouble() ?? 5.0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 5.0,
      resilience: (json['resilience'] as num?)?.toDouble() ?? 5.0,
      leadership: (json['leadership'] as num?)?.toDouble() ?? 5.0,
      communication: (json['communication'] as num?)?.toDouble() ?? 5.0,
      discipline: (json['discipline'] as num?)?.toDouble() ?? 5.0,
      learningAbility: (json['learningAbility'] as num?)?.toDouble() ?? 5.0,
      competitiveness: (json['competitiveness'] as num?)?.toDouble() ?? 5.0,
      emotionalControl: (json['emotionalControl'] as num?)?.toDouble() ?? 5.0,
    );

Map<String, dynamic> _$$MentalAttributesImplToJson(
        _$MentalAttributesImpl instance) =>
    <String, dynamic>{
      'motivation': instance.motivation,
      'concentration': instance.concentration,
      'confidence': instance.confidence,
      'resilience': instance.resilience,
      'leadership': instance.leadership,
      'communication': instance.communication,
      'discipline': instance.discipline,
      'learningAbility': instance.learningAbility,
      'competitiveness': instance.competitiveness,
      'emotionalControl': instance.emotionalControl,
    };

_$PerformanceMetricsImpl _$$PerformanceMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$PerformanceMetricsImpl(
      matchesPlayed: (json['matchesPlayed'] as num?)?.toInt() ?? 0,
      matchesStarted: (json['matchesStarted'] as num?)?.toInt() ?? 0,
      minutesPlayed: (json['minutesPlayed'] as num?)?.toInt() ?? 0,
      goals: (json['goals'] as num?)?.toInt() ?? 0,
      assists: (json['assists'] as num?)?.toInt() ?? 0,
      yellowCards: (json['yellowCards'] as num?)?.toInt() ?? 0,
      redCards: (json['redCards'] as num?)?.toInt() ?? 0,
      trainingsAttended: (json['trainingsAttended'] as num?)?.toInt() ?? 0,
      totalTrainings: (json['totalTrainings'] as num?)?.toInt() ?? 0,
      attendancePercentage:
          (json['attendancePercentage'] as num?)?.toDouble() ?? 0.0,
      trainingRating: (json['trainingRating'] as num?)?.toDouble() ?? 0.0,
      improvementRate: (json['improvementRate'] as num?)?.toDouble() ?? 0.0,
      consistencyScore: (json['consistencyScore'] as num?)?.toDouble() ?? 0.0,
      potentialRating: (json['potentialRating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PerformanceMetricsImplToJson(
        _$PerformanceMetricsImpl instance) =>
    <String, dynamic>{
      'matchesPlayed': instance.matchesPlayed,
      'matchesStarted': instance.matchesStarted,
      'minutesPlayed': instance.minutesPlayed,
      'goals': instance.goals,
      'assists': instance.assists,
      'yellowCards': instance.yellowCards,
      'redCards': instance.redCards,
      'trainingsAttended': instance.trainingsAttended,
      'totalTrainings': instance.totalTrainings,
      'attendancePercentage': instance.attendancePercentage,
      'trainingRating': instance.trainingRating,
      'improvementRate': instance.improvementRate,
      'consistencyScore': instance.consistencyScore,
      'potentialRating': instance.potentialRating,
    };

_$DevelopmentGoalImpl _$$DevelopmentGoalImplFromJson(
        Map<String, dynamic> json) =>
    _$DevelopmentGoalImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$GoalCategoryEnumMap, json['category']),
      priority: $enumDecode(_$GoalPriorityEnumMap, json['priority']),
      targetDate: DateTime.parse(json['targetDate'] as String),
      currentValue: (json['currentValue'] as num?)?.toDouble() ?? 0.0,
      targetValue: (json['targetValue'] as num).toDouble(),
      unit: json['unit'] as String?,
      status: $enumDecode(_$GoalStatusEnumMap, json['status']),
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => GoalMilestone.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$DevelopmentGoalImplToJson(
        _$DevelopmentGoalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': _$GoalCategoryEnumMap[instance.category]!,
      'priority': _$GoalPriorityEnumMap[instance.priority]!,
      'targetDate': instance.targetDate.toIso8601String(),
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'unit': instance.unit,
      'status': _$GoalStatusEnumMap[instance.status]!,
      'milestones': instance.milestones,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$GoalCategoryEnumMap = {
  GoalCategory.technical: 'technical',
  GoalCategory.physical: 'physical',
  GoalCategory.tactical: 'tactical',
  GoalCategory.mental: 'mental',
  GoalCategory.behavioral: 'behavioral',
  GoalCategory.academic: 'academic',
};

const _$GoalPriorityEnumMap = {
  GoalPriority.low: 'low',
  GoalPriority.medium: 'medium',
  GoalPriority.high: 'high',
  GoalPriority.critical: 'critical',
};

const _$GoalStatusEnumMap = {
  GoalStatus.notStarted: 'notStarted',
  GoalStatus.inProgress: 'inProgress',
  GoalStatus.completed: 'completed',
  GoalStatus.overdue: 'overdue',
  GoalStatus.cancelled: 'cancelled',
};

_$GoalMilestoneImpl _$$GoalMilestoneImplFromJson(Map<String, dynamic> json) =>
    _$GoalMilestoneImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$GoalMilestoneImplToJson(_$GoalMilestoneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'targetDate': instance.targetDate.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
    };

_$ProgressAssessmentImpl _$$ProgressAssessmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ProgressAssessmentImpl(
      id: json['id'] as String,
      assessmentDate: DateTime.parse(json['assessmentDate'] as String),
      assessorId: json['assessorId'] as String,
      type: $enumDecode(_$AssessmentTypeEnumMap, json['type']),
      scores: (json['scores'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      strengths: json['strengths'] as String?,
      weaknesses: json['weaknesses'] as String?,
      recommendations: json['recommendations'] as String?,
      generalNotes: json['generalNotes'] as String?,
      actionPoints: (json['actionPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nextAssessmentDate: json['nextAssessmentDate'] == null
          ? null
          : DateTime.parse(json['nextAssessmentDate'] as String),
    );

Map<String, dynamic> _$$ProgressAssessmentImplToJson(
        _$ProgressAssessmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assessmentDate': instance.assessmentDate.toIso8601String(),
      'assessorId': instance.assessorId,
      'type': _$AssessmentTypeEnumMap[instance.type]!,
      'scores': instance.scores,
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'recommendations': instance.recommendations,
      'generalNotes': instance.generalNotes,
      'actionPoints': instance.actionPoints,
      'nextAssessmentDate': instance.nextAssessmentDate?.toIso8601String(),
    };

const _$AssessmentTypeEnumMap = {
  AssessmentType.monthly: 'monthly',
  AssessmentType.quarterly: 'quarterly',
  AssessmentType.seasonal: 'seasonal',
  AssessmentType.annual: 'annual',
  AssessmentType.special: 'special',
  AssessmentType.injury: 'injury',
  AssessmentType.development: 'development',
};

_$OverallRatingImpl _$$OverallRatingImplFromJson(Map<String, dynamic> json) =>
    _$OverallRatingImpl(
      current: (json['current'] as num?)?.toDouble() ?? 5.0,
      potential: (json['potential'] as num?)?.toDouble() ?? 5.0,
      technical: (json['technical'] as num?)?.toDouble() ?? 5.0,
      physical: (json['physical'] as num?)?.toDouble() ?? 5.0,
      tactical: (json['tactical'] as num?)?.toDouble() ?? 5.0,
      mental: (json['mental'] as num?)?.toDouble() ?? 5.0,
      improvement: (json['improvement'] as num?)?.toDouble() ?? 0.0,
      consistency: (json['consistency'] as num?)?.toDouble() ?? 0.0,
      peerComparison: (json['peerComparison'] as num?)?.toDouble() ?? 5.0,
      ageGroupComparison:
          (json['ageGroupComparison'] as num?)?.toDouble() ?? 5.0,
    );

Map<String, dynamic> _$$OverallRatingImplToJson(_$OverallRatingImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'potential': instance.potential,
      'technical': instance.technical,
      'physical': instance.physical,
      'tactical': instance.tactical,
      'mental': instance.mental,
      'improvement': instance.improvement,
      'consistency': instance.consistency,
      'peerComparison': instance.peerComparison,
      'ageGroupComparison': instance.ageGroupComparison,
    };
