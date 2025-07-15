// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_performance_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerPerformanceData _$PlayerPerformanceDataFromJson(
    Map<String, dynamic> json) {
  return _PlayerPerformanceData.fromJson(json);
}

/// @nodoc
mixin _$PlayerPerformanceData {
  String get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  PerformanceType get type => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // training, match, test
// Physical Performance Metrics
  PhysicalMetrics? get physicalMetrics =>
      throw _privateConstructorUsedError; // Technical Performance Metrics
  TechnicalMetrics? get technicalMetrics =>
      throw _privateConstructorUsedError; // Tactical Performance Metrics
  TacticalMetrics? get tacticalMetrics =>
      throw _privateConstructorUsedError; // Mental/Psychological Metrics
  MentalMetrics? get mentalMetrics =>
      throw _privateConstructorUsedError; // Match Specific Metrics
  MatchMetrics? get matchMetrics =>
      throw _privateConstructorUsedError; // Training Load & Recovery
  TrainingLoadMetrics? get trainingLoad =>
      throw _privateConstructorUsedError; // Wellness & Health
  WellnessMetrics? get wellness =>
      throw _privateConstructorUsedError; // Coach Evaluation
  CoachEvaluation? get coachEvaluation =>
      throw _privateConstructorUsedError; // AI-Generated Insights
  List<PerformanceInsight>? get insights => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerPerformanceDataCopyWith<PlayerPerformanceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerPerformanceDataCopyWith<$Res> {
  factory $PlayerPerformanceDataCopyWith(PlayerPerformanceData value,
          $Res Function(PlayerPerformanceData) then) =
      _$PlayerPerformanceDataCopyWithImpl<$Res, PlayerPerformanceData>;
  @useResult
  $Res call(
      {String id,
      String playerId,
      DateTime date,
      PerformanceType type,
      DateTime createdAt,
      PhysicalMetrics? physicalMetrics,
      TechnicalMetrics? technicalMetrics,
      TacticalMetrics? tacticalMetrics,
      MentalMetrics? mentalMetrics,
      MatchMetrics? matchMetrics,
      TrainingLoadMetrics? trainingLoad,
      WellnessMetrics? wellness,
      CoachEvaluation? coachEvaluation,
      List<PerformanceInsight>? insights,
      DateTime? updatedAt,
      String? notes});

  $PhysicalMetricsCopyWith<$Res>? get physicalMetrics;
  $TechnicalMetricsCopyWith<$Res>? get technicalMetrics;
  $TacticalMetricsCopyWith<$Res>? get tacticalMetrics;
  $MentalMetricsCopyWith<$Res>? get mentalMetrics;
  $MatchMetricsCopyWith<$Res>? get matchMetrics;
  $TrainingLoadMetricsCopyWith<$Res>? get trainingLoad;
  $WellnessMetricsCopyWith<$Res>? get wellness;
  $CoachEvaluationCopyWith<$Res>? get coachEvaluation;
}

/// @nodoc
class _$PlayerPerformanceDataCopyWithImpl<$Res,
        $Val extends PlayerPerformanceData>
    implements $PlayerPerformanceDataCopyWith<$Res> {
  _$PlayerPerformanceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? date = null,
    Object? type = null,
    Object? createdAt = null,
    Object? physicalMetrics = freezed,
    Object? technicalMetrics = freezed,
    Object? tacticalMetrics = freezed,
    Object? mentalMetrics = freezed,
    Object? matchMetrics = freezed,
    Object? trainingLoad = freezed,
    Object? wellness = freezed,
    Object? coachEvaluation = freezed,
    Object? insights = freezed,
    Object? updatedAt = freezed,
    Object? notes = freezed,
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
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PerformanceType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      physicalMetrics: freezed == physicalMetrics
          ? _value.physicalMetrics
          : physicalMetrics // ignore: cast_nullable_to_non_nullable
              as PhysicalMetrics?,
      technicalMetrics: freezed == technicalMetrics
          ? _value.technicalMetrics
          : technicalMetrics // ignore: cast_nullable_to_non_nullable
              as TechnicalMetrics?,
      tacticalMetrics: freezed == tacticalMetrics
          ? _value.tacticalMetrics
          : tacticalMetrics // ignore: cast_nullable_to_non_nullable
              as TacticalMetrics?,
      mentalMetrics: freezed == mentalMetrics
          ? _value.mentalMetrics
          : mentalMetrics // ignore: cast_nullable_to_non_nullable
              as MentalMetrics?,
      matchMetrics: freezed == matchMetrics
          ? _value.matchMetrics
          : matchMetrics // ignore: cast_nullable_to_non_nullable
              as MatchMetrics?,
      trainingLoad: freezed == trainingLoad
          ? _value.trainingLoad
          : trainingLoad // ignore: cast_nullable_to_non_nullable
              as TrainingLoadMetrics?,
      wellness: freezed == wellness
          ? _value.wellness
          : wellness // ignore: cast_nullable_to_non_nullable
              as WellnessMetrics?,
      coachEvaluation: freezed == coachEvaluation
          ? _value.coachEvaluation
          : coachEvaluation // ignore: cast_nullable_to_non_nullable
              as CoachEvaluation?,
      insights: freezed == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<PerformanceInsight>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PhysicalMetricsCopyWith<$Res>? get physicalMetrics {
    if (_value.physicalMetrics == null) {
      return null;
    }

    return $PhysicalMetricsCopyWith<$Res>(_value.physicalMetrics!, (value) {
      return _then(_value.copyWith(physicalMetrics: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TechnicalMetricsCopyWith<$Res>? get technicalMetrics {
    if (_value.technicalMetrics == null) {
      return null;
    }

    return $TechnicalMetricsCopyWith<$Res>(_value.technicalMetrics!, (value) {
      return _then(_value.copyWith(technicalMetrics: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TacticalMetricsCopyWith<$Res>? get tacticalMetrics {
    if (_value.tacticalMetrics == null) {
      return null;
    }

    return $TacticalMetricsCopyWith<$Res>(_value.tacticalMetrics!, (value) {
      return _then(_value.copyWith(tacticalMetrics: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MentalMetricsCopyWith<$Res>? get mentalMetrics {
    if (_value.mentalMetrics == null) {
      return null;
    }

    return $MentalMetricsCopyWith<$Res>(_value.mentalMetrics!, (value) {
      return _then(_value.copyWith(mentalMetrics: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MatchMetricsCopyWith<$Res>? get matchMetrics {
    if (_value.matchMetrics == null) {
      return null;
    }

    return $MatchMetricsCopyWith<$Res>(_value.matchMetrics!, (value) {
      return _then(_value.copyWith(matchMetrics: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TrainingLoadMetricsCopyWith<$Res>? get trainingLoad {
    if (_value.trainingLoad == null) {
      return null;
    }

    return $TrainingLoadMetricsCopyWith<$Res>(_value.trainingLoad!, (value) {
      return _then(_value.copyWith(trainingLoad: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WellnessMetricsCopyWith<$Res>? get wellness {
    if (_value.wellness == null) {
      return null;
    }

    return $WellnessMetricsCopyWith<$Res>(_value.wellness!, (value) {
      return _then(_value.copyWith(wellness: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CoachEvaluationCopyWith<$Res>? get coachEvaluation {
    if (_value.coachEvaluation == null) {
      return null;
    }

    return $CoachEvaluationCopyWith<$Res>(_value.coachEvaluation!, (value) {
      return _then(_value.copyWith(coachEvaluation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerPerformanceDataImplCopyWith<$Res>
    implements $PlayerPerformanceDataCopyWith<$Res> {
  factory _$$PlayerPerformanceDataImplCopyWith(
          _$PlayerPerformanceDataImpl value,
          $Res Function(_$PlayerPerformanceDataImpl) then) =
      __$$PlayerPerformanceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String playerId,
      DateTime date,
      PerformanceType type,
      DateTime createdAt,
      PhysicalMetrics? physicalMetrics,
      TechnicalMetrics? technicalMetrics,
      TacticalMetrics? tacticalMetrics,
      MentalMetrics? mentalMetrics,
      MatchMetrics? matchMetrics,
      TrainingLoadMetrics? trainingLoad,
      WellnessMetrics? wellness,
      CoachEvaluation? coachEvaluation,
      List<PerformanceInsight>? insights,
      DateTime? updatedAt,
      String? notes});

  @override
  $PhysicalMetricsCopyWith<$Res>? get physicalMetrics;
  @override
  $TechnicalMetricsCopyWith<$Res>? get technicalMetrics;
  @override
  $TacticalMetricsCopyWith<$Res>? get tacticalMetrics;
  @override
  $MentalMetricsCopyWith<$Res>? get mentalMetrics;
  @override
  $MatchMetricsCopyWith<$Res>? get matchMetrics;
  @override
  $TrainingLoadMetricsCopyWith<$Res>? get trainingLoad;
  @override
  $WellnessMetricsCopyWith<$Res>? get wellness;
  @override
  $CoachEvaluationCopyWith<$Res>? get coachEvaluation;
}

/// @nodoc
class __$$PlayerPerformanceDataImplCopyWithImpl<$Res>
    extends _$PlayerPerformanceDataCopyWithImpl<$Res,
        _$PlayerPerformanceDataImpl>
    implements _$$PlayerPerformanceDataImplCopyWith<$Res> {
  __$$PlayerPerformanceDataImplCopyWithImpl(_$PlayerPerformanceDataImpl _value,
      $Res Function(_$PlayerPerformanceDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? date = null,
    Object? type = null,
    Object? createdAt = null,
    Object? physicalMetrics = freezed,
    Object? technicalMetrics = freezed,
    Object? tacticalMetrics = freezed,
    Object? mentalMetrics = freezed,
    Object? matchMetrics = freezed,
    Object? trainingLoad = freezed,
    Object? wellness = freezed,
    Object? coachEvaluation = freezed,
    Object? insights = freezed,
    Object? updatedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$PlayerPerformanceDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PerformanceType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      physicalMetrics: freezed == physicalMetrics
          ? _value.physicalMetrics
          : physicalMetrics // ignore: cast_nullable_to_non_nullable
              as PhysicalMetrics?,
      technicalMetrics: freezed == technicalMetrics
          ? _value.technicalMetrics
          : technicalMetrics // ignore: cast_nullable_to_non_nullable
              as TechnicalMetrics?,
      tacticalMetrics: freezed == tacticalMetrics
          ? _value.tacticalMetrics
          : tacticalMetrics // ignore: cast_nullable_to_non_nullable
              as TacticalMetrics?,
      mentalMetrics: freezed == mentalMetrics
          ? _value.mentalMetrics
          : mentalMetrics // ignore: cast_nullable_to_non_nullable
              as MentalMetrics?,
      matchMetrics: freezed == matchMetrics
          ? _value.matchMetrics
          : matchMetrics // ignore: cast_nullable_to_non_nullable
              as MatchMetrics?,
      trainingLoad: freezed == trainingLoad
          ? _value.trainingLoad
          : trainingLoad // ignore: cast_nullable_to_non_nullable
              as TrainingLoadMetrics?,
      wellness: freezed == wellness
          ? _value.wellness
          : wellness // ignore: cast_nullable_to_non_nullable
              as WellnessMetrics?,
      coachEvaluation: freezed == coachEvaluation
          ? _value.coachEvaluation
          : coachEvaluation // ignore: cast_nullable_to_non_nullable
              as CoachEvaluation?,
      insights: freezed == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<PerformanceInsight>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
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
class _$PlayerPerformanceDataImpl implements _PlayerPerformanceData {
  const _$PlayerPerformanceDataImpl(
      {required this.id,
      required this.playerId,
      required this.date,
      required this.type,
      required this.createdAt,
      this.physicalMetrics,
      this.technicalMetrics,
      this.tacticalMetrics,
      this.mentalMetrics,
      this.matchMetrics,
      this.trainingLoad,
      this.wellness,
      this.coachEvaluation,
      final List<PerformanceInsight>? insights,
      this.updatedAt,
      this.notes})
      : _insights = insights;

  factory _$PlayerPerformanceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerPerformanceDataImplFromJson(json);

  @override
  final String id;
  @override
  final String playerId;
  @override
  final DateTime date;
  @override
  final PerformanceType type;
// Metadata
  @override
  final DateTime createdAt;
// training, match, test
// Physical Performance Metrics
  @override
  final PhysicalMetrics? physicalMetrics;
// Technical Performance Metrics
  @override
  final TechnicalMetrics? technicalMetrics;
// Tactical Performance Metrics
  @override
  final TacticalMetrics? tacticalMetrics;
// Mental/Psychological Metrics
  @override
  final MentalMetrics? mentalMetrics;
// Match Specific Metrics
  @override
  final MatchMetrics? matchMetrics;
// Training Load & Recovery
  @override
  final TrainingLoadMetrics? trainingLoad;
// Wellness & Health
  @override
  final WellnessMetrics? wellness;
// Coach Evaluation
  @override
  final CoachEvaluation? coachEvaluation;
// AI-Generated Insights
  final List<PerformanceInsight>? _insights;
// AI-Generated Insights
  @override
  List<PerformanceInsight>? get insights {
    final value = _insights;
    if (value == null) return null;
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? updatedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'PlayerPerformanceData(id: $id, playerId: $playerId, date: $date, type: $type, createdAt: $createdAt, physicalMetrics: $physicalMetrics, technicalMetrics: $technicalMetrics, tacticalMetrics: $tacticalMetrics, mentalMetrics: $mentalMetrics, matchMetrics: $matchMetrics, trainingLoad: $trainingLoad, wellness: $wellness, coachEvaluation: $coachEvaluation, insights: $insights, updatedAt: $updatedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerPerformanceDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.physicalMetrics, physicalMetrics) ||
                other.physicalMetrics == physicalMetrics) &&
            (identical(other.technicalMetrics, technicalMetrics) ||
                other.technicalMetrics == technicalMetrics) &&
            (identical(other.tacticalMetrics, tacticalMetrics) ||
                other.tacticalMetrics == tacticalMetrics) &&
            (identical(other.mentalMetrics, mentalMetrics) ||
                other.mentalMetrics == mentalMetrics) &&
            (identical(other.matchMetrics, matchMetrics) ||
                other.matchMetrics == matchMetrics) &&
            (identical(other.trainingLoad, trainingLoad) ||
                other.trainingLoad == trainingLoad) &&
            (identical(other.wellness, wellness) ||
                other.wellness == wellness) &&
            (identical(other.coachEvaluation, coachEvaluation) ||
                other.coachEvaluation == coachEvaluation) &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      playerId,
      date,
      type,
      createdAt,
      physicalMetrics,
      technicalMetrics,
      tacticalMetrics,
      mentalMetrics,
      matchMetrics,
      trainingLoad,
      wellness,
      coachEvaluation,
      const DeepCollectionEquality().hash(_insights),
      updatedAt,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerPerformanceDataImplCopyWith<_$PlayerPerformanceDataImpl>
      get copyWith => __$$PlayerPerformanceDataImplCopyWithImpl<
          _$PlayerPerformanceDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerPerformanceDataImplToJson(
      this,
    );
  }
}

abstract class _PlayerPerformanceData implements PlayerPerformanceData {
  const factory _PlayerPerformanceData(
      {required final String id,
      required final String playerId,
      required final DateTime date,
      required final PerformanceType type,
      required final DateTime createdAt,
      final PhysicalMetrics? physicalMetrics,
      final TechnicalMetrics? technicalMetrics,
      final TacticalMetrics? tacticalMetrics,
      final MentalMetrics? mentalMetrics,
      final MatchMetrics? matchMetrics,
      final TrainingLoadMetrics? trainingLoad,
      final WellnessMetrics? wellness,
      final CoachEvaluation? coachEvaluation,
      final List<PerformanceInsight>? insights,
      final DateTime? updatedAt,
      final String? notes}) = _$PlayerPerformanceDataImpl;

  factory _PlayerPerformanceData.fromJson(Map<String, dynamic> json) =
      _$PlayerPerformanceDataImpl.fromJson;

  @override
  String get id;
  @override
  String get playerId;
  @override
  DateTime get date;
  @override
  PerformanceType get type;
  @override // Metadata
  DateTime get createdAt;
  @override // training, match, test
// Physical Performance Metrics
  PhysicalMetrics? get physicalMetrics;
  @override // Technical Performance Metrics
  TechnicalMetrics? get technicalMetrics;
  @override // Tactical Performance Metrics
  TacticalMetrics? get tacticalMetrics;
  @override // Mental/Psychological Metrics
  MentalMetrics? get mentalMetrics;
  @override // Match Specific Metrics
  MatchMetrics? get matchMetrics;
  @override // Training Load & Recovery
  TrainingLoadMetrics? get trainingLoad;
  @override // Wellness & Health
  WellnessMetrics? get wellness;
  @override // Coach Evaluation
  CoachEvaluation? get coachEvaluation;
  @override // AI-Generated Insights
  List<PerformanceInsight>? get insights;
  @override
  DateTime? get updatedAt;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$PlayerPerformanceDataImplCopyWith<_$PlayerPerformanceDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PhysicalMetrics _$PhysicalMetricsFromJson(Map<String, dynamic> json) {
  return _PhysicalMetrics.fromJson(json);
}

/// @nodoc
mixin _$PhysicalMetrics {
// Distance & Speed
  double? get totalDistance => throw _privateConstructorUsedError; // meters
  double? get highSpeedRunning =>
      throw _privateConstructorUsedError; // meters >19.8 km/h
  double? get sprints => throw _privateConstructorUsedError; // count >25.2 km/h
  double? get maxSpeed => throw _privateConstructorUsedError; // km/h
  double? get averageSpeed => throw _privateConstructorUsedError; // km/h
// Acceleration & Deceleration
  int? get accelerations => throw _privateConstructorUsedError; // count >3 m/s²
  int? get decelerations =>
      throw _privateConstructorUsedError; // count <-3 m/s²
// Heart Rate
  int? get maxHeartRate => throw _privateConstructorUsedError; // bpm
  int? get averageHeartRate => throw _privateConstructorUsedError; // bpm
  int? get timeInZone1 =>
      throw _privateConstructorUsedError; // seconds (50-60% max HR)
  int? get timeInZone2 =>
      throw _privateConstructorUsedError; // seconds (60-70% max HR)
  int? get timeInZone3 =>
      throw _privateConstructorUsedError; // seconds (70-80% max HR)
  int? get timeInZone4 =>
      throw _privateConstructorUsedError; // seconds (80-90% max HR)
  int? get timeInZone5 =>
      throw _privateConstructorUsedError; // seconds (90-100% max HR)
// Power & Explosiveness
  double? get jumpHeight => throw _privateConstructorUsedError; // cm
  double? get sprintTime10m => throw _privateConstructorUsedError; // seconds
  double? get sprintTime30m => throw _privateConstructorUsedError; // seconds
  double? get agility505 => throw _privateConstructorUsedError; // seconds
// Endurance
  double? get yoyoTestDistance => throw _privateConstructorUsedError; // meters
  double? get vo2Max => throw _privateConstructorUsedError; // ml/kg/min
// Recovery Metrics
  double? get hrvScore =>
      throw _privateConstructorUsedError; // Heart Rate Variability
  int? get restingHeartRate => throw _privateConstructorUsedError; // bpm
  double? get sleepQuality => throw _privateConstructorUsedError; // 0-10
  int? get sleepHours => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhysicalMetricsCopyWith<PhysicalMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhysicalMetricsCopyWith<$Res> {
  factory $PhysicalMetricsCopyWith(
          PhysicalMetrics value, $Res Function(PhysicalMetrics) then) =
      _$PhysicalMetricsCopyWithImpl<$Res, PhysicalMetrics>;
  @useResult
  $Res call(
      {double? totalDistance,
      double? highSpeedRunning,
      double? sprints,
      double? maxSpeed,
      double? averageSpeed,
      int? accelerations,
      int? decelerations,
      int? maxHeartRate,
      int? averageHeartRate,
      int? timeInZone1,
      int? timeInZone2,
      int? timeInZone3,
      int? timeInZone4,
      int? timeInZone5,
      double? jumpHeight,
      double? sprintTime10m,
      double? sprintTime30m,
      double? agility505,
      double? yoyoTestDistance,
      double? vo2Max,
      double? hrvScore,
      int? restingHeartRate,
      double? sleepQuality,
      int? sleepHours});
}

/// @nodoc
class _$PhysicalMetricsCopyWithImpl<$Res, $Val extends PhysicalMetrics>
    implements $PhysicalMetricsCopyWith<$Res> {
  _$PhysicalMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDistance = freezed,
    Object? highSpeedRunning = freezed,
    Object? sprints = freezed,
    Object? maxSpeed = freezed,
    Object? averageSpeed = freezed,
    Object? accelerations = freezed,
    Object? decelerations = freezed,
    Object? maxHeartRate = freezed,
    Object? averageHeartRate = freezed,
    Object? timeInZone1 = freezed,
    Object? timeInZone2 = freezed,
    Object? timeInZone3 = freezed,
    Object? timeInZone4 = freezed,
    Object? timeInZone5 = freezed,
    Object? jumpHeight = freezed,
    Object? sprintTime10m = freezed,
    Object? sprintTime30m = freezed,
    Object? agility505 = freezed,
    Object? yoyoTestDistance = freezed,
    Object? vo2Max = freezed,
    Object? hrvScore = freezed,
    Object? restingHeartRate = freezed,
    Object? sleepQuality = freezed,
    Object? sleepHours = freezed,
  }) {
    return _then(_value.copyWith(
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      highSpeedRunning: freezed == highSpeedRunning
          ? _value.highSpeedRunning
          : highSpeedRunning // ignore: cast_nullable_to_non_nullable
              as double?,
      sprints: freezed == sprints
          ? _value.sprints
          : sprints // ignore: cast_nullable_to_non_nullable
              as double?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSpeed: freezed == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      accelerations: freezed == accelerations
          ? _value.accelerations
          : accelerations // ignore: cast_nullable_to_non_nullable
              as int?,
      decelerations: freezed == decelerations
          ? _value.decelerations
          : decelerations // ignore: cast_nullable_to_non_nullable
              as int?,
      maxHeartRate: freezed == maxHeartRate
          ? _value.maxHeartRate
          : maxHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      averageHeartRate: freezed == averageHeartRate
          ? _value.averageHeartRate
          : averageHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone1: freezed == timeInZone1
          ? _value.timeInZone1
          : timeInZone1 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone2: freezed == timeInZone2
          ? _value.timeInZone2
          : timeInZone2 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone3: freezed == timeInZone3
          ? _value.timeInZone3
          : timeInZone3 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone4: freezed == timeInZone4
          ? _value.timeInZone4
          : timeInZone4 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone5: freezed == timeInZone5
          ? _value.timeInZone5
          : timeInZone5 // ignore: cast_nullable_to_non_nullable
              as int?,
      jumpHeight: freezed == jumpHeight
          ? _value.jumpHeight
          : jumpHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      sprintTime10m: freezed == sprintTime10m
          ? _value.sprintTime10m
          : sprintTime10m // ignore: cast_nullable_to_non_nullable
              as double?,
      sprintTime30m: freezed == sprintTime30m
          ? _value.sprintTime30m
          : sprintTime30m // ignore: cast_nullable_to_non_nullable
              as double?,
      agility505: freezed == agility505
          ? _value.agility505
          : agility505 // ignore: cast_nullable_to_non_nullable
              as double?,
      yoyoTestDistance: freezed == yoyoTestDistance
          ? _value.yoyoTestDistance
          : yoyoTestDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      vo2Max: freezed == vo2Max
          ? _value.vo2Max
          : vo2Max // ignore: cast_nullable_to_non_nullable
              as double?,
      hrvScore: freezed == hrvScore
          ? _value.hrvScore
          : hrvScore // ignore: cast_nullable_to_non_nullable
              as double?,
      restingHeartRate: freezed == restingHeartRate
          ? _value.restingHeartRate
          : restingHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      sleepHours: freezed == sleepHours
          ? _value.sleepHours
          : sleepHours // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhysicalMetricsImplCopyWith<$Res>
    implements $PhysicalMetricsCopyWith<$Res> {
  factory _$$PhysicalMetricsImplCopyWith(_$PhysicalMetricsImpl value,
          $Res Function(_$PhysicalMetricsImpl) then) =
      __$$PhysicalMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? totalDistance,
      double? highSpeedRunning,
      double? sprints,
      double? maxSpeed,
      double? averageSpeed,
      int? accelerations,
      int? decelerations,
      int? maxHeartRate,
      int? averageHeartRate,
      int? timeInZone1,
      int? timeInZone2,
      int? timeInZone3,
      int? timeInZone4,
      int? timeInZone5,
      double? jumpHeight,
      double? sprintTime10m,
      double? sprintTime30m,
      double? agility505,
      double? yoyoTestDistance,
      double? vo2Max,
      double? hrvScore,
      int? restingHeartRate,
      double? sleepQuality,
      int? sleepHours});
}

/// @nodoc
class __$$PhysicalMetricsImplCopyWithImpl<$Res>
    extends _$PhysicalMetricsCopyWithImpl<$Res, _$PhysicalMetricsImpl>
    implements _$$PhysicalMetricsImplCopyWith<$Res> {
  __$$PhysicalMetricsImplCopyWithImpl(
      _$PhysicalMetricsImpl _value, $Res Function(_$PhysicalMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDistance = freezed,
    Object? highSpeedRunning = freezed,
    Object? sprints = freezed,
    Object? maxSpeed = freezed,
    Object? averageSpeed = freezed,
    Object? accelerations = freezed,
    Object? decelerations = freezed,
    Object? maxHeartRate = freezed,
    Object? averageHeartRate = freezed,
    Object? timeInZone1 = freezed,
    Object? timeInZone2 = freezed,
    Object? timeInZone3 = freezed,
    Object? timeInZone4 = freezed,
    Object? timeInZone5 = freezed,
    Object? jumpHeight = freezed,
    Object? sprintTime10m = freezed,
    Object? sprintTime30m = freezed,
    Object? agility505 = freezed,
    Object? yoyoTestDistance = freezed,
    Object? vo2Max = freezed,
    Object? hrvScore = freezed,
    Object? restingHeartRate = freezed,
    Object? sleepQuality = freezed,
    Object? sleepHours = freezed,
  }) {
    return _then(_$PhysicalMetricsImpl(
      totalDistance: freezed == totalDistance
          ? _value.totalDistance
          : totalDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      highSpeedRunning: freezed == highSpeedRunning
          ? _value.highSpeedRunning
          : highSpeedRunning // ignore: cast_nullable_to_non_nullable
              as double?,
      sprints: freezed == sprints
          ? _value.sprints
          : sprints // ignore: cast_nullable_to_non_nullable
              as double?,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSpeed: freezed == averageSpeed
          ? _value.averageSpeed
          : averageSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      accelerations: freezed == accelerations
          ? _value.accelerations
          : accelerations // ignore: cast_nullable_to_non_nullable
              as int?,
      decelerations: freezed == decelerations
          ? _value.decelerations
          : decelerations // ignore: cast_nullable_to_non_nullable
              as int?,
      maxHeartRate: freezed == maxHeartRate
          ? _value.maxHeartRate
          : maxHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      averageHeartRate: freezed == averageHeartRate
          ? _value.averageHeartRate
          : averageHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone1: freezed == timeInZone1
          ? _value.timeInZone1
          : timeInZone1 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone2: freezed == timeInZone2
          ? _value.timeInZone2
          : timeInZone2 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone3: freezed == timeInZone3
          ? _value.timeInZone3
          : timeInZone3 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone4: freezed == timeInZone4
          ? _value.timeInZone4
          : timeInZone4 // ignore: cast_nullable_to_non_nullable
              as int?,
      timeInZone5: freezed == timeInZone5
          ? _value.timeInZone5
          : timeInZone5 // ignore: cast_nullable_to_non_nullable
              as int?,
      jumpHeight: freezed == jumpHeight
          ? _value.jumpHeight
          : jumpHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      sprintTime10m: freezed == sprintTime10m
          ? _value.sprintTime10m
          : sprintTime10m // ignore: cast_nullable_to_non_nullable
              as double?,
      sprintTime30m: freezed == sprintTime30m
          ? _value.sprintTime30m
          : sprintTime30m // ignore: cast_nullable_to_non_nullable
              as double?,
      agility505: freezed == agility505
          ? _value.agility505
          : agility505 // ignore: cast_nullable_to_non_nullable
              as double?,
      yoyoTestDistance: freezed == yoyoTestDistance
          ? _value.yoyoTestDistance
          : yoyoTestDistance // ignore: cast_nullable_to_non_nullable
              as double?,
      vo2Max: freezed == vo2Max
          ? _value.vo2Max
          : vo2Max // ignore: cast_nullable_to_non_nullable
              as double?,
      hrvScore: freezed == hrvScore
          ? _value.hrvScore
          : hrvScore // ignore: cast_nullable_to_non_nullable
              as double?,
      restingHeartRate: freezed == restingHeartRate
          ? _value.restingHeartRate
          : restingHeartRate // ignore: cast_nullable_to_non_nullable
              as int?,
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      sleepHours: freezed == sleepHours
          ? _value.sleepHours
          : sleepHours // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhysicalMetricsImpl implements _PhysicalMetrics {
  const _$PhysicalMetricsImpl(
      {this.totalDistance,
      this.highSpeedRunning,
      this.sprints,
      this.maxSpeed,
      this.averageSpeed,
      this.accelerations,
      this.decelerations,
      this.maxHeartRate,
      this.averageHeartRate,
      this.timeInZone1,
      this.timeInZone2,
      this.timeInZone3,
      this.timeInZone4,
      this.timeInZone5,
      this.jumpHeight,
      this.sprintTime10m,
      this.sprintTime30m,
      this.agility505,
      this.yoyoTestDistance,
      this.vo2Max,
      this.hrvScore,
      this.restingHeartRate,
      this.sleepQuality,
      this.sleepHours});

  factory _$PhysicalMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhysicalMetricsImplFromJson(json);

// Distance & Speed
  @override
  final double? totalDistance;
// meters
  @override
  final double? highSpeedRunning;
// meters >19.8 km/h
  @override
  final double? sprints;
// count >25.2 km/h
  @override
  final double? maxSpeed;
// km/h
  @override
  final double? averageSpeed;
// km/h
// Acceleration & Deceleration
  @override
  final int? accelerations;
// count >3 m/s²
  @override
  final int? decelerations;
// count <-3 m/s²
// Heart Rate
  @override
  final int? maxHeartRate;
// bpm
  @override
  final int? averageHeartRate;
// bpm
  @override
  final int? timeInZone1;
// seconds (50-60% max HR)
  @override
  final int? timeInZone2;
// seconds (60-70% max HR)
  @override
  final int? timeInZone3;
// seconds (70-80% max HR)
  @override
  final int? timeInZone4;
// seconds (80-90% max HR)
  @override
  final int? timeInZone5;
// seconds (90-100% max HR)
// Power & Explosiveness
  @override
  final double? jumpHeight;
// cm
  @override
  final double? sprintTime10m;
// seconds
  @override
  final double? sprintTime30m;
// seconds
  @override
  final double? agility505;
// seconds
// Endurance
  @override
  final double? yoyoTestDistance;
// meters
  @override
  final double? vo2Max;
// ml/kg/min
// Recovery Metrics
  @override
  final double? hrvScore;
// Heart Rate Variability
  @override
  final int? restingHeartRate;
// bpm
  @override
  final double? sleepQuality;
// 0-10
  @override
  final int? sleepHours;

  @override
  String toString() {
    return 'PhysicalMetrics(totalDistance: $totalDistance, highSpeedRunning: $highSpeedRunning, sprints: $sprints, maxSpeed: $maxSpeed, averageSpeed: $averageSpeed, accelerations: $accelerations, decelerations: $decelerations, maxHeartRate: $maxHeartRate, averageHeartRate: $averageHeartRate, timeInZone1: $timeInZone1, timeInZone2: $timeInZone2, timeInZone3: $timeInZone3, timeInZone4: $timeInZone4, timeInZone5: $timeInZone5, jumpHeight: $jumpHeight, sprintTime10m: $sprintTime10m, sprintTime30m: $sprintTime30m, agility505: $agility505, yoyoTestDistance: $yoyoTestDistance, vo2Max: $vo2Max, hrvScore: $hrvScore, restingHeartRate: $restingHeartRate, sleepQuality: $sleepQuality, sleepHours: $sleepHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhysicalMetricsImpl &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.highSpeedRunning, highSpeedRunning) ||
                other.highSpeedRunning == highSpeedRunning) &&
            (identical(other.sprints, sprints) || other.sprints == sprints) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.averageSpeed, averageSpeed) ||
                other.averageSpeed == averageSpeed) &&
            (identical(other.accelerations, accelerations) ||
                other.accelerations == accelerations) &&
            (identical(other.decelerations, decelerations) ||
                other.decelerations == decelerations) &&
            (identical(other.maxHeartRate, maxHeartRate) ||
                other.maxHeartRate == maxHeartRate) &&
            (identical(other.averageHeartRate, averageHeartRate) ||
                other.averageHeartRate == averageHeartRate) &&
            (identical(other.timeInZone1, timeInZone1) ||
                other.timeInZone1 == timeInZone1) &&
            (identical(other.timeInZone2, timeInZone2) ||
                other.timeInZone2 == timeInZone2) &&
            (identical(other.timeInZone3, timeInZone3) ||
                other.timeInZone3 == timeInZone3) &&
            (identical(other.timeInZone4, timeInZone4) ||
                other.timeInZone4 == timeInZone4) &&
            (identical(other.timeInZone5, timeInZone5) ||
                other.timeInZone5 == timeInZone5) &&
            (identical(other.jumpHeight, jumpHeight) ||
                other.jumpHeight == jumpHeight) &&
            (identical(other.sprintTime10m, sprintTime10m) ||
                other.sprintTime10m == sprintTime10m) &&
            (identical(other.sprintTime30m, sprintTime30m) ||
                other.sprintTime30m == sprintTime30m) &&
            (identical(other.agility505, agility505) ||
                other.agility505 == agility505) &&
            (identical(other.yoyoTestDistance, yoyoTestDistance) ||
                other.yoyoTestDistance == yoyoTestDistance) &&
            (identical(other.vo2Max, vo2Max) || other.vo2Max == vo2Max) &&
            (identical(other.hrvScore, hrvScore) ||
                other.hrvScore == hrvScore) &&
            (identical(other.restingHeartRate, restingHeartRate) ||
                other.restingHeartRate == restingHeartRate) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.sleepHours, sleepHours) ||
                other.sleepHours == sleepHours));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        totalDistance,
        highSpeedRunning,
        sprints,
        maxSpeed,
        averageSpeed,
        accelerations,
        decelerations,
        maxHeartRate,
        averageHeartRate,
        timeInZone1,
        timeInZone2,
        timeInZone3,
        timeInZone4,
        timeInZone5,
        jumpHeight,
        sprintTime10m,
        sprintTime30m,
        agility505,
        yoyoTestDistance,
        vo2Max,
        hrvScore,
        restingHeartRate,
        sleepQuality,
        sleepHours
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhysicalMetricsImplCopyWith<_$PhysicalMetricsImpl> get copyWith =>
      __$$PhysicalMetricsImplCopyWithImpl<_$PhysicalMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhysicalMetricsImplToJson(
      this,
    );
  }
}

abstract class _PhysicalMetrics implements PhysicalMetrics {
  const factory _PhysicalMetrics(
      {final double? totalDistance,
      final double? highSpeedRunning,
      final double? sprints,
      final double? maxSpeed,
      final double? averageSpeed,
      final int? accelerations,
      final int? decelerations,
      final int? maxHeartRate,
      final int? averageHeartRate,
      final int? timeInZone1,
      final int? timeInZone2,
      final int? timeInZone3,
      final int? timeInZone4,
      final int? timeInZone5,
      final double? jumpHeight,
      final double? sprintTime10m,
      final double? sprintTime30m,
      final double? agility505,
      final double? yoyoTestDistance,
      final double? vo2Max,
      final double? hrvScore,
      final int? restingHeartRate,
      final double? sleepQuality,
      final int? sleepHours}) = _$PhysicalMetricsImpl;

  factory _PhysicalMetrics.fromJson(Map<String, dynamic> json) =
      _$PhysicalMetricsImpl.fromJson;

  @override // Distance & Speed
  double? get totalDistance;
  @override // meters
  double? get highSpeedRunning;
  @override // meters >19.8 km/h
  double? get sprints;
  @override // count >25.2 km/h
  double? get maxSpeed;
  @override // km/h
  double? get averageSpeed;
  @override // km/h
// Acceleration & Deceleration
  int? get accelerations;
  @override // count >3 m/s²
  int? get decelerations;
  @override // count <-3 m/s²
// Heart Rate
  int? get maxHeartRate;
  @override // bpm
  int? get averageHeartRate;
  @override // bpm
  int? get timeInZone1;
  @override // seconds (50-60% max HR)
  int? get timeInZone2;
  @override // seconds (60-70% max HR)
  int? get timeInZone3;
  @override // seconds (70-80% max HR)
  int? get timeInZone4;
  @override // seconds (80-90% max HR)
  int? get timeInZone5;
  @override // seconds (90-100% max HR)
// Power & Explosiveness
  double? get jumpHeight;
  @override // cm
  double? get sprintTime10m;
  @override // seconds
  double? get sprintTime30m;
  @override // seconds
  double? get agility505;
  @override // seconds
// Endurance
  double? get yoyoTestDistance;
  @override // meters
  double? get vo2Max;
  @override // ml/kg/min
// Recovery Metrics
  double? get hrvScore;
  @override // Heart Rate Variability
  int? get restingHeartRate;
  @override // bpm
  double? get sleepQuality;
  @override // 0-10
  int? get sleepHours;
  @override
  @JsonKey(ignore: true)
  _$$PhysicalMetricsImplCopyWith<_$PhysicalMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TechnicalMetrics _$TechnicalMetricsFromJson(Map<String, dynamic> json) {
  return _TechnicalMetrics.fromJson(json);
}

/// @nodoc
mixin _$TechnicalMetrics {
// Ball Control
  int? get touches => throw _privateConstructorUsedError; // total touches
  int? get firstTouchSuccess =>
      throw _privateConstructorUsedError; // successful first touches
  int? get firstTouchTotal =>
      throw _privateConstructorUsedError; // total first touches
// Passing
  int? get passesCompleted => throw _privateConstructorUsedError;
  int? get passesAttempted => throw _privateConstructorUsedError;
  int? get keyPasses =>
      throw _privateConstructorUsedError; // passes leading to shot
  int? get throughBalls => throw _privateConstructorUsedError;
  int? get longBallsCompleted => throw _privateConstructorUsedError;
  int? get longBallsAttempted =>
      throw _privateConstructorUsedError; // Dribbling
  int? get dribblesCompleted => throw _privateConstructorUsedError;
  int? get dribblesAttempted => throw _privateConstructorUsedError;
  int? get nutmegs => throw _privateConstructorUsedError; // Shooting
  int? get shots => throw _privateConstructorUsedError;
  int? get shotsOnTarget => throw _privateConstructorUsedError;
  int? get goals => throw _privateConstructorUsedError;
  double? get xG => throw _privateConstructorUsedError; // expected goals
// Defending
  int? get tackles => throw _privateConstructorUsedError;
  int? get tacklesWon => throw _privateConstructorUsedError;
  int? get interceptions => throw _privateConstructorUsedError;
  int? get blocks => throw _privateConstructorUsedError;
  int? get clearances => throw _privateConstructorUsedError;
  int? get aerialDuelsWon => throw _privateConstructorUsedError;
  int? get aerialDuelsTotal =>
      throw _privateConstructorUsedError; // Goalkeeping (if applicable)
  int? get saves => throw _privateConstructorUsedError;
  int? get savePercentage => throw _privateConstructorUsedError;
  int? get cleanSheets => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TechnicalMetricsCopyWith<TechnicalMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TechnicalMetricsCopyWith<$Res> {
  factory $TechnicalMetricsCopyWith(
          TechnicalMetrics value, $Res Function(TechnicalMetrics) then) =
      _$TechnicalMetricsCopyWithImpl<$Res, TechnicalMetrics>;
  @useResult
  $Res call(
      {int? touches,
      int? firstTouchSuccess,
      int? firstTouchTotal,
      int? passesCompleted,
      int? passesAttempted,
      int? keyPasses,
      int? throughBalls,
      int? longBallsCompleted,
      int? longBallsAttempted,
      int? dribblesCompleted,
      int? dribblesAttempted,
      int? nutmegs,
      int? shots,
      int? shotsOnTarget,
      int? goals,
      double? xG,
      int? tackles,
      int? tacklesWon,
      int? interceptions,
      int? blocks,
      int? clearances,
      int? aerialDuelsWon,
      int? aerialDuelsTotal,
      int? saves,
      int? savePercentage,
      int? cleanSheets});
}

/// @nodoc
class _$TechnicalMetricsCopyWithImpl<$Res, $Val extends TechnicalMetrics>
    implements $TechnicalMetricsCopyWith<$Res> {
  _$TechnicalMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? touches = freezed,
    Object? firstTouchSuccess = freezed,
    Object? firstTouchTotal = freezed,
    Object? passesCompleted = freezed,
    Object? passesAttempted = freezed,
    Object? keyPasses = freezed,
    Object? throughBalls = freezed,
    Object? longBallsCompleted = freezed,
    Object? longBallsAttempted = freezed,
    Object? dribblesCompleted = freezed,
    Object? dribblesAttempted = freezed,
    Object? nutmegs = freezed,
    Object? shots = freezed,
    Object? shotsOnTarget = freezed,
    Object? goals = freezed,
    Object? xG = freezed,
    Object? tackles = freezed,
    Object? tacklesWon = freezed,
    Object? interceptions = freezed,
    Object? blocks = freezed,
    Object? clearances = freezed,
    Object? aerialDuelsWon = freezed,
    Object? aerialDuelsTotal = freezed,
    Object? saves = freezed,
    Object? savePercentage = freezed,
    Object? cleanSheets = freezed,
  }) {
    return _then(_value.copyWith(
      touches: freezed == touches
          ? _value.touches
          : touches // ignore: cast_nullable_to_non_nullable
              as int?,
      firstTouchSuccess: freezed == firstTouchSuccess
          ? _value.firstTouchSuccess
          : firstTouchSuccess // ignore: cast_nullable_to_non_nullable
              as int?,
      firstTouchTotal: freezed == firstTouchTotal
          ? _value.firstTouchTotal
          : firstTouchTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      passesCompleted: freezed == passesCompleted
          ? _value.passesCompleted
          : passesCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      passesAttempted: freezed == passesAttempted
          ? _value.passesAttempted
          : passesAttempted // ignore: cast_nullable_to_non_nullable
              as int?,
      keyPasses: freezed == keyPasses
          ? _value.keyPasses
          : keyPasses // ignore: cast_nullable_to_non_nullable
              as int?,
      throughBalls: freezed == throughBalls
          ? _value.throughBalls
          : throughBalls // ignore: cast_nullable_to_non_nullable
              as int?,
      longBallsCompleted: freezed == longBallsCompleted
          ? _value.longBallsCompleted
          : longBallsCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      longBallsAttempted: freezed == longBallsAttempted
          ? _value.longBallsAttempted
          : longBallsAttempted // ignore: cast_nullable_to_non_nullable
              as int?,
      dribblesCompleted: freezed == dribblesCompleted
          ? _value.dribblesCompleted
          : dribblesCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      dribblesAttempted: freezed == dribblesAttempted
          ? _value.dribblesAttempted
          : dribblesAttempted // ignore: cast_nullable_to_non_nullable
              as int?,
      nutmegs: freezed == nutmegs
          ? _value.nutmegs
          : nutmegs // ignore: cast_nullable_to_non_nullable
              as int?,
      shots: freezed == shots
          ? _value.shots
          : shots // ignore: cast_nullable_to_non_nullable
              as int?,
      shotsOnTarget: freezed == shotsOnTarget
          ? _value.shotsOnTarget
          : shotsOnTarget // ignore: cast_nullable_to_non_nullable
              as int?,
      goals: freezed == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as int?,
      xG: freezed == xG
          ? _value.xG
          : xG // ignore: cast_nullable_to_non_nullable
              as double?,
      tackles: freezed == tackles
          ? _value.tackles
          : tackles // ignore: cast_nullable_to_non_nullable
              as int?,
      tacklesWon: freezed == tacklesWon
          ? _value.tacklesWon
          : tacklesWon // ignore: cast_nullable_to_non_nullable
              as int?,
      interceptions: freezed == interceptions
          ? _value.interceptions
          : interceptions // ignore: cast_nullable_to_non_nullable
              as int?,
      blocks: freezed == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as int?,
      clearances: freezed == clearances
          ? _value.clearances
          : clearances // ignore: cast_nullable_to_non_nullable
              as int?,
      aerialDuelsWon: freezed == aerialDuelsWon
          ? _value.aerialDuelsWon
          : aerialDuelsWon // ignore: cast_nullable_to_non_nullable
              as int?,
      aerialDuelsTotal: freezed == aerialDuelsTotal
          ? _value.aerialDuelsTotal
          : aerialDuelsTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      saves: freezed == saves
          ? _value.saves
          : saves // ignore: cast_nullable_to_non_nullable
              as int?,
      savePercentage: freezed == savePercentage
          ? _value.savePercentage
          : savePercentage // ignore: cast_nullable_to_non_nullable
              as int?,
      cleanSheets: freezed == cleanSheets
          ? _value.cleanSheets
          : cleanSheets // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TechnicalMetricsImplCopyWith<$Res>
    implements $TechnicalMetricsCopyWith<$Res> {
  factory _$$TechnicalMetricsImplCopyWith(_$TechnicalMetricsImpl value,
          $Res Function(_$TechnicalMetricsImpl) then) =
      __$$TechnicalMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? touches,
      int? firstTouchSuccess,
      int? firstTouchTotal,
      int? passesCompleted,
      int? passesAttempted,
      int? keyPasses,
      int? throughBalls,
      int? longBallsCompleted,
      int? longBallsAttempted,
      int? dribblesCompleted,
      int? dribblesAttempted,
      int? nutmegs,
      int? shots,
      int? shotsOnTarget,
      int? goals,
      double? xG,
      int? tackles,
      int? tacklesWon,
      int? interceptions,
      int? blocks,
      int? clearances,
      int? aerialDuelsWon,
      int? aerialDuelsTotal,
      int? saves,
      int? savePercentage,
      int? cleanSheets});
}

/// @nodoc
class __$$TechnicalMetricsImplCopyWithImpl<$Res>
    extends _$TechnicalMetricsCopyWithImpl<$Res, _$TechnicalMetricsImpl>
    implements _$$TechnicalMetricsImplCopyWith<$Res> {
  __$$TechnicalMetricsImplCopyWithImpl(_$TechnicalMetricsImpl _value,
      $Res Function(_$TechnicalMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? touches = freezed,
    Object? firstTouchSuccess = freezed,
    Object? firstTouchTotal = freezed,
    Object? passesCompleted = freezed,
    Object? passesAttempted = freezed,
    Object? keyPasses = freezed,
    Object? throughBalls = freezed,
    Object? longBallsCompleted = freezed,
    Object? longBallsAttempted = freezed,
    Object? dribblesCompleted = freezed,
    Object? dribblesAttempted = freezed,
    Object? nutmegs = freezed,
    Object? shots = freezed,
    Object? shotsOnTarget = freezed,
    Object? goals = freezed,
    Object? xG = freezed,
    Object? tackles = freezed,
    Object? tacklesWon = freezed,
    Object? interceptions = freezed,
    Object? blocks = freezed,
    Object? clearances = freezed,
    Object? aerialDuelsWon = freezed,
    Object? aerialDuelsTotal = freezed,
    Object? saves = freezed,
    Object? savePercentage = freezed,
    Object? cleanSheets = freezed,
  }) {
    return _then(_$TechnicalMetricsImpl(
      touches: freezed == touches
          ? _value.touches
          : touches // ignore: cast_nullable_to_non_nullable
              as int?,
      firstTouchSuccess: freezed == firstTouchSuccess
          ? _value.firstTouchSuccess
          : firstTouchSuccess // ignore: cast_nullable_to_non_nullable
              as int?,
      firstTouchTotal: freezed == firstTouchTotal
          ? _value.firstTouchTotal
          : firstTouchTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      passesCompleted: freezed == passesCompleted
          ? _value.passesCompleted
          : passesCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      passesAttempted: freezed == passesAttempted
          ? _value.passesAttempted
          : passesAttempted // ignore: cast_nullable_to_non_nullable
              as int?,
      keyPasses: freezed == keyPasses
          ? _value.keyPasses
          : keyPasses // ignore: cast_nullable_to_non_nullable
              as int?,
      throughBalls: freezed == throughBalls
          ? _value.throughBalls
          : throughBalls // ignore: cast_nullable_to_non_nullable
              as int?,
      longBallsCompleted: freezed == longBallsCompleted
          ? _value.longBallsCompleted
          : longBallsCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      longBallsAttempted: freezed == longBallsAttempted
          ? _value.longBallsAttempted
          : longBallsAttempted // ignore: cast_nullable_to_non_nullable
              as int?,
      dribblesCompleted: freezed == dribblesCompleted
          ? _value.dribblesCompleted
          : dribblesCompleted // ignore: cast_nullable_to_non_nullable
              as int?,
      dribblesAttempted: freezed == dribblesAttempted
          ? _value.dribblesAttempted
          : dribblesAttempted // ignore: cast_nullable_to_non_nullable
              as int?,
      nutmegs: freezed == nutmegs
          ? _value.nutmegs
          : nutmegs // ignore: cast_nullable_to_non_nullable
              as int?,
      shots: freezed == shots
          ? _value.shots
          : shots // ignore: cast_nullable_to_non_nullable
              as int?,
      shotsOnTarget: freezed == shotsOnTarget
          ? _value.shotsOnTarget
          : shotsOnTarget // ignore: cast_nullable_to_non_nullable
              as int?,
      goals: freezed == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as int?,
      xG: freezed == xG
          ? _value.xG
          : xG // ignore: cast_nullable_to_non_nullable
              as double?,
      tackles: freezed == tackles
          ? _value.tackles
          : tackles // ignore: cast_nullable_to_non_nullable
              as int?,
      tacklesWon: freezed == tacklesWon
          ? _value.tacklesWon
          : tacklesWon // ignore: cast_nullable_to_non_nullable
              as int?,
      interceptions: freezed == interceptions
          ? _value.interceptions
          : interceptions // ignore: cast_nullable_to_non_nullable
              as int?,
      blocks: freezed == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as int?,
      clearances: freezed == clearances
          ? _value.clearances
          : clearances // ignore: cast_nullable_to_non_nullable
              as int?,
      aerialDuelsWon: freezed == aerialDuelsWon
          ? _value.aerialDuelsWon
          : aerialDuelsWon // ignore: cast_nullable_to_non_nullable
              as int?,
      aerialDuelsTotal: freezed == aerialDuelsTotal
          ? _value.aerialDuelsTotal
          : aerialDuelsTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      saves: freezed == saves
          ? _value.saves
          : saves // ignore: cast_nullable_to_non_nullable
              as int?,
      savePercentage: freezed == savePercentage
          ? _value.savePercentage
          : savePercentage // ignore: cast_nullable_to_non_nullable
              as int?,
      cleanSheets: freezed == cleanSheets
          ? _value.cleanSheets
          : cleanSheets // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TechnicalMetricsImpl implements _TechnicalMetrics {
  const _$TechnicalMetricsImpl(
      {this.touches,
      this.firstTouchSuccess,
      this.firstTouchTotal,
      this.passesCompleted,
      this.passesAttempted,
      this.keyPasses,
      this.throughBalls,
      this.longBallsCompleted,
      this.longBallsAttempted,
      this.dribblesCompleted,
      this.dribblesAttempted,
      this.nutmegs,
      this.shots,
      this.shotsOnTarget,
      this.goals,
      this.xG,
      this.tackles,
      this.tacklesWon,
      this.interceptions,
      this.blocks,
      this.clearances,
      this.aerialDuelsWon,
      this.aerialDuelsTotal,
      this.saves,
      this.savePercentage,
      this.cleanSheets});

  factory _$TechnicalMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TechnicalMetricsImplFromJson(json);

// Ball Control
  @override
  final int? touches;
// total touches
  @override
  final int? firstTouchSuccess;
// successful first touches
  @override
  final int? firstTouchTotal;
// total first touches
// Passing
  @override
  final int? passesCompleted;
  @override
  final int? passesAttempted;
  @override
  final int? keyPasses;
// passes leading to shot
  @override
  final int? throughBalls;
  @override
  final int? longBallsCompleted;
  @override
  final int? longBallsAttempted;
// Dribbling
  @override
  final int? dribblesCompleted;
  @override
  final int? dribblesAttempted;
  @override
  final int? nutmegs;
// Shooting
  @override
  final int? shots;
  @override
  final int? shotsOnTarget;
  @override
  final int? goals;
  @override
  final double? xG;
// expected goals
// Defending
  @override
  final int? tackles;
  @override
  final int? tacklesWon;
  @override
  final int? interceptions;
  @override
  final int? blocks;
  @override
  final int? clearances;
  @override
  final int? aerialDuelsWon;
  @override
  final int? aerialDuelsTotal;
// Goalkeeping (if applicable)
  @override
  final int? saves;
  @override
  final int? savePercentage;
  @override
  final int? cleanSheets;

  @override
  String toString() {
    return 'TechnicalMetrics(touches: $touches, firstTouchSuccess: $firstTouchSuccess, firstTouchTotal: $firstTouchTotal, passesCompleted: $passesCompleted, passesAttempted: $passesAttempted, keyPasses: $keyPasses, throughBalls: $throughBalls, longBallsCompleted: $longBallsCompleted, longBallsAttempted: $longBallsAttempted, dribblesCompleted: $dribblesCompleted, dribblesAttempted: $dribblesAttempted, nutmegs: $nutmegs, shots: $shots, shotsOnTarget: $shotsOnTarget, goals: $goals, xG: $xG, tackles: $tackles, tacklesWon: $tacklesWon, interceptions: $interceptions, blocks: $blocks, clearances: $clearances, aerialDuelsWon: $aerialDuelsWon, aerialDuelsTotal: $aerialDuelsTotal, saves: $saves, savePercentage: $savePercentage, cleanSheets: $cleanSheets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TechnicalMetricsImpl &&
            (identical(other.touches, touches) || other.touches == touches) &&
            (identical(other.firstTouchSuccess, firstTouchSuccess) ||
                other.firstTouchSuccess == firstTouchSuccess) &&
            (identical(other.firstTouchTotal, firstTouchTotal) ||
                other.firstTouchTotal == firstTouchTotal) &&
            (identical(other.passesCompleted, passesCompleted) ||
                other.passesCompleted == passesCompleted) &&
            (identical(other.passesAttempted, passesAttempted) ||
                other.passesAttempted == passesAttempted) &&
            (identical(other.keyPasses, keyPasses) ||
                other.keyPasses == keyPasses) &&
            (identical(other.throughBalls, throughBalls) ||
                other.throughBalls == throughBalls) &&
            (identical(other.longBallsCompleted, longBallsCompleted) ||
                other.longBallsCompleted == longBallsCompleted) &&
            (identical(other.longBallsAttempted, longBallsAttempted) ||
                other.longBallsAttempted == longBallsAttempted) &&
            (identical(other.dribblesCompleted, dribblesCompleted) ||
                other.dribblesCompleted == dribblesCompleted) &&
            (identical(other.dribblesAttempted, dribblesAttempted) ||
                other.dribblesAttempted == dribblesAttempted) &&
            (identical(other.nutmegs, nutmegs) || other.nutmegs == nutmegs) &&
            (identical(other.shots, shots) || other.shots == shots) &&
            (identical(other.shotsOnTarget, shotsOnTarget) ||
                other.shotsOnTarget == shotsOnTarget) &&
            (identical(other.goals, goals) || other.goals == goals) &&
            (identical(other.xG, xG) || other.xG == xG) &&
            (identical(other.tackles, tackles) || other.tackles == tackles) &&
            (identical(other.tacklesWon, tacklesWon) ||
                other.tacklesWon == tacklesWon) &&
            (identical(other.interceptions, interceptions) ||
                other.interceptions == interceptions) &&
            (identical(other.blocks, blocks) || other.blocks == blocks) &&
            (identical(other.clearances, clearances) ||
                other.clearances == clearances) &&
            (identical(other.aerialDuelsWon, aerialDuelsWon) ||
                other.aerialDuelsWon == aerialDuelsWon) &&
            (identical(other.aerialDuelsTotal, aerialDuelsTotal) ||
                other.aerialDuelsTotal == aerialDuelsTotal) &&
            (identical(other.saves, saves) || other.saves == saves) &&
            (identical(other.savePercentage, savePercentage) ||
                other.savePercentage == savePercentage) &&
            (identical(other.cleanSheets, cleanSheets) ||
                other.cleanSheets == cleanSheets));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        touches,
        firstTouchSuccess,
        firstTouchTotal,
        passesCompleted,
        passesAttempted,
        keyPasses,
        throughBalls,
        longBallsCompleted,
        longBallsAttempted,
        dribblesCompleted,
        dribblesAttempted,
        nutmegs,
        shots,
        shotsOnTarget,
        goals,
        xG,
        tackles,
        tacklesWon,
        interceptions,
        blocks,
        clearances,
        aerialDuelsWon,
        aerialDuelsTotal,
        saves,
        savePercentage,
        cleanSheets
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TechnicalMetricsImplCopyWith<_$TechnicalMetricsImpl> get copyWith =>
      __$$TechnicalMetricsImplCopyWithImpl<_$TechnicalMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TechnicalMetricsImplToJson(
      this,
    );
  }
}

abstract class _TechnicalMetrics implements TechnicalMetrics {
  const factory _TechnicalMetrics(
      {final int? touches,
      final int? firstTouchSuccess,
      final int? firstTouchTotal,
      final int? passesCompleted,
      final int? passesAttempted,
      final int? keyPasses,
      final int? throughBalls,
      final int? longBallsCompleted,
      final int? longBallsAttempted,
      final int? dribblesCompleted,
      final int? dribblesAttempted,
      final int? nutmegs,
      final int? shots,
      final int? shotsOnTarget,
      final int? goals,
      final double? xG,
      final int? tackles,
      final int? tacklesWon,
      final int? interceptions,
      final int? blocks,
      final int? clearances,
      final int? aerialDuelsWon,
      final int? aerialDuelsTotal,
      final int? saves,
      final int? savePercentage,
      final int? cleanSheets}) = _$TechnicalMetricsImpl;

  factory _TechnicalMetrics.fromJson(Map<String, dynamic> json) =
      _$TechnicalMetricsImpl.fromJson;

  @override // Ball Control
  int? get touches;
  @override // total touches
  int? get firstTouchSuccess;
  @override // successful first touches
  int? get firstTouchTotal;
  @override // total first touches
// Passing
  int? get passesCompleted;
  @override
  int? get passesAttempted;
  @override
  int? get keyPasses;
  @override // passes leading to shot
  int? get throughBalls;
  @override
  int? get longBallsCompleted;
  @override
  int? get longBallsAttempted;
  @override // Dribbling
  int? get dribblesCompleted;
  @override
  int? get dribblesAttempted;
  @override
  int? get nutmegs;
  @override // Shooting
  int? get shots;
  @override
  int? get shotsOnTarget;
  @override
  int? get goals;
  @override
  double? get xG;
  @override // expected goals
// Defending
  int? get tackles;
  @override
  int? get tacklesWon;
  @override
  int? get interceptions;
  @override
  int? get blocks;
  @override
  int? get clearances;
  @override
  int? get aerialDuelsWon;
  @override
  int? get aerialDuelsTotal;
  @override // Goalkeeping (if applicable)
  int? get saves;
  @override
  int? get savePercentage;
  @override
  int? get cleanSheets;
  @override
  @JsonKey(ignore: true)
  _$$TechnicalMetricsImplCopyWith<_$TechnicalMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TacticalMetrics _$TacticalMetricsFromJson(Map<String, dynamic> json) {
  return _TacticalMetrics.fromJson(json);
}

/// @nodoc
mixin _$TacticalMetrics {
// Positioning
  double? get averagePositionX =>
      throw _privateConstructorUsedError; // field percentage 0-100
  double? get averagePositionY =>
      throw _privateConstructorUsedError; // field percentage 0-100
  double? get heatmapCoverage =>
      throw _privateConstructorUsedError; // percentage of field covered
// Team Play
  int? get combinationPlays => throw _privateConstructorUsedError;
  int? get supportRuns => throw _privateConstructorUsedError;
  int? get defensiveActions => throw _privateConstructorUsedError;
  double? get pressingIntensity => throw _privateConstructorUsedError; // 0-10
// Decision Making
  double? get decisionAccuracy =>
      throw _privateConstructorUsedError; // percentage
  int? get correctDecisions => throw _privateConstructorUsedError;
  int? get poorDecisions =>
      throw _privateConstructorUsedError; // Formation Discipline
  double? get positionAdherence =>
      throw _privateConstructorUsedError; // percentage
  double? get compactness =>
      throw _privateConstructorUsedError; // team shape metric
// Transition Play
  int? get counterAttacks => throw _privateConstructorUsedError;
  int? get recoveryRuns => throw _privateConstructorUsedError;
  double? get transitionSpeed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TacticalMetricsCopyWith<TacticalMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TacticalMetricsCopyWith<$Res> {
  factory $TacticalMetricsCopyWith(
          TacticalMetrics value, $Res Function(TacticalMetrics) then) =
      _$TacticalMetricsCopyWithImpl<$Res, TacticalMetrics>;
  @useResult
  $Res call(
      {double? averagePositionX,
      double? averagePositionY,
      double? heatmapCoverage,
      int? combinationPlays,
      int? supportRuns,
      int? defensiveActions,
      double? pressingIntensity,
      double? decisionAccuracy,
      int? correctDecisions,
      int? poorDecisions,
      double? positionAdherence,
      double? compactness,
      int? counterAttacks,
      int? recoveryRuns,
      double? transitionSpeed});
}

/// @nodoc
class _$TacticalMetricsCopyWithImpl<$Res, $Val extends TacticalMetrics>
    implements $TacticalMetricsCopyWith<$Res> {
  _$TacticalMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averagePositionX = freezed,
    Object? averagePositionY = freezed,
    Object? heatmapCoverage = freezed,
    Object? combinationPlays = freezed,
    Object? supportRuns = freezed,
    Object? defensiveActions = freezed,
    Object? pressingIntensity = freezed,
    Object? decisionAccuracy = freezed,
    Object? correctDecisions = freezed,
    Object? poorDecisions = freezed,
    Object? positionAdherence = freezed,
    Object? compactness = freezed,
    Object? counterAttacks = freezed,
    Object? recoveryRuns = freezed,
    Object? transitionSpeed = freezed,
  }) {
    return _then(_value.copyWith(
      averagePositionX: freezed == averagePositionX
          ? _value.averagePositionX
          : averagePositionX // ignore: cast_nullable_to_non_nullable
              as double?,
      averagePositionY: freezed == averagePositionY
          ? _value.averagePositionY
          : averagePositionY // ignore: cast_nullable_to_non_nullable
              as double?,
      heatmapCoverage: freezed == heatmapCoverage
          ? _value.heatmapCoverage
          : heatmapCoverage // ignore: cast_nullable_to_non_nullable
              as double?,
      combinationPlays: freezed == combinationPlays
          ? _value.combinationPlays
          : combinationPlays // ignore: cast_nullable_to_non_nullable
              as int?,
      supportRuns: freezed == supportRuns
          ? _value.supportRuns
          : supportRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      defensiveActions: freezed == defensiveActions
          ? _value.defensiveActions
          : defensiveActions // ignore: cast_nullable_to_non_nullable
              as int?,
      pressingIntensity: freezed == pressingIntensity
          ? _value.pressingIntensity
          : pressingIntensity // ignore: cast_nullable_to_non_nullable
              as double?,
      decisionAccuracy: freezed == decisionAccuracy
          ? _value.decisionAccuracy
          : decisionAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      correctDecisions: freezed == correctDecisions
          ? _value.correctDecisions
          : correctDecisions // ignore: cast_nullable_to_non_nullable
              as int?,
      poorDecisions: freezed == poorDecisions
          ? _value.poorDecisions
          : poorDecisions // ignore: cast_nullable_to_non_nullable
              as int?,
      positionAdherence: freezed == positionAdherence
          ? _value.positionAdherence
          : positionAdherence // ignore: cast_nullable_to_non_nullable
              as double?,
      compactness: freezed == compactness
          ? _value.compactness
          : compactness // ignore: cast_nullable_to_non_nullable
              as double?,
      counterAttacks: freezed == counterAttacks
          ? _value.counterAttacks
          : counterAttacks // ignore: cast_nullable_to_non_nullable
              as int?,
      recoveryRuns: freezed == recoveryRuns
          ? _value.recoveryRuns
          : recoveryRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      transitionSpeed: freezed == transitionSpeed
          ? _value.transitionSpeed
          : transitionSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TacticalMetricsImplCopyWith<$Res>
    implements $TacticalMetricsCopyWith<$Res> {
  factory _$$TacticalMetricsImplCopyWith(_$TacticalMetricsImpl value,
          $Res Function(_$TacticalMetricsImpl) then) =
      __$$TacticalMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? averagePositionX,
      double? averagePositionY,
      double? heatmapCoverage,
      int? combinationPlays,
      int? supportRuns,
      int? defensiveActions,
      double? pressingIntensity,
      double? decisionAccuracy,
      int? correctDecisions,
      int? poorDecisions,
      double? positionAdherence,
      double? compactness,
      int? counterAttacks,
      int? recoveryRuns,
      double? transitionSpeed});
}

/// @nodoc
class __$$TacticalMetricsImplCopyWithImpl<$Res>
    extends _$TacticalMetricsCopyWithImpl<$Res, _$TacticalMetricsImpl>
    implements _$$TacticalMetricsImplCopyWith<$Res> {
  __$$TacticalMetricsImplCopyWithImpl(
      _$TacticalMetricsImpl _value, $Res Function(_$TacticalMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averagePositionX = freezed,
    Object? averagePositionY = freezed,
    Object? heatmapCoverage = freezed,
    Object? combinationPlays = freezed,
    Object? supportRuns = freezed,
    Object? defensiveActions = freezed,
    Object? pressingIntensity = freezed,
    Object? decisionAccuracy = freezed,
    Object? correctDecisions = freezed,
    Object? poorDecisions = freezed,
    Object? positionAdherence = freezed,
    Object? compactness = freezed,
    Object? counterAttacks = freezed,
    Object? recoveryRuns = freezed,
    Object? transitionSpeed = freezed,
  }) {
    return _then(_$TacticalMetricsImpl(
      averagePositionX: freezed == averagePositionX
          ? _value.averagePositionX
          : averagePositionX // ignore: cast_nullable_to_non_nullable
              as double?,
      averagePositionY: freezed == averagePositionY
          ? _value.averagePositionY
          : averagePositionY // ignore: cast_nullable_to_non_nullable
              as double?,
      heatmapCoverage: freezed == heatmapCoverage
          ? _value.heatmapCoverage
          : heatmapCoverage // ignore: cast_nullable_to_non_nullable
              as double?,
      combinationPlays: freezed == combinationPlays
          ? _value.combinationPlays
          : combinationPlays // ignore: cast_nullable_to_non_nullable
              as int?,
      supportRuns: freezed == supportRuns
          ? _value.supportRuns
          : supportRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      defensiveActions: freezed == defensiveActions
          ? _value.defensiveActions
          : defensiveActions // ignore: cast_nullable_to_non_nullable
              as int?,
      pressingIntensity: freezed == pressingIntensity
          ? _value.pressingIntensity
          : pressingIntensity // ignore: cast_nullable_to_non_nullable
              as double?,
      decisionAccuracy: freezed == decisionAccuracy
          ? _value.decisionAccuracy
          : decisionAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      correctDecisions: freezed == correctDecisions
          ? _value.correctDecisions
          : correctDecisions // ignore: cast_nullable_to_non_nullable
              as int?,
      poorDecisions: freezed == poorDecisions
          ? _value.poorDecisions
          : poorDecisions // ignore: cast_nullable_to_non_nullable
              as int?,
      positionAdherence: freezed == positionAdherence
          ? _value.positionAdherence
          : positionAdherence // ignore: cast_nullable_to_non_nullable
              as double?,
      compactness: freezed == compactness
          ? _value.compactness
          : compactness // ignore: cast_nullable_to_non_nullable
              as double?,
      counterAttacks: freezed == counterAttacks
          ? _value.counterAttacks
          : counterAttacks // ignore: cast_nullable_to_non_nullable
              as int?,
      recoveryRuns: freezed == recoveryRuns
          ? _value.recoveryRuns
          : recoveryRuns // ignore: cast_nullable_to_non_nullable
              as int?,
      transitionSpeed: freezed == transitionSpeed
          ? _value.transitionSpeed
          : transitionSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TacticalMetricsImpl implements _TacticalMetrics {
  const _$TacticalMetricsImpl(
      {this.averagePositionX,
      this.averagePositionY,
      this.heatmapCoverage,
      this.combinationPlays,
      this.supportRuns,
      this.defensiveActions,
      this.pressingIntensity,
      this.decisionAccuracy,
      this.correctDecisions,
      this.poorDecisions,
      this.positionAdherence,
      this.compactness,
      this.counterAttacks,
      this.recoveryRuns,
      this.transitionSpeed});

  factory _$TacticalMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TacticalMetricsImplFromJson(json);

// Positioning
  @override
  final double? averagePositionX;
// field percentage 0-100
  @override
  final double? averagePositionY;
// field percentage 0-100
  @override
  final double? heatmapCoverage;
// percentage of field covered
// Team Play
  @override
  final int? combinationPlays;
  @override
  final int? supportRuns;
  @override
  final int? defensiveActions;
  @override
  final double? pressingIntensity;
// 0-10
// Decision Making
  @override
  final double? decisionAccuracy;
// percentage
  @override
  final int? correctDecisions;
  @override
  final int? poorDecisions;
// Formation Discipline
  @override
  final double? positionAdherence;
// percentage
  @override
  final double? compactness;
// team shape metric
// Transition Play
  @override
  final int? counterAttacks;
  @override
  final int? recoveryRuns;
  @override
  final double? transitionSpeed;

  @override
  String toString() {
    return 'TacticalMetrics(averagePositionX: $averagePositionX, averagePositionY: $averagePositionY, heatmapCoverage: $heatmapCoverage, combinationPlays: $combinationPlays, supportRuns: $supportRuns, defensiveActions: $defensiveActions, pressingIntensity: $pressingIntensity, decisionAccuracy: $decisionAccuracy, correctDecisions: $correctDecisions, poorDecisions: $poorDecisions, positionAdherence: $positionAdherence, compactness: $compactness, counterAttacks: $counterAttacks, recoveryRuns: $recoveryRuns, transitionSpeed: $transitionSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TacticalMetricsImpl &&
            (identical(other.averagePositionX, averagePositionX) ||
                other.averagePositionX == averagePositionX) &&
            (identical(other.averagePositionY, averagePositionY) ||
                other.averagePositionY == averagePositionY) &&
            (identical(other.heatmapCoverage, heatmapCoverage) ||
                other.heatmapCoverage == heatmapCoverage) &&
            (identical(other.combinationPlays, combinationPlays) ||
                other.combinationPlays == combinationPlays) &&
            (identical(other.supportRuns, supportRuns) ||
                other.supportRuns == supportRuns) &&
            (identical(other.defensiveActions, defensiveActions) ||
                other.defensiveActions == defensiveActions) &&
            (identical(other.pressingIntensity, pressingIntensity) ||
                other.pressingIntensity == pressingIntensity) &&
            (identical(other.decisionAccuracy, decisionAccuracy) ||
                other.decisionAccuracy == decisionAccuracy) &&
            (identical(other.correctDecisions, correctDecisions) ||
                other.correctDecisions == correctDecisions) &&
            (identical(other.poorDecisions, poorDecisions) ||
                other.poorDecisions == poorDecisions) &&
            (identical(other.positionAdherence, positionAdherence) ||
                other.positionAdherence == positionAdherence) &&
            (identical(other.compactness, compactness) ||
                other.compactness == compactness) &&
            (identical(other.counterAttacks, counterAttacks) ||
                other.counterAttacks == counterAttacks) &&
            (identical(other.recoveryRuns, recoveryRuns) ||
                other.recoveryRuns == recoveryRuns) &&
            (identical(other.transitionSpeed, transitionSpeed) ||
                other.transitionSpeed == transitionSpeed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averagePositionX,
      averagePositionY,
      heatmapCoverage,
      combinationPlays,
      supportRuns,
      defensiveActions,
      pressingIntensity,
      decisionAccuracy,
      correctDecisions,
      poorDecisions,
      positionAdherence,
      compactness,
      counterAttacks,
      recoveryRuns,
      transitionSpeed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TacticalMetricsImplCopyWith<_$TacticalMetricsImpl> get copyWith =>
      __$$TacticalMetricsImplCopyWithImpl<_$TacticalMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TacticalMetricsImplToJson(
      this,
    );
  }
}

abstract class _TacticalMetrics implements TacticalMetrics {
  const factory _TacticalMetrics(
      {final double? averagePositionX,
      final double? averagePositionY,
      final double? heatmapCoverage,
      final int? combinationPlays,
      final int? supportRuns,
      final int? defensiveActions,
      final double? pressingIntensity,
      final double? decisionAccuracy,
      final int? correctDecisions,
      final int? poorDecisions,
      final double? positionAdherence,
      final double? compactness,
      final int? counterAttacks,
      final int? recoveryRuns,
      final double? transitionSpeed}) = _$TacticalMetricsImpl;

  factory _TacticalMetrics.fromJson(Map<String, dynamic> json) =
      _$TacticalMetricsImpl.fromJson;

  @override // Positioning
  double? get averagePositionX;
  @override // field percentage 0-100
  double? get averagePositionY;
  @override // field percentage 0-100
  double? get heatmapCoverage;
  @override // percentage of field covered
// Team Play
  int? get combinationPlays;
  @override
  int? get supportRuns;
  @override
  int? get defensiveActions;
  @override
  double? get pressingIntensity;
  @override // 0-10
// Decision Making
  double? get decisionAccuracy;
  @override // percentage
  int? get correctDecisions;
  @override
  int? get poorDecisions;
  @override // Formation Discipline
  double? get positionAdherence;
  @override // percentage
  double? get compactness;
  @override // team shape metric
// Transition Play
  int? get counterAttacks;
  @override
  int? get recoveryRuns;
  @override
  double? get transitionSpeed;
  @override
  @JsonKey(ignore: true)
  _$$TacticalMetricsImplCopyWith<_$TacticalMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MentalMetrics _$MentalMetricsFromJson(Map<String, dynamic> json) {
  return _MentalMetrics.fromJson(json);
}

/// @nodoc
mixin _$MentalMetrics {
// Self Assessment
  double? get confidence => throw _privateConstructorUsedError; // 0-10
  double? get motivation => throw _privateConstructorUsedError; // 0-10
  double? get focus => throw _privateConstructorUsedError; // 0-10
  double? get stressLevel => throw _privateConstructorUsedError; // 0-10
// Coach Assessment
  double? get leadership => throw _privateConstructorUsedError; // 0-10
  double? get communication => throw _privateConstructorUsedError; // 0-10
  double? get workRate => throw _privateConstructorUsedError; // 0-10
  double? get coachability => throw _privateConstructorUsedError; // 0-10
  double? get teamwork => throw _privateConstructorUsedError; // 0-10
// Performance Under Pressure
  double? get pressureHandling => throw _privateConstructorUsedError; // 0-10
  int? get mistakesUnderPressure =>
      throw _privateConstructorUsedError; // Learning & Development
  double? get learningRate => throw _privateConstructorUsedError; // 0-10
  double? get adaptability => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MentalMetricsCopyWith<MentalMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentalMetricsCopyWith<$Res> {
  factory $MentalMetricsCopyWith(
          MentalMetrics value, $Res Function(MentalMetrics) then) =
      _$MentalMetricsCopyWithImpl<$Res, MentalMetrics>;
  @useResult
  $Res call(
      {double? confidence,
      double? motivation,
      double? focus,
      double? stressLevel,
      double? leadership,
      double? communication,
      double? workRate,
      double? coachability,
      double? teamwork,
      double? pressureHandling,
      int? mistakesUnderPressure,
      double? learningRate,
      double? adaptability});
}

/// @nodoc
class _$MentalMetricsCopyWithImpl<$Res, $Val extends MentalMetrics>
    implements $MentalMetricsCopyWith<$Res> {
  _$MentalMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confidence = freezed,
    Object? motivation = freezed,
    Object? focus = freezed,
    Object? stressLevel = freezed,
    Object? leadership = freezed,
    Object? communication = freezed,
    Object? workRate = freezed,
    Object? coachability = freezed,
    Object? teamwork = freezed,
    Object? pressureHandling = freezed,
    Object? mistakesUnderPressure = freezed,
    Object? learningRate = freezed,
    Object? adaptability = freezed,
  }) {
    return _then(_value.copyWith(
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      motivation: freezed == motivation
          ? _value.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as double?,
      focus: freezed == focus
          ? _value.focus
          : focus // ignore: cast_nullable_to_non_nullable
              as double?,
      stressLevel: freezed == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      leadership: freezed == leadership
          ? _value.leadership
          : leadership // ignore: cast_nullable_to_non_nullable
              as double?,
      communication: freezed == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as double?,
      workRate: freezed == workRate
          ? _value.workRate
          : workRate // ignore: cast_nullable_to_non_nullable
              as double?,
      coachability: freezed == coachability
          ? _value.coachability
          : coachability // ignore: cast_nullable_to_non_nullable
              as double?,
      teamwork: freezed == teamwork
          ? _value.teamwork
          : teamwork // ignore: cast_nullable_to_non_nullable
              as double?,
      pressureHandling: freezed == pressureHandling
          ? _value.pressureHandling
          : pressureHandling // ignore: cast_nullable_to_non_nullable
              as double?,
      mistakesUnderPressure: freezed == mistakesUnderPressure
          ? _value.mistakesUnderPressure
          : mistakesUnderPressure // ignore: cast_nullable_to_non_nullable
              as int?,
      learningRate: freezed == learningRate
          ? _value.learningRate
          : learningRate // ignore: cast_nullable_to_non_nullable
              as double?,
      adaptability: freezed == adaptability
          ? _value.adaptability
          : adaptability // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentalMetricsImplCopyWith<$Res>
    implements $MentalMetricsCopyWith<$Res> {
  factory _$$MentalMetricsImplCopyWith(
          _$MentalMetricsImpl value, $Res Function(_$MentalMetricsImpl) then) =
      __$$MentalMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? confidence,
      double? motivation,
      double? focus,
      double? stressLevel,
      double? leadership,
      double? communication,
      double? workRate,
      double? coachability,
      double? teamwork,
      double? pressureHandling,
      int? mistakesUnderPressure,
      double? learningRate,
      double? adaptability});
}

/// @nodoc
class __$$MentalMetricsImplCopyWithImpl<$Res>
    extends _$MentalMetricsCopyWithImpl<$Res, _$MentalMetricsImpl>
    implements _$$MentalMetricsImplCopyWith<$Res> {
  __$$MentalMetricsImplCopyWithImpl(
      _$MentalMetricsImpl _value, $Res Function(_$MentalMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confidence = freezed,
    Object? motivation = freezed,
    Object? focus = freezed,
    Object? stressLevel = freezed,
    Object? leadership = freezed,
    Object? communication = freezed,
    Object? workRate = freezed,
    Object? coachability = freezed,
    Object? teamwork = freezed,
    Object? pressureHandling = freezed,
    Object? mistakesUnderPressure = freezed,
    Object? learningRate = freezed,
    Object? adaptability = freezed,
  }) {
    return _then(_$MentalMetricsImpl(
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      motivation: freezed == motivation
          ? _value.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as double?,
      focus: freezed == focus
          ? _value.focus
          : focus // ignore: cast_nullable_to_non_nullable
              as double?,
      stressLevel: freezed == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      leadership: freezed == leadership
          ? _value.leadership
          : leadership // ignore: cast_nullable_to_non_nullable
              as double?,
      communication: freezed == communication
          ? _value.communication
          : communication // ignore: cast_nullable_to_non_nullable
              as double?,
      workRate: freezed == workRate
          ? _value.workRate
          : workRate // ignore: cast_nullable_to_non_nullable
              as double?,
      coachability: freezed == coachability
          ? _value.coachability
          : coachability // ignore: cast_nullable_to_non_nullable
              as double?,
      teamwork: freezed == teamwork
          ? _value.teamwork
          : teamwork // ignore: cast_nullable_to_non_nullable
              as double?,
      pressureHandling: freezed == pressureHandling
          ? _value.pressureHandling
          : pressureHandling // ignore: cast_nullable_to_non_nullable
              as double?,
      mistakesUnderPressure: freezed == mistakesUnderPressure
          ? _value.mistakesUnderPressure
          : mistakesUnderPressure // ignore: cast_nullable_to_non_nullable
              as int?,
      learningRate: freezed == learningRate
          ? _value.learningRate
          : learningRate // ignore: cast_nullable_to_non_nullable
              as double?,
      adaptability: freezed == adaptability
          ? _value.adaptability
          : adaptability // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentalMetricsImpl implements _MentalMetrics {
  const _$MentalMetricsImpl(
      {this.confidence,
      this.motivation,
      this.focus,
      this.stressLevel,
      this.leadership,
      this.communication,
      this.workRate,
      this.coachability,
      this.teamwork,
      this.pressureHandling,
      this.mistakesUnderPressure,
      this.learningRate,
      this.adaptability});

  factory _$MentalMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentalMetricsImplFromJson(json);

// Self Assessment
  @override
  final double? confidence;
// 0-10
  @override
  final double? motivation;
// 0-10
  @override
  final double? focus;
// 0-10
  @override
  final double? stressLevel;
// 0-10
// Coach Assessment
  @override
  final double? leadership;
// 0-10
  @override
  final double? communication;
// 0-10
  @override
  final double? workRate;
// 0-10
  @override
  final double? coachability;
// 0-10
  @override
  final double? teamwork;
// 0-10
// Performance Under Pressure
  @override
  final double? pressureHandling;
// 0-10
  @override
  final int? mistakesUnderPressure;
// Learning & Development
  @override
  final double? learningRate;
// 0-10
  @override
  final double? adaptability;

  @override
  String toString() {
    return 'MentalMetrics(confidence: $confidence, motivation: $motivation, focus: $focus, stressLevel: $stressLevel, leadership: $leadership, communication: $communication, workRate: $workRate, coachability: $coachability, teamwork: $teamwork, pressureHandling: $pressureHandling, mistakesUnderPressure: $mistakesUnderPressure, learningRate: $learningRate, adaptability: $adaptability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentalMetricsImpl &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.motivation, motivation) ||
                other.motivation == motivation) &&
            (identical(other.focus, focus) || other.focus == focus) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            (identical(other.leadership, leadership) ||
                other.leadership == leadership) &&
            (identical(other.communication, communication) ||
                other.communication == communication) &&
            (identical(other.workRate, workRate) ||
                other.workRate == workRate) &&
            (identical(other.coachability, coachability) ||
                other.coachability == coachability) &&
            (identical(other.teamwork, teamwork) ||
                other.teamwork == teamwork) &&
            (identical(other.pressureHandling, pressureHandling) ||
                other.pressureHandling == pressureHandling) &&
            (identical(other.mistakesUnderPressure, mistakesUnderPressure) ||
                other.mistakesUnderPressure == mistakesUnderPressure) &&
            (identical(other.learningRate, learningRate) ||
                other.learningRate == learningRate) &&
            (identical(other.adaptability, adaptability) ||
                other.adaptability == adaptability));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      confidence,
      motivation,
      focus,
      stressLevel,
      leadership,
      communication,
      workRate,
      coachability,
      teamwork,
      pressureHandling,
      mistakesUnderPressure,
      learningRate,
      adaptability);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MentalMetricsImplCopyWith<_$MentalMetricsImpl> get copyWith =>
      __$$MentalMetricsImplCopyWithImpl<_$MentalMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentalMetricsImplToJson(
      this,
    );
  }
}

abstract class _MentalMetrics implements MentalMetrics {
  const factory _MentalMetrics(
      {final double? confidence,
      final double? motivation,
      final double? focus,
      final double? stressLevel,
      final double? leadership,
      final double? communication,
      final double? workRate,
      final double? coachability,
      final double? teamwork,
      final double? pressureHandling,
      final int? mistakesUnderPressure,
      final double? learningRate,
      final double? adaptability}) = _$MentalMetricsImpl;

  factory _MentalMetrics.fromJson(Map<String, dynamic> json) =
      _$MentalMetricsImpl.fromJson;

  @override // Self Assessment
  double? get confidence;
  @override // 0-10
  double? get motivation;
  @override // 0-10
  double? get focus;
  @override // 0-10
  double? get stressLevel;
  @override // 0-10
// Coach Assessment
  double? get leadership;
  @override // 0-10
  double? get communication;
  @override // 0-10
  double? get workRate;
  @override // 0-10
  double? get coachability;
  @override // 0-10
  double? get teamwork;
  @override // 0-10
// Performance Under Pressure
  double? get pressureHandling;
  @override // 0-10
  int? get mistakesUnderPressure;
  @override // Learning & Development
  double? get learningRate;
  @override // 0-10
  double? get adaptability;
  @override
  @JsonKey(ignore: true)
  _$$MentalMetricsImplCopyWith<_$MentalMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchMetrics _$MatchMetricsFromJson(Map<String, dynamic> json) {
  return _MatchMetrics.fromJson(json);
}

/// @nodoc
mixin _$MatchMetrics {
  String get matchId => throw _privateConstructorUsedError;
  int? get minutesPlayed => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError; // 0-10
// Match Events
  int? get goals => throw _privateConstructorUsedError;
  int? get assists => throw _privateConstructorUsedError;
  int? get yellowCards => throw _privateConstructorUsedError;
  int? get redCards => throw _privateConstructorUsedError; // Advanced Stats
  double? get xG => throw _privateConstructorUsedError; // expected goals
  double? get xA => throw _privateConstructorUsedError; // expected assists
  double? get xGChain =>
      throw _privateConstructorUsedError; // expected goals from moves involved in
  double? get xGBuildup => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MatchMetricsCopyWith<MatchMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchMetricsCopyWith<$Res> {
  factory $MatchMetricsCopyWith(
          MatchMetrics value, $Res Function(MatchMetrics) then) =
      _$MatchMetricsCopyWithImpl<$Res, MatchMetrics>;
  @useResult
  $Res call(
      {String matchId,
      int? minutesPlayed,
      String? position,
      double? rating,
      int? goals,
      int? assists,
      int? yellowCards,
      int? redCards,
      double? xG,
      double? xA,
      double? xGChain,
      double? xGBuildup});
}

/// @nodoc
class _$MatchMetricsCopyWithImpl<$Res, $Val extends MatchMetrics>
    implements $MatchMetricsCopyWith<$Res> {
  _$MatchMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? minutesPlayed = freezed,
    Object? position = freezed,
    Object? rating = freezed,
    Object? goals = freezed,
    Object? assists = freezed,
    Object? yellowCards = freezed,
    Object? redCards = freezed,
    Object? xG = freezed,
    Object? xA = freezed,
    Object? xGChain = freezed,
    Object? xGBuildup = freezed,
  }) {
    return _then(_value.copyWith(
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      minutesPlayed: freezed == minutesPlayed
          ? _value.minutesPlayed
          : minutesPlayed // ignore: cast_nullable_to_non_nullable
              as int?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      goals: freezed == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as int?,
      assists: freezed == assists
          ? _value.assists
          : assists // ignore: cast_nullable_to_non_nullable
              as int?,
      yellowCards: freezed == yellowCards
          ? _value.yellowCards
          : yellowCards // ignore: cast_nullable_to_non_nullable
              as int?,
      redCards: freezed == redCards
          ? _value.redCards
          : redCards // ignore: cast_nullable_to_non_nullable
              as int?,
      xG: freezed == xG
          ? _value.xG
          : xG // ignore: cast_nullable_to_non_nullable
              as double?,
      xA: freezed == xA
          ? _value.xA
          : xA // ignore: cast_nullable_to_non_nullable
              as double?,
      xGChain: freezed == xGChain
          ? _value.xGChain
          : xGChain // ignore: cast_nullable_to_non_nullable
              as double?,
      xGBuildup: freezed == xGBuildup
          ? _value.xGBuildup
          : xGBuildup // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchMetricsImplCopyWith<$Res>
    implements $MatchMetricsCopyWith<$Res> {
  factory _$$MatchMetricsImplCopyWith(
          _$MatchMetricsImpl value, $Res Function(_$MatchMetricsImpl) then) =
      __$$MatchMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String matchId,
      int? minutesPlayed,
      String? position,
      double? rating,
      int? goals,
      int? assists,
      int? yellowCards,
      int? redCards,
      double? xG,
      double? xA,
      double? xGChain,
      double? xGBuildup});
}

/// @nodoc
class __$$MatchMetricsImplCopyWithImpl<$Res>
    extends _$MatchMetricsCopyWithImpl<$Res, _$MatchMetricsImpl>
    implements _$$MatchMetricsImplCopyWith<$Res> {
  __$$MatchMetricsImplCopyWithImpl(
      _$MatchMetricsImpl _value, $Res Function(_$MatchMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchId = null,
    Object? minutesPlayed = freezed,
    Object? position = freezed,
    Object? rating = freezed,
    Object? goals = freezed,
    Object? assists = freezed,
    Object? yellowCards = freezed,
    Object? redCards = freezed,
    Object? xG = freezed,
    Object? xA = freezed,
    Object? xGChain = freezed,
    Object? xGBuildup = freezed,
  }) {
    return _then(_$MatchMetricsImpl(
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      minutesPlayed: freezed == minutesPlayed
          ? _value.minutesPlayed
          : minutesPlayed // ignore: cast_nullable_to_non_nullable
              as int?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      goals: freezed == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as int?,
      assists: freezed == assists
          ? _value.assists
          : assists // ignore: cast_nullable_to_non_nullable
              as int?,
      yellowCards: freezed == yellowCards
          ? _value.yellowCards
          : yellowCards // ignore: cast_nullable_to_non_nullable
              as int?,
      redCards: freezed == redCards
          ? _value.redCards
          : redCards // ignore: cast_nullable_to_non_nullable
              as int?,
      xG: freezed == xG
          ? _value.xG
          : xG // ignore: cast_nullable_to_non_nullable
              as double?,
      xA: freezed == xA
          ? _value.xA
          : xA // ignore: cast_nullable_to_non_nullable
              as double?,
      xGChain: freezed == xGChain
          ? _value.xGChain
          : xGChain // ignore: cast_nullable_to_non_nullable
              as double?,
      xGBuildup: freezed == xGBuildup
          ? _value.xGBuildup
          : xGBuildup // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchMetricsImpl implements _MatchMetrics {
  const _$MatchMetricsImpl(
      {required this.matchId,
      this.minutesPlayed,
      this.position,
      this.rating,
      this.goals,
      this.assists,
      this.yellowCards,
      this.redCards,
      this.xG,
      this.xA,
      this.xGChain,
      this.xGBuildup});

  factory _$MatchMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchMetricsImplFromJson(json);

  @override
  final String matchId;
  @override
  final int? minutesPlayed;
  @override
  final String? position;
  @override
  final double? rating;
// 0-10
// Match Events
  @override
  final int? goals;
  @override
  final int? assists;
  @override
  final int? yellowCards;
  @override
  final int? redCards;
// Advanced Stats
  @override
  final double? xG;
// expected goals
  @override
  final double? xA;
// expected assists
  @override
  final double? xGChain;
// expected goals from moves involved in
  @override
  final double? xGBuildup;

  @override
  String toString() {
    return 'MatchMetrics(matchId: $matchId, minutesPlayed: $minutesPlayed, position: $position, rating: $rating, goals: $goals, assists: $assists, yellowCards: $yellowCards, redCards: $redCards, xG: $xG, xA: $xA, xGChain: $xGChain, xGBuildup: $xGBuildup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchMetricsImpl &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.minutesPlayed, minutesPlayed) ||
                other.minutesPlayed == minutesPlayed) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.goals, goals) || other.goals == goals) &&
            (identical(other.assists, assists) || other.assists == assists) &&
            (identical(other.yellowCards, yellowCards) ||
                other.yellowCards == yellowCards) &&
            (identical(other.redCards, redCards) ||
                other.redCards == redCards) &&
            (identical(other.xG, xG) || other.xG == xG) &&
            (identical(other.xA, xA) || other.xA == xA) &&
            (identical(other.xGChain, xGChain) || other.xGChain == xGChain) &&
            (identical(other.xGBuildup, xGBuildup) ||
                other.xGBuildup == xGBuildup));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      matchId,
      minutesPlayed,
      position,
      rating,
      goals,
      assists,
      yellowCards,
      redCards,
      xG,
      xA,
      xGChain,
      xGBuildup);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchMetricsImplCopyWith<_$MatchMetricsImpl> get copyWith =>
      __$$MatchMetricsImplCopyWithImpl<_$MatchMetricsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchMetricsImplToJson(
      this,
    );
  }
}

abstract class _MatchMetrics implements MatchMetrics {
  const factory _MatchMetrics(
      {required final String matchId,
      final int? minutesPlayed,
      final String? position,
      final double? rating,
      final int? goals,
      final int? assists,
      final int? yellowCards,
      final int? redCards,
      final double? xG,
      final double? xA,
      final double? xGChain,
      final double? xGBuildup}) = _$MatchMetricsImpl;

  factory _MatchMetrics.fromJson(Map<String, dynamic> json) =
      _$MatchMetricsImpl.fromJson;

  @override
  String get matchId;
  @override
  int? get minutesPlayed;
  @override
  String? get position;
  @override
  double? get rating;
  @override // 0-10
// Match Events
  int? get goals;
  @override
  int? get assists;
  @override
  int? get yellowCards;
  @override
  int? get redCards;
  @override // Advanced Stats
  double? get xG;
  @override // expected goals
  double? get xA;
  @override // expected assists
  double? get xGChain;
  @override // expected goals from moves involved in
  double? get xGBuildup;
  @override
  @JsonKey(ignore: true)
  _$$MatchMetricsImplCopyWith<_$MatchMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainingLoadMetrics _$TrainingLoadMetricsFromJson(Map<String, dynamic> json) {
  return _TrainingLoadMetrics.fromJson(json);
}

/// @nodoc
mixin _$TrainingLoadMetrics {
// Acute:Chronic Workload Ratio
  double? get acwr => throw _privateConstructorUsedError; // optimal: 0.8-1.3
  double? get weeklyLoad => throw _privateConstructorUsedError;
  double? get monthlyLoad =>
      throw _privateConstructorUsedError; // Training Intensity
  double? get sessionRPE =>
      throw _privateConstructorUsedError; // Rate of Perceived Exertion 0-10
  double? get trainingLoad =>
      throw _privateConstructorUsedError; // RPE * duration
// Monotony & Strain
  double? get trainingMonotony => throw _privateConstructorUsedError;
  double? get trainingStrain =>
      throw _privateConstructorUsedError; // Recovery Status
  double? get recoveryScore => throw _privateConstructorUsedError; // 0-100
  String? get fatigueLevel =>
      throw _privateConstructorUsedError; // low, moderate, high
// Injury Risk
  double? get injuryRiskScore => throw _privateConstructorUsedError; // 0-100
  List<String>? get riskFactors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrainingLoadMetricsCopyWith<TrainingLoadMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingLoadMetricsCopyWith<$Res> {
  factory $TrainingLoadMetricsCopyWith(
          TrainingLoadMetrics value, $Res Function(TrainingLoadMetrics) then) =
      _$TrainingLoadMetricsCopyWithImpl<$Res, TrainingLoadMetrics>;
  @useResult
  $Res call(
      {double? acwr,
      double? weeklyLoad,
      double? monthlyLoad,
      double? sessionRPE,
      double? trainingLoad,
      double? trainingMonotony,
      double? trainingStrain,
      double? recoveryScore,
      String? fatigueLevel,
      double? injuryRiskScore,
      List<String>? riskFactors});
}

/// @nodoc
class _$TrainingLoadMetricsCopyWithImpl<$Res, $Val extends TrainingLoadMetrics>
    implements $TrainingLoadMetricsCopyWith<$Res> {
  _$TrainingLoadMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acwr = freezed,
    Object? weeklyLoad = freezed,
    Object? monthlyLoad = freezed,
    Object? sessionRPE = freezed,
    Object? trainingLoad = freezed,
    Object? trainingMonotony = freezed,
    Object? trainingStrain = freezed,
    Object? recoveryScore = freezed,
    Object? fatigueLevel = freezed,
    Object? injuryRiskScore = freezed,
    Object? riskFactors = freezed,
  }) {
    return _then(_value.copyWith(
      acwr: freezed == acwr
          ? _value.acwr
          : acwr // ignore: cast_nullable_to_non_nullable
              as double?,
      weeklyLoad: freezed == weeklyLoad
          ? _value.weeklyLoad
          : weeklyLoad // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyLoad: freezed == monthlyLoad
          ? _value.monthlyLoad
          : monthlyLoad // ignore: cast_nullable_to_non_nullable
              as double?,
      sessionRPE: freezed == sessionRPE
          ? _value.sessionRPE
          : sessionRPE // ignore: cast_nullable_to_non_nullable
              as double?,
      trainingLoad: freezed == trainingLoad
          ? _value.trainingLoad
          : trainingLoad // ignore: cast_nullable_to_non_nullable
              as double?,
      trainingMonotony: freezed == trainingMonotony
          ? _value.trainingMonotony
          : trainingMonotony // ignore: cast_nullable_to_non_nullable
              as double?,
      trainingStrain: freezed == trainingStrain
          ? _value.trainingStrain
          : trainingStrain // ignore: cast_nullable_to_non_nullable
              as double?,
      recoveryScore: freezed == recoveryScore
          ? _value.recoveryScore
          : recoveryScore // ignore: cast_nullable_to_non_nullable
              as double?,
      fatigueLevel: freezed == fatigueLevel
          ? _value.fatigueLevel
          : fatigueLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      injuryRiskScore: freezed == injuryRiskScore
          ? _value.injuryRiskScore
          : injuryRiskScore // ignore: cast_nullable_to_non_nullable
              as double?,
      riskFactors: freezed == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingLoadMetricsImplCopyWith<$Res>
    implements $TrainingLoadMetricsCopyWith<$Res> {
  factory _$$TrainingLoadMetricsImplCopyWith(_$TrainingLoadMetricsImpl value,
          $Res Function(_$TrainingLoadMetricsImpl) then) =
      __$$TrainingLoadMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? acwr,
      double? weeklyLoad,
      double? monthlyLoad,
      double? sessionRPE,
      double? trainingLoad,
      double? trainingMonotony,
      double? trainingStrain,
      double? recoveryScore,
      String? fatigueLevel,
      double? injuryRiskScore,
      List<String>? riskFactors});
}

/// @nodoc
class __$$TrainingLoadMetricsImplCopyWithImpl<$Res>
    extends _$TrainingLoadMetricsCopyWithImpl<$Res, _$TrainingLoadMetricsImpl>
    implements _$$TrainingLoadMetricsImplCopyWith<$Res> {
  __$$TrainingLoadMetricsImplCopyWithImpl(_$TrainingLoadMetricsImpl _value,
      $Res Function(_$TrainingLoadMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acwr = freezed,
    Object? weeklyLoad = freezed,
    Object? monthlyLoad = freezed,
    Object? sessionRPE = freezed,
    Object? trainingLoad = freezed,
    Object? trainingMonotony = freezed,
    Object? trainingStrain = freezed,
    Object? recoveryScore = freezed,
    Object? fatigueLevel = freezed,
    Object? injuryRiskScore = freezed,
    Object? riskFactors = freezed,
  }) {
    return _then(_$TrainingLoadMetricsImpl(
      acwr: freezed == acwr
          ? _value.acwr
          : acwr // ignore: cast_nullable_to_non_nullable
              as double?,
      weeklyLoad: freezed == weeklyLoad
          ? _value.weeklyLoad
          : weeklyLoad // ignore: cast_nullable_to_non_nullable
              as double?,
      monthlyLoad: freezed == monthlyLoad
          ? _value.monthlyLoad
          : monthlyLoad // ignore: cast_nullable_to_non_nullable
              as double?,
      sessionRPE: freezed == sessionRPE
          ? _value.sessionRPE
          : sessionRPE // ignore: cast_nullable_to_non_nullable
              as double?,
      trainingLoad: freezed == trainingLoad
          ? _value.trainingLoad
          : trainingLoad // ignore: cast_nullable_to_non_nullable
              as double?,
      trainingMonotony: freezed == trainingMonotony
          ? _value.trainingMonotony
          : trainingMonotony // ignore: cast_nullable_to_non_nullable
              as double?,
      trainingStrain: freezed == trainingStrain
          ? _value.trainingStrain
          : trainingStrain // ignore: cast_nullable_to_non_nullable
              as double?,
      recoveryScore: freezed == recoveryScore
          ? _value.recoveryScore
          : recoveryScore // ignore: cast_nullable_to_non_nullable
              as double?,
      fatigueLevel: freezed == fatigueLevel
          ? _value.fatigueLevel
          : fatigueLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      injuryRiskScore: freezed == injuryRiskScore
          ? _value.injuryRiskScore
          : injuryRiskScore // ignore: cast_nullable_to_non_nullable
              as double?,
      riskFactors: freezed == riskFactors
          ? _value._riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingLoadMetricsImpl implements _TrainingLoadMetrics {
  const _$TrainingLoadMetricsImpl(
      {this.acwr,
      this.weeklyLoad,
      this.monthlyLoad,
      this.sessionRPE,
      this.trainingLoad,
      this.trainingMonotony,
      this.trainingStrain,
      this.recoveryScore,
      this.fatigueLevel,
      this.injuryRiskScore,
      final List<String>? riskFactors})
      : _riskFactors = riskFactors;

  factory _$TrainingLoadMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingLoadMetricsImplFromJson(json);

// Acute:Chronic Workload Ratio
  @override
  final double? acwr;
// optimal: 0.8-1.3
  @override
  final double? weeklyLoad;
  @override
  final double? monthlyLoad;
// Training Intensity
  @override
  final double? sessionRPE;
// Rate of Perceived Exertion 0-10
  @override
  final double? trainingLoad;
// RPE * duration
// Monotony & Strain
  @override
  final double? trainingMonotony;
  @override
  final double? trainingStrain;
// Recovery Status
  @override
  final double? recoveryScore;
// 0-100
  @override
  final String? fatigueLevel;
// low, moderate, high
// Injury Risk
  @override
  final double? injuryRiskScore;
// 0-100
  final List<String>? _riskFactors;
// 0-100
  @override
  List<String>? get riskFactors {
    final value = _riskFactors;
    if (value == null) return null;
    if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TrainingLoadMetrics(acwr: $acwr, weeklyLoad: $weeklyLoad, monthlyLoad: $monthlyLoad, sessionRPE: $sessionRPE, trainingLoad: $trainingLoad, trainingMonotony: $trainingMonotony, trainingStrain: $trainingStrain, recoveryScore: $recoveryScore, fatigueLevel: $fatigueLevel, injuryRiskScore: $injuryRiskScore, riskFactors: $riskFactors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingLoadMetricsImpl &&
            (identical(other.acwr, acwr) || other.acwr == acwr) &&
            (identical(other.weeklyLoad, weeklyLoad) ||
                other.weeklyLoad == weeklyLoad) &&
            (identical(other.monthlyLoad, monthlyLoad) ||
                other.monthlyLoad == monthlyLoad) &&
            (identical(other.sessionRPE, sessionRPE) ||
                other.sessionRPE == sessionRPE) &&
            (identical(other.trainingLoad, trainingLoad) ||
                other.trainingLoad == trainingLoad) &&
            (identical(other.trainingMonotony, trainingMonotony) ||
                other.trainingMonotony == trainingMonotony) &&
            (identical(other.trainingStrain, trainingStrain) ||
                other.trainingStrain == trainingStrain) &&
            (identical(other.recoveryScore, recoveryScore) ||
                other.recoveryScore == recoveryScore) &&
            (identical(other.fatigueLevel, fatigueLevel) ||
                other.fatigueLevel == fatigueLevel) &&
            (identical(other.injuryRiskScore, injuryRiskScore) ||
                other.injuryRiskScore == injuryRiskScore) &&
            const DeepCollectionEquality()
                .equals(other._riskFactors, _riskFactors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      acwr,
      weeklyLoad,
      monthlyLoad,
      sessionRPE,
      trainingLoad,
      trainingMonotony,
      trainingStrain,
      recoveryScore,
      fatigueLevel,
      injuryRiskScore,
      const DeepCollectionEquality().hash(_riskFactors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingLoadMetricsImplCopyWith<_$TrainingLoadMetricsImpl> get copyWith =>
      __$$TrainingLoadMetricsImplCopyWithImpl<_$TrainingLoadMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingLoadMetricsImplToJson(
      this,
    );
  }
}

abstract class _TrainingLoadMetrics implements TrainingLoadMetrics {
  const factory _TrainingLoadMetrics(
      {final double? acwr,
      final double? weeklyLoad,
      final double? monthlyLoad,
      final double? sessionRPE,
      final double? trainingLoad,
      final double? trainingMonotony,
      final double? trainingStrain,
      final double? recoveryScore,
      final String? fatigueLevel,
      final double? injuryRiskScore,
      final List<String>? riskFactors}) = _$TrainingLoadMetricsImpl;

  factory _TrainingLoadMetrics.fromJson(Map<String, dynamic> json) =
      _$TrainingLoadMetricsImpl.fromJson;

  @override // Acute:Chronic Workload Ratio
  double? get acwr;
  @override // optimal: 0.8-1.3
  double? get weeklyLoad;
  @override
  double? get monthlyLoad;
  @override // Training Intensity
  double? get sessionRPE;
  @override // Rate of Perceived Exertion 0-10
  double? get trainingLoad;
  @override // RPE * duration
// Monotony & Strain
  double? get trainingMonotony;
  @override
  double? get trainingStrain;
  @override // Recovery Status
  double? get recoveryScore;
  @override // 0-100
  String? get fatigueLevel;
  @override // low, moderate, high
// Injury Risk
  double? get injuryRiskScore;
  @override // 0-100
  List<String>? get riskFactors;
  @override
  @JsonKey(ignore: true)
  _$$TrainingLoadMetricsImplCopyWith<_$TrainingLoadMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WellnessMetrics _$WellnessMetricsFromJson(Map<String, dynamic> json) {
  return _WellnessMetrics.fromJson(json);
}

/// @nodoc
mixin _$WellnessMetrics {
// Daily Wellness
  double? get sleepQuality => throw _privateConstructorUsedError; // 0-10
  double? get sleepHours => throw _privateConstructorUsedError;
  double? get fatigue => throw _privateConstructorUsedError; // 0-10
  double? get soreness => throw _privateConstructorUsedError; // 0-10
  double? get stress => throw _privateConstructorUsedError; // 0-10
  double? get mood => throw _privateConstructorUsedError; // 0-10
// Nutrition & Hydration
  double? get hydrationLevel => throw _privateConstructorUsedError; // 0-10
  double? get nutritionQuality => throw _privateConstructorUsedError; // 0-10
// Health Indicators
  double? get bodyWeight => throw _privateConstructorUsedError; // kg
  double? get bodyFat => throw _privateConstructorUsedError; // percentage
  double? get muscleMass => throw _privateConstructorUsedError; // kg
// Injury Status
  bool? get isInjured => throw _privateConstructorUsedError;
  String? get injuryType => throw _privateConstructorUsedError;
  int? get daysUntilReturn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WellnessMetricsCopyWith<WellnessMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WellnessMetricsCopyWith<$Res> {
  factory $WellnessMetricsCopyWith(
          WellnessMetrics value, $Res Function(WellnessMetrics) then) =
      _$WellnessMetricsCopyWithImpl<$Res, WellnessMetrics>;
  @useResult
  $Res call(
      {double? sleepQuality,
      double? sleepHours,
      double? fatigue,
      double? soreness,
      double? stress,
      double? mood,
      double? hydrationLevel,
      double? nutritionQuality,
      double? bodyWeight,
      double? bodyFat,
      double? muscleMass,
      bool? isInjured,
      String? injuryType,
      int? daysUntilReturn});
}

/// @nodoc
class _$WellnessMetricsCopyWithImpl<$Res, $Val extends WellnessMetrics>
    implements $WellnessMetricsCopyWith<$Res> {
  _$WellnessMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepQuality = freezed,
    Object? sleepHours = freezed,
    Object? fatigue = freezed,
    Object? soreness = freezed,
    Object? stress = freezed,
    Object? mood = freezed,
    Object? hydrationLevel = freezed,
    Object? nutritionQuality = freezed,
    Object? bodyWeight = freezed,
    Object? bodyFat = freezed,
    Object? muscleMass = freezed,
    Object? isInjured = freezed,
    Object? injuryType = freezed,
    Object? daysUntilReturn = freezed,
  }) {
    return _then(_value.copyWith(
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      sleepHours: freezed == sleepHours
          ? _value.sleepHours
          : sleepHours // ignore: cast_nullable_to_non_nullable
              as double?,
      fatigue: freezed == fatigue
          ? _value.fatigue
          : fatigue // ignore: cast_nullable_to_non_nullable
              as double?,
      soreness: freezed == soreness
          ? _value.soreness
          : soreness // ignore: cast_nullable_to_non_nullable
              as double?,
      stress: freezed == stress
          ? _value.stress
          : stress // ignore: cast_nullable_to_non_nullable
              as double?,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as double?,
      hydrationLevel: freezed == hydrationLevel
          ? _value.hydrationLevel
          : hydrationLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      nutritionQuality: freezed == nutritionQuality
          ? _value.nutritionQuality
          : nutritionQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyWeight: freezed == bodyWeight
          ? _value.bodyWeight
          : bodyWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFat: freezed == bodyFat
          ? _value.bodyFat
          : bodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      isInjured: freezed == isInjured
          ? _value.isInjured
          : isInjured // ignore: cast_nullable_to_non_nullable
              as bool?,
      injuryType: freezed == injuryType
          ? _value.injuryType
          : injuryType // ignore: cast_nullable_to_non_nullable
              as String?,
      daysUntilReturn: freezed == daysUntilReturn
          ? _value.daysUntilReturn
          : daysUntilReturn // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WellnessMetricsImplCopyWith<$Res>
    implements $WellnessMetricsCopyWith<$Res> {
  factory _$$WellnessMetricsImplCopyWith(_$WellnessMetricsImpl value,
          $Res Function(_$WellnessMetricsImpl) then) =
      __$$WellnessMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? sleepQuality,
      double? sleepHours,
      double? fatigue,
      double? soreness,
      double? stress,
      double? mood,
      double? hydrationLevel,
      double? nutritionQuality,
      double? bodyWeight,
      double? bodyFat,
      double? muscleMass,
      bool? isInjured,
      String? injuryType,
      int? daysUntilReturn});
}

/// @nodoc
class __$$WellnessMetricsImplCopyWithImpl<$Res>
    extends _$WellnessMetricsCopyWithImpl<$Res, _$WellnessMetricsImpl>
    implements _$$WellnessMetricsImplCopyWith<$Res> {
  __$$WellnessMetricsImplCopyWithImpl(
      _$WellnessMetricsImpl _value, $Res Function(_$WellnessMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sleepQuality = freezed,
    Object? sleepHours = freezed,
    Object? fatigue = freezed,
    Object? soreness = freezed,
    Object? stress = freezed,
    Object? mood = freezed,
    Object? hydrationLevel = freezed,
    Object? nutritionQuality = freezed,
    Object? bodyWeight = freezed,
    Object? bodyFat = freezed,
    Object? muscleMass = freezed,
    Object? isInjured = freezed,
    Object? injuryType = freezed,
    Object? daysUntilReturn = freezed,
  }) {
    return _then(_$WellnessMetricsImpl(
      sleepQuality: freezed == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      sleepHours: freezed == sleepHours
          ? _value.sleepHours
          : sleepHours // ignore: cast_nullable_to_non_nullable
              as double?,
      fatigue: freezed == fatigue
          ? _value.fatigue
          : fatigue // ignore: cast_nullable_to_non_nullable
              as double?,
      soreness: freezed == soreness
          ? _value.soreness
          : soreness // ignore: cast_nullable_to_non_nullable
              as double?,
      stress: freezed == stress
          ? _value.stress
          : stress // ignore: cast_nullable_to_non_nullable
              as double?,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as double?,
      hydrationLevel: freezed == hydrationLevel
          ? _value.hydrationLevel
          : hydrationLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      nutritionQuality: freezed == nutritionQuality
          ? _value.nutritionQuality
          : nutritionQuality // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyWeight: freezed == bodyWeight
          ? _value.bodyWeight
          : bodyWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      bodyFat: freezed == bodyFat
          ? _value.bodyFat
          : bodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      isInjured: freezed == isInjured
          ? _value.isInjured
          : isInjured // ignore: cast_nullable_to_non_nullable
              as bool?,
      injuryType: freezed == injuryType
          ? _value.injuryType
          : injuryType // ignore: cast_nullable_to_non_nullable
              as String?,
      daysUntilReturn: freezed == daysUntilReturn
          ? _value.daysUntilReturn
          : daysUntilReturn // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WellnessMetricsImpl implements _WellnessMetrics {
  const _$WellnessMetricsImpl(
      {this.sleepQuality,
      this.sleepHours,
      this.fatigue,
      this.soreness,
      this.stress,
      this.mood,
      this.hydrationLevel,
      this.nutritionQuality,
      this.bodyWeight,
      this.bodyFat,
      this.muscleMass,
      this.isInjured,
      this.injuryType,
      this.daysUntilReturn});

  factory _$WellnessMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WellnessMetricsImplFromJson(json);

// Daily Wellness
  @override
  final double? sleepQuality;
// 0-10
  @override
  final double? sleepHours;
  @override
  final double? fatigue;
// 0-10
  @override
  final double? soreness;
// 0-10
  @override
  final double? stress;
// 0-10
  @override
  final double? mood;
// 0-10
// Nutrition & Hydration
  @override
  final double? hydrationLevel;
// 0-10
  @override
  final double? nutritionQuality;
// 0-10
// Health Indicators
  @override
  final double? bodyWeight;
// kg
  @override
  final double? bodyFat;
// percentage
  @override
  final double? muscleMass;
// kg
// Injury Status
  @override
  final bool? isInjured;
  @override
  final String? injuryType;
  @override
  final int? daysUntilReturn;

  @override
  String toString() {
    return 'WellnessMetrics(sleepQuality: $sleepQuality, sleepHours: $sleepHours, fatigue: $fatigue, soreness: $soreness, stress: $stress, mood: $mood, hydrationLevel: $hydrationLevel, nutritionQuality: $nutritionQuality, bodyWeight: $bodyWeight, bodyFat: $bodyFat, muscleMass: $muscleMass, isInjured: $isInjured, injuryType: $injuryType, daysUntilReturn: $daysUntilReturn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WellnessMetricsImpl &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.sleepHours, sleepHours) ||
                other.sleepHours == sleepHours) &&
            (identical(other.fatigue, fatigue) || other.fatigue == fatigue) &&
            (identical(other.soreness, soreness) ||
                other.soreness == soreness) &&
            (identical(other.stress, stress) || other.stress == stress) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.hydrationLevel, hydrationLevel) ||
                other.hydrationLevel == hydrationLevel) &&
            (identical(other.nutritionQuality, nutritionQuality) ||
                other.nutritionQuality == nutritionQuality) &&
            (identical(other.bodyWeight, bodyWeight) ||
                other.bodyWeight == bodyWeight) &&
            (identical(other.bodyFat, bodyFat) || other.bodyFat == bodyFat) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            (identical(other.isInjured, isInjured) ||
                other.isInjured == isInjured) &&
            (identical(other.injuryType, injuryType) ||
                other.injuryType == injuryType) &&
            (identical(other.daysUntilReturn, daysUntilReturn) ||
                other.daysUntilReturn == daysUntilReturn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sleepQuality,
      sleepHours,
      fatigue,
      soreness,
      stress,
      mood,
      hydrationLevel,
      nutritionQuality,
      bodyWeight,
      bodyFat,
      muscleMass,
      isInjured,
      injuryType,
      daysUntilReturn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WellnessMetricsImplCopyWith<_$WellnessMetricsImpl> get copyWith =>
      __$$WellnessMetricsImplCopyWithImpl<_$WellnessMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WellnessMetricsImplToJson(
      this,
    );
  }
}

abstract class _WellnessMetrics implements WellnessMetrics {
  const factory _WellnessMetrics(
      {final double? sleepQuality,
      final double? sleepHours,
      final double? fatigue,
      final double? soreness,
      final double? stress,
      final double? mood,
      final double? hydrationLevel,
      final double? nutritionQuality,
      final double? bodyWeight,
      final double? bodyFat,
      final double? muscleMass,
      final bool? isInjured,
      final String? injuryType,
      final int? daysUntilReturn}) = _$WellnessMetricsImpl;

  factory _WellnessMetrics.fromJson(Map<String, dynamic> json) =
      _$WellnessMetricsImpl.fromJson;

  @override // Daily Wellness
  double? get sleepQuality;
  @override // 0-10
  double? get sleepHours;
  @override
  double? get fatigue;
  @override // 0-10
  double? get soreness;
  @override // 0-10
  double? get stress;
  @override // 0-10
  double? get mood;
  @override // 0-10
// Nutrition & Hydration
  double? get hydrationLevel;
  @override // 0-10
  double? get nutritionQuality;
  @override // 0-10
// Health Indicators
  double? get bodyWeight;
  @override // kg
  double? get bodyFat;
  @override // percentage
  double? get muscleMass;
  @override // kg
// Injury Status
  bool? get isInjured;
  @override
  String? get injuryType;
  @override
  int? get daysUntilReturn;
  @override
  @JsonKey(ignore: true)
  _$$WellnessMetricsImplCopyWith<_$WellnessMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachEvaluation _$CoachEvaluationFromJson(Map<String, dynamic> json) {
  return _CoachEvaluation.fromJson(json);
}

/// @nodoc
mixin _$CoachEvaluation {
  String get coachId => throw _privateConstructorUsedError;
  DateTime get evaluationDate =>
      throw _privateConstructorUsedError; // Performance Rating
  double? get overallRating => throw _privateConstructorUsedError; // 0-10
  double? get technicalRating => throw _privateConstructorUsedError; // 0-10
  double? get tacticalRating => throw _privateConstructorUsedError; // 0-10
  double? get physicalRating => throw _privateConstructorUsedError; // 0-10
  double? get mentalRating => throw _privateConstructorUsedError; // 0-10
// Development Areas
  List<String>? get strengths => throw _privateConstructorUsedError;
  List<String>? get weaknesses => throw _privateConstructorUsedError;
  List<String>? get developmentGoals =>
      throw _privateConstructorUsedError; // Comments
  String? get generalComments => throw _privateConstructorUsedError;
  String? get improvementAdvice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoachEvaluationCopyWith<CoachEvaluation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachEvaluationCopyWith<$Res> {
  factory $CoachEvaluationCopyWith(
          CoachEvaluation value, $Res Function(CoachEvaluation) then) =
      _$CoachEvaluationCopyWithImpl<$Res, CoachEvaluation>;
  @useResult
  $Res call(
      {String coachId,
      DateTime evaluationDate,
      double? overallRating,
      double? technicalRating,
      double? tacticalRating,
      double? physicalRating,
      double? mentalRating,
      List<String>? strengths,
      List<String>? weaknesses,
      List<String>? developmentGoals,
      String? generalComments,
      String? improvementAdvice});
}

/// @nodoc
class _$CoachEvaluationCopyWithImpl<$Res, $Val extends CoachEvaluation>
    implements $CoachEvaluationCopyWith<$Res> {
  _$CoachEvaluationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coachId = null,
    Object? evaluationDate = null,
    Object? overallRating = freezed,
    Object? technicalRating = freezed,
    Object? tacticalRating = freezed,
    Object? physicalRating = freezed,
    Object? mentalRating = freezed,
    Object? strengths = freezed,
    Object? weaknesses = freezed,
    Object? developmentGoals = freezed,
    Object? generalComments = freezed,
    Object? improvementAdvice = freezed,
  }) {
    return _then(_value.copyWith(
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      evaluationDate: null == evaluationDate
          ? _value.evaluationDate
          : evaluationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      overallRating: freezed == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double?,
      technicalRating: freezed == technicalRating
          ? _value.technicalRating
          : technicalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      tacticalRating: freezed == tacticalRating
          ? _value.tacticalRating
          : tacticalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      physicalRating: freezed == physicalRating
          ? _value.physicalRating
          : physicalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      mentalRating: freezed == mentalRating
          ? _value.mentalRating
          : mentalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      strengths: freezed == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      weaknesses: freezed == weaknesses
          ? _value.weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      developmentGoals: freezed == developmentGoals
          ? _value.developmentGoals
          : developmentGoals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      generalComments: freezed == generalComments
          ? _value.generalComments
          : generalComments // ignore: cast_nullable_to_non_nullable
              as String?,
      improvementAdvice: freezed == improvementAdvice
          ? _value.improvementAdvice
          : improvementAdvice // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoachEvaluationImplCopyWith<$Res>
    implements $CoachEvaluationCopyWith<$Res> {
  factory _$$CoachEvaluationImplCopyWith(_$CoachEvaluationImpl value,
          $Res Function(_$CoachEvaluationImpl) then) =
      __$$CoachEvaluationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String coachId,
      DateTime evaluationDate,
      double? overallRating,
      double? technicalRating,
      double? tacticalRating,
      double? physicalRating,
      double? mentalRating,
      List<String>? strengths,
      List<String>? weaknesses,
      List<String>? developmentGoals,
      String? generalComments,
      String? improvementAdvice});
}

/// @nodoc
class __$$CoachEvaluationImplCopyWithImpl<$Res>
    extends _$CoachEvaluationCopyWithImpl<$Res, _$CoachEvaluationImpl>
    implements _$$CoachEvaluationImplCopyWith<$Res> {
  __$$CoachEvaluationImplCopyWithImpl(
      _$CoachEvaluationImpl _value, $Res Function(_$CoachEvaluationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coachId = null,
    Object? evaluationDate = null,
    Object? overallRating = freezed,
    Object? technicalRating = freezed,
    Object? tacticalRating = freezed,
    Object? physicalRating = freezed,
    Object? mentalRating = freezed,
    Object? strengths = freezed,
    Object? weaknesses = freezed,
    Object? developmentGoals = freezed,
    Object? generalComments = freezed,
    Object? improvementAdvice = freezed,
  }) {
    return _then(_$CoachEvaluationImpl(
      coachId: null == coachId
          ? _value.coachId
          : coachId // ignore: cast_nullable_to_non_nullable
              as String,
      evaluationDate: null == evaluationDate
          ? _value.evaluationDate
          : evaluationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      overallRating: freezed == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double?,
      technicalRating: freezed == technicalRating
          ? _value.technicalRating
          : technicalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      tacticalRating: freezed == tacticalRating
          ? _value.tacticalRating
          : tacticalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      physicalRating: freezed == physicalRating
          ? _value.physicalRating
          : physicalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      mentalRating: freezed == mentalRating
          ? _value.mentalRating
          : mentalRating // ignore: cast_nullable_to_non_nullable
              as double?,
      strengths: freezed == strengths
          ? _value._strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      weaknesses: freezed == weaknesses
          ? _value._weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      developmentGoals: freezed == developmentGoals
          ? _value._developmentGoals
          : developmentGoals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      generalComments: freezed == generalComments
          ? _value.generalComments
          : generalComments // ignore: cast_nullable_to_non_nullable
              as String?,
      improvementAdvice: freezed == improvementAdvice
          ? _value.improvementAdvice
          : improvementAdvice // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachEvaluationImpl implements _CoachEvaluation {
  const _$CoachEvaluationImpl(
      {required this.coachId,
      required this.evaluationDate,
      this.overallRating,
      this.technicalRating,
      this.tacticalRating,
      this.physicalRating,
      this.mentalRating,
      final List<String>? strengths,
      final List<String>? weaknesses,
      final List<String>? developmentGoals,
      this.generalComments,
      this.improvementAdvice})
      : _strengths = strengths,
        _weaknesses = weaknesses,
        _developmentGoals = developmentGoals;

  factory _$CoachEvaluationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachEvaluationImplFromJson(json);

  @override
  final String coachId;
  @override
  final DateTime evaluationDate;
// Performance Rating
  @override
  final double? overallRating;
// 0-10
  @override
  final double? technicalRating;
// 0-10
  @override
  final double? tacticalRating;
// 0-10
  @override
  final double? physicalRating;
// 0-10
  @override
  final double? mentalRating;
// 0-10
// Development Areas
  final List<String>? _strengths;
// 0-10
// Development Areas
  @override
  List<String>? get strengths {
    final value = _strengths;
    if (value == null) return null;
    if (_strengths is EqualUnmodifiableListView) return _strengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _weaknesses;
  @override
  List<String>? get weaknesses {
    final value = _weaknesses;
    if (value == null) return null;
    if (_weaknesses is EqualUnmodifiableListView) return _weaknesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _developmentGoals;
  @override
  List<String>? get developmentGoals {
    final value = _developmentGoals;
    if (value == null) return null;
    if (_developmentGoals is EqualUnmodifiableListView)
      return _developmentGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Comments
  @override
  final String? generalComments;
  @override
  final String? improvementAdvice;

  @override
  String toString() {
    return 'CoachEvaluation(coachId: $coachId, evaluationDate: $evaluationDate, overallRating: $overallRating, technicalRating: $technicalRating, tacticalRating: $tacticalRating, physicalRating: $physicalRating, mentalRating: $mentalRating, strengths: $strengths, weaknesses: $weaknesses, developmentGoals: $developmentGoals, generalComments: $generalComments, improvementAdvice: $improvementAdvice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachEvaluationImpl &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.evaluationDate, evaluationDate) ||
                other.evaluationDate == evaluationDate) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            (identical(other.technicalRating, technicalRating) ||
                other.technicalRating == technicalRating) &&
            (identical(other.tacticalRating, tacticalRating) ||
                other.tacticalRating == tacticalRating) &&
            (identical(other.physicalRating, physicalRating) ||
                other.physicalRating == physicalRating) &&
            (identical(other.mentalRating, mentalRating) ||
                other.mentalRating == mentalRating) &&
            const DeepCollectionEquality()
                .equals(other._strengths, _strengths) &&
            const DeepCollectionEquality()
                .equals(other._weaknesses, _weaknesses) &&
            const DeepCollectionEquality()
                .equals(other._developmentGoals, _developmentGoals) &&
            (identical(other.generalComments, generalComments) ||
                other.generalComments == generalComments) &&
            (identical(other.improvementAdvice, improvementAdvice) ||
                other.improvementAdvice == improvementAdvice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      coachId,
      evaluationDate,
      overallRating,
      technicalRating,
      tacticalRating,
      physicalRating,
      mentalRating,
      const DeepCollectionEquality().hash(_strengths),
      const DeepCollectionEquality().hash(_weaknesses),
      const DeepCollectionEquality().hash(_developmentGoals),
      generalComments,
      improvementAdvice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachEvaluationImplCopyWith<_$CoachEvaluationImpl> get copyWith =>
      __$$CoachEvaluationImplCopyWithImpl<_$CoachEvaluationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachEvaluationImplToJson(
      this,
    );
  }
}

abstract class _CoachEvaluation implements CoachEvaluation {
  const factory _CoachEvaluation(
      {required final String coachId,
      required final DateTime evaluationDate,
      final double? overallRating,
      final double? technicalRating,
      final double? tacticalRating,
      final double? physicalRating,
      final double? mentalRating,
      final List<String>? strengths,
      final List<String>? weaknesses,
      final List<String>? developmentGoals,
      final String? generalComments,
      final String? improvementAdvice}) = _$CoachEvaluationImpl;

  factory _CoachEvaluation.fromJson(Map<String, dynamic> json) =
      _$CoachEvaluationImpl.fromJson;

  @override
  String get coachId;
  @override
  DateTime get evaluationDate;
  @override // Performance Rating
  double? get overallRating;
  @override // 0-10
  double? get technicalRating;
  @override // 0-10
  double? get tacticalRating;
  @override // 0-10
  double? get physicalRating;
  @override // 0-10
  double? get mentalRating;
  @override // 0-10
// Development Areas
  List<String>? get strengths;
  @override
  List<String>? get weaknesses;
  @override
  List<String>? get developmentGoals;
  @override // Comments
  String? get generalComments;
  @override
  String? get improvementAdvice;
  @override
  @JsonKey(ignore: true)
  _$$CoachEvaluationImplCopyWith<_$CoachEvaluationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerformanceInsight _$PerformanceInsightFromJson(Map<String, dynamic> json) {
  return _PerformanceInsight.fromJson(json);
}

/// @nodoc
mixin _$PerformanceInsight {
  String get id => throw _privateConstructorUsedError;
  InsightType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  InsightPriority get priority => throw _privateConstructorUsedError;
  DateTime get generatedAt =>
      throw _privateConstructorUsedError; // Actionable Recommendations
  List<String>? get recommendations =>
      throw _privateConstructorUsedError; // Related Metrics
  Map<String, dynamic>? get relatedData =>
      throw _privateConstructorUsedError; // Trend Analysis
  String? get trend =>
      throw _privateConstructorUsedError; // improving, stable, declining
  double? get changePercentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PerformanceInsightCopyWith<PerformanceInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceInsightCopyWith<$Res> {
  factory $PerformanceInsightCopyWith(
          PerformanceInsight value, $Res Function(PerformanceInsight) then) =
      _$PerformanceInsightCopyWithImpl<$Res, PerformanceInsight>;
  @useResult
  $Res call(
      {String id,
      InsightType type,
      String title,
      String description,
      InsightPriority priority,
      DateTime generatedAt,
      List<String>? recommendations,
      Map<String, dynamic>? relatedData,
      String? trend,
      double? changePercentage});
}

/// @nodoc
class _$PerformanceInsightCopyWithImpl<$Res, $Val extends PerformanceInsight>
    implements $PerformanceInsightCopyWith<$Res> {
  _$PerformanceInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? generatedAt = null,
    Object? recommendations = freezed,
    Object? relatedData = freezed,
    Object? trend = freezed,
    Object? changePercentage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InsightType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as InsightPriority,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recommendations: freezed == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      relatedData: freezed == relatedData
          ? _value.relatedData
          : relatedData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      trend: freezed == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String?,
      changePercentage: freezed == changePercentage
          ? _value.changePercentage
          : changePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PerformanceInsightImplCopyWith<$Res>
    implements $PerformanceInsightCopyWith<$Res> {
  factory _$$PerformanceInsightImplCopyWith(_$PerformanceInsightImpl value,
          $Res Function(_$PerformanceInsightImpl) then) =
      __$$PerformanceInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      InsightType type,
      String title,
      String description,
      InsightPriority priority,
      DateTime generatedAt,
      List<String>? recommendations,
      Map<String, dynamic>? relatedData,
      String? trend,
      double? changePercentage});
}

/// @nodoc
class __$$PerformanceInsightImplCopyWithImpl<$Res>
    extends _$PerformanceInsightCopyWithImpl<$Res, _$PerformanceInsightImpl>
    implements _$$PerformanceInsightImplCopyWith<$Res> {
  __$$PerformanceInsightImplCopyWithImpl(_$PerformanceInsightImpl _value,
      $Res Function(_$PerformanceInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? generatedAt = null,
    Object? recommendations = freezed,
    Object? relatedData = freezed,
    Object? trend = freezed,
    Object? changePercentage = freezed,
  }) {
    return _then(_$PerformanceInsightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InsightType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as InsightPriority,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      recommendations: freezed == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      relatedData: freezed == relatedData
          ? _value._relatedData
          : relatedData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      trend: freezed == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String?,
      changePercentage: freezed == changePercentage
          ? _value.changePercentage
          : changePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceInsightImpl implements _PerformanceInsight {
  const _$PerformanceInsightImpl(
      {required this.id,
      required this.type,
      required this.title,
      required this.description,
      required this.priority,
      required this.generatedAt,
      final List<String>? recommendations,
      final Map<String, dynamic>? relatedData,
      this.trend,
      this.changePercentage})
      : _recommendations = recommendations,
        _relatedData = relatedData;

  factory _$PerformanceInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceInsightImplFromJson(json);

  @override
  final String id;
  @override
  final InsightType type;
  @override
  final String title;
  @override
  final String description;
  @override
  final InsightPriority priority;
  @override
  final DateTime generatedAt;
// Actionable Recommendations
  final List<String>? _recommendations;
// Actionable Recommendations
  @override
  List<String>? get recommendations {
    final value = _recommendations;
    if (value == null) return null;
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Related Metrics
  final Map<String, dynamic>? _relatedData;
// Related Metrics
  @override
  Map<String, dynamic>? get relatedData {
    final value = _relatedData;
    if (value == null) return null;
    if (_relatedData is EqualUnmodifiableMapView) return _relatedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Trend Analysis
  @override
  final String? trend;
// improving, stable, declining
  @override
  final double? changePercentage;

  @override
  String toString() {
    return 'PerformanceInsight(id: $id, type: $type, title: $title, description: $description, priority: $priority, generatedAt: $generatedAt, recommendations: $recommendations, relatedData: $relatedData, trend: $trend, changePercentage: $changePercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceInsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            const DeepCollectionEquality()
                .equals(other._relatedData, _relatedData) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.changePercentage, changePercentage) ||
                other.changePercentage == changePercentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      description,
      priority,
      generatedAt,
      const DeepCollectionEquality().hash(_recommendations),
      const DeepCollectionEquality().hash(_relatedData),
      trend,
      changePercentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceInsightImplCopyWith<_$PerformanceInsightImpl> get copyWith =>
      __$$PerformanceInsightImplCopyWithImpl<_$PerformanceInsightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceInsightImplToJson(
      this,
    );
  }
}

abstract class _PerformanceInsight implements PerformanceInsight {
  const factory _PerformanceInsight(
      {required final String id,
      required final InsightType type,
      required final String title,
      required final String description,
      required final InsightPriority priority,
      required final DateTime generatedAt,
      final List<String>? recommendations,
      final Map<String, dynamic>? relatedData,
      final String? trend,
      final double? changePercentage}) = _$PerformanceInsightImpl;

  factory _PerformanceInsight.fromJson(Map<String, dynamic> json) =
      _$PerformanceInsightImpl.fromJson;

  @override
  String get id;
  @override
  InsightType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  InsightPriority get priority;
  @override
  DateTime get generatedAt;
  @override // Actionable Recommendations
  List<String>? get recommendations;
  @override // Related Metrics
  Map<String, dynamic>? get relatedData;
  @override // Trend Analysis
  String? get trend;
  @override // improving, stable, declining
  double? get changePercentage;
  @override
  @JsonKey(ignore: true)
  _$$PerformanceInsightImplCopyWith<_$PerformanceInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
