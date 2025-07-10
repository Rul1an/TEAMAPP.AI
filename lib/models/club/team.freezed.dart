// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Team _$TeamFromJson(Map<String, dynamic> json) {
  return _Team.fromJson(json);
}

/// @nodoc
mixin _$Team {
  String get id => throw _privateConstructorUsedError;
  String get clubId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortName =>
      throw _privateConstructorUsedError; // Team Classification
  AgeCategory get ageCategory => throw _privateConstructorUsedError;
  TeamLevel get level => throw _privateConstructorUsedError;
  TeamGender get gender => throw _privateConstructorUsedError; // Details
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get colors =>
      throw _privateConstructorUsedError; // Season Information
  String get currentSeason => throw _privateConstructorUsedError;
  String? get league => throw _privateConstructorUsedError;
  String? get division => throw _privateConstructorUsedError; // Settings
  TeamSettings get settings => throw _privateConstructorUsedError; // Staff
  List<String> get staffIds => throw _privateConstructorUsedError;
  String? get headCoachId => throw _privateConstructorUsedError;
  String? get assistantCoachId => throw _privateConstructorUsedError;
  String? get teamManagerId => throw _privateConstructorUsedError; // Players
  List<String> get playerIds => throw _privateConstructorUsedError;
  List<String> get captainIds => throw _privateConstructorUsedError; // Status
  TeamStatus get status => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamCopyWith<Team> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamCopyWith<$Res> {
  factory $TeamCopyWith(Team value, $Res Function(Team) then) =
      _$TeamCopyWithImpl<$Res, Team>;
  @useResult
  $Res call({
    String id,
    String clubId,
    String name,
    String shortName,
    AgeCategory ageCategory,
    TeamLevel level,
    TeamGender gender,
    String? description,
    String? logoUrl,
    String? colors,
    String currentSeason,
    String? league,
    String? division,
    TeamSettings settings,
    List<String> staffIds,
    String? headCoachId,
    String? assistantCoachId,
    String? teamManagerId,
    List<String> playerIds,
    List<String> captainIds,
    TeamStatus status,
    DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  });

  $TeamSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$TeamCopyWithImpl<$Res, $Val extends Team>
    implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? shortName = null,
    Object? ageCategory = null,
    Object? level = null,
    Object? gender = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? colors = freezed,
    Object? currentSeason = null,
    Object? league = freezed,
    Object? division = freezed,
    Object? settings = null,
    Object? staffIds = null,
    Object? headCoachId = freezed,
    Object? assistantCoachId = freezed,
    Object? teamManagerId = freezed,
    Object? playerIds = null,
    Object? captainIds = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            clubId: null == clubId
                ? _value.clubId
                : clubId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            shortName: null == shortName
                ? _value.shortName
                : shortName // ignore: cast_nullable_to_non_nullable
                      as String,
            ageCategory: null == ageCategory
                ? _value.ageCategory
                : ageCategory // ignore: cast_nullable_to_non_nullable
                      as AgeCategory,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as TeamLevel,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as TeamGender,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            colors: freezed == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentSeason: null == currentSeason
                ? _value.currentSeason
                : currentSeason // ignore: cast_nullable_to_non_nullable
                      as String,
            league: freezed == league
                ? _value.league
                : league // ignore: cast_nullable_to_non_nullable
                      as String?,
            division: freezed == division
                ? _value.division
                : division // ignore: cast_nullable_to_non_nullable
                      as String?,
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as TeamSettings,
            staffIds: null == staffIds
                ? _value.staffIds
                : staffIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            headCoachId: freezed == headCoachId
                ? _value.headCoachId
                : headCoachId // ignore: cast_nullable_to_non_nullable
                      as String?,
            assistantCoachId: freezed == assistantCoachId
                ? _value.assistantCoachId
                : assistantCoachId // ignore: cast_nullable_to_non_nullable
                      as String?,
            teamManagerId: freezed == teamManagerId
                ? _value.teamManagerId
                : teamManagerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            playerIds: null == playerIds
                ? _value.playerIds
                : playerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            captainIds: null == captainIds
                ? _value.captainIds
                : captainIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TeamStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedBy: freezed == updatedBy
                ? _value.updatedBy
                : updatedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamSettingsCopyWith<$Res> get settings {
    return $TeamSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamImplCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$$TeamImplCopyWith(
    _$TeamImpl value,
    $Res Function(_$TeamImpl) then,
  ) = __$$TeamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clubId,
    String name,
    String shortName,
    AgeCategory ageCategory,
    TeamLevel level,
    TeamGender gender,
    String? description,
    String? logoUrl,
    String? colors,
    String currentSeason,
    String? league,
    String? division,
    TeamSettings settings,
    List<String> staffIds,
    String? headCoachId,
    String? assistantCoachId,
    String? teamManagerId,
    List<String> playerIds,
    List<String> captainIds,
    TeamStatus status,
    DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  });

  @override
  $TeamSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$TeamImplCopyWithImpl<$Res>
    extends _$TeamCopyWithImpl<$Res, _$TeamImpl>
    implements _$$TeamImplCopyWith<$Res> {
  __$$TeamImplCopyWithImpl(_$TeamImpl _value, $Res Function(_$TeamImpl) _then)
    : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? shortName = null,
    Object? ageCategory = null,
    Object? level = null,
    Object? gender = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? colors = freezed,
    Object? currentSeason = null,
    Object? league = freezed,
    Object? division = freezed,
    Object? settings = null,
    Object? staffIds = null,
    Object? headCoachId = freezed,
    Object? assistantCoachId = freezed,
    Object? teamManagerId = freezed,
    Object? playerIds = null,
    Object? captainIds = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _$TeamImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        clubId: null == clubId
            ? _value.clubId
            : clubId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortName: null == shortName
            ? _value.shortName
            : shortName // ignore: cast_nullable_to_non_nullable
                  as String,
        ageCategory: null == ageCategory
            ? _value.ageCategory
            : ageCategory // ignore: cast_nullable_to_non_nullable
                  as AgeCategory,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as TeamLevel,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as TeamGender,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        colors: freezed == colors
            ? _value.colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentSeason: null == currentSeason
            ? _value.currentSeason
            : currentSeason // ignore: cast_nullable_to_non_nullable
                  as String,
        league: freezed == league
            ? _value.league
            : league // ignore: cast_nullable_to_non_nullable
                  as String?,
        division: freezed == division
            ? _value.division
            : division // ignore: cast_nullable_to_non_nullable
                  as String?,
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as TeamSettings,
        staffIds: null == staffIds
            ? _value._staffIds
            : staffIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        headCoachId: freezed == headCoachId
            ? _value.headCoachId
            : headCoachId // ignore: cast_nullable_to_non_nullable
                  as String?,
        assistantCoachId: freezed == assistantCoachId
            ? _value.assistantCoachId
            : assistantCoachId // ignore: cast_nullable_to_non_nullable
                  as String?,
        teamManagerId: freezed == teamManagerId
            ? _value.teamManagerId
            : teamManagerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        playerIds: null == playerIds
            ? _value._playerIds
            : playerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        captainIds: null == captainIds
            ? _value._captainIds
            : captainIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TeamStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedBy: freezed == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamImpl implements _Team {
  const _$TeamImpl({
    required this.id,
    required this.clubId,
    required this.name,
    required this.shortName,
    required this.ageCategory,
    required this.level,
    required this.gender,
    this.description,
    this.logoUrl,
    this.colors,
    required this.currentSeason,
    this.league,
    this.division,
    required this.settings,
    final List<String> staffIds = const [],
    this.headCoachId,
    this.assistantCoachId,
    this.teamManagerId,
    final List<String> playerIds = const [],
    final List<String> captainIds = const [],
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  }) : _staffIds = staffIds,
       _playerIds = playerIds,
       _captainIds = captainIds;

  factory _$TeamImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String name;
  @override
  final String shortName;
  // Team Classification
  @override
  final AgeCategory ageCategory;
  @override
  final TeamLevel level;
  @override
  final TeamGender gender;
  // Details
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? colors;
  // Season Information
  @override
  final String currentSeason;
  @override
  final String? league;
  @override
  final String? division;
  // Settings
  @override
  final TeamSettings settings;
  // Staff
  final List<String> _staffIds;
  // Staff
  @override
  @JsonKey()
  List<String> get staffIds {
    if (_staffIds is EqualUnmodifiableListView) return _staffIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staffIds);
  }

  @override
  final String? headCoachId;
  @override
  final String? assistantCoachId;
  @override
  final String? teamManagerId;
  // Players
  final List<String> _playerIds;
  // Players
  @override
  @JsonKey()
  List<String> get playerIds {
    if (_playerIds is EqualUnmodifiableListView) return _playerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerIds);
  }

  final List<String> _captainIds;
  @override
  @JsonKey()
  List<String> get captainIds {
    if (_captainIds is EqualUnmodifiableListView) return _captainIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_captainIds);
  }

  // Status
  @override
  final TeamStatus status;
  // Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'Team(id: $id, clubId: $clubId, name: $name, shortName: $shortName, ageCategory: $ageCategory, level: $level, gender: $gender, description: $description, logoUrl: $logoUrl, colors: $colors, currentSeason: $currentSeason, league: $league, division: $division, settings: $settings, staffIds: $staffIds, headCoachId: $headCoachId, assistantCoachId: $assistantCoachId, teamManagerId: $teamManagerId, playerIds: $playerIds, captainIds: $captainIds, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.ageCategory, ageCategory) ||
                other.ageCategory == ageCategory) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.colors, colors) || other.colors == colors) &&
            (identical(other.currentSeason, currentSeason) ||
                other.currentSeason == currentSeason) &&
            (identical(other.league, league) || other.league == league) &&
            (identical(other.division, division) ||
                other.division == division) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality().equals(other._staffIds, _staffIds) &&
            (identical(other.headCoachId, headCoachId) ||
                other.headCoachId == headCoachId) &&
            (identical(other.assistantCoachId, assistantCoachId) ||
                other.assistantCoachId == assistantCoachId) &&
            (identical(other.teamManagerId, teamManagerId) ||
                other.teamManagerId == teamManagerId) &&
            const DeepCollectionEquality().equals(
              other._playerIds,
              _playerIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._captainIds,
              _captainIds,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    clubId,
    name,
    shortName,
    ageCategory,
    level,
    gender,
    description,
    logoUrl,
    colors,
    currentSeason,
    league,
    division,
    settings,
    const DeepCollectionEquality().hash(_staffIds),
    headCoachId,
    assistantCoachId,
    teamManagerId,
    const DeepCollectionEquality().hash(_playerIds),
    const DeepCollectionEquality().hash(_captainIds),
    status,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamImplCopyWith<_$TeamImpl> get copyWith =>
      __$$TeamImplCopyWithImpl<_$TeamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamImplToJson(this);
  }
}

