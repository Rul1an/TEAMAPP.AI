// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Club _$ClubFromJson(Map<String, dynamic> json) {
  return _Club.fromJson(json);
}

/// @nodoc
mixin _$Club {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError; // Address
  String? get street => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError; // Club Details
  DateTime get foundedDate => throw _privateConstructorUsedError;
  String? get colors => throw _privateConstructorUsedError;
  String? get motto => throw _privateConstructorUsedError; // SaaS Properties
  ClubTier get tier => throw _privateConstructorUsedError;
  List<Team> get teams => throw _privateConstructorUsedError;
  List<StaffMember> get staff => throw _privateConstructorUsedError; // Settings
  ClubSettings get settings => throw _privateConstructorUsedError; // Status
  ClubStatus get status => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClubCopyWith<Club> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubCopyWith<$Res> {
  factory $ClubCopyWith(Club value, $Res Function(Club) then) =
      _$ClubCopyWithImpl<$Res, Club>;
  @useResult
  $Res call({
    String id,
    String name,
    String shortName,
    String? description,
    String? logoUrl,
    String? website,
    String? email,
    String? phone,
    String? street,
    String? city,
    String? postalCode,
    String? country,
    DateTime foundedDate,
    String? colors,
    String? motto,
    ClubTier tier,
    List<Team> teams,
    List<StaffMember> staff,
    ClubSettings settings,
    ClubStatus status,
    DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  });

  $ClubSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$ClubCopyWithImpl<$Res, $Val extends Club>
    implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? foundedDate = null,
    Object? colors = freezed,
    Object? motto = freezed,
    Object? tier = null,
    Object? teams = null,
    Object? staff = null,
    Object? settings = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            shortName: null == shortName
                ? _value.shortName
                : shortName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            website: freezed == website
                ? _value.website
                : website // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            street: freezed == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            postalCode: freezed == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            foundedDate: null == foundedDate
                ? _value.foundedDate
                : foundedDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            colors: freezed == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as String?,
            motto: freezed == motto
                ? _value.motto
                : motto // ignore: cast_nullable_to_non_nullable
                      as String?,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as ClubTier,
            teams: null == teams
                ? _value.teams
                : teams // ignore: cast_nullable_to_non_nullable
                      as List<Team>,
            staff: null == staff
                ? _value.staff
                : staff // ignore: cast_nullable_to_non_nullable
                      as List<StaffMember>,
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as ClubSettings,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ClubStatus,
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
  $ClubSettingsCopyWith<$Res> get settings {
    return $ClubSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClubImplCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$$ClubImplCopyWith(
    _$ClubImpl value,
    $Res Function(_$ClubImpl) then,
  ) = __$$ClubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String shortName,
    String? description,
    String? logoUrl,
    String? website,
    String? email,
    String? phone,
    String? street,
    String? city,
    String? postalCode,
    String? country,
    DateTime foundedDate,
    String? colors,
    String? motto,
    ClubTier tier,
    List<Team> teams,
    List<StaffMember> staff,
    ClubSettings settings,
    ClubStatus status,
    DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  });

  @override
  $ClubSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$ClubImplCopyWithImpl<$Res>
    extends _$ClubCopyWithImpl<$Res, _$ClubImpl>
    implements _$$ClubImplCopyWith<$Res> {
  __$$ClubImplCopyWithImpl(_$ClubImpl _value, $Res Function(_$ClubImpl) _then)
    : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? foundedDate = null,
    Object? colors = freezed,
    Object? motto = freezed,
    Object? tier = null,
    Object? teams = null,
    Object? staff = null,
    Object? settings = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(
      _$ClubImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortName: null == shortName
            ? _value.shortName
            : shortName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        website: freezed == website
            ? _value.website
            : website // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        street: freezed == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        postalCode: freezed == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        foundedDate: null == foundedDate
            ? _value.foundedDate
            : foundedDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        colors: freezed == colors
            ? _value.colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as String?,
        motto: freezed == motto
            ? _value.motto
            : motto // ignore: cast_nullable_to_non_nullable
                  as String?,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as ClubTier,
        teams: null == teams
            ? _value._teams
            : teams // ignore: cast_nullable_to_non_nullable
                  as List<Team>,
        staff: null == staff
            ? _value._staff
            : staff // ignore: cast_nullable_to_non_nullable
                  as List<StaffMember>,
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as ClubSettings,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ClubStatus,
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
class _$ClubImpl extends _Club {
  const _$ClubImpl({
    required this.id,
    required this.name,
    required this.shortName,
    this.description,
    this.logoUrl,
    this.website,
    this.email,
    this.phone,
    this.street,
    this.city,
    this.postalCode,
    this.country,
    required this.foundedDate,
    this.colors,
    this.motto,
    this.tier = ClubTier.basic,
    final List<Team> teams = const [],
    final List<StaffMember> staff = const [],
    required this.settings,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  }) : _teams = teams,
       _staff = staff,
       super._();

  factory _$ClubImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String shortName;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? website;
  @override
  final String? email;
  @override
  final String? phone;
  // Address
  @override
  final String? street;
  @override
  final String? city;
  @override
  final String? postalCode;
  @override
  final String? country;
  // Club Details
  @override
  final DateTime foundedDate;
  @override
  final String? colors;
  @override
  final String? motto;
  // SaaS Properties
  @override
  @JsonKey()
  final ClubTier tier;
  final List<Team> _teams;
  @override
  @JsonKey()
  List<Team> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  final List<StaffMember> _staff;
  @override
  @JsonKey()
  List<StaffMember> get staff {
    if (_staff is EqualUnmodifiableListView) return _staff;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staff);
  }

  // Settings
  @override
  final ClubSettings settings;
  // Status
  @override
  final ClubStatus status;
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
    return 'Club(id: $id, name: $name, shortName: $shortName, description: $description, logoUrl: $logoUrl, website: $website, email: $email, phone: $phone, street: $street, city: $city, postalCode: $postalCode, country: $country, foundedDate: $foundedDate, colors: $colors, motto: $motto, tier: $tier, teams: $teams, staff: $staff, settings: $settings, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.foundedDate, foundedDate) ||
                other.foundedDate == foundedDate) &&
            (identical(other.colors, colors) || other.colors == colors) &&
            (identical(other.motto, motto) || other.motto == motto) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            const DeepCollectionEquality().equals(other._teams, _teams) &&
            const DeepCollectionEquality().equals(other._staff, _staff) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
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
    name,
    shortName,
    description,
    logoUrl,
    website,
    email,
    phone,
    street,
    city,
    postalCode,
    country,
    foundedDate,
    colors,
    motto,
    tier,
    const DeepCollectionEquality().hash(_teams),
    const DeepCollectionEquality().hash(_staff),
    settings,
    status,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith =>
      __$$ClubImplCopyWithImpl<_$ClubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubImplToJson(this);
  }
}

