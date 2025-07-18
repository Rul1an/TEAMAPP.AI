// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerProgress _$PlayerProgressFromJson(Map<String, dynamic> json) {
  return _PlayerProgress.fromJson(json);
}

/// @nodoc
mixin _$PlayerProgress {
  String get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  String get season => throw _privateConstructorUsedError; // Assessment Period
  DateTime get startDate =>
      throw _privateConstructorUsedError; // Technical Skills (1-10 scale)
  TechnicalSkills get technicalSkills =>
      throw _privateConstructorUsedError; // Physical Attributes (1-10 scale)
  PhysicalAttributes get physicalAttributes =>
      throw _privateConstructorUsedError; // Tactical Understanding (1-10 scale)
  TacticalSkills get tacticalSkills =>
      throw _privateConstructorUsedError; // Mental Attributes (1-10 scale)
  MentalAttributes get mentalAttributes =>
      throw _privateConstructorUsedError; // Performance Metrics
  PerformanceMetrics get performanceMetrics =>
      throw _privateConstructorUsedError; // Overall Ratings
  OverallRating get overallRating =>
      throw _privateConstructorUsedError; // Status
  ProgressStatus get status => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get endDate =>
      throw _privateConstructorUsedError; // Development Goals
  List<DevelopmentGoal> get goals =>
      throw _privateConstructorUsedError; // Assessments
  List<ProgressAssessment> get assessments =>
      throw _privateConstructorUsedError; // Notes & Recommendations
  String? get coachNotes => throw _privateConstructorUsedError;
  String? get developmentPlan => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get assessedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerProgressCopyWith<PlayerProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerProgressCopyWith<$Res> {
  factory $PlayerProgressCopyWith(
          PlayerProgress value, $Res Function(PlayerProgress) then) =
      _$PlayerProgressCopyWithImpl<$Res, PlayerProgress>;
  @useResult
  $Res call(
      {String id,
      String playerId,
      String teamId,
      String clubId,
      String season,
      DateTime startDate,
      TechnicalSkills technicalSkills,
      PhysicalAttributes physicalAttributes,
      TacticalSkills tacticalSkills,
      MentalAttributes mentalAttributes,
      PerformanceMetrics performanceMetrics,
      OverallRating overallRating,
      ProgressStatus status,
      DateTime createdAt,
      DateTime? endDate,
      List<DevelopmentGoal> goals,
      List<ProgressAssessment> assessments,
      String? coachNotes,
      String? developmentPlan,
      List<String> recommendations,
      DateTime? updatedAt,
      String? assessedBy});

  $TechnicalSkillsCopyWith<$Res> get technicalSkills;
  $PhysicalAttributesCopyWith<$Res> get physicalAttributes;
  $TacticalSkillsCopyWith<$Res> get tacticalSkills;
  $MentalAttributesCopyWith<$Res> get mentalAttributes;
  $PerformanceMetricsCopyWith<$Res> get performanceMetrics;
  $OverallRatingCopyWith<$Res> get overallRating;
}

/// @nodoc
class _$PlayerProgressCopyWithImpl<$Res, $Val extends PlayerProgress>
    implements $PlayerProgressCopyWith<$Res> {
  _$PlayerProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? teamId = null,
    Object? clubId = null,
    Object? season = null,
    Object? startDate = null,
    Object? technicalSkills = null,
    Object? physicalAttributes = null,
    Object? tacticalSkills = null,
    Object? mentalAttributes = null,
    Object? performanceMetrics = null,
    Object? overallRating = null,
    Object? status = null,
    Object? createdAt = null,
    Object? endDate = freezed,
    Object? goals = null,
    Object? assessments = null,
    Object? coachNotes = freezed,
    Object? developmentPlan = freezed,
    Object? recommendations = null,
    Object? updatedAt = freezed,
    Object? assessedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      season: null == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      technicalSkills: null == technicalSkills
          ? _value.technicalSkills
          : technicalSkills // ignore: cast_nullable_to_non_nullable
              as TechnicalSkills,
      physicalAttributes: null == physicalAttributes
          ? _value.physicalAttributes
          : physicalAttributes // ignore: cast_nullable_to_non_nullable
              as PhysicalAttributes,
      tacticalSkills: null == tacticalSkills
          ? _value.tacticalSkills
          : tacticalSkills // ignore: cast_nullable_to_non_nullable
              as TacticalSkills,
      mentalAttributes: null == mentalAttributes
          ? _value.mentalAttributes
          : mentalAttributes // ignore: cast_nullable_to_non_nullable
              as MentalAttributes,
      performanceMetrics: null == performanceMetrics
          ? _value.performanceMetrics
          : performanceMetrics // ignore: cast_nullable_to_non_nullable
              as PerformanceMetrics,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as OverallRating,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProgressStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<DevelopmentGoal>,
      assessments: null == assessments
          ? _value.assessments
          : assessments // ignore: cast_nullable_to_non_nullable
              as List<ProgressAssessment>,
      coachNotes: freezed == coachNotes
          ? _value.coachNotes
          : coachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      developmentPlan: freezed == developmentPlan
          ? _value.developmentPlan
          : developmentPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assessedBy: freezed == assessedBy
          ? _value.assessedBy
          : assessedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TechnicalSkillsCopyWith<$Res> get technicalSkills {
    return $TechnicalSkillsCopyWith<$Res>(_value.technicalSkills, (value) {
      return _then(_value.copyWith(technicalSkills: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PhysicalAttributesCopyWith<$Res> get physicalAttributes {
    return $PhysicalAttributesCopyWith<$Res>(_value.physicalAttributes,
        (value) {
      return _then(_value.copyWith(physicalAttributes: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TacticalSkillsCopyWith<$Res> get tacticalSkills {
    return $TacticalSkillsCopyWith<$Res>(_value.tacticalSkills, (value) {
      return _then(_value.copyWith(tacticalSkills: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MentalAttributesCopyWith<$Res> get mentalAttributes {
    return $MentalAttributesCopyWith<$Res>(_value.mentalAttributes, (value) {
      return _then(_value.copyWith(mentalAttributes: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PerformanceMetricsCopyWith<$Res> get performanceMetrics {
    return $PerformanceMetricsCopyWith<$Res>(_value.performanceMetrics,
        (value) {
      return _then(_value.copyWith(performanceMetrics: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OverallRatingCopyWith<$Res> get overallRating {
    return $OverallRatingCopyWith<$Res>(_value.overallRating, (value) {
      return _then(_value.copyWith(overallRating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerProgressImplCopyWith<$Res>
    implements $PlayerProgressCopyWith<$Res> {
  factory _$$PlayerProgressImplCopyWith(_$PlayerProgressImpl value,
          $Res Function(_$PlayerProgressImpl) then) =
      __$$PlayerProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String playerId,
      String teamId,
      String clubId,
      String season,
      DateTime startDate,
      TechnicalSkills technicalSkills,
      PhysicalAttributes physicalAttributes,
      TacticalSkills tacticalSkills,
      MentalAttributes mentalAttributes,
      PerformanceMetrics performanceMetrics,
      OverallRating overallRating,
      ProgressStatus status,
      DateTime createdAt,
      DateTime? endDate,
      List<DevelopmentGoal> goals,
      List<ProgressAssessment> assessments,
      String? coachNotes,
      String? developmentPlan,
      List<String> recommendations,
      DateTime? updatedAt,
      String? assessedBy});

  @override
  $TechnicalSkillsCopyWith<$Res> get technicalSkills;
  @override
  $PhysicalAttributesCopyWith<$Res> get physicalAttributes;
  @override
  $TacticalSkillsCopyWith<$Res> get tacticalSkills;
  @override
  $MentalAttributesCopyWith<$Res> get mentalAttributes;
  @override
  $PerformanceMetricsCopyWith<$Res> get performanceMetrics;
  @override
  $OverallRatingCopyWith<$Res> get overallRating;
}

/// @nodoc
class __$$PlayerProgressImplCopyWithImpl<$Res>
    extends _$PlayerProgressCopyWithImpl<$Res, _$PlayerProgressImpl>
    implements _$$PlayerProgressImplCopyWith<$Res> {
  __$$PlayerProgressImplCopyWithImpl(
      _$PlayerProgressImpl _value, $Res Function(_$PlayerProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? teamId = null,
    Object? clubId = null,
    Object? season = null,
    Object? startDate = null,
    Object? technicalSkills = null,
    Object? physicalAttributes = null,
    Object? tacticalSkills = null,
    Object? mentalAttributes = null,
    Object? performanceMetrics = null,
    Object? overallRating = null,
    Object? status = null,
    Object? createdAt = null,
    Object? endDate = freezed,
    Object? goals = null,
    Object? assessments = null,
    Object? coachNotes = freezed,
    Object? developmentPlan = freezed,
    Object? recommendations = null,
    Object? updatedAt = freezed,
    Object? assessedBy = freezed,
  }) {
    return _then(_$PlayerProgressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      season: null == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      technicalSkills: null == technicalSkills
          ? _value.technicalSkills
          : technicalSkills // ignore: cast_nullable_to_non_nullable
              as TechnicalSkills,
      physicalAttributes: null == physicalAttributes
          ? _value.physicalAttributes
          : physicalAttributes // ignore: cast_nullable_to_non_nullable
              as PhysicalAttributes,
      tacticalSkills: null == tacticalSkills
          ? _value.tacticalSkills
          : tacticalSkills // ignore: cast_nullable_to_non_nullable
              as TacticalSkills,
      mentalAttributes: null == mentalAttributes
          ? _value.mentalAttributes
          : mentalAttributes // ignore: cast_nullable_to_non_nullable
              as MentalAttributes,
      performanceMetrics: null == performanceMetrics
          ? _value.performanceMetrics
          : performanceMetrics // ignore: cast_nullable_to_non_nullable
              as PerformanceMetrics,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as OverallRating,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProgressStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      goals: null == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<DevelopmentGoal>,
      assessments: null == assessments
          ? _value._assessments
          : assessments // ignore: cast_nullable_to_non_nullable
              as List<ProgressAssessment>,
      coachNotes: freezed == coachNotes
          ? _value.coachNotes
          : coachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      developmentPlan: freezed == developmentPlan
          ? _value.developmentPlan
          : developmentPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      assessedBy: freezed == assessedBy
          ? _value.assessedBy
          : assessedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerProgressImpl implements _PlayerProgress {
  const _$PlayerProgressImpl(
      {required this.id,
      required this.playerId,
      required this.teamId,
      required this.clubId,
      required this.season,
      required this.startDate,
      required this.technicalSkills,
      required this.physicalAttributes,
      required this.tacticalSkills,
      required this.mentalAttributes,
      required this.performanceMetrics,
      required this.overallRating,
      required this.status,
      required this.createdAt,
      this.endDate,
      final List<DevelopmentGoal> goals = const [],
      final List<ProgressAssessment> assessments = const [],
      this.coachNotes,
      this.developmentPlan,
      final List<String> recommendations = const [],
      this.updatedAt,
      this.assessedBy})
      : _goals = goals,
        _assessments = assessments,
        _recommendations = recommendations;

  factory _$PlayerProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerProgressImplFromJson(json);

  @override
  final String id;
  @override
  final String playerId;
  @override
  final String teamId;
  @override
  final String clubId;
  @override
  final String season;
// Assessment Period
  @override
  final DateTime startDate;
// Technical Skills (1-10 scale)
  @override
  final TechnicalSkills technicalSkills;
// Physical Attributes (1-10 scale)
  @override
  final PhysicalAttributes physicalAttributes;
// Tactical Understanding (1-10 scale)
  @override
  final TacticalSkills tacticalSkills;
// Mental Attributes (1-10 scale)
  @override
  final MentalAttributes mentalAttributes;
// Performance Metrics
  @override
  final PerformanceMetrics performanceMetrics;
// Overall Ratings
  @override
  final OverallRating overallRating;
// Status
  @override
  final ProgressStatus status;
// Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime? endDate;
// Development Goals
  final List<DevelopmentGoal> _goals;
// Development Goals
  @override
  @JsonKey()
  List<DevelopmentGoal> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

// Assessments
  final List<ProgressAssessment> _assessments;
// Assessments
  @override
  @JsonKey()
  List<ProgressAssessment> get assessments {
    if (_assessments is EqualUnmodifiableListView) return _assessments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assessments);
  }

// Notes & Recommendations
  @override
  final String? coachNotes;
  @override
  final String? developmentPlan;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final DateTime? updatedAt;
  @override
  final String? assessedBy;

  @override
  String toString() {
    return 'PlayerProgress(id: $id, playerId: $playerId, teamId: $teamId, clubId: $clubId, season: $season, startDate: $startDate, technicalSkills: $technicalSkills, physicalAttributes: $physicalAttributes, tacticalSkills: $tacticalSkills, mentalAttributes: $mentalAttributes, performanceMetrics: $performanceMetrics, overallRating: $overallRating, status: $status, createdAt: $createdAt, endDate: $endDate, goals: $goals, assessments: $assessments, coachNotes: $coachNotes, developmentPlan: $developmentPlan, recommendations: $recommendations, updatedAt: $updatedAt, assessedBy: $assessedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.technicalSkills, technicalSkills) ||
                other.technicalSkills == technicalSkills) &&
            (identical(other.physicalAttributes, physicalAttributes) ||
                other.physicalAttributes == physicalAttributes) &&
            (identical(other.tacticalSkills, tacticalSkills) ||
                other.tacticalSkills == tacticalSkills) &&
            (identical(other.mentalAttributes, mentalAttributes) ||
                other.mentalAttributes == mentalAttributes) &&
            (identical(other.performanceMetrics, performanceMetrics) ||
                other.performanceMetrics == performanceMetrics) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            const DeepCollectionEquality()
                .equals(other._assessments, _assessments) &&
            (identical(other.coachNotes, coachNotes) ||
                other.coachNotes == coachNotes) &&
            (identical(other.developmentPlan, developmentPlan) ||
                other.developmentPlan == developmentPlan) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.assessedBy, assessedBy) ||
                other.assessedBy == assessedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        playerId,
        teamId,
        clubId,
        season,
        startDate,
        technicalSkills,
        physicalAttributes,
        tacticalSkills,
        mentalAttributes,
        performanceMetrics,
        overallRating,
        status,
        createdAt,
        endDate,
        const DeepCollectionEquality().hash(_goals),
        const DeepCollectionEquality().hash(_assessments),
        coachNotes,
        developmentPlan,
        const DeepCollectionEquality().hash(_recommendations),
        updatedAt,
        assessedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerProgressImplCopyWith<_$PlayerProgressImpl> get copyWith =>
      __$$PlayerProgressImplCopyWithImpl<_$PlayerProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerProgressImplToJson(
      this,
    );
  }
}

abstract class _PlayerProgress implements PlayerProgress {
  const factory _PlayerProgress(
      {required final String id,
      required final String playerId,
      required final String teamId,
      required final String clubId,
      required final String season,
      required final DateTime startDate,
      required final TechnicalSkills technicalSkills,
      required final PhysicalAttributes physicalAttributes,
      required final TacticalSkills tacticalSkills,
      required final MentalAttributes mentalAttributes,
      required final PerformanceMetrics performanceMetrics,
      required final OverallRating overallRating,
      required final ProgressStatus status,
      required final DateTime createdAt,
      final DateTime? endDate,
      final List<DevelopmentGoal> goals,
      final List<ProgressAssessment> assessments,
      final String? coachNotes,
      final String? developmentPlan,
      final List<String> recommendations,
      final DateTime? updatedAt,
      final String? assessedBy}) = _$PlayerProgressImpl;

  factory _PlayerProgress.fromJson(Map<String, dynamic> json) =
      _$PlayerProgressImpl.fromJson;

  @override
  String get id;
  @override
  String get playerId;
  @override
  String get teamId;
  @override
  String get clubId;
  @override
  String get season;
  @override // Assessment Period
  DateTime get startDate;
  @override // Technical Skills (1-10 scale)
  TechnicalSkills get technicalSkills;
  @override // Physical Attributes (1-10 scale)
  PhysicalAttributes get physicalAttributes;
  @override // Tactical Understanding (1-10 scale)
  TacticalSkills get tacticalSkills;
  @override // Mental Attributes (1-10 scale)
  MentalAttributes get mentalAttributes;
  @override // Performance Metrics
  PerformanceMetrics get performanceMetrics;
  @override // Overall Ratings
  OverallRating get overallRating;
  @override // Status
  ProgressStatus get status;
  @override // Metadata
  DateTime get createdAt;
  @override
  DateTime? get endDate;
  @override // Development Goals
  List<DevelopmentGoal> get goals;
  @override // Assessments
  List<ProgressAssessment> get assessments;
  @override // Notes & Recommendations
  String? get coachNotes;
  @override
  String? get developmentPlan;
  @override
  List<String> get recommendations;
  @override
  DateTime? get updatedAt;
  @override
  String? get assessedBy;
  @override
  @JsonKey(ignore: true)
  _$$PlayerProgressImplCopyWith<_$PlayerProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TechnicalSkills _$TechnicalSkillsFromJson(Map<String, dynamic> json) {
  return _TechnicalSkills.fromJson(json);
}

/// @nodoc
mixin _$TechnicalSkills {
  double get ballControl => throw _privateConstructorUsedError;
  double get firstTouch => throw _privateConstructorUsedError;
  double get passing => throw _privateConstructorUsedError;
  double get shooting => throw _privateConstructorUsedError;
  double get crossing => throw _privateConstructorUsedError;
  double get dribbling => throw _privateConstructorUsedError;
  double get heading => throw _privateConstructorUsedError;
  double get finishing => throw _privateConstructorUsedError;
  double get longPassing => throw _privateConstructorUsedError;
  double get setPlays =>
      throw _privateConstructorUsedError; // Goalkeeping (if applicable)
  double? get shotStopping => throw _privateConstructorUsedError;
  double? get distribution => throw _privateConstructorUsedError;
  double? get positioning => throw _privateConstructorUsedError;
  double? get handling => throw _privateConstructorUsedError;
  double? get communication => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TechnicalSkillsCopyWith<TechnicalSkills> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicalSkillsCopyWith<$Res> {
  factory $TechnicalSkillsCopyWith(
          TechnicalSkills value, $Res Function(TechnicalSkills) then) =
      _$TechnicalSkillsCopyWithImpl<$Res, TechnicalSkills>;
  @useResult
  $Res call(
      {double ballControl,
      double firstTouch,
      double passing,
      double shooting,
      double crossing,
      double dribbling,
      double heading,
      double finishing,
      double longPassing,
      double setPlays,
      double? shotStopping,
      double? distribution,
      double? positioning,
      double? handling,
      double? communication});
}

/// @nodoc
class _$TechnicalSkillsCopyWithImpl<$Res, $Val extends TechnicalSkills>
    implements $TechnicalSkillsCopyWith<$Res> {
  _$TechnicalSkillsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ballControl = null,
    Object? firstTouch = null,
    Object? passing = null,
    Object? shooting = null,
    Object? crossing = null,
    Object? dribbling = null,
    Object? heading = null,
    Object? finishing = null,
    Object? longPassing = null,
    Object? setPlays = null,
    Object? shotStopping = freezed,
    Object? distribution = freezed,
    Object? positioning = freezed,
    Object? handling = freezed,
    Object? communication = freezed,
  }) {
    return _then(_value.copyWith(
      ballControl: null == ballControl
          ? _value.ballControl
          : ballControl // ignore: cast_nullable_to_non_nullable
              as double,
      firstTouch: null == firstTouch
          ? _value.firstTouch
          : firstTouch // ignore: cast_nullable_to_non_nullable
              as double,
      passing: null == passing
          ? _value.passing
          : passing // ignore: cast_nullable_to_non_nullable
              as double,
      shooting: null == shooting
          ? _value.shooting
          : shooting // ignore: cast_nullable_to_non_nullable
              as double,
      crossing: null == crossing
          ? _value.crossing
          : crossing // ignore: cast_nullable_to_non_nullable
              as double,
      dribbling: null == dribbling
          ? _value.dribbling
          : dribbling // ignore: cast_nullable_to_non_nullable
              as double,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
      finishing: null == finishing
          ? _value.finishing
          : finishing // ignore: cast_nullable_to_non_nullable
              as double,
      longPassing: null == longPassing
          ? _value.longPassing
          : longPassing // ignore: cast_nullable_to_non_nullable
              as double,
      setPlays: null == setPlays
          ? _value.setPlays
          : setPlays // ignore: cast_nullable_to_non_nullable
              as double,
      shotStopping: freezed == shotStopping
          ? _value.shotStopping
          : shotStopping // ignore: cast_nullable_to_non_nullable
              as double?,
      distribution: freezed == distribution
          ? _value.distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as double?,
      positioning: freezed == positioning
          ? _value.positioning
          : positioning // ignore: cast_nullable_to_non_nullable
              as double?,
      handling: freezed == handling
          ? _value.handling
          : handling // ignore: cast_nullable_to_non_nullable
              as double?,
      communication: freezed == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TechnicalSkillsImplCopyWith<$Res>
    implements $TechnicalSkillsCopyWith<$Res> {
  factory _$$TechnicalSkillsImplCopyWith(_$TechnicalSkillsImpl value,
          $Res Function(_$TechnicalSkillsImpl) then) =
      __$$TechnicalSkillsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double ballControl,
      double firstTouch,
      double passing,
      double shooting,
      double crossing,
      double dribbling,
      double heading,
      double finishing,
      double longPassing,
      double setPlays,
      double? shotStopping,
      double? distribution,
      double? positioning,
      double? handling,
      double? communication});
}

/// @nodoc
class __$$TechnicalSkillsImplCopyWithImpl<$Res>
    extends _$TechnicalSkillsCopyWithImpl<$Res, _$TechnicalSkillsImpl>
    implements _$$TechnicalSkillsImplCopyWith<$Res> {
  __$$TechnicalSkillsImplCopyWithImpl(
      _$TechnicalSkillsImpl _value, $Res Function(_$TechnicalSkillsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ballControl = null,
    Object? firstTouch = null,
    Object? passing = null,
    Object? shooting = null,
    Object? crossing = null,
    Object? dribbling = null,
    Object? heading = null,
    Object? finishing = null,
    Object? longPassing = null,
    Object? setPlays = null,
    Object? shotStopping = freezed,
    Object? distribution = freezed,
    Object? positioning = freezed,
    Object? handling = freezed,
    Object? communication = freezed,
  }) {
    return _then(_$TechnicalSkillsImpl(
      ballControl: null == ballControl
          ? _value.ballControl
          : ballControl // ignore: cast_nullable_to_non_nullable
              as double,
      firstTouch: null == firstTouch
          ? _value.firstTouch
          : firstTouch // ignore: cast_nullable_to_non_nullable
              as double,
      passing: null == passing
          ? _value.passing
          : passing // ignore: cast_nullable_to_non_nullable
              as double,
      shooting: null == shooting
          ? _value.shooting
          : shooting // ignore: cast_nullable_to_non_nullable
              as double,
      crossing: null == crossing
          ? _value.crossing
          : crossing // ignore: cast_nullable_to_non_nullable
              as double,
      dribbling: null == dribbling
          ? _value.dribbling
          : dribbling // ignore: cast_nullable_to_non_nullable
              as double,
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
      finishing: null == finishing
          ? _value.finishing
          : finishing // ignore: cast_nullable_to_non_nullable
              as double,
      longPassing: null == longPassing
          ? _value.longPassing
          : longPassing // ignore: cast_nullable_to_non_nullable
              as double,
      setPlays: null == setPlays
          ? _value.setPlays
          : setPlays // ignore: cast_nullable_to_non_nullable
              as double,
      shotStopping: freezed == shotStopping
          ? _value.shotStopping
          : shotStopping // ignore: cast_nullable_to_non_nullable
              as double?,
      distribution: freezed == distribution
          ? _value.distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as double?,
      positioning: freezed == positioning
          ? _value.positioning
          : positioning // ignore: cast_nullable_to_non_nullable
              as double?,
      handling: freezed == handling
          ? _value.handling
          : handling // ignore: cast_nullable_to_non_nullable
              as double?,
      communication: freezed == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicalSkillsImpl implements _TechnicalSkills {
  const _$TechnicalSkillsImpl(
      {this.ballControl = 5.0,
      this.firstTouch = 5.0,
      this.passing = 5.0,
      this.shooting = 5.0,
      this.crossing = 5.0,
      this.dribbling = 5.0,
      this.heading = 5.0,
      this.finishing = 5.0,
      this.longPassing = 5.0,
      this.setPlays = 5.0,
      this.shotStopping,
      this.distribution,
      this.positioning,
      this.handling,
      this.communication});

  factory _$TechnicalSkillsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicalSkillsImplFromJson(json);

  @override
  @JsonKey()
  final double ballControl;
  @override
  @JsonKey()
  final double firstTouch;
  @override
  @JsonKey()
  final double passing;
  @override
  @JsonKey()
  final double shooting;
  @override
  @JsonKey()
  final double crossing;
  @override
  @JsonKey()
  final double dribbling;
  @override
  @JsonKey()
  final double heading;
  @override
  @JsonKey()
  final double finishing;
  @override
  @JsonKey()
  final double longPassing;
  @override
  @JsonKey()
  final double setPlays;
// Goalkeeping (if applicable)
  @override
  final double? shotStopping;
  @override
  final double? distribution;
  @override
  final double? positioning;
  @override
  final double? handling;
  @override
  final double? communication;

  @override
  String toString() {
    return 'TechnicalSkills(ballControl: $ballControl, firstTouch: $firstTouch, passing: $passing, shooting: $shooting, crossing: $crossing, dribbling: $dribbling, heading: $heading, finishing: $finishing, longPassing: $longPassing, setPlays: $setPlays, shotStopping: $shotStopping, distribution: $distribution, positioning: $positioning, handling: $handling, communication: $communication)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicalSkillsImpl &&
            (identical(other.ballControl, ballControl) ||
                other.ballControl == ballControl) &&
            (identical(other.firstTouch, firstTouch) ||
                other.firstTouch == firstTouch) &&
            (identical(other.passing, passing) || other.passing == passing) &&
            (identical(other.shooting, shooting) ||
                other.shooting == shooting) &&
            (identical(other.crossing, crossing) ||
                other.crossing == crossing) &&
            (identical(other.dribbling, dribbling) ||
                other.dribbling == dribbling) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.finishing, finishing) ||
                other.finishing == finishing) &&
            (identical(other.longPassing, longPassing) ||
                other.longPassing == longPassing) &&
            (identical(other.setPlays, setPlays) ||
                other.setPlays == setPlays) &&
            (identical(other.shotStopping, shotStopping) ||
                other.shotStopping == shotStopping) &&
            (identical(other.distribution, distribution) ||
                other.distribution == distribution) &&
            (identical(other.positioning, positioning) ||
                other.positioning == positioning) &&
            (identical(other.handling, handling) ||
                other.handling == handling) &&
            (identical(other.communication, communication) ||
                other.communication == communication));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ballControl,
      firstTouch,
      passing,
      shooting,
      crossing,
      dribbling,
      heading,
      finishing,
      longPassing,
      setPlays,
      shotStopping,
      distribution,
      positioning,
      handling,
      communication);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicalSkillsImplCopyWith<_$TechnicalSkillsImpl> get copyWith =>
      __$$TechnicalSkillsImplCopyWithImpl<_$TechnicalSkillsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicalSkillsImplToJson(
      this,
    );
  }
}

abstract class _TechnicalSkills implements TechnicalSkills {
  const factory _TechnicalSkills(
      {final double ballControl,
      final double firstTouch,
      final double passing,
      final double shooting,
      final double crossing,
      final double dribbling,
      final double heading,
      final double finishing,
      final double longPassing,
      final double setPlays,
      final double? shotStopping,
      final double? distribution,
      final double? positioning,
      final double? handling,
      final double? communication}) = _$TechnicalSkillsImpl;

  factory _TechnicalSkills.fromJson(Map<String, dynamic> json) =
      _$TechnicalSkillsImpl.fromJson;

  @override
  double get ballControl;
  @override
  double get firstTouch;
  @override
  double get passing;
  @override
  double get shooting;
  @override
  double get crossing;
  @override
  double get dribbling;
  @override
  double get heading;
  @override
  double get finishing;
  @override
  double get longPassing;
  @override
  double get setPlays;
  @override // Goalkeeping (if applicable)
  double? get shotStopping;
  @override
  double? get distribution;
  @override
  double? get positioning;
  @override
  double? get handling;
  @override
  double? get communication;
  @override
  @JsonKey(ignore: true)
  _$$TechnicalSkillsImplCopyWith<_$TechnicalSkillsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhysicalAttributes _$PhysicalAttributesFromJson(Map<String, dynamic> json) {
  return _PhysicalAttributes.fromJson(json);
}

/// @nodoc
mixin _$PhysicalAttributes {
  double get speed => throw _privateConstructorUsedError;
  double get acceleration => throw _privateConstructorUsedError;
  double get agility => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  double get strength => throw _privateConstructorUsedError;
  double get stamina => throw _privateConstructorUsedError;
  double get jumping => throw _privateConstructorUsedError;
  double get coordination => throw _privateConstructorUsedError;
  double get flexibility => throw _privateConstructorUsedError;
  double get powerEndurance =>
      throw _privateConstructorUsedError; // Measurements
  double? get height => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get bodyFatPercentage =>
      throw _privateConstructorUsedError; // Performance Tests
  double? get sprintTime40m => throw _privateConstructorUsedError;
  double? get maxSpeed => throw _privateConstructorUsedError;
  double? get verticalJump => throw _privateConstructorUsedError;
  double? get vo2Max => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhysicalAttributesCopyWith<PhysicalAttributes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhysicalAttributesCopyWith<$Res> {
  factory $PhysicalAttributesCopyWith(
          PhysicalAttributes value, $Res Function(PhysicalAttributes) then) =
      _$PhysicalAttributesCopyWithImpl<$Res, PhysicalAttributes>;
  @useResult
  $Res call(
      {double speed,
      double acceleration,
      double agility,
      double balance,
      double strength,
      double stamina,
      double jumping,
      double coordination,
      double flexibility,
      double powerEndurance,
      double? height,
      double? weight,
      double? bodyFatPercentage,
      double? sprintTime40m,
      double? maxSpeed,
      double? verticalJump,
      double? vo2Max});
}

/// @nodoc
class _$PhysicalAttributesCopyWithImpl<$Res, $Val extends PhysicalAttributes>
    implements $PhysicalAttributesCopyWith<$Res> {
  _$PhysicalAttributesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? speed = null,
    Object? acceleration = null,
    Object? agility = null,
    Object? balance = null,
    Object? strength = null,
    Object? stamina = null,
    Object? jumping = null,
    Object? coordination = null,
    Object? flexibility = null,
    Object? powerEndurance = null,
    Object? height = freezed,
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? sprintTime40m = freezed,
    Object? maxSpeed = freezed,
    Object? verticalJump = freezed,
    Object? vo2Max = freezed,
  }) {
    return _then(_value.copyWith(
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      acceleration: null == acceleration
          ? _value.acceleration
          : acceleration // ignore: cast_nullable_to_non_nullable
              as double,
      agility: null == agility
          ? _value.agility
          : agility // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
      stamina: null == stamina
          ? _value.stamina
          : stamina // ignore: cast_nullable_to_non_nullable
              as double,
      jumping: null == jumping
          ? _value.jumping
          : jumping // ignore: cast_nullable_to_non_nullable
              as double,
      coordination: null == coordination
          ? _value.coordination
          : coordination // ignore: cast_nullable_to_non_nullable
              as double,
      flexibility: null == flexibility
          ? _value.flexibility
          : flexibility // ignore: cast_nullable_to_non_nullable
              as double,
      powerEndurance: null == powerEndurance
          ? _value.powerEndurance
          : powerEndurance // ignore: cast_nullable_to_non_nullable
              as double,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      sprintTime40m: freezed == sprintTime40m
          ? _value.sprintTime40m
          : sprintTime40m // ignore: cast_nullable_to_non_nullable
              as double?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      verticalJump: freezed == verticalJump
          ? _value.verticalJump
          : verticalJump // ignore: cast_nullable_to_non_nullable
              as double?,
      vo2Max: freezed == vo2Max
          ? _value.vo2Max
          : vo2Max // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhysicalAttributesImplCopyWith<$Res>
    implements $PhysicalAttributesCopyWith<$Res> {
  factory _$$PhysicalAttributesImplCopyWith(_$PhysicalAttributesImpl value,
          $Res Function(_$PhysicalAttributesImpl) then) =
      __$$PhysicalAttributesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double speed,
      double acceleration,
      double agility,
      double balance,
      double strength,
      double stamina,
      double jumping,
      double coordination,
      double flexibility,
      double powerEndurance,
      double? height,
      double? weight,
      double? bodyFatPercentage,
      double? sprintTime40m,
      double? maxSpeed,
      double? verticalJump,
      double? vo2Max});
}

/// @nodoc
class __$$PhysicalAttributesImplCopyWithImpl<$Res>
    extends _$PhysicalAttributesCopyWithImpl<$Res, _$PhysicalAttributesImpl>
    implements _$$PhysicalAttributesImplCopyWith<$Res> {
  __$$PhysicalAttributesImplCopyWithImpl(_$PhysicalAttributesImpl _value,
      $Res Function(_$PhysicalAttributesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? speed = null,
    Object? acceleration = null,
    Object? agility = null,
    Object? balance = null,
    Object? strength = null,
    Object? stamina = null,
    Object? jumping = null,
    Object? coordination = null,
    Object? flexibility = null,
    Object? powerEndurance = null,
    Object? height = freezed,
    Object? weight = freezed,
    Object? bodyFatPercentage = freezed,
    Object? sprintTime40m = freezed,
    Object? maxSpeed = freezed,
    Object? verticalJump = freezed,
    Object? vo2Max = freezed,
  }) {
    return _then(_$PhysicalAttributesImpl(
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      acceleration: null == acceleration
          ? _value.acceleration
          : acceleration // ignore: cast_nullable_to_non_nullable
              as double,
      agility: null == agility
          ? _value.agility
          : agility // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      strength: null == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as double,
      stamina: null == stamina
          ? _value.stamina
          : stamina // ignore: cast_nullable_to_non_nullable
              as double,
      jumping: null == jumping
          ? _value.jumping
          : jumping // ignore: cast_nullable_to_non_nullable
              as double,
      coordination: null == coordination
          ? _value.coordination
          : coordination // ignore: cast_nullable_to_non_nullable
              as double,
      flexibility: null == flexibility
          ? _value.flexibility
          : flexibility // ignore: cast_nullable_to_non_nullable
              as double,
      powerEndurance: null == powerEndurance
          ? _value.powerEndurance
          : powerEndurance // ignore: cast_nullable_to_non_nullable
              as double,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      sprintTime40m: freezed == sprintTime40m
          ? _value.sprintTime40m
          : sprintTime40m // ignore: cast_nullable_to_non_nullable
              as double?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      verticalJump: freezed == verticalJump
          ? _value.verticalJump
          : verticalJump // ignore: cast_nullable_to_non_nullable
              as double?,
      vo2Max: freezed == vo2Max
          ? _value.vo2Max
          : vo2Max // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhysicalAttributesImpl implements _PhysicalAttributes {
  const _$PhysicalAttributesImpl(
      {this.speed = 5.0,
      this.acceleration = 5.0,
      this.agility = 5.0,
      this.balance = 5.0,
      this.strength = 5.0,
      this.stamina = 5.0,
      this.jumping = 5.0,
      this.coordination = 5.0,
      this.flexibility = 5.0,
      this.powerEndurance = 5.0,
      this.height,
      this.weight,
      this.bodyFatPercentage,
      this.sprintTime40m,
      this.maxSpeed,
      this.verticalJump,
      this.vo2Max});

  factory _$PhysicalAttributesImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhysicalAttributesImplFromJson(json);

  @override
  @JsonKey()
  final double speed;
  @override
  @JsonKey()
  final double acceleration;
  @override
  @JsonKey()
  final double agility;
  @override
  @JsonKey()
  final double balance;
  @override
  @JsonKey()
  final double strength;
  @override
  @JsonKey()
  final double stamina;
  @override
  @JsonKey()
  final double jumping;
  @override
  @JsonKey()
  final double coordination;
  @override
  @JsonKey()
  final double flexibility;
  @override
  @JsonKey()
  final double powerEndurance;
// Measurements
  @override
  final double? height;
  @override
  final double? weight;
  @override
  final double? bodyFatPercentage;
// Performance Tests
  @override
  final double? sprintTime40m;
  @override
  final double? maxSpeed;
  @override
  final double? verticalJump;
  @override
  final double? vo2Max;

  @override
  String toString() {
    return 'PhysicalAttributes(speed: $speed, acceleration: $acceleration, agility: $agility, balance: $balance, strength: $strength, stamina: $stamina, jumping: $jumping, coordination: $coordination, flexibility: $flexibility, powerEndurance: $powerEndurance, height: $height, weight: $weight, bodyFatPercentage: $bodyFatPercentage, sprintTime40m: $sprintTime40m, maxSpeed: $maxSpeed, verticalJump: $verticalJump, vo2Max: $vo2Max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhysicalAttributesImpl &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.acceleration, acceleration) ||
                other.acceleration == acceleration) &&
            (identical(other.agility, agility) || other.agility == agility) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.stamina, stamina) || other.stamina == stamina) &&
            (identical(other.jumping, jumping) || other.jumping == jumping) &&
            (identical(other.coordination, coordination) ||
                other.coordination == coordination) &&
            (identical(other.flexibility, flexibility) ||
                other.flexibility == flexibility) &&
            (identical(other.powerEndurance, powerEndurance) ||
                other.powerEndurance == powerEndurance) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.sprintTime40m, sprintTime40m) ||
                other.sprintTime40m == sprintTime40m) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.verticalJump, verticalJump) ||
                other.verticalJump == verticalJump) &&
            (identical(other.vo2Max, vo2Max) || other.vo2Max == vo2Max));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      speed,
      acceleration,
      agility,
      balance,
      strength,
      stamina,
      jumping,
      coordination,
      flexibility,
      powerEndurance,
      height,
      weight,
      bodyFatPercentage,
      sprintTime40m,
      maxSpeed,
      verticalJump,
      vo2Max);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhysicalAttributesImplCopyWith<_$PhysicalAttributesImpl> get copyWith =>
      __$$PhysicalAttributesImplCopyWithImpl<_$PhysicalAttributesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhysicalAttributesImplToJson(
      this,
    );
  }
}

abstract class _PhysicalAttributes implements PhysicalAttributes {
  const factory _PhysicalAttributes(
      {final double speed,
      final double acceleration,
      final double agility,
      final double balance,
      final double strength,
      final double stamina,
      final double jumping,
      final double coordination,
      final double flexibility,
      final double powerEndurance,
      final double? height,
      final double? weight,
      final double? bodyFatPercentage,
      final double? sprintTime40m,
      final double? maxSpeed,
      final double? verticalJump,
      final double? vo2Max}) = _$PhysicalAttributesImpl;

  factory _PhysicalAttributes.fromJson(Map<String, dynamic> json) =
      _$PhysicalAttributesImpl.fromJson;

  @override
  double get speed;
  @override
  double get acceleration;
  @override
  double get agility;
  @override
  double get balance;
  @override
  double get strength;
  @override
  double get stamina;
  @override
  double get jumping;
  @override
  double get coordination;
  @override
  double get flexibility;
  @override
  double get powerEndurance;
  @override // Measurements
  double? get height;
  @override
  double? get weight;
  @override
  double? get bodyFatPercentage;
  @override // Performance Tests
  double? get sprintTime40m;
  @override
  double? get maxSpeed;
  @override
  double? get verticalJump;
  @override
  double? get vo2Max;
  @override
  @JsonKey(ignore: true)
  _$$PhysicalAttributesImplCopyWith<_$PhysicalAttributesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TacticalSkills _$TacticalSkillsFromJson(Map<String, dynamic> json) {
  return _TacticalSkills.fromJson(json);
}

/// @nodoc
mixin _$TacticalSkills {
  double get positioning => throw _privateConstructorUsedError;
  double get decisionMaking => throw _privateConstructorUsedError;
  double get gameReading => throw _privateConstructorUsedError;
  double get anticipation => throw _privateConstructorUsedError;
  double get teamWork => throw _privateConstructorUsedError;
  double get defensiveAwareness => throw _privateConstructorUsedError;
  double get offensiveMovement => throw _privateConstructorUsedError;
  double get pressureHandling => throw _privateConstructorUsedError;
  double get adaptability => throw _privateConstructorUsedError;
  double get gameIntelligence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TacticalSkillsCopyWith<TacticalSkills> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TacticalSkillsCopyWith<$Res> {
  factory $TacticalSkillsCopyWith(
          TacticalSkills value, $Res Function(TacticalSkills) then) =
      _$TacticalSkillsCopyWithImpl<$Res, TacticalSkills>;
  @useResult
  $Res call(
      {double positioning,
      double decisionMaking,
      double gameReading,
      double anticipation,
      double teamWork,
      double defensiveAwareness,
      double offensiveMovement,
      double pressureHandling,
      double adaptability,
      double gameIntelligence});
}

/// @nodoc
class _$TacticalSkillsCopyWithImpl<$Res, $Val extends TacticalSkills>
    implements $TacticalSkillsCopyWith<$Res> {
  _$TacticalSkillsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? positioning = null,
    Object? decisionMaking = null,
    Object? gameReading = null,
    Object? anticipation = null,
    Object? teamWork = null,
    Object? defensiveAwareness = null,
    Object? offensiveMovement = null,
    Object? pressureHandling = null,
    Object? adaptability = null,
    Object? gameIntelligence = null,
  }) {
    return _then(_value.copyWith(
      positioning: null == positioning
          ? _value.positioning
          : positioning // ignore: cast_nullable_to_non_nullable
              as double,
      decisionMaking: null == decisionMaking
          ? _value.decisionMaking
          : decisionMaking // ignore: cast_nullable_to_non_nullable
              as double,
      gameReading: null == gameReading
          ? _value.gameReading
          : gameReading // ignore: cast_nullable_to_non_nullable
              as double,
      anticipation: null == anticipation
          ? _value.anticipation
          : anticipation // ignore: cast_nullable_to_non_nullable
              as double,
      teamWork: null == teamWork
          ? _value.teamWork
          : teamWork // ignore: cast_nullable_to_non_nullable
              as double,
      defensiveAwareness: null == defensiveAwareness
          ? _value.defensiveAwareness
          : defensiveAwareness // ignore: cast_nullable_to_non_nullable
              as double,
      offensiveMovement: null == offensiveMovement
          ? _value.offensiveMovement
          : offensiveMovement // ignore: cast_nullable_to_non_nullable
              as double,
      pressureHandling: null == pressureHandling
          ? _value.pressureHandling
          : pressureHandling // ignore: cast_nullable_to_non_nullable
              as double,
      adaptability: null == adaptability
          ? _value.adaptability
          : adaptability // ignore: cast_nullable_to_non_nullable
              as double,
      gameIntelligence: null == gameIntelligence
          ? _value.gameIntelligence
          : gameIntelligence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TacticalSkillsImplCopyWith<$Res>
    implements $TacticalSkillsCopyWith<$Res> {
  factory _$$TacticalSkillsImplCopyWith(_$TacticalSkillsImpl value,
          $Res Function(_$TacticalSkillsImpl) then) =
      __$$TacticalSkillsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double positioning,
      double decisionMaking,
      double gameReading,
      double anticipation,
      double teamWork,
      double defensiveAwareness,
      double offensiveMovement,
      double pressureHandling,
      double adaptability,
      double gameIntelligence});
}

/// @nodoc
class __$$TacticalSkillsImplCopyWithImpl<$Res>
    extends _$TacticalSkillsCopyWithImpl<$Res, _$TacticalSkillsImpl>
    implements _$$TacticalSkillsImplCopyWith<$Res> {
  __$$TacticalSkillsImplCopyWithImpl(
      _$TacticalSkillsImpl _value, $Res Function(_$TacticalSkillsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? positioning = null,
    Object? decisionMaking = null,
    Object? gameReading = null,
    Object? anticipation = null,
    Object? teamWork = null,
    Object? defensiveAwareness = null,
    Object? offensiveMovement = null,
    Object? pressureHandling = null,
    Object? adaptability = null,
    Object? gameIntelligence = null,
  }) {
    return _then(_$TacticalSkillsImpl(
      positioning: null == positioning
          ? _value.positioning
          : positioning // ignore: cast_nullable_to_non_nullable
              as double,
      decisionMaking: null == decisionMaking
          ? _value.decisionMaking
          : decisionMaking // ignore: cast_nullable_to_non_nullable
              as double,
      gameReading: null == gameReading
          ? _value.gameReading
          : gameReading // ignore: cast_nullable_to_non_nullable
              as double,
      anticipation: null == anticipation
          ? _value.anticipation
          : anticipation // ignore: cast_nullable_to_non_nullable
              as double,
      teamWork: null == teamWork
          ? _value.teamWork
          : teamWork // ignore: cast_nullable_to_non_nullable
              as double,
      defensiveAwareness: null == defensiveAwareness
          ? _value.defensiveAwareness
          : defensiveAwareness // ignore: cast_nullable_to_non_nullable
              as double,
      offensiveMovement: null == offensiveMovement
          ? _value.offensiveMovement
          : offensiveMovement // ignore: cast_nullable_to_non_nullable
              as double,
      pressureHandling: null == pressureHandling
          ? _value.pressureHandling
          : pressureHandling // ignore: cast_nullable_to_non_nullable
              as double,
      adaptability: null == adaptability
          ? _value.adaptability
          : adaptability // ignore: cast_nullable_to_non_nullable
              as double,
      gameIntelligence: null == gameIntelligence
          ? _value.gameIntelligence
          : gameIntelligence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TacticalSkillsImpl implements _TacticalSkills {
  const _$TacticalSkillsImpl(
      {this.positioning = 5.0,
      this.decisionMaking = 5.0,
      this.gameReading = 5.0,
      this.anticipation = 5.0,
      this.teamWork = 5.0,
      this.defensiveAwareness = 5.0,
      this.offensiveMovement = 5.0,
      this.pressureHandling = 5.0,
      this.adaptability = 5.0,
      this.gameIntelligence = 5.0});

  factory _$TacticalSkillsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TacticalSkillsImplFromJson(json);

  @override
  @JsonKey()
  final double positioning;
  @override
  @JsonKey()
  final double decisionMaking;
  @override
  @JsonKey()
  final double gameReading;
  @override
  @JsonKey()
  final double anticipation;
  @override
  @JsonKey()
  final double teamWork;
  @override
  @JsonKey()
  final double defensiveAwareness;
  @override
  @JsonKey()
  final double offensiveMovement;
  @override
  @JsonKey()
  final double pressureHandling;
  @override
  @JsonKey()
  final double adaptability;
  @override
  @JsonKey()
  final double gameIntelligence;

  @override
  String toString() {
    return 'TacticalSkills(positioning: $positioning, decisionMaking: $decisionMaking, gameReading: $gameReading, anticipation: $anticipation, teamWork: $teamWork, defensiveAwareness: $defensiveAwareness, offensiveMovement: $offensiveMovement, pressureHandling: $pressureHandling, adaptability: $adaptability, gameIntelligence: $gameIntelligence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TacticalSkillsImpl &&
            (identical(other.positioning, positioning) ||
                other.positioning == positioning) &&
            (identical(other.decisionMaking, decisionMaking) ||
                other.decisionMaking == decisionMaking) &&
            (identical(other.gameReading, gameReading) ||
                other.gameReading == gameReading) &&
            (identical(other.anticipation, anticipation) ||
                other.anticipation == anticipation) &&
            (identical(other.teamWork, teamWork) ||
                other.teamWork == teamWork) &&
            (identical(other.defensiveAwareness, defensiveAwareness) ||
                other.defensiveAwareness == defensiveAwareness) &&
            (identical(other.offensiveMovement, offensiveMovement) ||
                other.offensiveMovement == offensiveMovement) &&
            (identical(other.pressureHandling, pressureHandling) ||
                other.pressureHandling == pressureHandling) &&
            (identical(other.adaptability, adaptability) ||
                other.adaptability == adaptability) &&
            (identical(other.gameIntelligence, gameIntelligence) ||
                other.gameIntelligence == gameIntelligence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      positioning,
      decisionMaking,
      gameReading,
      anticipation,
      teamWork,
      defensiveAwareness,
      offensiveMovement,
      pressureHandling,
      adaptability,
      gameIntelligence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TacticalSkillsImplCopyWith<_$TacticalSkillsImpl> get copyWith =>
      __$$TacticalSkillsImplCopyWithImpl<_$TacticalSkillsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TacticalSkillsImplToJson(
      this,
    );
  }
}

abstract class _TacticalSkills implements TacticalSkills {
  const factory _TacticalSkills(
      {final double positioning,
      final double decisionMaking,
      final double gameReading,
      final double anticipation,
      final double teamWork,
      final double defensiveAwareness,
      final double offensiveMovement,
      final double pressureHandling,
      final double adaptability,
      final double gameIntelligence}) = _$TacticalSkillsImpl;

  factory _TacticalSkills.fromJson(Map<String, dynamic> json) =
      _$TacticalSkillsImpl.fromJson;

  @override
  double get positioning;
  @override
  double get decisionMaking;
  @override
  double get gameReading;
  @override
  double get anticipation;
  @override
  double get teamWork;
  @override
  double get defensiveAwareness;
  @override
  double get offensiveMovement;
  @override
  double get pressureHandling;
  @override
  double get adaptability;
  @override
  double get gameIntelligence;
  @override
  @JsonKey(ignore: true)
  _$$TacticalSkillsImplCopyWith<_$TacticalSkillsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MentalAttributes _$MentalAttributesFromJson(Map<String, dynamic> json) {
  return _MentalAttributes.fromJson(json);
}

/// @nodoc
mixin _$MentalAttributes {
  double get motivation => throw _privateConstructorUsedError;
  double get concentration => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  double get resilience => throw _privateConstructorUsedError;
  double get leadership => throw _privateConstructorUsedError;
  double get communication => throw _privateConstructorUsedError;
  double get discipline => throw _privateConstructorUsedError;
  double get learningAbility => throw _privateConstructorUsedError;
  double get competitiveness => throw _privateConstructorUsedError;
  double get emotionalControl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MentalAttributesCopyWith<MentalAttributes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentalAttributesCopyWith<$Res> {
  factory $MentalAttributesCopyWith(
          MentalAttributes value, $Res Function(MentalAttributes) then) =
      _$MentalAttributesCopyWithImpl<$Res, MentalAttributes>;
  @useResult
  $Res call(
      {double motivation,
      double concentration,
      double confidence,
      double resilience,
      double leadership,
      double communication,
      double discipline,
      double learningAbility,
      double competitiveness,
      double emotionalControl});
}

/// @nodoc
class _$MentalAttributesCopyWithImpl<$Res, $Val extends MentalAttributes>
    implements $MentalAttributesCopyWith<$Res> {
  _$MentalAttributesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? motivation = null,
    Object? concentration = null,
    Object? confidence = null,
    Object? resilience = null,
    Object? leadership = null,
    Object? communication = null,
    Object? discipline = null,
    Object? learningAbility = null,
    Object? competitiveness = null,
    Object? emotionalControl = null,
  }) {
    return _then(_value.copyWith(
      motivation: null == motivation
          ? _value.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as double,
      concentration: null == concentration
          ? _value.concentration
          : concentration // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      resilience: null == resilience
          ? _value.resilience
          : resilience // ignore: cast_nullable_to_non_nullable
              as double,
      leadership: null == leadership
          ? _value.leadership
          : leadership // ignore: cast_nullable_to_non_nullable
              as double,
      communication: null == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as double,
      discipline: null == discipline
          ? _value.discipline
          : discipline // ignore: cast_nullable_to_non_nullable
              as double,
      learningAbility: null == learningAbility
          ? _value.learningAbility
          : learningAbility // ignore: cast_nullable_to_non_nullable
              as double,
      competitiveness: null == competitiveness
          ? _value.competitiveness
          : competitiveness // ignore: cast_nullable_to_non_nullable
              as double,
      emotionalControl: null == emotionalControl
          ? _value.emotionalControl
          : emotionalControl // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentalAttributesImplCopyWith<$Res>
    implements $MentalAttributesCopyWith<$Res> {
  factory _$$MentalAttributesImplCopyWith(_$MentalAttributesImpl value,
          $Res Function(_$MentalAttributesImpl) then) =
      __$$MentalAttributesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double motivation,
      double concentration,
      double confidence,
      double resilience,
      double leadership,
      double communication,
      double discipline,
      double learningAbility,
      double competitiveness,
      double emotionalControl});
}

/// @nodoc
class __$$MentalAttributesImplCopyWithImpl<$Res>
    extends _$MentalAttributesCopyWithImpl<$Res, _$MentalAttributesImpl>
    implements _$$MentalAttributesImplCopyWith<$Res> {
  __$$MentalAttributesImplCopyWithImpl(_$MentalAttributesImpl _value,
      $Res Function(_$MentalAttributesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? motivation = null,
    Object? concentration = null,
    Object? confidence = null,
    Object? resilience = null,
    Object? leadership = null,
    Object? communication = null,
    Object? discipline = null,
    Object? learningAbility = null,
    Object? competitiveness = null,
    Object? emotionalControl = null,
  }) {
    return _then(_$MentalAttributesImpl(
      motivation: null == motivation
          ? _value.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as double,
      concentration: null == concentration
          ? _value.concentration
          : concentration // ignore: cast_nullable_to_non_nullable
              as double,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      resilience: null == resilience
          ? _value.resilience
          : resilience // ignore: cast_nullable_to_non_nullable
              as double,
      leadership: null == leadership
          ? _value.leadership
          : leadership // ignore: cast_nullable_to_non_nullable
              as double,
      communication: null == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as double,
      discipline: null == discipline
          ? _value.discipline
          : discipline // ignore: cast_nullable_to_non_nullable
              as double,
      learningAbility: null == learningAbility
          ? _value.learningAbility
          : learningAbility // ignore: cast_nullable_to_non_nullable
              as double,
      competitiveness: null == competitiveness
          ? _value.competitiveness
          : competitiveness // ignore: cast_nullable_to_non_nullable
              as double,
      emotionalControl: null == emotionalControl
          ? _value.emotionalControl
          : emotionalControl // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentalAttributesImpl implements _MentalAttributes {
  const _$MentalAttributesImpl(
      {this.motivation = 5.0,
      this.concentration = 5.0,
      this.confidence = 5.0,
      this.resilience = 5.0,
      this.leadership = 5.0,
      this.communication = 5.0,
      this.discipline = 5.0,
      this.learningAbility = 5.0,
      this.competitiveness = 5.0,
      this.emotionalControl = 5.0});

  factory _$MentalAttributesImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentalAttributesImplFromJson(json);

  @override
  @JsonKey()
  final double motivation;
  @override
  @JsonKey()
  final double concentration;
  @override
  @JsonKey()
  final double confidence;
  @override
  @JsonKey()
  final double resilience;
  @override
  @JsonKey()
  final double leadership;
  @override
  @JsonKey()
  final double communication;
  @override
  @JsonKey()
  final double discipline;
  @override
  @JsonKey()
  final double learningAbility;
  @override
  @JsonKey()
  final double competitiveness;
  @override
  @JsonKey()
  final double emotionalControl;

  @override
  String toString() {
    return 'MentalAttributes(motivation: $motivation, concentration: $concentration, confidence: $confidence, resilience: $resilience, leadership: $leadership, communication: $communication, discipline: $discipline, learningAbility: $learningAbility, competitiveness: $competitiveness, emotionalControl: $emotionalControl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentalAttributesImpl &&
            (identical(other.motivation, motivation) ||
                other.motivation == motivation) &&
            (identical(other.concentration, concentration) ||
                other.concentration == concentration) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.resilience, resilience) ||
                other.resilience == resilience) &&
            (identical(other.leadership, leadership) ||
                other.leadership == leadership) &&
            (identical(other.communication, communication) ||
                other.communication == communication) &&
            (identical(other.discipline, discipline) ||
                other.discipline == discipline) &&
            (identical(other.learningAbility, learningAbility) ||
                other.learningAbility == learningAbility) &&
            (identical(other.competitiveness, competitiveness) ||
                other.competitiveness == competitiveness) &&
            (identical(other.emotionalControl, emotionalControl) ||
                other.emotionalControl == emotionalControl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      motivation,
      concentration,
      confidence,
      resilience,
      leadership,
      communication,
      discipline,
      learningAbility,
      competitiveness,
      emotionalControl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MentalAttributesImplCopyWith<_$MentalAttributesImpl> get copyWith =>
      __$$MentalAttributesImplCopyWithImpl<_$MentalAttributesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentalAttributesImplToJson(
      this,
    );
  }
}

abstract class _MentalAttributes implements MentalAttributes {
  const factory _MentalAttributes(
      {final double motivation,
      final double concentration,
      final double confidence,
      final double resilience,
      final double leadership,
      final double communication,
      final double discipline,
      final double learningAbility,
      final double competitiveness,
      final double emotionalControl}) = _$MentalAttributesImpl;

  factory _MentalAttributes.fromJson(Map<String, dynamic> json) =
      _$MentalAttributesImpl.fromJson;

  @override
  double get motivation;
  @override
  double get concentration;
  @override
  double get confidence;
  @override
  double get resilience;
  @override
  double get leadership;
  @override
  double get communication;
  @override
  double get discipline;
  @override
  double get learningAbility;
  @override
  double get competitiveness;
  @override
  double get emotionalControl;
  @override
  @JsonKey(ignore: true)
  _$$MentalAttributesImplCopyWith<_$MentalAttributesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerformanceMetrics _$PerformanceMetricsFromJson(Map<String, dynamic> json) {
  return _PerformanceMetrics.fromJson(json);
}

/// @nodoc
mixin _$PerformanceMetrics {
// Match Statistics
  int get matchesPlayed => throw _privateConstructorUsedError;
  int get matchesStarted => throw _privateConstructorUsedError;
  int get minutesPlayed => throw _privateConstructorUsedError;
  int get goals => throw _privateConstructorUsedError;
  int get assists => throw _privateConstructorUsedError;
  int get yellowCards => throw _privateConstructorUsedError;
  int get redCards => throw _privateConstructorUsedError; // Training Statistics
  int get trainingsAttended => throw _privateConstructorUsedError;
  int get totalTrainings => throw _privateConstructorUsedError;
  double get attendancePercentage => throw _privateConstructorUsedError;
  double get trainingRating =>
      throw _privateConstructorUsedError; // Development Metrics
  double get improvementRate => throw _privateConstructorUsedError;
  double get consistencyScore => throw _privateConstructorUsedError;
  double get potentialRating => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PerformanceMetricsCopyWith<PerformanceMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceMetricsCopyWith<$Res> {
  factory $PerformanceMetricsCopyWith(
          PerformanceMetrics value, $Res Function(PerformanceMetrics) then) =
      _$PerformanceMetricsCopyWithImpl<$Res, PerformanceMetrics>;
  @useResult
  $Res call(
      {int matchesPlayed,
      int matchesStarted,
      int minutesPlayed,
      int goals,
      int assists,
      int yellowCards,
      int redCards,
      int trainingsAttended,
      int totalTrainings,
      double attendancePercentage,
      double trainingRating,
      double improvementRate,
      double consistencyScore,
      double potentialRating});
}

/// @nodoc
class _$PerformanceMetricsCopyWithImpl<$Res, $Val extends PerformanceMetrics>
    implements $PerformanceMetricsCopyWith<$Res> {
  _$PerformanceMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchesPlayed = null,
    Object? matchesStarted = null,
    Object? minutesPlayed = null,
    Object? goals = null,
    Object? assists = null,
    Object? yellowCards = null,
    Object? redCards = null,
    Object? trainingsAttended = null,
    Object? totalTrainings = null,
    Object? attendancePercentage = null,
    Object? trainingRating = null,
    Object? improvementRate = null,
    Object? consistencyScore = null,
    Object? potentialRating = null,
  }) {
    return _then(_value.copyWith(
      matchesPlayed: null == matchesPlayed
          ? _value.matchesPlayed
          : matchesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      matchesStarted: null == matchesStarted
          ? _value.matchesStarted
          : matchesStarted // ignore: cast_nullable_to_non_nullable
              as int,
      minutesPlayed: null == minutesPlayed
          ? _value.minutesPlayed
          : minutesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as int,
      assists: null == assists
          ? _value.assists
          : assists // ignore: cast_nullable_to_non_nullable
              as int,
      yellowCards: null == yellowCards
          ? _value.yellowCards
          : yellowCards // ignore: cast_nullable_to_non_nullable
              as int,
      redCards: null == redCards
          ? _value.redCards
          : redCards // ignore: cast_nullable_to_non_nullable
              as int,
      trainingsAttended: null == trainingsAttended
          ? _value.trainingsAttended
          : trainingsAttended // ignore: cast_nullable_to_non_nullable
              as int,
      totalTrainings: null == totalTrainings
          ? _value.totalTrainings
          : totalTrainings // ignore: cast_nullable_to_non_nullable
              as int,
      attendancePercentage: null == attendancePercentage
          ? _value.attendancePercentage
          : attendancePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      trainingRating: null == trainingRating
          ? _value.trainingRating
          : trainingRating // ignore: cast_nullable_to_non_nullable
              as double,
      improvementRate: null == improvementRate
          ? _value.improvementRate
          : improvementRate // ignore: cast_nullable_to_non_nullable
              as double,
      consistencyScore: null == consistencyScore
          ? _value.consistencyScore
          : consistencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      potentialRating: null == potentialRating
          ? _value.potentialRating
          : potentialRating // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerformanceMetricsImplCopyWith<$Res>
    implements $PerformanceMetricsCopyWith<$Res> {
  factory _$$PerformanceMetricsImplCopyWith(_$PerformanceMetricsImpl value,
          $Res Function(_$PerformanceMetricsImpl) then) =
      __$$PerformanceMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int matchesPlayed,
      int matchesStarted,
      int minutesPlayed,
      int goals,
      int assists,
      int yellowCards,
      int redCards,
      int trainingsAttended,
      int totalTrainings,
      double attendancePercentage,
      double trainingRating,
      double improvementRate,
      double consistencyScore,
      double potentialRating});
}

/// @nodoc
class __$$PerformanceMetricsImplCopyWithImpl<$Res>
    extends _$PerformanceMetricsCopyWithImpl<$Res, _$PerformanceMetricsImpl>
    implements _$$PerformanceMetricsImplCopyWith<$Res> {
  __$$PerformanceMetricsImplCopyWithImpl(_$PerformanceMetricsImpl _value,
      $Res Function(_$PerformanceMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchesPlayed = null,
    Object? matchesStarted = null,
    Object? minutesPlayed = null,
    Object? goals = null,
    Object? assists = null,
    Object? yellowCards = null,
    Object? redCards = null,
    Object? trainingsAttended = null,
    Object? totalTrainings = null,
    Object? attendancePercentage = null,
    Object? trainingRating = null,
    Object? improvementRate = null,
    Object? consistencyScore = null,
    Object? potentialRating = null,
  }) {
    return _then(_$PerformanceMetricsImpl(
      matchesPlayed: null == matchesPlayed
          ? _value.matchesPlayed
          : matchesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      matchesStarted: null == matchesStarted
          ? _value.matchesStarted
          : matchesStarted // ignore: cast_nullable_to_non_nullable
              as int,
      minutesPlayed: null == minutesPlayed
          ? _value.minutesPlayed
          : minutesPlayed // ignore: cast_nullable_to_non_nullable
              as int,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as int,
      assists: null == assists
          ? _value.assists
          : assists // ignore: cast_nullable_to_non_nullable
              as int,
      yellowCards: null == yellowCards
          ? _value.yellowCards
          : yellowCards // ignore: cast_nullable_to_non_nullable
              as int,
      redCards: null == redCards
          ? _value.redCards
          : redCards // ignore: cast_nullable_to_non_nullable
              as int,
      trainingsAttended: null == trainingsAttended
          ? _value.trainingsAttended
          : trainingsAttended // ignore: cast_nullable_to_non_nullable
              as int,
      totalTrainings: null == totalTrainings
          ? _value.totalTrainings
          : totalTrainings // ignore: cast_nullable_to_non_nullable
              as int,
      attendancePercentage: null == attendancePercentage
          ? _value.attendancePercentage
          : attendancePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      trainingRating: null == trainingRating
          ? _value.trainingRating
          : trainingRating // ignore: cast_nullable_to_non_nullable
              as double,
      improvementRate: null == improvementRate
          ? _value.improvementRate
          : improvementRate // ignore: cast_nullable_to_non_nullable
              as double,
      consistencyScore: null == consistencyScore
          ? _value.consistencyScore
          : consistencyScore // ignore: cast_nullable_to_non_nullable
              as double,
      potentialRating: null == potentialRating
          ? _value.potentialRating
          : potentialRating // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceMetricsImpl implements _PerformanceMetrics {
  const _$PerformanceMetricsImpl(
      {this.matchesPlayed = 0,
      this.matchesStarted = 0,
      this.minutesPlayed = 0,
      this.goals = 0,
      this.assists = 0,
      this.yellowCards = 0,
      this.redCards = 0,
      this.trainingsAttended = 0,
      this.totalTrainings = 0,
      this.attendancePercentage = 0.0,
      this.trainingRating = 0.0,
      this.improvementRate = 0.0,
      this.consistencyScore = 0.0,
      this.potentialRating = 0.0});

  factory _$PerformanceMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceMetricsImplFromJson(json);

// Match Statistics
  @override
  @JsonKey()
  final int matchesPlayed;
  @override
  @JsonKey()
  final int matchesStarted;
  @override
  @JsonKey()
  final int minutesPlayed;
  @override
  @JsonKey()
  final int goals;
  @override
  @JsonKey()
  final int assists;
  @override
  @JsonKey()
  final int yellowCards;
  @override
  @JsonKey()
  final int redCards;
// Training Statistics
  @override
  @JsonKey()
  final int trainingsAttended;
  @override
  @JsonKey()
  final int totalTrainings;
  @override
  @JsonKey()
  final double attendancePercentage;
  @override
  @JsonKey()
  final double trainingRating;
// Development Metrics
  @override
  @JsonKey()
  final double improvementRate;
  @override
  @JsonKey()
  final double consistencyScore;
  @override
  @JsonKey()
  final double potentialRating;

  @override
  String toString() {
    return 'PerformanceMetrics(matchesPlayed: $matchesPlayed, matchesStarted: $matchesStarted, minutesPlayed: $minutesPlayed, goals: $goals, assists: $assists, yellowCards: $yellowCards, redCards: $redCards, trainingsAttended: $trainingsAttended, totalTrainings: $totalTrainings, attendancePercentage: $attendancePercentage, trainingRating: $trainingRating, improvementRate: $improvementRate, consistencyScore: $consistencyScore, potentialRating: $potentialRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceMetricsImpl &&
            (identical(other.matchesPlayed, matchesPlayed) ||
                other.matchesPlayed == matchesPlayed) &&
            (identical(other.matchesStarted, matchesStarted) ||
                other.matchesStarted == matchesStarted) &&
            (identical(other.minutesPlayed, minutesPlayed) ||
                other.minutesPlayed == minutesPlayed) &&
            (identical(other.goals, goals) || other.goals == goals) &&
            (identical(other.assists, assists) || other.assists == assists) &&
            (identical(other.yellowCards, yellowCards) ||
                other.yellowCards == yellowCards) &&
            (identical(other.redCards, redCards) ||
                other.redCards == redCards) &&
            (identical(other.trainingsAttended, trainingsAttended) ||
                other.trainingsAttended == trainingsAttended) &&
            (identical(other.totalTrainings, totalTrainings) ||
                other.totalTrainings == totalTrainings) &&
            (identical(other.attendancePercentage, attendancePercentage) ||
                other.attendancePercentage == attendancePercentage) &&
            (identical(other.trainingRating, trainingRating) ||
                other.trainingRating == trainingRating) &&
            (identical(other.improvementRate, improvementRate) ||
                other.improvementRate == improvementRate) &&
            (identical(other.consistencyScore, consistencyScore) ||
                other.consistencyScore == consistencyScore) &&
            (identical(other.potentialRating, potentialRating) ||
                other.potentialRating == potentialRating));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matchesPlayed,
      matchesStarted,
      minutesPlayed,
      goals,
      assists,
      yellowCards,
      redCards,
      trainingsAttended,
      totalTrainings,
      attendancePercentage,
      trainingRating,
      improvementRate,
      consistencyScore,
      potentialRating);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      __$$PerformanceMetricsImplCopyWithImpl<_$PerformanceMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceMetricsImplToJson(
      this,
    );
  }
}

abstract class _PerformanceMetrics implements PerformanceMetrics {
  const factory _PerformanceMetrics(
      {final int matchesPlayed,
      final int matchesStarted,
      final int minutesPlayed,
      final int goals,
      final int assists,
      final int yellowCards,
      final int redCards,
      final int trainingsAttended,
      final int totalTrainings,
      final double attendancePercentage,
      final double trainingRating,
      final double improvementRate,
      final double consistencyScore,
      final double potentialRating}) = _$PerformanceMetricsImpl;

  factory _PerformanceMetrics.fromJson(Map<String, dynamic> json) =
      _$PerformanceMetricsImpl.fromJson;

  @override // Match Statistics
  int get matchesPlayed;
  @override
  int get matchesStarted;
  @override
  int get minutesPlayed;
  @override
  int get goals;
  @override
  int get assists;
  @override
  int get yellowCards;
  @override
  int get redCards;
  @override // Training Statistics
  int get trainingsAttended;
  @override
  int get totalTrainings;
  @override
  double get attendancePercentage;
  @override
  double get trainingRating;
  @override // Development Metrics
  double get improvementRate;
  @override
  double get consistencyScore;
  @override
  double get potentialRating;
  @override
  @JsonKey(ignore: true)
  _$$PerformanceMetricsImplCopyWith<_$PerformanceMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DevelopmentGoal _$DevelopmentGoalFromJson(Map<String, dynamic> json) {
  return _DevelopmentGoal.fromJson(json);
}

/// @nodoc
mixin _$DevelopmentGoal {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  GoalCategory get category => throw _privateConstructorUsedError;
  GoalPriority get priority => throw _privateConstructorUsedError;
  DateTime get targetDate => throw _privateConstructorUsedError;
  double get targetValue => throw _privateConstructorUsedError; // Status
  GoalStatus get status => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError; // Progress
  double get currentValue => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError; // Tracking
  List<GoalMilestone> get milestones => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DevelopmentGoalCopyWith<DevelopmentGoal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DevelopmentGoalCopyWith<$Res> {
  factory $DevelopmentGoalCopyWith(
          DevelopmentGoal value, $Res Function(DevelopmentGoal) then) =
      _$DevelopmentGoalCopyWithImpl<$Res, DevelopmentGoal>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      GoalCategory category,
      GoalPriority priority,
      DateTime targetDate,
      double targetValue,
      GoalStatus status,
      DateTime createdAt,
      double currentValue,
      String? unit,
      List<GoalMilestone> milestones,
      DateTime? completedAt,
      String? createdBy});
}

/// @nodoc
class _$DevelopmentGoalCopyWithImpl<$Res, $Val extends DevelopmentGoal>
    implements $DevelopmentGoalCopyWith<$Res> {
  _$DevelopmentGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? priority = null,
    Object? targetDate = null,
    Object? targetValue = null,
    Object? status = null,
    Object? createdAt = null,
    Object? currentValue = null,
    Object? unit = freezed,
    Object? milestones = null,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GoalCategory,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as GoalPriority,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GoalStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentValue: null == currentValue
          ? _value.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<GoalMilestone>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DevelopmentGoalImplCopyWith<$Res>
    implements $DevelopmentGoalCopyWith<$Res> {
  factory _$$DevelopmentGoalImplCopyWith(_$DevelopmentGoalImpl value,
          $Res Function(_$DevelopmentGoalImpl) then) =
      __$$DevelopmentGoalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      GoalCategory category,
      GoalPriority priority,
      DateTime targetDate,
      double targetValue,
      GoalStatus status,
      DateTime createdAt,
      double currentValue,
      String? unit,
      List<GoalMilestone> milestones,
      DateTime? completedAt,
      String? createdBy});
}

/// @nodoc
class __$$DevelopmentGoalImplCopyWithImpl<$Res>
    extends _$DevelopmentGoalCopyWithImpl<$Res, _$DevelopmentGoalImpl>
    implements _$$DevelopmentGoalImplCopyWith<$Res> {
  __$$DevelopmentGoalImplCopyWithImpl(
      _$DevelopmentGoalImpl _value, $Res Function(_$DevelopmentGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? priority = null,
    Object? targetDate = null,
    Object? targetValue = null,
    Object? status = null,
    Object? createdAt = null,
    Object? currentValue = null,
    Object? unit = freezed,
    Object? milestones = null,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$DevelopmentGoalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as GoalCategory,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as GoalPriority,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GoalStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentValue: null == currentValue
          ? _value.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as double,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<GoalMilestone>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DevelopmentGoalImpl implements _DevelopmentGoal {
  const _$DevelopmentGoalImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.priority,
      required this.targetDate,
      required this.targetValue,
      required this.status,
      required this.createdAt,
      this.currentValue = 0.0,
      this.unit,
      final List<GoalMilestone> milestones = const [],
      this.completedAt,
      this.createdBy})
      : _milestones = milestones;

  factory _$DevelopmentGoalImpl.fromJson(Map<String, dynamic> json) =>
      _$$DevelopmentGoalImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final GoalCategory category;
  @override
  final GoalPriority priority;
  @override
  final DateTime targetDate;
  @override
  final double targetValue;
// Status
  @override
  final GoalStatus status;
// Metadata
  @override
  final DateTime createdAt;
// Progress
  @override
  @JsonKey()
  final double currentValue;
  @override
  final String? unit;
// Tracking
  final List<GoalMilestone> _milestones;
// Tracking
  @override
  @JsonKey()
  List<GoalMilestone> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  @override
  final DateTime? completedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'DevelopmentGoal(id: $id, title: $title, description: $description, category: $category, priority: $priority, targetDate: $targetDate, targetValue: $targetValue, status: $status, createdAt: $createdAt, currentValue: $currentValue, unit: $unit, milestones: $milestones, completedAt: $completedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DevelopmentGoalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      category,
      priority,
      targetDate,
      targetValue,
      status,
      createdAt,
      currentValue,
      unit,
      const DeepCollectionEquality().hash(_milestones),
      completedAt,
      createdBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DevelopmentGoalImplCopyWith<_$DevelopmentGoalImpl> get copyWith =>
      __$$DevelopmentGoalImplCopyWithImpl<_$DevelopmentGoalImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DevelopmentGoalImplToJson(
      this,
    );
  }
}

abstract class _DevelopmentGoal implements DevelopmentGoal {
  const factory _DevelopmentGoal(
      {required final String id,
      required final String title,
      required final String description,
      required final GoalCategory category,
      required final GoalPriority priority,
      required final DateTime targetDate,
      required final double targetValue,
      required final GoalStatus status,
      required final DateTime createdAt,
      final double currentValue,
      final String? unit,
      final List<GoalMilestone> milestones,
      final DateTime? completedAt,
      final String? createdBy}) = _$DevelopmentGoalImpl;

  factory _DevelopmentGoal.fromJson(Map<String, dynamic> json) =
      _$DevelopmentGoalImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  GoalCategory get category;
  @override
  GoalPriority get priority;
  @override
  DateTime get targetDate;
  @override
  double get targetValue;
  @override // Status
  GoalStatus get status;
  @override // Metadata
  DateTime get createdAt;
  @override // Progress
  double get currentValue;
  @override
  String? get unit;
  @override // Tracking
  List<GoalMilestone> get milestones;
  @override
  DateTime? get completedAt;
  @override
  String? get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$DevelopmentGoalImplCopyWith<_$DevelopmentGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoalMilestone _$GoalMilestoneFromJson(Map<String, dynamic> json) {
  return _GoalMilestone.fromJson(json);
}

/// @nodoc
mixin _$GoalMilestone {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get targetDate => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoalMilestoneCopyWith<GoalMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalMilestoneCopyWith<$Res> {
  factory $GoalMilestoneCopyWith(
          GoalMilestone value, $Res Function(GoalMilestone) then) =
      _$GoalMilestoneCopyWithImpl<$Res, GoalMilestone>;
  @useResult
  $Res call(
      {String id,
      String description,
      DateTime targetDate,
      bool isCompleted,
      DateTime? completedAt,
      String? notes});
}

/// @nodoc
class _$GoalMilestoneCopyWithImpl<$Res, $Val extends GoalMilestone>
    implements $GoalMilestoneCopyWith<$Res> {
  _$GoalMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? targetDate = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalMilestoneImplCopyWith<$Res>
    implements $GoalMilestoneCopyWith<$Res> {
  factory _$$GoalMilestoneImplCopyWith(
          _$GoalMilestoneImpl value, $Res Function(_$GoalMilestoneImpl) then) =
      __$$GoalMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      DateTime targetDate,
      bool isCompleted,
      DateTime? completedAt,
      String? notes});
}

/// @nodoc
class __$$GoalMilestoneImplCopyWithImpl<$Res>
    extends _$GoalMilestoneCopyWithImpl<$Res, _$GoalMilestoneImpl>
    implements _$$GoalMilestoneImplCopyWith<$Res> {
  __$$GoalMilestoneImplCopyWithImpl(
      _$GoalMilestoneImpl _value, $Res Function(_$GoalMilestoneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? targetDate = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$GoalMilestoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      targetDate: null == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalMilestoneImpl implements _GoalMilestone {
  const _$GoalMilestoneImpl(
      {required this.id,
      required this.description,
      required this.targetDate,
      required this.isCompleted,
      this.completedAt,
      this.notes});

  factory _$GoalMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalMilestoneImplFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final DateTime targetDate;
  @override
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'GoalMilestone(id: $id, description: $description, targetDate: $targetDate, isCompleted: $isCompleted, completedAt: $completedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalMilestoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, description, targetDate,
      isCompleted, completedAt, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalMilestoneImplCopyWith<_$GoalMilestoneImpl> get copyWith =>
      __$$GoalMilestoneImplCopyWithImpl<_$GoalMilestoneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalMilestoneImplToJson(
      this,
    );
  }
}

abstract class _GoalMilestone implements GoalMilestone {
  const factory _GoalMilestone(
      {required final String id,
      required final String description,
      required final DateTime targetDate,
      required final bool isCompleted,
      final DateTime? completedAt,
      final String? notes}) = _$GoalMilestoneImpl;

  factory _GoalMilestone.fromJson(Map<String, dynamic> json) =
      _$GoalMilestoneImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  DateTime get targetDate;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$GoalMilestoneImplCopyWith<_$GoalMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgressAssessment _$ProgressAssessmentFromJson(Map<String, dynamic> json) {
  return _ProgressAssessment.fromJson(json);
}

/// @nodoc
mixin _$ProgressAssessment {
  String get id => throw _privateConstructorUsedError;
  DateTime get assessmentDate => throw _privateConstructorUsedError;
  String get assessorId => throw _privateConstructorUsedError;
  AssessmentType get type => throw _privateConstructorUsedError; // Scores
  Map<String, double> get scores =>
      throw _privateConstructorUsedError; // Feedback
  String? get strengths => throw _privateConstructorUsedError;
  String? get weaknesses => throw _privateConstructorUsedError;
  String? get recommendations => throw _privateConstructorUsedError;
  String? get generalNotes => throw _privateConstructorUsedError; // Next Steps
  List<String> get actionPoints => throw _privateConstructorUsedError;
  DateTime? get nextAssessmentDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProgressAssessmentCopyWith<ProgressAssessment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressAssessmentCopyWith<$Res> {
  factory $ProgressAssessmentCopyWith(
          ProgressAssessment value, $Res Function(ProgressAssessment) then) =
      _$ProgressAssessmentCopyWithImpl<$Res, ProgressAssessment>;
  @useResult
  $Res call(
      {String id,
      DateTime assessmentDate,
      String assessorId,
      AssessmentType type,
      Map<String, double> scores,
      String? strengths,
      String? weaknesses,
      String? recommendations,
      String? generalNotes,
      List<String> actionPoints,
      DateTime? nextAssessmentDate});
}

/// @nodoc
class _$ProgressAssessmentCopyWithImpl<$Res, $Val extends ProgressAssessment>
    implements $ProgressAssessmentCopyWith<$Res> {
  _$ProgressAssessmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentDate = null,
    Object? assessorId = null,
    Object? type = null,
    Object? scores = null,
    Object? strengths = freezed,
    Object? weaknesses = freezed,
    Object? recommendations = freezed,
    Object? generalNotes = freezed,
    Object? actionPoints = null,
    Object? nextAssessmentDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assessmentDate: null == assessmentDate
          ? _value.assessmentDate
          : assessmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assessorId: null == assessorId
          ? _value.assessorId
          : assessorId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssessmentType,
      scores: null == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      strengths: freezed == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as String?,
      weaknesses: freezed == weaknesses
          ? _value.weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as String?,
      generalNotes: freezed == generalNotes
          ? _value.generalNotes
          : generalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      actionPoints: null == actionPoints
          ? _value.actionPoints
          : actionPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nextAssessmentDate: freezed == nextAssessmentDate
          ? _value.nextAssessmentDate
          : nextAssessmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressAssessmentImplCopyWith<$Res>
    implements $ProgressAssessmentCopyWith<$Res> {
  factory _$$ProgressAssessmentImplCopyWith(_$ProgressAssessmentImpl value,
          $Res Function(_$ProgressAssessmentImpl) then) =
      __$$ProgressAssessmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime assessmentDate,
      String assessorId,
      AssessmentType type,
      Map<String, double> scores,
      String? strengths,
      String? weaknesses,
      String? recommendations,
      String? generalNotes,
      List<String> actionPoints,
      DateTime? nextAssessmentDate});
}

/// @nodoc
class __$$ProgressAssessmentImplCopyWithImpl<$Res>
    extends _$ProgressAssessmentCopyWithImpl<$Res, _$ProgressAssessmentImpl>
    implements _$$ProgressAssessmentImplCopyWith<$Res> {
  __$$ProgressAssessmentImplCopyWithImpl(_$ProgressAssessmentImpl _value,
      $Res Function(_$ProgressAssessmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentDate = null,
    Object? assessorId = null,
    Object? type = null,
    Object? scores = null,
    Object? strengths = freezed,
    Object? weaknesses = freezed,
    Object? recommendations = freezed,
    Object? generalNotes = freezed,
    Object? actionPoints = null,
    Object? nextAssessmentDate = freezed,
  }) {
    return _then(_$ProgressAssessmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assessmentDate: null == assessmentDate
          ? _value.assessmentDate
          : assessmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      assessorId: null == assessorId
          ? _value.assessorId
          : assessorId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssessmentType,
      scores: null == scores
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      strengths: freezed == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as String?,
      weaknesses: freezed == weaknesses
          ? _value.weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as String?,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as String?,
      generalNotes: freezed == generalNotes
          ? _value.generalNotes
          : generalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      actionPoints: null == actionPoints
          ? _value._actionPoints
          : actionPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nextAssessmentDate: freezed == nextAssessmentDate
          ? _value.nextAssessmentDate
          : nextAssessmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressAssessmentImpl implements _ProgressAssessment {
  const _$ProgressAssessmentImpl(
      {required this.id,
      required this.assessmentDate,
      required this.assessorId,
      required this.type,
      required final Map<String, double> scores,
      this.strengths,
      this.weaknesses,
      this.recommendations,
      this.generalNotes,
      final List<String> actionPoints = const [],
      this.nextAssessmentDate})
      : _scores = scores,
        _actionPoints = actionPoints;

  factory _$ProgressAssessmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressAssessmentImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime assessmentDate;
  @override
  final String assessorId;
  @override
  final AssessmentType type;
// Scores
  final Map<String, double> _scores;
// Scores
  @override
  Map<String, double> get scores {
    if (_scores is EqualUnmodifiableMapView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_scores);
  }

// Feedback
  @override
  final String? strengths;
  @override
  final String? weaknesses;
  @override
  final String? recommendations;
  @override
  final String? generalNotes;
// Next Steps
  final List<String> _actionPoints;
// Next Steps
  @override
  @JsonKey()
  List<String> get actionPoints {
    if (_actionPoints is EqualUnmodifiableListView) return _actionPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionPoints);
  }

  @override
  final DateTime? nextAssessmentDate;

  @override
  String toString() {
    return 'ProgressAssessment(id: $id, assessmentDate: $assessmentDate, assessorId: $assessorId, type: $type, scores: $scores, strengths: $strengths, weaknesses: $weaknesses, recommendations: $recommendations, generalNotes: $generalNotes, actionPoints: $actionPoints, nextAssessmentDate: $nextAssessmentDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressAssessmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assessmentDate, assessmentDate) ||
                other.assessmentDate == assessmentDate) &&
            (identical(other.assessorId, assessorId) ||
                other.assessorId == assessorId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            (identical(other.strengths, strengths) ||
                other.strengths == strengths) &&
            (identical(other.weaknesses, weaknesses) ||
                other.weaknesses == weaknesses) &&
            (identical(other.recommendations, recommendations) ||
                other.recommendations == recommendations) &&
            (identical(other.generalNotes, generalNotes) ||
                other.generalNotes == generalNotes) &&
            const DeepCollectionEquality()
                .equals(other._actionPoints, _actionPoints) &&
            (identical(other.nextAssessmentDate, nextAssessmentDate) ||
                other.nextAssessmentDate == nextAssessmentDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      assessmentDate,
      assessorId,
      type,
      const DeepCollectionEquality().hash(_scores),
      strengths,
      weaknesses,
      recommendations,
      generalNotes,
      const DeepCollectionEquality().hash(_actionPoints),
      nextAssessmentDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressAssessmentImplCopyWith<_$ProgressAssessmentImpl> get copyWith =>
      __$$ProgressAssessmentImplCopyWithImpl<_$ProgressAssessmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressAssessmentImplToJson(
      this,
    );
  }
}

abstract class _ProgressAssessment implements ProgressAssessment {
  const factory _ProgressAssessment(
      {required final String id,
      required final DateTime assessmentDate,
      required final String assessorId,
      required final AssessmentType type,
      required final Map<String, double> scores,
      final String? strengths,
      final String? weaknesses,
      final String? recommendations,
      final String? generalNotes,
      final List<String> actionPoints,
      final DateTime? nextAssessmentDate}) = _$ProgressAssessmentImpl;

  factory _ProgressAssessment.fromJson(Map<String, dynamic> json) =
      _$ProgressAssessmentImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get assessmentDate;
  @override
  String get assessorId;
  @override
  AssessmentType get type;
  @override // Scores
  Map<String, double> get scores;
  @override // Feedback
  String? get strengths;
  @override
  String? get weaknesses;
  @override
  String? get recommendations;
  @override
  String? get generalNotes;
  @override // Next Steps
  List<String> get actionPoints;
  @override
  DateTime? get nextAssessmentDate;
  @override
  @JsonKey(ignore: true)
  _$$ProgressAssessmentImplCopyWith<_$ProgressAssessmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OverallRating _$OverallRatingFromJson(Map<String, dynamic> json) {
  return _OverallRating.fromJson(json);
}

/// @nodoc
mixin _$OverallRating {
  double get current => throw _privateConstructorUsedError;
  double get potential => throw _privateConstructorUsedError;
  double get technical => throw _privateConstructorUsedError;
  double get physical => throw _privateConstructorUsedError;
  double get tactical => throw _privateConstructorUsedError;
  double get mental => throw _privateConstructorUsedError; // Trend
  double get improvement => throw _privateConstructorUsedError;
  double get consistency => throw _privateConstructorUsedError; // Comparison
  double get peerComparison => throw _privateConstructorUsedError;
  double get ageGroupComparison => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OverallRatingCopyWith<OverallRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverallRatingCopyWith<$Res> {
  factory $OverallRatingCopyWith(
          OverallRating value, $Res Function(OverallRating) then) =
      _$OverallRatingCopyWithImpl<$Res, OverallRating>;
  @useResult
  $Res call(
      {double current,
      double potential,
      double technical,
      double physical,
      double tactical,
      double mental,
      double improvement,
      double consistency,
      double peerComparison,
      double ageGroupComparison});
}

/// @nodoc
class _$OverallRatingCopyWithImpl<$Res, $Val extends OverallRating>
    implements $OverallRatingCopyWith<$Res> {
  _$OverallRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? potential = null,
    Object? technical = null,
    Object? physical = null,
    Object? tactical = null,
    Object? mental = null,
    Object? improvement = null,
    Object? consistency = null,
    Object? peerComparison = null,
    Object? ageGroupComparison = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      potential: null == potential
          ? _value.potential
          : potential // ignore: cast_nullable_to_non_nullable
              as double,
      technical: null == technical
          ? _value.technical
          : technical // ignore: cast_nullable_to_non_nullable
              as double,
      physical: null == physical
          ? _value.physical
          : physical // ignore: cast_nullable_to_non_nullable
              as double,
      tactical: null == tactical
          ? _value.tactical
          : tactical // ignore: cast_nullable_to_non_nullable
              as double,
      mental: null == mental
          ? _value.mental
          : mental // ignore: cast_nullable_to_non_nullable
              as double,
      improvement: null == improvement
          ? _value.improvement
          : improvement // ignore: cast_nullable_to_non_nullable
              as double,
      consistency: null == consistency
          ? _value.consistency
          : consistency // ignore: cast_nullable_to_non_nullable
              as double,
      peerComparison: null == peerComparison
          ? _value.peerComparison
          : peerComparison // ignore: cast_nullable_to_non_nullable
              as double,
      ageGroupComparison: null == ageGroupComparison
          ? _value.ageGroupComparison
          : ageGroupComparison // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverallRatingImplCopyWith<$Res>
    implements $OverallRatingCopyWith<$Res> {
  factory _$$OverallRatingImplCopyWith(
          _$OverallRatingImpl value, $Res Function(_$OverallRatingImpl) then) =
      __$$OverallRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double current,
      double potential,
      double technical,
      double physical,
      double tactical,
      double mental,
      double improvement,
      double consistency,
      double peerComparison,
      double ageGroupComparison});
}

/// @nodoc
class __$$OverallRatingImplCopyWithImpl<$Res>
    extends _$OverallRatingCopyWithImpl<$Res, _$OverallRatingImpl>
    implements _$$OverallRatingImplCopyWith<$Res> {
  __$$OverallRatingImplCopyWithImpl(
      _$OverallRatingImpl _value, $Res Function(_$OverallRatingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? potential = null,
    Object? technical = null,
    Object? physical = null,
    Object? tactical = null,
    Object? mental = null,
    Object? improvement = null,
    Object? consistency = null,
    Object? peerComparison = null,
    Object? ageGroupComparison = null,
  }) {
    return _then(_$OverallRatingImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      potential: null == potential
          ? _value.potential
          : potential // ignore: cast_nullable_to_non_nullable
              as double,
      technical: null == technical
          ? _value.technical
          : technical // ignore: cast_nullable_to_non_nullable
              as double,
      physical: null == physical
          ? _value.physical
          : physical // ignore: cast_nullable_to_non_nullable
              as double,
      tactical: null == tactical
          ? _value.tactical
          : tactical // ignore: cast_nullable_to_non_nullable
              as double,
      mental: null == mental
          ? _value.mental
          : mental // ignore: cast_nullable_to_non_nullable
              as double,
      improvement: null == improvement
          ? _value.improvement
          : improvement // ignore: cast_nullable_to_non_nullable
              as double,
      consistency: null == consistency
          ? _value.consistency
          : consistency // ignore: cast_nullable_to_non_nullable
              as double,
      peerComparison: null == peerComparison
          ? _value.peerComparison
          : peerComparison // ignore: cast_nullable_to_non_nullable
              as double,
      ageGroupComparison: null == ageGroupComparison
          ? _value.ageGroupComparison
          : ageGroupComparison // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OverallRatingImpl implements _OverallRating {
  const _$OverallRatingImpl(
      {this.current = 5.0,
      this.potential = 5.0,
      this.technical = 5.0,
      this.physical = 5.0,
      this.tactical = 5.0,
      this.mental = 5.0,
      this.improvement = 0.0,
      this.consistency = 0.0,
      this.peerComparison = 5.0,
      this.ageGroupComparison = 5.0});

  factory _$OverallRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverallRatingImplFromJson(json);

  @override
  @JsonKey()
  final double current;
  @override
  @JsonKey()
  final double potential;
  @override
  @JsonKey()
  final double technical;
  @override
  @JsonKey()
  final double physical;
  @override
  @JsonKey()
  final double tactical;
  @override
  @JsonKey()
  final double mental;
// Trend
  @override
  @JsonKey()
  final double improvement;
  @override
  @JsonKey()
  final double consistency;
// Comparison
  @override
  @JsonKey()
  final double peerComparison;
  @override
  @JsonKey()
  final double ageGroupComparison;

  @override
  String toString() {
    return 'OverallRating(current: $current, potential: $potential, technical: $technical, physical: $physical, tactical: $tactical, mental: $mental, improvement: $improvement, consistency: $consistency, peerComparison: $peerComparison, ageGroupComparison: $ageGroupComparison)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverallRatingImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.potential, potential) ||
                other.potential == potential) &&
            (identical(other.technical, technical) ||
                other.technical == technical) &&
            (identical(other.physical, physical) ||
                other.physical == physical) &&
            (identical(other.tactical, tactical) ||
                other.tactical == tactical) &&
            (identical(other.mental, mental) || other.mental == mental) &&
            (identical(other.improvement, improvement) ||
                other.improvement == improvement) &&
            (identical(other.consistency, consistency) ||
                other.consistency == consistency) &&
            (identical(other.peerComparison, peerComparison) ||
                other.peerComparison == peerComparison) &&
            (identical(other.ageGroupComparison, ageGroupComparison) ||
                other.ageGroupComparison == ageGroupComparison));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      current,
      potential,
      technical,
      physical,
      tactical,
      mental,
      improvement,
      consistency,
      peerComparison,
      ageGroupComparison);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OverallRatingImplCopyWith<_$OverallRatingImpl> get copyWith =>
      __$$OverallRatingImplCopyWithImpl<_$OverallRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverallRatingImplToJson(
      this,
    );
  }
}

abstract class _OverallRating implements OverallRating {
  const factory _OverallRating(
      {final double current,
      final double potential,
      final double technical,
      final double physical,
      final double tactical,
      final double mental,
      final double improvement,
      final double consistency,
      final double peerComparison,
      final double ageGroupComparison}) = _$OverallRatingImpl;

  factory _OverallRating.fromJson(Map<String, dynamic> json) =
      _$OverallRatingImpl.fromJson;

  @override
  double get current;
  @override
  double get potential;
  @override
  double get technical;
  @override
  double get physical;
  @override
  double get tactical;
  @override
  double get mental;
  @override // Trend
  double get improvement;
  @override
  double get consistency;
  @override // Comparison
  double get peerComparison;
  @override
  double get ageGroupComparison;
  @override
  @JsonKey(ignore: true)
  _$$OverallRatingImplCopyWith<_$OverallRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