abstract class _Team implements Team {
  const factory _Team({
    required final String id,
    required final String clubId,
    required final String name,
    required final String shortName,
    required final AgeCategory ageCategory,
    required final TeamLevel level,
    required final TeamGender gender,
    final String? description,
    final String? logoUrl,
    final String? colors,
    required final String currentSeason,
    final String? league,
    final String? division,
    required final TeamSettings settings,
    final List<String> staffIds,
    final String? headCoachId,
    final String? assistantCoachId,
    final String? teamManagerId,
    final List<String> playerIds,
    final List<String> captainIds,
    required final TeamStatus status,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final String? createdBy,
    final String? updatedBy,
  }) = _$TeamImpl;

  factory _Team.fromJson(Map<String, dynamic> json) = _$TeamImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override
  String get name;
  @override
  String get shortName;
  @override // Team Classification
  AgeCategory get ageCategory;
  @override
  TeamLevel get level;
  @override
  TeamGender get gender;
  @override // Details
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get colors;
  @override // Season Information
  String get currentSeason;
  @override
  String? get league;
  @override
  String? get division;
  @override // Settings
  TeamSettings get settings;
  @override // Staff
  List<String> get staffIds;
  @override
  String? get headCoachId;
  @override
  String? get assistantCoachId;
  @override
  String? get teamManagerId;
  @override // Players
  List<String> get playerIds;
  @override
  List<String> get captainIds;
  @override // Status
  TeamStatus get status;
  @override // Metadata
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$TeamImplCopyWith<_$TeamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamSettings _$TeamSettingsFromJson(Map<String, dynamic> json) {
  return _TeamSettings.fromJson(json);
}

/// @nodoc
mixin _$TeamSettings {
  // Training
  int get trainingsPerWeek => throw _privateConstructorUsedError;
  int get defaultTrainingDuration => throw _privateConstructorUsedError;
  List<String> get trainingDays => throw _privateConstructorUsedError; // Match
  String get matchDay => throw _privateConstructorUsedError;
  int get defaultMatchDuration =>
      throw _privateConstructorUsedError; // Communication
  bool get allowParentCommunication => throw _privateConstructorUsedError;
  bool get sendTrainingReminders => throw _privateConstructorUsedError;
  bool get sendMatchReminders =>
      throw _privateConstructorUsedError; // Performance
  bool get trackPlayerPerformance => throw _privateConstructorUsedError;
  bool get enableVideoAnalysis => throw _privateConstructorUsedError;
  bool get enableGPSTracking =>
      throw _privateConstructorUsedError; // Administrative
  bool get requireMedicalCertificate => throw _privateConstructorUsedError;
  bool get requireInsurance => throw _privateConstructorUsedError;
  bool get requireVOG => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamSettingsCopyWith<TeamSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamSettingsCopyWith<$Res> {
  factory $TeamSettingsCopyWith(
    TeamSettings value,
    $Res Function(TeamSettings) then,
  ) = _$TeamSettingsCopyWithImpl<$Res, TeamSettings>;
  @useResult
  $Res call({
    int trainingsPerWeek,
    int defaultTrainingDuration,
    List<String> trainingDays,
    String matchDay,
    int defaultMatchDuration,
    bool allowParentCommunication,
    bool sendTrainingReminders,
    bool sendMatchReminders,
    bool trackPlayerPerformance,
    bool enableVideoAnalysis,
    bool enableGPSTracking,
    bool requireMedicalCertificate,
    bool requireInsurance,
    bool requireVOG,
  });
}

/// @nodoc
class _$TeamSettingsCopyWithImpl<$Res, $Val extends TeamSettings>
    implements $TeamSettingsCopyWith<$Res> {
  _$TeamSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainingsPerWeek = null,
    Object? defaultTrainingDuration = null,
    Object? trainingDays = null,
    Object? matchDay = null,
    Object? defaultMatchDuration = null,
    Object? allowParentCommunication = null,
    Object? sendTrainingReminders = null,
    Object? sendMatchReminders = null,
    Object? trackPlayerPerformance = null,
    Object? enableVideoAnalysis = null,
    Object? enableGPSTracking = null,
    Object? requireMedicalCertificate = null,
    Object? requireInsurance = null,
    Object? requireVOG = null,
  }) {
    return _then(
      _value.copyWith(
            trainingsPerWeek: null == trainingsPerWeek
                ? _value.trainingsPerWeek
                : trainingsPerWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            defaultTrainingDuration: null == defaultTrainingDuration
                ? _value.defaultTrainingDuration
                : defaultTrainingDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            trainingDays: null == trainingDays
                ? _value.trainingDays
                : trainingDays // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            matchDay: null == matchDay
                ? _value.matchDay
                : matchDay // ignore: cast_nullable_to_non_nullable
                      as String,
            defaultMatchDuration: null == defaultMatchDuration
                ? _value.defaultMatchDuration
                : defaultMatchDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            allowParentCommunication: null == allowParentCommunication
                ? _value.allowParentCommunication
                : allowParentCommunication // ignore: cast_nullable_to_non_nullable
                      as bool,
            sendTrainingReminders: null == sendTrainingReminders
                ? _value.sendTrainingReminders
                : sendTrainingReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            sendMatchReminders: null == sendMatchReminders
                ? _value.sendMatchReminders
                : sendMatchReminders // ignore: cast_nullable_to_non_nullable
                      as bool,
            trackPlayerPerformance: null == trackPlayerPerformance
                ? _value.trackPlayerPerformance
                : trackPlayerPerformance // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableVideoAnalysis: null == enableVideoAnalysis
                ? _value.enableVideoAnalysis
                : enableVideoAnalysis // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableGPSTracking: null == enableGPSTracking
                ? _value.enableGPSTracking
                : enableGPSTracking // ignore: cast_nullable_to_non_nullable
                      as bool,
            requireMedicalCertificate: null == requireMedicalCertificate
                ? _value.requireMedicalCertificate
                : requireMedicalCertificate // ignore: cast_nullable_to_non_nullable
                      as bool,
            requireInsurance: null == requireInsurance
                ? _value.requireInsurance
                : requireInsurance // ignore: cast_nullable_to_non_nullable
                      as bool,
            requireVOG: null == requireVOG
                ? _value.requireVOG
                : requireVOG // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamSettingsImplCopyWith<$Res>
    implements $TeamSettingsCopyWith<$Res> {
  factory _$$TeamSettingsImplCopyWith(
    _$TeamSettingsImpl value,
    $Res Function(_$TeamSettingsImpl) then,
  ) = __$$TeamSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int trainingsPerWeek,
    int defaultTrainingDuration,
    List<String> trainingDays,
    String matchDay,
    int defaultMatchDuration,
    bool allowParentCommunication,
    bool sendTrainingReminders,
    bool sendMatchReminders,
    bool trackPlayerPerformance,
    bool enableVideoAnalysis,
    bool enableGPSTracking,
    bool requireMedicalCertificate,
    bool requireInsurance,
    bool requireVOG,
  });
}

/// @nodoc
class __$$TeamSettingsImplCopyWithImpl<$Res>
    extends _$TeamSettingsCopyWithImpl<$Res, _$TeamSettingsImpl>
    implements _$$TeamSettingsImplCopyWith<$Res> {
  __$$TeamSettingsImplCopyWithImpl(
    _$TeamSettingsImpl _value,
    $Res Function(_$TeamSettingsImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainingsPerWeek = null,
    Object? defaultTrainingDuration = null,
    Object? trainingDays = null,
    Object? matchDay = null,
    Object? defaultMatchDuration = null,
    Object? allowParentCommunication = null,
    Object? sendTrainingReminders = null,
    Object? sendMatchReminders = null,
    Object? trackPlayerPerformance = null,
    Object? enableVideoAnalysis = null,
    Object? enableGPSTracking = null,
    Object? requireMedicalCertificate = null,
    Object? requireInsurance = null,
    Object? requireVOG = null,
  }) {
    return _then(
      _$TeamSettingsImpl(
        trainingsPerWeek: null == trainingsPerWeek
            ? _value.trainingsPerWeek
            : trainingsPerWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        defaultTrainingDuration: null == defaultTrainingDuration
            ? _value.defaultTrainingDuration
            : defaultTrainingDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        trainingDays: null == trainingDays
            ? _value._trainingDays
            : trainingDays // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        matchDay: null == matchDay
            ? _value.matchDay
            : matchDay // ignore: cast_nullable_to_non_nullable
                  as String,
        defaultMatchDuration: null == defaultMatchDuration
            ? _value.defaultMatchDuration
            : defaultMatchDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        allowParentCommunication: null == allowParentCommunication
            ? _value.allowParentCommunication
            : allowParentCommunication // ignore: cast_nullable_to_non_nullable
                  as bool,
        sendTrainingReminders: null == sendTrainingReminders
            ? _value.sendTrainingReminders
            : sendTrainingReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        sendMatchReminders: null == sendMatchReminders
            ? _value.sendMatchReminders
            : sendMatchReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        trackPlayerPerformance: null == trackPlayerPerformance
            ? _value.trackPlayerPerformance
            : trackPlayerPerformance // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableVideoAnalysis: null == enableVideoAnalysis
            ? _value.enableVideoAnalysis
            : enableVideoAnalysis // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableGPSTracking: null == enableGPSTracking
            ? _value.enableGPSTracking
            : enableGPSTracking // ignore: cast_nullable_to_non_nullable
                  as bool,
        requireMedicalCertificate: null == requireMedicalCertificate
            ? _value.requireMedicalCertificate
            : requireMedicalCertificate // ignore: cast_nullable_to_non_nullable
                  as bool,
        requireInsurance: null == requireInsurance
            ? _value.requireInsurance
            : requireInsurance // ignore: cast_nullable_to_non_nullable
                  as bool,
        requireVOG: null == requireVOG
            ? _value.requireVOG
            : requireVOG // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamSettingsImpl implements _TeamSettings {
  const _$TeamSettingsImpl({
    this.trainingsPerWeek = 2,
    this.defaultTrainingDuration = 90,
    final List<String> trainingDays = const ['Tuesday', 'Thursday'],
    this.matchDay = 'Saturday',
    this.defaultMatchDuration = 90,
    this.allowParentCommunication = true,
    this.sendTrainingReminders = true,
    this.sendMatchReminders = true,
    this.trackPlayerPerformance = true,
    this.enableVideoAnalysis = true,
    this.enableGPSTracking = false,
    this.requireMedicalCertificate = true,
    this.requireInsurance = true,
    this.requireVOG = false,
  }) : _trainingDays = trainingDays;

  factory _$TeamSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamSettingsImplFromJson(json);

  // Training
  @override
  @JsonKey()
  final int trainingsPerWeek;
  @override
  @JsonKey()
  final int defaultTrainingDuration;
  final List<String> _trainingDays;
  @override
  @JsonKey()
  List<String> get trainingDays {
    if (_trainingDays is EqualUnmodifiableListView) return _trainingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trainingDays);
  }

  // Match
  @override
  @JsonKey()
  final String matchDay;
  @override
  @JsonKey()
  final int defaultMatchDuration;
  // Communication
  @override
  @JsonKey()
  final bool allowParentCommunication;
  @override
  @JsonKey()
  final bool sendTrainingReminders;
  @override
  @JsonKey()
  final bool sendMatchReminders;
  // Performance
  @override
  @JsonKey()
  final bool trackPlayerPerformance;
  @override
  @JsonKey()
  final bool enableVideoAnalysis;
  @override
  @JsonKey()
  final bool enableGPSTracking;
  // Administrative
  @override
  @JsonKey()
  final bool requireMedicalCertificate;
  @override
  @JsonKey()
  final bool requireInsurance;
  @override
  @JsonKey()
  final bool requireVOG;

  @override
  String toString() {
    return 'TeamSettings(trainingsPerWeek: $trainingsPerWeek, defaultTrainingDuration: $defaultTrainingDuration, trainingDays: $trainingDays, matchDay: $matchDay, defaultMatchDuration: $defaultMatchDuration, allowParentCommunication: $allowParentCommunication, sendTrainingReminders: $sendTrainingReminders, sendMatchReminders: $sendMatchReminders, trackPlayerPerformance: $trackPlayerPerformance, enableVideoAnalysis: $enableVideoAnalysis, enableGPSTracking: $enableGPSTracking, requireMedicalCertificate: $requireMedicalCertificate, requireInsurance: $requireInsurance, requireVOG: $requireVOG)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamSettingsImpl &&
            (identical(other.trainingsPerWeek, trainingsPerWeek) ||
                other.trainingsPerWeek == trainingsPerWeek) &&
            (identical(
                  other.defaultTrainingDuration,
                  defaultTrainingDuration,
                ) ||
                other.defaultTrainingDuration == defaultTrainingDuration) &&
            const DeepCollectionEquality().equals(
              other._trainingDays,
              _trainingDays,
            ) &&
            (identical(other.matchDay, matchDay) ||
                other.matchDay == matchDay) &&
            (identical(other.defaultMatchDuration, defaultMatchDuration) ||
                other.defaultMatchDuration == defaultMatchDuration) &&
            (identical(
                  other.allowParentCommunication,
                  allowParentCommunication,
                ) ||
                other.allowParentCommunication == allowParentCommunication) &&
            (identical(other.sendTrainingReminders, sendTrainingReminders) ||
                other.sendTrainingReminders == sendTrainingReminders) &&
            (identical(other.sendMatchReminders, sendMatchReminders) ||
                other.sendMatchReminders == sendMatchReminders) &&
            (identical(other.trackPlayerPerformance, trackPlayerPerformance) ||
                other.trackPlayerPerformance == trackPlayerPerformance) &&
            (identical(other.enableVideoAnalysis, enableVideoAnalysis) ||
                other.enableVideoAnalysis == enableVideoAnalysis) &&
            (identical(other.enableGPSTracking, enableGPSTracking) ||
                other.enableGPSTracking == enableGPSTracking) &&
            (identical(
                  other.requireMedicalCertificate,
                  requireMedicalCertificate,
                ) ||
                other.requireMedicalCertificate == requireMedicalCertificate) &&
            (identical(other.requireInsurance, requireInsurance) ||
                other.requireInsurance == requireInsurance) &&
            (identical(other.requireVOG, requireVOG) ||
                other.requireVOG == requireVOG));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    trainingsPerWeek,
    defaultTrainingDuration,
    const DeepCollectionEquality().hash(_trainingDays),
    matchDay,
    defaultMatchDuration,
    allowParentCommunication,
    sendTrainingReminders,
    sendMatchReminders,
    trackPlayerPerformance,
    enableVideoAnalysis,
    enableGPSTracking,
    requireMedicalCertificate,
    requireInsurance,
    requireVOG,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamSettingsImplCopyWith<_$TeamSettingsImpl> get copyWith =>
      __$$TeamSettingsImplCopyWithImpl<_$TeamSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamSettingsImplToJson(this);
  }
}

abstract class _TeamSettings implements TeamSettings {
  const factory _TeamSettings({
    final int trainingsPerWeek,
    final int defaultTrainingDuration,
    final List<String> trainingDays,
    final String matchDay,
    final int defaultMatchDuration,
    final bool allowParentCommunication,
    final bool sendTrainingReminders,
    final bool sendMatchReminders,
    final bool trackPlayerPerformance,
    final bool enableVideoAnalysis,
    final bool enableGPSTracking,
    final bool requireMedicalCertificate,
    final bool requireInsurance,
    final bool requireVOG,
  }) = _$TeamSettingsImpl;

  factory _TeamSettings.fromJson(Map<String, dynamic> json) =
      _$TeamSettingsImpl.fromJson;

  @override // Training
  int get trainingsPerWeek;
  @override
  int get defaultTrainingDuration;
  @override
  List<String> get trainingDays;
  @override // Match
  String get matchDay;
  @override
  int get defaultMatchDuration;
  @override // Communication
  bool get allowParentCommunication;
  @override
  bool get sendTrainingReminders;
  @override
  bool get sendMatchReminders;
  @override // Performance
  bool get trackPlayerPerformance;
  @override
  bool get enableVideoAnalysis;
  @override
  bool get enableGPSTracking;
  @override // Administrative
  bool get requireMedicalCertificate;
  @override
  bool get requireInsurance;
  @override
  bool get requireVOG;
  @override
  @JsonKey(ignore: true)
  _$$TeamSettingsImplCopyWith<_$TeamSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
