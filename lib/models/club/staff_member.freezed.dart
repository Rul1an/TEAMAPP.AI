// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StaffMember _$StaffMemberFromJson(Map<String, dynamic> json) {
  return _StaffMember.fromJson(json);
}

/// @nodoc
mixin _$StaffMember {
  String get id => throw _privateConstructorUsedError;
  String get clubId =>
      throw _privateConstructorUsedError; // Personal Information
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  String? get nickname =>
      throw _privateConstructorUsedError; // Contact Information
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get emergencyContact => throw _privateConstructorUsedError;
  String? get emergencyPhone => throw _privateConstructorUsedError; // Address
  String? get street => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String? get country =>
      throw _privateConstructorUsedError; // Professional Information
  StaffRole get primaryRole => throw _privateConstructorUsedError;
  List<StaffRole> get additionalRoles => throw _privateConstructorUsedError;
  String? get employeeNumber => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError; // Qualifications
  List<Qualification> get qualifications => throw _privateConstructorUsedError;
  List<Certificate> get certificates =>
      throw _privateConstructorUsedError; // Permissions
  StaffPermissions get permissions =>
      throw _privateConstructorUsedError; // Teams
  List<String> get teamIds => throw _privateConstructorUsedError;
  List<String> get primaryTeamIds =>
      throw _privateConstructorUsedError; // Availability
  StaffAvailability get availability =>
      throw _privateConstructorUsedError; // Documents
  bool? get hasVOG => throw _privateConstructorUsedError;
  DateTime? get vogExpiryDate => throw _privateConstructorUsedError;
  bool? get hasMedicalCertificate => throw _privateConstructorUsedError;
  DateTime? get medicalCertificateExpiry => throw _privateConstructorUsedError;
  bool? get hasInsurance => throw _privateConstructorUsedError; // Status
  StaffStatus get status => throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StaffMemberCopyWith<StaffMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffMemberCopyWith<$Res> {
  factory $StaffMemberCopyWith(
          StaffMember value, $Res Function(StaffMember) then) =
      _$StaffMemberCopyWithImpl<$Res, StaffMember>;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String firstName,
      String lastName,
      String? middleName,
      String? nickname,
      String email,
      String? phone,
      String? emergencyContact,
      String? emergencyPhone,
      String? street,
      String? city,
      String? postalCode,
      String? country,
      StaffRole primaryRole,
      List<StaffRole> additionalRoles,
      String? employeeNumber,
      DateTime? startDate,
      DateTime? endDate,
      List<Qualification> qualifications,
      List<Certificate> certificates,
      StaffPermissions permissions,
      List<String> teamIds,
      List<String> primaryTeamIds,
      StaffAvailability availability,
      bool? hasVOG,
      DateTime? vogExpiryDate,
      bool? hasMedicalCertificate,
      DateTime? medicalCertificateExpiry,
      bool? hasInsurance,
      StaffStatus status,
      DateTime createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});

  $StaffPermissionsCopyWith<$Res> get permissions;
  $StaffAvailabilityCopyWith<$Res> get availability;
}