abstract class _Club extends Club {
  const factory _Club({
    required final String id,
    required final String name,
    required final String shortName,
    final String? description,
    final String? logoUrl,
    final String? website,
    final String? email,
    final String? phone,
    final String? street,
    final String? city,
    final String? postalCode,
    final String? country,
    required final DateTime foundedDate,
    final String? colors,
    final String? motto,
    final ClubTier tier,
    final List<Team> teams,
    final List<StaffMember> staff,
    required final ClubSettings settings,
    required final ClubStatus status,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final String? createdBy,
    final String? updatedBy,
  }) = _$ClubImpl;
  const _Club._() : super._();

  factory _Club.fromJson(Map<String, dynamic> json) = _$ClubImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get shortName;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get website;
  @override
  String? get email;
  @override
  String? get phone;
  @override // Address
  String? get street;
  @override
  String? get city;
  @override
  String? get postalCode;
  @override
  String? get country;
  @override // Club Details
  DateTime get foundedDate;
  @override
  String? get colors;
  @override
  String? get motto;
  @override // SaaS Properties
  ClubTier get tier;
  @override
  List<Team> get teams;
  @override
  List<StaffMember> get staff;
  @override // Settings
  ClubSettings get settings;
  @override // Status
  ClubStatus get status;
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
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClubSettings _$ClubSettingsFromJson(Map<String, dynamic> json) {
  return _ClubSettings.fromJson(json);
}

/// @nodoc
mixin _$ClubSettings {
  // General
  String get defaultLanguage => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError; // Features
  bool get enablePlayerTracking => throw _privateConstructorUsedError;
  bool get enableCommunication => throw _privateConstructorUsedError;
  bool get enableFinancialManagement => throw _privateConstructorUsedError;
  bool get enableAdvancedAnalytics =>
      throw _privateConstructorUsedError; // Privacy
  bool get allowParentAccess => throw _privateConstructorUsedError;
  bool get allowPlayerSelfRegistration => throw _privateConstructorUsedError;
  bool get requireVOGForStaff =>
      throw _privateConstructorUsedError; // Notifications
  bool get emailNotifications => throw _privateConstructorUsedError;
  bool get pushNotifications => throw _privateConstructorUsedError;
  bool get smsNotifications => throw _privateConstructorUsedError; // Training
  int get defaultTrainingDuration => throw _privateConstructorUsedError;
  int get defaultMatchDuration =>
      throw _privateConstructorUsedError; // Data Retention
  int get dataRetentionYears => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClubSettingsCopyWith<ClubSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubSettingsCopyWith<$Res> {
  factory $ClubSettingsCopyWith(
    ClubSettings value,
    $Res Function(ClubSettings) then,
  ) = _$ClubSettingsCopyWithImpl<$Res, ClubSettings>;
  @useResult
  $Res call({
    String defaultLanguage,
    String currency,
    String timezone,
    bool enablePlayerTracking,
    bool enableCommunication,
    bool enableFinancialManagement,
    bool enableAdvancedAnalytics,
    bool allowParentAccess,
    bool allowPlayerSelfRegistration,
    bool requireVOGForStaff,
    bool emailNotifications,
    bool pushNotifications,
    bool smsNotifications,
    int defaultTrainingDuration,
    int defaultMatchDuration,
    int dataRetentionYears,
  });
}

/// @nodoc
class _$ClubSettingsCopyWithImpl<$Res, $Val extends ClubSettings>
    implements $ClubSettingsCopyWith<$Res> {
  _$ClubSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultLanguage = null,
    Object? currency = null,
    Object? timezone = null,
    Object? enablePlayerTracking = null,
    Object? enableCommunication = null,
    Object? enableFinancialManagement = null,
    Object? enableAdvancedAnalytics = null,
    Object? allowParentAccess = null,
    Object? allowPlayerSelfRegistration = null,
    Object? requireVOGForStaff = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? defaultTrainingDuration = null,
    Object? defaultMatchDuration = null,
    Object? dataRetentionYears = null,
  }) {
    return _then(
      _value.copyWith(
            defaultLanguage: null == defaultLanguage
                ? _value.defaultLanguage
                : defaultLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            timezone: null == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String,
            enablePlayerTracking: null == enablePlayerTracking
                ? _value.enablePlayerTracking
                : enablePlayerTracking // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableCommunication: null == enableCommunication
                ? _value.enableCommunication
                : enableCommunication // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableFinancialManagement: null == enableFinancialManagement
                ? _value.enableFinancialManagement
                : enableFinancialManagement // ignore: cast_nullable_to_non_nullable
                      as bool,
            enableAdvancedAnalytics: null == enableAdvancedAnalytics
                ? _value.enableAdvancedAnalytics
                : enableAdvancedAnalytics // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowParentAccess: null == allowParentAccess
                ? _value.allowParentAccess
                : allowParentAccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowPlayerSelfRegistration: null == allowPlayerSelfRegistration
                ? _value.allowPlayerSelfRegistration
                : allowPlayerSelfRegistration // ignore: cast_nullable_to_non_nullable
                      as bool,
            requireVOGForStaff: null == requireVOGForStaff
                ? _value.requireVOGForStaff
                : requireVOGForStaff // ignore: cast_nullable_to_non_nullable
                      as bool,
            emailNotifications: null == emailNotifications
                ? _value.emailNotifications
                : emailNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            pushNotifications: null == pushNotifications
                ? _value.pushNotifications
                : pushNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            smsNotifications: null == smsNotifications
                ? _value.smsNotifications
                : smsNotifications // ignore: cast_nullable_to_non_nullable
                      as bool,
            defaultTrainingDuration: null == defaultTrainingDuration
                ? _value.defaultTrainingDuration
                : defaultTrainingDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            defaultMatchDuration: null == defaultMatchDuration
                ? _value.defaultMatchDuration
                : defaultMatchDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            dataRetentionYears: null == dataRetentionYears
                ? _value.dataRetentionYears
                : dataRetentionYears // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClubSettingsImplCopyWith<$Res>
    implements $ClubSettingsCopyWith<$Res> {
  factory _$$ClubSettingsImplCopyWith(
    _$ClubSettingsImpl value,
    $Res Function(_$ClubSettingsImpl) then,
  ) = __$$ClubSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String defaultLanguage,
    String currency,
    String timezone,
    bool enablePlayerTracking,
    bool enableCommunication,
    bool enableFinancialManagement,
    bool enableAdvancedAnalytics,
    bool allowParentAccess,
    bool allowPlayerSelfRegistration,
    bool requireVOGForStaff,
    bool emailNotifications,
    bool pushNotifications,
    bool smsNotifications,
    int defaultTrainingDuration,
    int defaultMatchDuration,
    int dataRetentionYears,
  });
}

/// @nodoc
class __$$ClubSettingsImplCopyWithImpl<$Res>
    extends _$ClubSettingsCopyWithImpl<$Res, _$ClubSettingsImpl>
    implements _$$ClubSettingsImplCopyWith<$Res> {
  __$$ClubSettingsImplCopyWithImpl(
    _$ClubSettingsImpl _value,
    $Res Function(_$ClubSettingsImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultLanguage = null,
    Object? currency = null,
    Object? timezone = null,
    Object? enablePlayerTracking = null,
    Object? enableCommunication = null,
    Object? enableFinancialManagement = null,
    Object? enableAdvancedAnalytics = null,
    Object? allowParentAccess = null,
    Object? allowPlayerSelfRegistration = null,
    Object? requireVOGForStaff = null,
    Object? emailNotifications = null,
    Object? pushNotifications = null,
    Object? smsNotifications = null,
    Object? defaultTrainingDuration = null,
    Object? defaultMatchDuration = null,
    Object? dataRetentionYears = null,
  }) {
    return _then(
      _$ClubSettingsImpl(
        defaultLanguage: null == defaultLanguage
            ? _value.defaultLanguage
            : defaultLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        timezone: null == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        enablePlayerTracking: null == enablePlayerTracking
            ? _value.enablePlayerTracking
            : enablePlayerTracking // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableCommunication: null == enableCommunication
            ? _value.enableCommunication
            : enableCommunication // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableFinancialManagement: null == enableFinancialManagement
            ? _value.enableFinancialManagement
            : enableFinancialManagement // ignore: cast_nullable_to_non_nullable
                  as bool,
        enableAdvancedAnalytics: null == enableAdvancedAnalytics
            ? _value.enableAdvancedAnalytics
            : enableAdvancedAnalytics // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowParentAccess: null == allowParentAccess
            ? _value.allowParentAccess
            : allowParentAccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowPlayerSelfRegistration: null == allowPlayerSelfRegistration
            ? _value.allowPlayerSelfRegistration
            : allowPlayerSelfRegistration // ignore: cast_nullable_to_non_nullable
                  as bool,
        requireVOGForStaff: null == requireVOGForStaff
            ? _value.requireVOGForStaff
            : requireVOGForStaff // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailNotifications: null == emailNotifications
            ? _value.emailNotifications
            : emailNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        pushNotifications: null == pushNotifications
            ? _value.pushNotifications
            : pushNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        smsNotifications: null == smsNotifications
            ? _value.smsNotifications
            : smsNotifications // ignore: cast_nullable_to_non_nullable
                  as bool,
        defaultTrainingDuration: null == defaultTrainingDuration
            ? _value.defaultTrainingDuration
            : defaultTrainingDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        defaultMatchDuration: null == defaultMatchDuration
            ? _value.defaultMatchDuration
            : defaultMatchDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        dataRetentionYears: null == dataRetentionYears
            ? _value.dataRetentionYears
            : dataRetentionYears // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubSettingsImpl implements _ClubSettings {
  const _$ClubSettingsImpl({
    this.defaultLanguage = 'nl',
    this.currency = 'EUR',
    this.timezone = 'Europe/Amsterdam',
    this.enablePlayerTracking = true,
    this.enableCommunication = true,
    this.enableFinancialManagement = false,
    this.enableAdvancedAnalytics = false,
    this.allowParentAccess = true,
    this.allowPlayerSelfRegistration = false,
    this.requireVOGForStaff = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.defaultTrainingDuration = 90,
    this.defaultMatchDuration = 90,
    this.dataRetentionYears = 7,
  });

  factory _$ClubSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubSettingsImplFromJson(json);

  // General
  @override
  @JsonKey()
  final String defaultLanguage;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String timezone;
  // Features
  @override
  @JsonKey()
  final bool enablePlayerTracking;
  @override
  @JsonKey()
  final bool enableCommunication;
  @override
  @JsonKey()
  final bool enableFinancialManagement;
  @override
  @JsonKey()
  final bool enableAdvancedAnalytics;
  // Privacy
  @override
  @JsonKey()
  final bool allowParentAccess;
  @override
  @JsonKey()
  final bool allowPlayerSelfRegistration;
  @override
  @JsonKey()
  final bool requireVOGForStaff;
  // Notifications
  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  final bool pushNotifications;
  @override
  @JsonKey()
  final bool smsNotifications;
  // Training
  @override
  @JsonKey()
  final int defaultTrainingDuration;
  @override
  @JsonKey()
  final int defaultMatchDuration;
  // Data Retention
  @override
  @JsonKey()
  final int dataRetentionYears;

  @override
  String toString() {
    return 'ClubSettings(defaultLanguage: $defaultLanguage, currency: $currency, timezone: $timezone, enablePlayerTracking: $enablePlayerTracking, enableCommunication: $enableCommunication, enableFinancialManagement: $enableFinancialManagement, enableAdvancedAnalytics: $enableAdvancedAnalytics, allowParentAccess: $allowParentAccess, allowPlayerSelfRegistration: $allowPlayerSelfRegistration, requireVOGForStaff: $requireVOGForStaff, emailNotifications: $emailNotifications, pushNotifications: $pushNotifications, smsNotifications: $smsNotifications, defaultTrainingDuration: $defaultTrainingDuration, defaultMatchDuration: $defaultMatchDuration, dataRetentionYears: $dataRetentionYears)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubSettingsImpl &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.enablePlayerTracking, enablePlayerTracking) ||
                other.enablePlayerTracking == enablePlayerTracking) &&
            (identical(other.enableCommunication, enableCommunication) ||
                other.enableCommunication == enableCommunication) &&
            (identical(
                  other.enableFinancialManagement,
                  enableFinancialManagement,
                ) ||
                other.enableFinancialManagement == enableFinancialManagement) &&
            (identical(
                  other.enableAdvancedAnalytics,
                  enableAdvancedAnalytics,
                ) ||
                other.enableAdvancedAnalytics == enableAdvancedAnalytics) &&
            (identical(other.allowParentAccess, allowParentAccess) ||
                other.allowParentAccess == allowParentAccess) &&
            (identical(
                  other.allowPlayerSelfRegistration,
                  allowPlayerSelfRegistration,
                ) ||
                other.allowPlayerSelfRegistration ==
                    allowPlayerSelfRegistration) &&
            (identical(other.requireVOGForStaff, requireVOGForStaff) ||
                other.requireVOGForStaff == requireVOGForStaff) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.smsNotifications, smsNotifications) ||
                other.smsNotifications == smsNotifications) &&
            (identical(
                  other.defaultTrainingDuration,
                  defaultTrainingDuration,
                ) ||
                other.defaultTrainingDuration == defaultTrainingDuration) &&
            (identical(other.defaultMatchDuration, defaultMatchDuration) ||
                other.defaultMatchDuration == defaultMatchDuration) &&
            (identical(other.dataRetentionYears, dataRetentionYears) ||
                other.dataRetentionYears == dataRetentionYears));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    defaultLanguage,
    currency,
    timezone,
    enablePlayerTracking,
    enableCommunication,
    enableFinancialManagement,
    enableAdvancedAnalytics,
    allowParentAccess,
    allowPlayerSelfRegistration,
    requireVOGForStaff,
    emailNotifications,
    pushNotifications,
    smsNotifications,
    defaultTrainingDuration,
    defaultMatchDuration,
    dataRetentionYears,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubSettingsImplCopyWith<_$ClubSettingsImpl> get copyWith =>
      __$$ClubSettingsImplCopyWithImpl<_$ClubSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubSettingsImplToJson(this);
  }
}

abstract class _ClubSettings implements ClubSettings {
  const factory _ClubSettings({
    final String defaultLanguage,
    final String currency,
    final String timezone,
    final bool enablePlayerTracking,
    final bool enableCommunication,
    final bool enableFinancialManagement,
    final bool enableAdvancedAnalytics,
    final bool allowParentAccess,
    final bool allowPlayerSelfRegistration,
    final bool requireVOGForStaff,
    final bool emailNotifications,
    final bool pushNotifications,
    final bool smsNotifications,
    final int defaultTrainingDuration,
    final int defaultMatchDuration,
    final int dataRetentionYears,
  }) = _$ClubSettingsImpl;

  factory _ClubSettings.fromJson(Map<String, dynamic> json) =
      _$ClubSettingsImpl.fromJson;

  @override // General
  String get defaultLanguage;
  @override
  String get currency;
  @override
  String get timezone;
  @override // Features
  bool get enablePlayerTracking;
  @override
  bool get enableCommunication;
  @override
  bool get enableFinancialManagement;
  @override
  bool get enableAdvancedAnalytics;
  @override // Privacy
  bool get allowParentAccess;
  @override
  bool get allowPlayerSelfRegistration;
  @override
  bool get requireVOGForStaff;
  @override // Notifications
  bool get emailNotifications;
  @override
  bool get pushNotifications;
  @override
  bool get smsNotifications;
  @override // Training
  int get defaultTrainingDuration;
  @override
  int get defaultMatchDuration;
  @override // Data Retention
  int get dataRetentionYears;
  @override
  @JsonKey(ignore: true)
  _$$ClubSettingsImplCopyWith<_$ClubSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