/// @nodoc
class _$StaffMemberCopyWithImpl<$Res, $Val extends StaffMember>
    implements $StaffMemberCopyWith<$Res> {
  _$StaffMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? middleName = freezed,
    Object? nickname = freezed,
    Object? email = null,
    Object? phone = freezed,
    Object? emergencyContact = freezed,
    Object? emergencyPhone = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? primaryRole = null,
    Object? additionalRoles = null,
    Object? employeeNumber = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? qualifications = null,
    Object? certificates = null,
    Object? permissions = null,
    Object? teamIds = null,
    Object? primaryTeamIds = null,
    Object? availability = null,
    Object? hasVOG = freezed,
    Object? vogExpiryDate = freezed,
    Object? hasMedicalCertificate = freezed,
    Object? medicalCertificateExpiry = freezed,
    Object? hasInsurance = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyPhone: freezed == emergencyPhone
          ? _value.emergencyPhone
          : emergencyPhone // ignore: cast_nullable_to_non_nullable
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
      primaryRole: null == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as StaffRole,
      additionalRoles: null == additionalRoles
          ? _value.additionalRoles
          : additionalRoles // ignore: cast_nullable_to_non_nullable
              as List<StaffRole>,
      employeeNumber: freezed == employeeNumber
          ? _value.employeeNumber
          : employeeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      qualifications: null == qualifications
          ? _value.qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<Qualification>,
      certificates: null == certificates
          ? _value.certificates
          : certificates // ignore: cast_nullable_to_non_nullable
              as List<Certificate>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as StaffPermissions,
      teamIds: null == teamIds
          ? _value.teamIds
          : teamIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      primaryTeamIds: null == primaryTeamIds
          ? _value.primaryTeamIds
          : primaryTeamIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availability: null == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as StaffAvailability,
      hasVOG: freezed == hasVOG
          ? _value.hasVOG
          : hasVOG // ignore: cast_nullable_to_non_nullable
              as bool?,
      vogExpiryDate: freezed == vogExpiryDate
          ? _value.vogExpiryDate
          : vogExpiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasMedicalCertificate: freezed == hasMedicalCertificate
          ? _value.hasMedicalCertificate
          : hasMedicalCertificate // ignore: cast_nullable_to_non_nullable
              as bool?,
      medicalCertificateExpiry: freezed == medicalCertificateExpiry
          ? _value.medicalCertificateExpiry
          : medicalCertificateExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasInsurance: freezed == hasInsurance
          ? _value.hasInsurance
          : hasInsurance // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StaffStatus,
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
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StaffPermissionsCopyWith<$Res> get permissions {
    return $StaffPermissionsCopyWith<$Res>(_value.permissions, (value) {
      return _then(_value.copyWith(permissions: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StaffAvailabilityCopyWith<$Res> get availability {
    return $StaffAvailabilityCopyWith<$Res>(_value.availability, (value) {
      return _then(_value.copyWith(availability: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StaffMemberImplCopyWith<$Res>
    implements $StaffMemberCopyWith<$Res> {
  factory _$$StaffMemberImplCopyWith(
          _$StaffMemberImpl value, $Res Function(_$StaffMemberImpl) then) =
      __$$StaffMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String firstName,
      String lastName,
      String? middleName,
      String? nickname,
      String email,
      String? phone,
      String? emergencyContact,
      String? emergencyPhone,
      String? street,
      String? city,
      String? postalCode,
      String? country,
      StaffRole primaryRole,
      List<StaffRole> additionalRoles,
      String? employeeNumber,
      DateTime? startDate,
      DateTime? endDate,
      List<Qualification> qualifications,
      List<Certificate> certificates,
      StaffPermissions permissions,
      List<String> teamIds,
      List<String> primaryTeamIds,
      StaffAvailability availability,
      bool? hasVOG,
      DateTime? vogExpiryDate,
      bool? hasMedicalCertificate,
      DateTime? medicalCertificateExpiry,
      bool? hasInsurance,
      StaffStatus status,
      DateTime createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});

  @override
  $StaffPermissionsCopyWith<$Res> get permissions;
  @override
  $StaffAvailabilityCopyWith<$Res> get availability;
}

/// @nodoc
class __$$StaffMemberImplCopyWithImpl<$Res>
    extends _$StaffMemberCopyWithImpl<$Res, _$StaffMemberImpl>
    implements _$$StaffMemberImplCopyWith<$Res> {
  __$$StaffMemberImplCopyWithImpl(
      _$StaffMemberImpl _value, $Res Function(_$StaffMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? middleName = freezed,
    Object? nickname = freezed,
    Object? email = null,
    Object? phone = freezed,
    Object? emergencyContact = freezed,
    Object? emergencyPhone = freezed,
    Object? street = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? primaryRole = null,
    Object? additionalRoles = null,
    Object? employeeNumber = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? qualifications = null,
    Object? certificates = null,
    Object? permissions = null,
    Object? teamIds = null,
    Object? primaryTeamIds = null,
    Object? availability = null,
    Object? hasVOG = freezed,
    Object? vogExpiryDate = freezed,
    Object? hasMedicalCertificate = freezed,
    Object? medicalCertificateExpiry = freezed,
    Object? hasInsurance = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$StaffMemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _value.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyPhone: freezed == emergencyPhone
          ? _value.emergencyPhone
          : emergencyPhone // ignore: cast_nullable_to_non_nullable
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
      primaryRole: null == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as StaffRole,
      additionalRoles: null == additionalRoles
          ? _value._additionalRoles
          : additionalRoles // ignore: cast_nullable_to_non_nullable
              as List<StaffRole>,
      employeeNumber: freezed == employeeNumber
          ? _value.employeeNumber
          : employeeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      qualifications: null == qualifications
          ? _value._qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<Qualification>,
      certificates: null == certificates
          ? _value._certificates
          : certificates // ignore: cast_nullable_to_non_nullable
              as List<Certificate>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as StaffPermissions,
      teamIds: null == teamIds
          ? _value._teamIds
          : teamIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      primaryTeamIds: null == primaryTeamIds
          ? _value._primaryTeamIds
          : primaryTeamIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availability: null == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as StaffAvailability,
      hasVOG: freezed == hasVOG
          ? _value.hasVOG
          : hasVOG // ignore: cast_nullable_to_non_nullable
              as bool?,
      vogExpiryDate: freezed == vogExpiryDate
          ? _value.vogExpiryDate
          : vogExpiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasMedicalCertificate: freezed == hasMedicalCertificate
          ? _value.hasMedicalCertificate
          : hasMedicalCertificate // ignore: cast_nullable_to_non_nullable
              as bool?,
      medicalCertificateExpiry: freezed == medicalCertificateExpiry
          ? _value.medicalCertificateExpiry
          : medicalCertificateExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasInsurance: freezed == hasInsurance
          ? _value.hasInsurance
          : hasInsurance // ignore: cast_nullable_to_non_nullable
              as bool?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as StaffStatus,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffMemberImpl implements _StaffMember {
  const _$StaffMemberImpl(
      {required this.id,
      required this.clubId,
      required this.firstName,
      required this.lastName,
      this.middleName,
      this.nickname,
      required this.email,
      this.phone,
      this.emergencyContact,
      this.emergencyPhone,
      this.street,
      this.city,
      this.postalCode,
      this.country,
      required this.primaryRole,
      final List<StaffRole> additionalRoles = const [],
      this.employeeNumber,
      this.startDate,
      this.endDate,
      final List<Qualification> qualifications = const [],
      final List<Certificate> certificates = const [],
      required this.permissions,
      final List<String> teamIds = const [],
      final List<String> primaryTeamIds = const [],
      required this.availability,
      this.hasVOG,
      this.vogExpiryDate,
      this.hasMedicalCertificate,
      this.medicalCertificateExpiry,
      this.hasInsurance,
      required this.status,
      required this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _additionalRoles = additionalRoles,
        _qualifications = qualifications,
        _certificates = certificates,
        _teamIds = teamIds,
        _primaryTeamIds = primaryTeamIds;

  factory _$StaffMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
// Personal Information
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? middleName;
  @override
  final String? nickname;
// Contact Information
  @override
  final String email;
  @override
  final String? phone;
  @override
  final String? emergencyContact;
  @override
  final String? emergencyPhone;
// Address
  @override
  final String? street;
  @override
  final String? city;
  @override
  final String? postalCode;
  @override
  final String? country;
// Professional Information
  @override
  final StaffRole primaryRole;
  final List<StaffRole> _additionalRoles;
  @override
  @JsonKey()
  List<StaffRole> get additionalRoles {
    if (_additionalRoles is EqualUnmodifiableListView) return _additionalRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_additionalRoles);
  }

  @override
  final String? employeeNumber;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
// Qualifications
  final List<Qualification> _qualifications;
// Qualifications
  @override
  @JsonKey()
  List<Qualification> get qualifications {
    if (_qualifications is EqualUnmodifiableListView) return _qualifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_qualifications);
  }

  final List<Certificate> _certificates;
  @override
  @JsonKey()
  List<Certificate> get certificates {
    if (_certificates is EqualUnmodifiableListView) return _certificates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certificates);
  }

// Permissions
  @override
  final StaffPermissions permissions;
// Teams
  final List<String> _teamIds;
// Teams
  @override
  @JsonKey()
  List<String> get teamIds {
    if (_teamIds is EqualUnmodifiableListView) return _teamIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teamIds);
  }

  final List<String> _primaryTeamIds;
  @override
  @JsonKey()
  List<String> get primaryTeamIds {
    if (_primaryTeamIds is EqualUnmodifiableListView) return _primaryTeamIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_primaryTeamIds);
  }

// Availability
  @override
  final StaffAvailability availability;
// Documents
  @override
  final bool? hasVOG;
  @override
  final DateTime? vogExpiryDate;
  @override
  final bool? hasMedicalCertificate;
  @override
  final DateTime? medicalCertificateExpiry;
  @override
  final bool? hasInsurance;
// Status
  @override
  final StaffStatus status;
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
    return 'StaffMember(id: $id, clubId: $clubId, firstName: $firstName, lastName: $lastName, middleName: $middleName, nickname: $nickname, email: $email, phone: $phone, emergencyContact: $emergencyContact, emergencyPhone: $emergencyPhone, street: $street, city: $city, postalCode: $postalCode, country: $country, primaryRole: $primaryRole, additionalRoles: $additionalRoles, employeeNumber: $employeeNumber, startDate: $startDate, endDate: $endDate, qualifications: $qualifications, certificates: $certificates, permissions: $permissions, teamIds: $teamIds, primaryTeamIds: $primaryTeamIds, availability: $availability, hasVOG: $hasVOG, vogExpiryDate: $vogExpiryDate, hasMedicalCertificate: $hasMedicalCertificate, medicalCertificateExpiry: $medicalCertificateExpiry, hasInsurance: $hasInsurance, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            (identical(other.emergencyPhone, emergencyPhone) ||
                other.emergencyPhone == emergencyPhone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.primaryRole, primaryRole) ||
                other.primaryRole == primaryRole) &&
            const DeepCollectionEquality()
                .equals(other._additionalRoles, _additionalRoles) &&
            (identical(other.employeeNumber, employeeNumber) ||
                other.employeeNumber == employeeNumber) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._qualifications, _qualifications) &&
            const DeepCollectionEquality()
                .equals(other._certificates, _certificates) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            const DeepCollectionEquality().equals(other._teamIds, _teamIds) &&
            const DeepCollectionEquality()
                .equals(other._primaryTeamIds, _primaryTeamIds) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.hasVOG, hasVOG) || other.hasVOG == hasVOG) &&
            (identical(other.vogExpiryDate, vogExpiryDate) ||
                other.vogExpiryDate == vogExpiryDate) &&
            (identical(other.hasMedicalCertificate, hasMedicalCertificate) ||
                other.hasMedicalCertificate == hasMedicalCertificate) &&
            (identical(
                    other.medicalCertificateExpiry, medicalCertificateExpiry) ||
                other.medicalCertificateExpiry == medicalCertificateExpiry) &&
            (identical(other.hasInsurance, hasInsurance) ||
                other.hasInsurance == hasInsurance) &&
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
        firstName,
        lastName,
        middleName,
        nickname,
        email,
        phone,
        emergencyContact,
        emergencyPhone,
        street,
        city,
        postalCode,
        country,
        primaryRole,
        const DeepCollectionEquality().hash(_additionalRoles),
        employeeNumber,
        startDate,
        endDate,
        const DeepCollectionEquality().hash(_qualifications),
        const DeepCollectionEquality().hash(_certificates),
        permissions,
        const DeepCollectionEquality().hash(_teamIds),
        const DeepCollectionEquality().hash(_primaryTeamIds),
        availability,
        hasVOG,
        vogExpiryDate,
        hasMedicalCertificate,
        medicalCertificateExpiry,
        hasInsurance,
        status,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffMemberImplCopyWith<_$StaffMemberImpl> get copyWith =>
      __$$StaffMemberImplCopyWithImpl<_$StaffMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffMemberImplToJson(
      this,
    );
  }
}

abstract class _StaffMember implements StaffMember {
  const factory _StaffMember(
      {required final String id,
      required final String clubId,
      required final String firstName,
      required final String lastName,
      final String? middleName,
      final String? nickname,
      required final String email,
      final String? phone,
      final String? emergencyContact,
      final String? emergencyPhone,
      final String? street,
      final String? city,
      final String? postalCode,
      final String? country,
      required final StaffRole primaryRole,
      final List<StaffRole> additionalRoles,
      final String? employeeNumber,
      final DateTime? startDate,
      final DateTime? endDate,
      final List<Qualification> qualifications,
      final List<Certificate> certificates,
      required final StaffPermissions permissions,
      final List<String> teamIds,
      final List<String> primaryTeamIds,
      required final StaffAvailability availability,
      final bool? hasVOG,
      final DateTime? vogExpiryDate,
      final bool? hasMedicalCertificate,
      final DateTime? medicalCertificateExpiry,
      final bool? hasInsurance,
      required final StaffStatus status,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$StaffMemberImpl;

  factory _StaffMember.fromJson(Map<String, dynamic> json) =
      _$StaffMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get clubId;
  @override // Personal Information
  String get firstName;
  @override
  String get lastName;
  @override
  String? get middleName;
  @override
  String? get nickname;
  @override // Contact Information
  String get email;
  @override
  String? get phone;
  @override
  String? get emergencyContact;
  @override
  String? get emergencyPhone;
  @override // Address
  String? get street;
  @override
  String? get city;
  @override
  String? get postalCode;
  @override
  String? get country;
  @override // Professional Information
  StaffRole get primaryRole;
  @override
  List<StaffRole> get additionalRoles;
  @override
  String? get employeeNumber;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override // Qualifications
  List<Qualification> get qualifications;
  @override
  List<Certificate> get certificates;
  @override // Permissions
  StaffPermissions get permissions;
  @override // Teams
  List<String> get teamIds;
  @override
  List<String> get primaryTeamIds;
  @override // Availability
  StaffAvailability get availability;
  @override // Documents
  bool? get hasVOG;
  @override
  DateTime? get vogExpiryDate;
  @override
  bool? get hasMedicalCertificate;
  @override
  DateTime? get medicalCertificateExpiry;
  @override
  bool? get hasInsurance;
  @override // Status
  StaffStatus get status;
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
  _$$StaffMemberImplCopyWith<_$StaffMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StaffPermissions _$StaffPermissionsFromJson(Map<String, dynamic> json) {
  return _StaffPermissions.fromJson(json);
}

/// @nodoc
mixin _$StaffPermissions {
// Administrative
  bool get canManageClub => throw _privateConstructorUsedError;
  bool get canManageTeams => throw _privateConstructorUsedError;
  bool get canManageStaff => throw _privateConstructorUsedError;
  bool get canManagePlayers =>
      throw _privateConstructorUsedError; // Training & Matches
  bool get canCreateTraining => throw _privateConstructorUsedError;
  bool get canEditTraining => throw _privateConstructorUsedError;
  bool get canDeleteTraining => throw _privateConstructorUsedError;
  bool get canManageMatches =>
      throw _privateConstructorUsedError; // Performance & Analytics
  bool get canViewPlayerData => throw _privateConstructorUsedError;
  bool get canEditPlayerData => throw _privateConstructorUsedError;
  bool get canViewAnalytics => throw _privateConstructorUsedError;
  bool get canExportData => throw _privateConstructorUsedError; // Communication
  bool get canSendMessages => throw _privateConstructorUsedError;
  bool get canManageCommunication => throw _privateConstructorUsedError;
  bool get canAccessParentPortal =>
      throw _privateConstructorUsedError; // Financial
  bool get canViewFinancials => throw _privateConstructorUsedError;
  bool get canManagePayments => throw _privateConstructorUsedError;
  bool get canGenerateInvoices => throw _privateConstructorUsedError; // System
  bool get canManageSettings => throw _privateConstructorUsedError;
  bool get canViewLogs => throw _privateConstructorUsedError;
  bool get canManageIntegrations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StaffPermissionsCopyWith<StaffPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffPermissionsCopyWith<$Res> {
  factory $StaffPermissionsCopyWith(
          StaffPermissions value, $Res Function(StaffPermissions) then) =
      _$StaffPermissionsCopyWithImpl<$Res, StaffPermissions>;
  @useResult
  $Res call(
      {bool canManageClub,
      bool canManageTeams,
      bool canManageStaff,
      bool canManagePlayers,
      bool canCreateTraining,
      bool canEditTraining,
      bool canDeleteTraining,
      bool canManageMatches,
      bool canViewPlayerData,
      bool canEditPlayerData,
      bool canViewAnalytics,
      bool canExportData,
      bool canSendMessages,
      bool canManageCommunication,
      bool canAccessParentPortal,
      bool canViewFinancials,
      bool canManagePayments,
      bool canGenerateInvoices,
      bool canManageSettings,
      bool canViewLogs,
      bool canManageIntegrations});
}

/// @nodoc
class _$StaffPermissionsCopyWithImpl<$Res, $Val extends StaffPermissions>
    implements $StaffPermissionsCopyWith<$Res> {
  _$StaffPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canManageClub = null,
    Object? canManageTeams = null,
    Object? canManageStaff = null,
    Object? canManagePlayers = null,
    Object? canCreateTraining = null,
    Object? canEditTraining = null,
    Object? canDeleteTraining = null,
    Object? canManageMatches = null,
    Object? canViewPlayerData = null,
    Object? canEditPlayerData = null,
    Object? canViewAnalytics = null,
    Object? canExportData = null,
    Object? canSendMessages = null,
    Object? canManageCommunication = null,
    Object? canAccessParentPortal = null,
    Object? canViewFinancials = null,
    Object? canManagePayments = null,
    Object? canGenerateInvoices = null,
    Object? canManageSettings = null,
    Object? canViewLogs = null,
    Object? canManageIntegrations = null,
  }) {
    return _then(_value.copyWith(
      canManageClub: null == canManageClub
          ? _value.canManageClub
          : canManageClub // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageTeams: null == canManageTeams
          ? _value.canManageTeams
          : canManageTeams // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageStaff: null == canManageStaff
          ? _value.canManageStaff
          : canManageStaff // ignore: cast_nullable_to_non_nullable
              as bool,
      canManagePlayers: null == canManagePlayers
          ? _value.canManagePlayers
          : canManagePlayers // ignore: cast_nullable_to_non_nullable
              as bool,
      canCreateTraining: null == canCreateTraining
          ? _value.canCreateTraining
          : canCreateTraining // ignore: cast_nullable_to_non_nullable
              as bool,
      canEditTraining: null == canEditTraining
          ? _value.canEditTraining
          : canEditTraining // ignore: cast_nullable_to_non_nullable
              as bool,
      canDeleteTraining: null == canDeleteTraining
          ? _value.canDeleteTraining
          : canDeleteTraining // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageMatches: null == canManageMatches
          ? _value.canManageMatches
          : canManageMatches // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewPlayerData: null == canViewPlayerData
          ? _value.canViewPlayerData
          : canViewPlayerData // ignore: cast_nullable_to_non_nullable
              as bool,
      canEditPlayerData: null == canEditPlayerData
          ? _value.canEditPlayerData
          : canEditPlayerData // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewAnalytics: null == canViewAnalytics
          ? _value.canViewAnalytics
          : canViewAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      canExportData: null == canExportData
          ? _value.canExportData
          : canExportData // ignore: cast_nullable_to_non_nullable
              as bool,
      canSendMessages: null == canSendMessages
          ? _value.canSendMessages
          : canSendMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageCommunication: null == canManageCommunication
          ? _value.canManageCommunication
          : canManageCommunication // ignore: cast_nullable_to_non_nullable
              as bool,
      canAccessParentPortal: null == canAccessParentPortal
          ? _value.canAccessParentPortal
          : canAccessParentPortal // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewFinancials: null == canViewFinancials
          ? _value.canViewFinancials
          : canViewFinancials // ignore: cast_nullable_to_non_nullable
              as bool,
      canManagePayments: null == canManagePayments
          ? _value.canManagePayments
          : canManagePayments // ignore: cast_nullable_to_non_nullable
              as bool,
      canGenerateInvoices: null == canGenerateInvoices
          ? _value.canGenerateInvoices
          : canGenerateInvoices // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageSettings: null == canManageSettings
          ? _value.canManageSettings
          : canManageSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewLogs: null == canViewLogs
          ? _value.canViewLogs
          : canViewLogs // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageIntegrations: null == canManageIntegrations
          ? _value.canManageIntegrations
          : canManageIntegrations // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffPermissionsImplCopyWith<$Res>
    implements $StaffPermissionsCopyWith<$Res> {
  factory _$$StaffPermissionsImplCopyWith(_$StaffPermissionsImpl value,
          $Res Function(_$StaffPermissionsImpl) then) =
      __$$StaffPermissionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool canManageClub,
      bool canManageTeams,
      bool canManageStaff,
      bool canManagePlayers,
      bool canCreateTraining,
      bool canEditTraining,
      bool canDeleteTraining,
      bool canManageMatches,
      bool canViewPlayerData,
      bool canEditPlayerData,
      bool canViewAnalytics,
      bool canExportData,
      bool canSendMessages,
      bool canManageCommunication,
      bool canAccessParentPortal,
      bool canViewFinancials,
      bool canManagePayments,
      bool canGenerateInvoices,
      bool canManageSettings,
      bool canViewLogs,
      bool canManageIntegrations});
}

/// @nodoc
class __$$StaffPermissionsImplCopyWithImpl<$Res>
    extends _$StaffPermissionsCopyWithImpl<$Res, _$StaffPermissionsImpl>
    implements _$$StaffPermissionsImplCopyWith<$Res> {
  __$$StaffPermissionsImplCopyWithImpl(_$StaffPermissionsImpl _value,
      $Res Function(_$StaffPermissionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canManageClub = null,
    Object? canManageTeams = null,
    Object? canManageStaff = null,
    Object? canManagePlayers = null,
    Object? canCreateTraining = null,
    Object? canEditTraining = null,
    Object? canDeleteTraining = null,
    Object? canManageMatches = null,
    Object? canViewPlayerData = null,
    Object? canEditPlayerData = null,
    Object? canViewAnalytics = null,
    Object? canExportData = null,
    Object? canSendMessages = null,
    Object? canManageCommunication = null,
    Object? canAccessParentPortal = null,
    Object? canViewFinancials = null,
    Object? canManagePayments = null,
    Object? canGenerateInvoices = null,
    Object? canManageSettings = null,
    Object? canViewLogs = null,
    Object? canManageIntegrations = null,
  }) {
    return _then(_$StaffPermissionsImpl(
      canManageClub: null == canManageClub
          ? _value.canManageClub
          : canManageClub // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageTeams: null == canManageTeams
          ? _value.canManageTeams
          : canManageTeams // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageStaff: null == canManageStaff
          ? _value.canManageStaff
          : canManageStaff // ignore: cast_nullable_to_non_nullable
              as bool,
      canManagePlayers: null == canManagePlayers
          ? _value.canManagePlayers
          : canManagePlayers // ignore: cast_nullable_to_non_nullable
              as bool,
      canCreateTraining: null == canCreateTraining
          ? _value.canCreateTraining
          : canCreateTraining // ignore: cast_nullable_to_non_nullable
              as bool,
      canEditTraining: null == canEditTraining
          ? _value.canEditTraining
          : canEditTraining // ignore: cast_nullable_to_non_nullable
              as bool,
      canDeleteTraining: null == canDeleteTraining
          ? _value.canDeleteTraining
          : canDeleteTraining // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageMatches: null == canManageMatches
          ? _value.canManageMatches
          : canManageMatches // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewPlayerData: null == canViewPlayerData
          ? _value.canViewPlayerData
          : canViewPlayerData // ignore: cast_nullable_to_non_nullable
              as bool,
      canEditPlayerData: null == canEditPlayerData
          ? _value.canEditPlayerData
          : canEditPlayerData // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewAnalytics: null == canViewAnalytics
          ? _value.canViewAnalytics
          : canViewAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      canExportData: null == canExportData
          ? _value.canExportData
          : canExportData // ignore: cast_nullable_to_non_nullable
              as bool,
      canSendMessages: null == canSendMessages
          ? _value.canSendMessages
          : canSendMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageCommunication: null == canManageCommunication
          ? _value.canManageCommunication
          : canManageCommunication // ignore: cast_nullable_to_non_nullable
              as bool,
      canAccessParentPortal: null == canAccessParentPortal
          ? _value.canAccessParentPortal
          : canAccessParentPortal // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewFinancials: null == canViewFinancials
          ? _value.canViewFinancials
          : canViewFinancials // ignore: cast_nullable_to_non_nullable
              as bool,
      canManagePayments: null == canManagePayments
          ? _value.canManagePayments
          : canManagePayments // ignore: cast_nullable_to_non_nullable
              as bool,
      canGenerateInvoices: null == canGenerateInvoices
          ? _value.canGenerateInvoices
          : canGenerateInvoices // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageSettings: null == canManageSettings
          ? _value.canManageSettings
          : canManageSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      canViewLogs: null == canViewLogs
          ? _value.canViewLogs
          : canViewLogs // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageIntegrations: null == canManageIntegrations
          ? _value.canManageIntegrations
          : canManageIntegrations // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffPermissionsImpl implements _StaffPermissions {
  const _$StaffPermissionsImpl(
      {this.canManageClub = false,
      this.canManageTeams = false,
      this.canManageStaff = false,
      this.canManagePlayers = false,
      this.canCreateTraining = false,
      this.canEditTraining = false,
      this.canDeleteTraining = false,
      this.canManageMatches = false,
      this.canViewPlayerData = false,
      this.canEditPlayerData = false,
      this.canViewAnalytics = false,
      this.canExportData = false,
      this.canSendMessages = false,
      this.canManageCommunication = false,
      this.canAccessParentPortal = false,
      this.canViewFinancials = false,
      this.canManagePayments = false,
      this.canGenerateInvoices = false,
      this.canManageSettings = false,
      this.canViewLogs = false,
      this.canManageIntegrations = false});

  factory _$StaffPermissionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffPermissionsImplFromJson(json);

// Administrative
  @override
  @JsonKey()
  final bool canManageClub;
  @override
  @JsonKey()
  final bool canManageTeams;
  @override
  @JsonKey()
  final bool canManageStaff;
  @override
  @JsonKey()
  final bool canManagePlayers;
// Training & Matches
  @override
  @JsonKey()
  final bool canCreateTraining;
  @override
  @JsonKey()
  final bool canEditTraining;
  @override
  @JsonKey()
  final bool canDeleteTraining;
  @override
  @JsonKey()
  final bool canManageMatches;
// Performance & Analytics
  @override
  @JsonKey()
  final bool canViewPlayerData;
  @override
  @JsonKey()
  final bool canEditPlayerData;
  @override
  @JsonKey()
  final bool canViewAnalytics;
  @override
  @JsonKey()
  final bool canExportData;
// Communication
  @override
  @JsonKey()
  final bool canSendMessages;
  @override
  @JsonKey()
  final bool canManageCommunication;
  @override
  @JsonKey()
  final bool canAccessParentPortal;
// Financial
  @override
  @JsonKey()
  final bool canViewFinancials;
  @override
  @JsonKey()
  final bool canManagePayments;
  @override
  @JsonKey()
  final bool canGenerateInvoices;
// System
  @override
  @JsonKey()
  final bool canManageSettings;
  @override
  @JsonKey()
  final bool canViewLogs;
  @override
  @JsonKey()
  final bool canManageIntegrations;

  @override
  String toString() {
    return 'StaffPermissions(canManageClub: $canManageClub, canManageTeams: $canManageTeams, canManageStaff: $canManageStaff, canManagePlayers: $canManagePlayers, canCreateTraining: $canCreateTraining, canEditTraining: $canEditTraining, canDeleteTraining: $canDeleteTraining, canManageMatches: $canManageMatches, canViewPlayerData: $canViewPlayerData, canEditPlayerData: $canEditPlayerData, canViewAnalytics: $canViewAnalytics, canExportData: $canExportData, canSendMessages: $canSendMessages, canManageCommunication: $canManageCommunication, canAccessParentPortal: $canAccessParentPortal, canViewFinancials: $canViewFinancials, canManagePayments: $canManagePayments, canGenerateInvoices: $canGenerateInvoices, canManageSettings: $canManageSettings, canViewLogs: $canViewLogs, canManageIntegrations: $canManageIntegrations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffPermissionsImpl &&
            (identical(other.canManageClub, canManageClub) ||
                other.canManageClub == canManageClub) &&
            (identical(other.canManageTeams, canManageTeams) ||
                other.canManageTeams == canManageTeams) &&
            (identical(other.canManageStaff, canManageStaff) ||
                other.canManageStaff == canManageStaff) &&
            (identical(other.canManagePlayers, canManagePlayers) ||
                other.canManagePlayers == canManagePlayers) &&
            (identical(other.canCreateTraining, canCreateTraining) ||
                other.canCreateTraining == canCreateTraining) &&
            (identical(other.canEditTraining, canEditTraining) ||
                other.canEditTraining == canEditTraining) &&
            (identical(other.canDeleteTraining, canDeleteTraining) ||
                other.canDeleteTraining == canDeleteTraining) &&
            (identical(other.canManageMatches, canManageMatches) ||
                other.canManageMatches == canManageMatches) &&
            (identical(other.canViewPlayerData, canViewPlayerData) ||
                other.canViewPlayerData == canViewPlayerData) &&
            (identical(other.canEditPlayerData, canEditPlayerData) ||
                other.canEditPlayerData == canEditPlayerData) &&
            (identical(other.canViewAnalytics, canViewAnalytics) ||
                other.canViewAnalytics == canViewAnalytics) &&
            (identical(other.canExportData, canExportData) ||
                other.canExportData == canExportData) &&
            (identical(other.canSendMessages, canSendMessages) ||
                other.canSendMessages == canSendMessages) &&
            (identical(other.canManageCommunication, canManageCommunication) ||
                other.canManageCommunication == canManageCommunication) &&
            (identical(other.canAccessParentPortal, canAccessParentPortal) ||
                other.canAccessParentPortal == canAccessParentPortal) &&
            (identical(other.canViewFinancials, canViewFinancials) ||
                other.canViewFinancials == canViewFinancials) &&
            (identical(other.canManagePayments, canManagePayments) ||
                other.canManagePayments == canManagePayments) &&
            (identical(other.canGenerateInvoices, canGenerateInvoices) ||
                other.canGenerateInvoices == canGenerateInvoices) &&
            (identical(other.canManageSettings, canManageSettings) ||
                other.canManageSettings == canManageSettings) &&
            (identical(other.canViewLogs, canViewLogs) ||
                other.canViewLogs == canViewLogs) &&
            (identical(other.canManageIntegrations, canManageIntegrations) ||
                other.canManageIntegrations == canManageIntegrations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        canManageClub,
        canManageTeams,
        canManageStaff,
        canManagePlayers,
        canCreateTraining,
        canEditTraining,
        canDeleteTraining,
        canManageMatches,
        canViewPlayerData,
        canEditPlayerData,
        canViewAnalytics,
        canExportData,
        canSendMessages,
        canManageCommunication,
        canAccessParentPortal,
        canViewFinancials,
        canManagePayments,
        canGenerateInvoices,
        canManageSettings,
        canViewLogs,
        canManageIntegrations
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffPermissionsImplCopyWith<_$StaffPermissionsImpl> get copyWith =>
      __$$StaffPermissionsImplCopyWithImpl<_$StaffPermissionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffPermissionsImplToJson(
      this,
    );
  }
}

abstract class _StaffPermissions implements StaffPermissions {
  const factory _StaffPermissions(
      {final bool canManageClub,
      final bool canManageTeams,
      final bool canManageStaff,
      final bool canManagePlayers,
      final bool canCreateTraining,
      final bool canEditTraining,
      final bool canDeleteTraining,
      final bool canManageMatches,
      final bool canViewPlayerData,
      final bool canEditPlayerData,
      final bool canViewAnalytics,
      final bool canExportData,
      final bool canSendMessages,
      final bool canManageCommunication,
      final bool canAccessParentPortal,
      final bool canViewFinancials,
      final bool canManagePayments,
      final bool canGenerateInvoices,
      final bool canManageSettings,
      final bool canViewLogs,
      final bool canManageIntegrations}) = _$StaffPermissionsImpl;

  factory _StaffPermissions.fromJson(Map<String, dynamic> json) =
      _$StaffPermissionsImpl.fromJson;

  @override // Administrative
  bool get canManageClub;
  @override
  bool get canManageTeams;
  @override
  bool get canManageStaff;
  @override
  bool get canManagePlayers;
  @override // Training & Matches
  bool get canCreateTraining;
  @override
  bool get canEditTraining;
  @override
  bool get canDeleteTraining;
  @override
  bool get canManageMatches;
  @override // Performance & Analytics
  bool get canViewPlayerData;
  @override
  bool get canEditPlayerData;
  @override
  bool get canViewAnalytics;
  @override
  bool get canExportData;
  @override // Communication
  bool get canSendMessages;
  @override
  bool get canManageCommunication;
  @override
  bool get canAccessParentPortal;
  @override // Financial
  bool get canViewFinancials;
  @override
  bool get canManagePayments;
  @override
  bool get canGenerateInvoices;
  @override // System
  bool get canManageSettings;
  @override
  bool get canViewLogs;
  @override
  bool get canManageIntegrations;
  @override
  @JsonKey(ignore: true)
  _$$StaffPermissionsImplCopyWith<_$StaffPermissionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StaffAvailability _$StaffAvailabilityFromJson(Map<String, dynamic> json) {
  return _StaffAvailability.fromJson(json);
}

/// @nodoc
mixin _$StaffAvailability {
  List<String> get availableDays => throw _privateConstructorUsedError;
  String? get preferredTimeSlot => throw _privateConstructorUsedError;
  List<String> get unavailablePeriods => throw _privateConstructorUsedError;
  int? get maxHoursPerWeek => throw _privateConstructorUsedError;
  bool? get availableForMatches => throw _privateConstructorUsedError;
  bool? get availableForTraining => throw _privateConstructorUsedError;
  bool? get availableForEvents => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StaffAvailabilityCopyWith<StaffAvailability> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffAvailabilityCopyWith<$Res> {
  factory $StaffAvailabilityCopyWith(
          StaffAvailability value, $Res Function(StaffAvailability) then) =
      _$StaffAvailabilityCopyWithImpl<$Res, StaffAvailability>;
  @useResult
  $Res call(
      {List<String> availableDays,
      String? preferredTimeSlot,
      List<String> unavailablePeriods,
      int? maxHoursPerWeek,
      bool? availableForMatches,
      bool? availableForTraining,
      bool? availableForEvents});
}

/// @nodoc
class _$StaffAvailabilityCopyWithImpl<$Res, $Val extends StaffAvailability>
    implements $StaffAvailabilityCopyWith<$Res> {
  _$StaffAvailabilityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableDays = null,
    Object? preferredTimeSlot = freezed,
    Object? unavailablePeriods = null,
    Object? maxHoursPerWeek = freezed,
    Object? availableForMatches = freezed,
    Object? availableForTraining = freezed,
    Object? availableForEvents = freezed,
  }) {
    return _then(_value.copyWith(
      availableDays: null == availableDays
          ? _value.availableDays
          : availableDays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferredTimeSlot: freezed == preferredTimeSlot
          ? _value.preferredTimeSlot
          : preferredTimeSlot // ignore: cast_nullable_to_non_nullable
              as String?,
      unavailablePeriods: null == unavailablePeriods
          ? _value.unavailablePeriods
          : unavailablePeriods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxHoursPerWeek: freezed == maxHoursPerWeek
          ? _value.maxHoursPerWeek
          : maxHoursPerWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      availableForMatches: freezed == availableForMatches
          ? _value.availableForMatches
          : availableForMatches // ignore: cast_nullable_to_non_nullable
              as bool?,
      availableForTraining: freezed == availableForTraining
          ? _value.availableForTraining
          : availableForTraining // ignore: cast_nullable_to_non_nullable
              as bool?,
      availableForEvents: freezed == availableForEvents
          ? _value.availableForEvents
          : availableForEvents // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StaffAvailabilityImplCopyWith<$Res>
    implements $StaffAvailabilityCopyWith<$Res> {
  factory _$$StaffAvailabilityImplCopyWith(_$StaffAvailabilityImpl value,
          $Res Function(_$StaffAvailabilityImpl) then) =
      __$$StaffAvailabilityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> availableDays,
      String? preferredTimeSlot,
      List<String> unavailablePeriods,
      int? maxHoursPerWeek,
      bool? availableForMatches,
      bool? availableForTraining,
      bool? availableForEvents});
}

/// @nodoc
class __$$StaffAvailabilityImplCopyWithImpl<$Res>
    extends _$StaffAvailabilityCopyWithImpl<$Res, _$StaffAvailabilityImpl>
    implements _$$StaffAvailabilityImplCopyWith<$Res> {
  __$$StaffAvailabilityImplCopyWithImpl(_$StaffAvailabilityImpl _value,
      $Res Function(_$StaffAvailabilityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availableDays = null,
    Object? preferredTimeSlot = freezed,
    Object? unavailablePeriods = null,
    Object? maxHoursPerWeek = freezed,
    Object? availableForMatches = freezed,
    Object? availableForTraining = freezed,
    Object? availableForEvents = freezed,
  }) {
    return _then(_$StaffAvailabilityImpl(
      availableDays: null == availableDays
          ? _value._availableDays
          : availableDays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      preferredTimeSlot: freezed == preferredTimeSlot
          ? _value.preferredTimeSlot
          : preferredTimeSlot // ignore: cast_nullable_to_non_nullable
              as String?,
      unavailablePeriods: null == unavailablePeriods
          ? _value._unavailablePeriods
          : unavailablePeriods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxHoursPerWeek: freezed == maxHoursPerWeek
          ? _value.maxHoursPerWeek
          : maxHoursPerWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      availableForMatches: freezed == availableForMatches
          ? _value.availableForMatches
          : availableForMatches // ignore: cast_nullable_to_non_nullable
              as bool?,
      availableForTraining: freezed == availableForTraining
          ? _value.availableForTraining
          : availableForTraining // ignore: cast_nullable_to_non_nullable
              as bool?,
      availableForEvents: freezed == availableForEvents
          ? _value.availableForEvents
          : availableForEvents // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffAvailabilityImpl implements _StaffAvailability {
  const _$StaffAvailabilityImpl(
      {final List<String> availableDays = const [],
      this.preferredTimeSlot,
      final List<String> unavailablePeriods = const [],
      this.maxHoursPerWeek,
      this.availableForMatches,
      this.availableForTraining,
      this.availableForEvents})
      : _availableDays = availableDays,
        _unavailablePeriods = unavailablePeriods;

  factory _$StaffAvailabilityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffAvailabilityImplFromJson(json);

  final List<String> _availableDays;
  @override
  @JsonKey()
  List<String> get availableDays {
    if (_availableDays is EqualUnmodifiableListView) return _availableDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableDays);
  }

  @override
  final String? preferredTimeSlot;
  final List<String> _unavailablePeriods;
  @override
  @JsonKey()
  List<String> get unavailablePeriods {
    if (_unavailablePeriods is EqualUnmodifiableListView)
      return _unavailablePeriods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unavailablePeriods);
  }

  @override
  final int? maxHoursPerWeek;
  @override
  final bool? availableForMatches;
  @override
  final bool? availableForTraining;
  @override
  final bool? availableForEvents;

  @override
  String toString() {
    return 'StaffAvailability(availableDays: $availableDays, preferredTimeSlot: $preferredTimeSlot, unavailablePeriods: $unavailablePeriods, maxHoursPerWeek: $maxHoursPerWeek, availableForMatches: $availableForMatches, availableForTraining: $availableForTraining, availableForEvents: $availableForEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffAvailabilityImpl &&
            const DeepCollectionEquality()
                .equals(other._availableDays, _availableDays) &&
            (identical(other.preferredTimeSlot, preferredTimeSlot) ||
                other.preferredTimeSlot == preferredTimeSlot) &&
            const DeepCollectionEquality()
                .equals(other._unavailablePeriods, _unavailablePeriods) &&
            (identical(other.maxHoursPerWeek, maxHoursPerWeek) ||
                other.maxHoursPerWeek == maxHoursPerWeek) &&
            (identical(other.availableForMatches, availableForMatches) ||
                other.availableForMatches == availableForMatches) &&
            (identical(other.availableForTraining, availableForTraining) ||
                other.availableForTraining == availableForTraining) &&
            (identical(other.availableForEvents, availableForEvents) ||
                other.availableForEvents == availableForEvents));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_availableDays),
      preferredTimeSlot,
      const DeepCollectionEquality().hash(_unavailablePeriods),
      maxHoursPerWeek,
      availableForMatches,
      availableForTraining,
      availableForEvents);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffAvailabilityImplCopyWith<_$StaffAvailabilityImpl> get copyWith =>
      __$$StaffAvailabilityImplCopyWithImpl<_$StaffAvailabilityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffAvailabilityImplToJson(
      this,
    );
  }
}

abstract class _StaffAvailability implements StaffAvailability {
  const factory _StaffAvailability(
      {final List<String> availableDays,
      final String? preferredTimeSlot,
      final List<String> unavailablePeriods,
      final int? maxHoursPerWeek,
      final bool? availableForMatches,
      final bool? availableForTraining,
      final bool? availableForEvents}) = _$StaffAvailabilityImpl;

  factory _StaffAvailability.fromJson(Map<String, dynamic> json) =
      _$StaffAvailabilityImpl.fromJson;

  @override
  List<String> get availableDays;
  @override
  String? get preferredTimeSlot;
  @override
  List<String> get unavailablePeriods;
  @override
  int? get maxHoursPerWeek;
  @override
  bool? get availableForMatches;
  @override
  bool? get availableForTraining;
  @override
  bool? get availableForEvents;
  @override
  @JsonKey(ignore: true)
  _$$StaffAvailabilityImplCopyWith<_$StaffAvailabilityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Qualification _$QualificationFromJson(Map<String, dynamic> json) {
  return _Qualification.fromJson(json);
}

/// @nodoc
mixin _$Qualification {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get issuingBody => throw _privateConstructorUsedError;
  DateTime get issuedDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get certificateNumber => throw _privateConstructorUsedError;
  String? get level => throw _privateConstructorUsedError;
  bool? get isValid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QualificationCopyWith<Qualification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QualificationCopyWith<$Res> {
  factory $QualificationCopyWith(
          Qualification value, $Res Function(Qualification) then) =
      _$QualificationCopyWithImpl<$Res, Qualification>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String issuingBody,
      DateTime issuedDate,
      DateTime? expiryDate,
      String? certificateNumber,
      String? level,
      bool? isValid});
}

/// @nodoc
class _$QualificationCopyWithImpl<$Res, $Val extends Qualification>
    implements $QualificationCopyWith<$Res> {
  _$QualificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? issuingBody = null,
    Object? issuedDate = null,
    Object? expiryDate = freezed,
    Object? certificateNumber = freezed,
    Object? level = freezed,
    Object? isValid = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      issuingBody: null == issuingBody
          ? _value.issuingBody
          : issuingBody // ignore: cast_nullable_to_non_nullable
              as String,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certificateNumber: freezed == certificateNumber
          ? _value.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: freezed == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QualificationImplCopyWith<$Res>
    implements $QualificationCopyWith<$Res> {
  factory _$$QualificationImplCopyWith(
          _$QualificationImpl value, $Res Function(_$QualificationImpl) then) =
      __$$QualificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String issuingBody,
      DateTime issuedDate,
      DateTime? expiryDate,
      String? certificateNumber,
      String? level,
      bool? isValid});
}

/// @nodoc
class __$$QualificationImplCopyWithImpl<$Res>
    extends _$QualificationCopyWithImpl<$Res, _$QualificationImpl>
    implements _$$QualificationImplCopyWith<$Res> {
  __$$QualificationImplCopyWithImpl(
      _$QualificationImpl _value, $Res Function(_$QualificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? issuingBody = null,
    Object? issuedDate = null,
    Object? expiryDate = freezed,
    Object? certificateNumber = freezed,
    Object? level = freezed,
    Object? isValid = freezed,
  }) {
    return _then(_$QualificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      issuingBody: null == issuingBody
          ? _value.issuingBody
          : issuingBody // ignore: cast_nullable_to_non_nullable
              as String,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certificateNumber: freezed == certificateNumber
          ? _value.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: freezed == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QualificationImpl implements _Qualification {
  const _$QualificationImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.issuingBody,
      required this.issuedDate,
      this.expiryDate,
      this.certificateNumber,
      this.level,
      this.isValid});

  factory _$QualificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$QualificationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String issuingBody;
  @override
  final DateTime issuedDate;
  @override
  final DateTime? expiryDate;
  @override
  final String? certificateNumber;
  @override
  final String? level;
  @override
  final bool? isValid;

  @override
  String toString() {
    return 'Qualification(id: $id, name: $name, type: $type, issuingBody: $issuingBody, issuedDate: $issuedDate, expiryDate: $expiryDate, certificateNumber: $certificateNumber, level: $level, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QualificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.issuingBody, issuingBody) ||
                other.issuingBody == issuingBody) &&
            (identical(other.issuedDate, issuedDate) ||
                other.issuedDate == issuedDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.certificateNumber, certificateNumber) ||
                other.certificateNumber == certificateNumber) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, issuingBody,
      issuedDate, expiryDate, certificateNumber, level, isValid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QualificationImplCopyWith<_$QualificationImpl> get copyWith =>
      __$$QualificationImplCopyWithImpl<_$QualificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QualificationImplToJson(
      this,
    );
  }
}

abstract class _Qualification implements Qualification {
  const factory _Qualification(
      {required final String id,
      required final String name,
      required final String type,
      required final String issuingBody,
      required final DateTime issuedDate,
      final DateTime? expiryDate,
      final String? certificateNumber,
      final String? level,
      final bool? isValid}) = _$QualificationImpl;

  factory _Qualification.fromJson(Map<String, dynamic> json) =
      _$QualificationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get issuingBody;
  @override
  DateTime get issuedDate;
  @override
  DateTime? get expiryDate;
  @override
  String? get certificateNumber;
  @override
  String? get level;
  @override
  bool? get isValid;
  @override
  @JsonKey(ignore: true)
  _$$QualificationImplCopyWith<_$QualificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Certificate _$CertificateFromJson(Map<String, dynamic> json) {
  return _Certificate.fromJson(json);
}

/// @nodoc
mixin _$Certificate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get issuedDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get issuingBody => throw _privateConstructorUsedError;
  String? get documentUrl => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CertificateCopyWith<Certificate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificateCopyWith<$Res> {
  factory $CertificateCopyWith(
          Certificate value, $Res Function(Certificate) then) =
      _$CertificateCopyWithImpl<$Res, Certificate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      DateTime issuedDate,
      DateTime? expiryDate,
      String? issuingBody,
      String? documentUrl,
      bool? isVerified});
}

/// @nodoc
class _$CertificateCopyWithImpl<$Res, $Val extends Certificate>
    implements $CertificateCopyWith<$Res> {
  _$CertificateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? issuedDate = null,
    Object? expiryDate = freezed,
    Object? issuingBody = freezed,
    Object? documentUrl = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      issuingBody: freezed == issuingBody
          ? _value.issuingBody
          : issuingBody // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrl: freezed == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificateImplCopyWith<$Res>
    implements $CertificateCopyWith<$Res> {
  factory _$$CertificateImplCopyWith(
          _$CertificateImpl value, $Res Function(_$CertificateImpl) then) =
      __$$CertificateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      DateTime issuedDate,
      DateTime? expiryDate,
      String? issuingBody,
      String? documentUrl,
      bool? isVerified});
}

/// @nodoc
class __$$CertificateImplCopyWithImpl<$Res>
    extends _$CertificateCopyWithImpl<$Res, _$CertificateImpl>
    implements _$$CertificateImplCopyWith<$Res> {
  __$$CertificateImplCopyWithImpl(
      _$CertificateImpl _value, $Res Function(_$CertificateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? issuedDate = null,
    Object? expiryDate = freezed,
    Object? issuingBody = freezed,
    Object? documentUrl = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_$CertificateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      issuedDate: null == issuedDate
          ? _value.issuedDate
          : issuedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      issuingBody: freezed == issuingBody
          ? _value.issuingBody
          : issuingBody // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrl: freezed == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertificateImpl implements _Certificate {
  const _$CertificateImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.issuedDate,
      this.expiryDate,
      this.issuingBody,
      this.documentUrl,
      this.isVerified});

  factory _$CertificateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertificateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final DateTime issuedDate;
  @override
  final DateTime? expiryDate;
  @override
  final String? issuingBody;
  @override
  final String? documentUrl;
  @override
  final bool? isVerified;

  @override
  String toString() {
    return 'Certificate(id: $id, name: $name, type: $type, issuedDate: $issuedDate, expiryDate: $expiryDate, issuingBody: $issuingBody, documentUrl: $documentUrl, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.issuedDate, issuedDate) ||
                other.issuedDate == issuedDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.issuingBody, issuingBody) ||
                other.issuingBody == issuingBody) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, issuedDate,
      expiryDate, issuingBody, documentUrl, isVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificateImplCopyWith<_$CertificateImpl> get copyWith =>
      __$$CertificateImplCopyWithImpl<_$CertificateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertificateImplToJson(
      this,
    );
  }
}

abstract class _Certificate implements Certificate {
  const factory _Certificate(
      {required final String id,
      required final String name,
      required final String type,
      required final DateTime issuedDate,
      final DateTime? expiryDate,
      final String? issuingBody,
      final String? documentUrl,
      final bool? isVerified}) = _$CertificateImpl;

  factory _Certificate.fromJson(Map<String, dynamic> json) =
      _$CertificateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  DateTime get issuedDate;
  @override
  DateTime? get expiryDate;
  @override
  String? get issuingBody;
  @override
  String? get documentUrl;
  @override
  bool? get isVerified;
  @override
  @JsonKey(ignore: true)
  _$$CertificateImplCopyWith<_$CertificateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
