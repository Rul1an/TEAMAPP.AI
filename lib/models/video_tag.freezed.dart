// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoTag _$VideoTagFromJson(Map<String, dynamic> json) {
  return _VideoTag.fromJson(json);
}

/// @nodoc
mixin _$VideoTag {
  String get id => throw _privateConstructorUsedError;
  String get videoId => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  VideoTagType get tagType => throw _privateConstructorUsedError;
  double get timestampSeconds => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get tagData => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this VideoTag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoTagCopyWith<VideoTag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoTagCopyWith<$Res> {
  factory $VideoTagCopyWith(VideoTag value, $Res Function(VideoTag) then) =
      _$VideoTagCopyWithImpl<$Res, VideoTag>;
  @useResult
  $Res call(
      {String id,
      String videoId,
      String organizationId,
      VideoTagType tagType,
      double timestampSeconds,
      String? title,
      String? description,
      Map<String, dynamic> tagData,
      String? createdBy,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$VideoTagCopyWithImpl<$Res, $Val extends VideoTag>
    implements $VideoTagCopyWith<$Res> {
  _$VideoTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? organizationId = null,
    Object? tagType = null,
    Object? timestampSeconds = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? tagData = null,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      tagType: null == tagType
          ? _value.tagType
          : tagType // ignore: cast_nullable_to_non_nullable
              as VideoTagType,
      timestampSeconds: null == timestampSeconds
          ? _value.timestampSeconds
          : timestampSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tagData: null == tagData
          ? _value.tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoTagImplCopyWith<$Res>
    implements $VideoTagCopyWith<$Res> {
  factory _$$VideoTagImplCopyWith(
          _$VideoTagImpl value, $Res Function(_$VideoTagImpl) then) =
      __$$VideoTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String videoId,
      String organizationId,
      VideoTagType tagType,
      double timestampSeconds,
      String? title,
      String? description,
      Map<String, dynamic> tagData,
      String? createdBy,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$VideoTagImplCopyWithImpl<$Res>
    extends _$VideoTagCopyWithImpl<$Res, _$VideoTagImpl>
    implements _$$VideoTagImplCopyWith<$Res> {
  __$$VideoTagImplCopyWithImpl(
      _$VideoTagImpl _value, $Res Function(_$VideoTagImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? videoId = null,
    Object? organizationId = null,
    Object? tagType = null,
    Object? timestampSeconds = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? tagData = null,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VideoTagImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      tagType: null == tagType
          ? _value.tagType
          : tagType // ignore: cast_nullable_to_non_nullable
              as VideoTagType,
      timestampSeconds: null == timestampSeconds
          ? _value.timestampSeconds
          : timestampSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tagData: null == tagData
          ? _value._tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoTagImpl extends _VideoTag with DiagnosticableTreeMixin {
  const _$VideoTagImpl(
      {required this.id,
      required this.videoId,
      required this.organizationId,
      required this.tagType,
      required this.timestampSeconds,
      this.title,
      this.description,
      required final Map<String, dynamic> tagData,
      this.createdBy,
      required this.createdAt,
      this.updatedAt})
      : _tagData = tagData,
        super._();

  factory _$VideoTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoTagImplFromJson(json);

  @override
  final String id;
  @override
  final String videoId;
  @override
  final String organizationId;
  @override
  final VideoTagType tagType;
  @override
  final double timestampSeconds;
  @override
  final String? title;
  @override
  final String? description;
  final Map<String, dynamic> _tagData;
  @override
  Map<String, dynamic> get tagData {
    if (_tagData is EqualUnmodifiableMapView) return _tagData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tagData);
  }

  @override
  final String? createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTag(id: $id, videoId: $videoId, organizationId: $organizationId, tagType: $tagType, timestampSeconds: $timestampSeconds, title: $title, description: $description, tagData: $tagData, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTag'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('videoId', videoId))
      ..add(DiagnosticsProperty('organizationId', organizationId))
      ..add(DiagnosticsProperty('tagType', tagType))
      ..add(DiagnosticsProperty('timestampSeconds', timestampSeconds))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('tagData', tagData))
      ..add(DiagnosticsProperty('createdBy', createdBy))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTagImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.tagType, tagType) || other.tagType == tagType) &&
            (identical(other.timestampSeconds, timestampSeconds) ||
                other.timestampSeconds == timestampSeconds) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tagData, _tagData) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      videoId,
      organizationId,
      tagType,
      timestampSeconds,
      title,
      description,
      const DeepCollectionEquality().hash(_tagData),
      createdBy,
      createdAt,
      updatedAt);

  /// Create a copy of VideoTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTagImplCopyWith<_$VideoTagImpl> get copyWith =>
      __$$VideoTagImplCopyWithImpl<_$VideoTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoTagImplToJson(
      this,
    );
  }
}

abstract class _VideoTag extends VideoTag {
  const factory _VideoTag(
      {required final String id,
      required final String videoId,
      required final String organizationId,
      required final VideoTagType tagType,
      required final double timestampSeconds,
      final String? title,
      final String? description,
      required final Map<String, dynamic> tagData,
      final String? createdBy,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$VideoTagImpl;
  const _VideoTag._() : super._();

  factory _VideoTag.fromJson(Map<String, dynamic> json) =
      _$VideoTagImpl.fromJson;

  @override
  String get id;
  @override
  String get videoId;
  @override
  String get organizationId;
  @override
  VideoTagType get tagType;
  @override
  double get timestampSeconds;
  @override
  String? get title;
  @override
  String? get description;
  @override
  Map<String, dynamic> get tagData;
  @override
  String? get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of VideoTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTagImplCopyWith<_$VideoTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateVideoTagRequest _$CreateVideoTagRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateVideoTagRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateVideoTagRequest {
  String get videoId => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  VideoTagType get tagType => throw _privateConstructorUsedError;
  double get timestampSeconds => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get tagData => throw _privateConstructorUsedError;

  /// Serializes this CreateVideoTagRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateVideoTagRequestCopyWith<CreateVideoTagRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateVideoTagRequestCopyWith<$Res> {
  factory $CreateVideoTagRequestCopyWith(CreateVideoTagRequest value,
          $Res Function(CreateVideoTagRequest) then) =
      _$CreateVideoTagRequestCopyWithImpl<$Res, CreateVideoTagRequest>;
  @useResult
  $Res call(
      {String videoId,
      String organizationId,
      VideoTagType tagType,
      double timestampSeconds,
      String? title,
      String? description,
      Map<String, dynamic> tagData});
}

/// @nodoc
class _$CreateVideoTagRequestCopyWithImpl<$Res,
        $Val extends CreateVideoTagRequest>
    implements $CreateVideoTagRequestCopyWith<$Res> {
  _$CreateVideoTagRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? organizationId = null,
    Object? tagType = null,
    Object? timestampSeconds = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? tagData = null,
  }) {
    return _then(_value.copyWith(
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      tagType: null == tagType
          ? _value.tagType
          : tagType // ignore: cast_nullable_to_non_nullable
              as VideoTagType,
      timestampSeconds: null == timestampSeconds
          ? _value.timestampSeconds
          : timestampSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tagData: null == tagData
          ? _value.tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateVideoTagRequestImplCopyWith<$Res>
    implements $CreateVideoTagRequestCopyWith<$Res> {
  factory _$$CreateVideoTagRequestImplCopyWith(
          _$CreateVideoTagRequestImpl value,
          $Res Function(_$CreateVideoTagRequestImpl) then) =
      __$$CreateVideoTagRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String videoId,
      String organizationId,
      VideoTagType tagType,
      double timestampSeconds,
      String? title,
      String? description,
      Map<String, dynamic> tagData});
}

/// @nodoc
class __$$CreateVideoTagRequestImplCopyWithImpl<$Res>
    extends _$CreateVideoTagRequestCopyWithImpl<$Res,
        _$CreateVideoTagRequestImpl>
    implements _$$CreateVideoTagRequestImplCopyWith<$Res> {
  __$$CreateVideoTagRequestImplCopyWithImpl(_$CreateVideoTagRequestImpl _value,
      $Res Function(_$CreateVideoTagRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? organizationId = null,
    Object? tagType = null,
    Object? timestampSeconds = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? tagData = null,
  }) {
    return _then(_$CreateVideoTagRequestImpl(
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      tagType: null == tagType
          ? _value.tagType
          : tagType // ignore: cast_nullable_to_non_nullable
              as VideoTagType,
      timestampSeconds: null == timestampSeconds
          ? _value.timestampSeconds
          : timestampSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tagData: null == tagData
          ? _value._tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateVideoTagRequestImpl
    with DiagnosticableTreeMixin
    implements _CreateVideoTagRequest {
  const _$CreateVideoTagRequestImpl(
      {required this.videoId,
      required this.organizationId,
      required this.tagType,
      required this.timestampSeconds,
      this.title,
      this.description,
      final Map<String, dynamic> tagData = const {}})
      : _tagData = tagData;

  factory _$CreateVideoTagRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateVideoTagRequestImplFromJson(json);

  @override
  final String videoId;
  @override
  final String organizationId;
  @override
  final VideoTagType tagType;
  @override
  final double timestampSeconds;
  @override
  final String? title;
  @override
  final String? description;
  final Map<String, dynamic> _tagData;
  @override
  @JsonKey()
  Map<String, dynamic> get tagData {
    if (_tagData is EqualUnmodifiableMapView) return _tagData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tagData);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreateVideoTagRequest(videoId: $videoId, organizationId: $organizationId, tagType: $tagType, timestampSeconds: $timestampSeconds, title: $title, description: $description, tagData: $tagData)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreateVideoTagRequest'))
      ..add(DiagnosticsProperty('videoId', videoId))
      ..add(DiagnosticsProperty('organizationId', organizationId))
      ..add(DiagnosticsProperty('tagType', tagType))
      ..add(DiagnosticsProperty('timestampSeconds', timestampSeconds))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('tagData', tagData));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateVideoTagRequestImpl &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.tagType, tagType) || other.tagType == tagType) &&
            (identical(other.timestampSeconds, timestampSeconds) ||
                other.timestampSeconds == timestampSeconds) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tagData, _tagData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      videoId,
      organizationId,
      tagType,
      timestampSeconds,
      title,
      description,
      const DeepCollectionEquality().hash(_tagData));

  /// Create a copy of CreateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateVideoTagRequestImplCopyWith<_$CreateVideoTagRequestImpl>
      get copyWith => __$$CreateVideoTagRequestImplCopyWithImpl<
          _$CreateVideoTagRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateVideoTagRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateVideoTagRequest implements CreateVideoTagRequest {
  const factory _CreateVideoTagRequest(
      {required final String videoId,
      required final String organizationId,
      required final VideoTagType tagType,
      required final double timestampSeconds,
      final String? title,
      final String? description,
      final Map<String, dynamic> tagData}) = _$CreateVideoTagRequestImpl;

  factory _CreateVideoTagRequest.fromJson(Map<String, dynamic> json) =
      _$CreateVideoTagRequestImpl.fromJson;

  @override
  String get videoId;
  @override
  String get organizationId;
  @override
  VideoTagType get tagType;
  @override
  double get timestampSeconds;
  @override
  String? get title;
  @override
  String? get description;
  @override
  Map<String, dynamic> get tagData;

  /// Create a copy of CreateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateVideoTagRequestImplCopyWith<_$CreateVideoTagRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateVideoTagRequest _$UpdateVideoTagRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateVideoTagRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateVideoTagRequest {
  String get tagId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get tagData => throw _privateConstructorUsedError;
  double? get timestampSeconds => throw _privateConstructorUsedError;

  /// Serializes this UpdateVideoTagRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateVideoTagRequestCopyWith<UpdateVideoTagRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateVideoTagRequestCopyWith<$Res> {
  factory $UpdateVideoTagRequestCopyWith(UpdateVideoTagRequest value,
          $Res Function(UpdateVideoTagRequest) then) =
      _$UpdateVideoTagRequestCopyWithImpl<$Res, UpdateVideoTagRequest>;
  @useResult
  $Res call(
      {String tagId,
      String? title,
      String? description,
      Map<String, dynamic>? tagData,
      double? timestampSeconds});
}

/// @nodoc
class _$UpdateVideoTagRequestCopyWithImpl<$Res,
        $Val extends UpdateVideoTagRequest>
    implements $UpdateVideoTagRequestCopyWith<$Res> {
  _$UpdateVideoTagRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagId = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? tagData = freezed,
    Object? timestampSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      tagId: null == tagId
          ? _value.tagId
          : tagId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tagData: freezed == tagData
          ? _value.tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestampSeconds: freezed == timestampSeconds
          ? _value.timestampSeconds
          : timestampSeconds // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateVideoTagRequestImplCopyWith<$Res>
    implements $UpdateVideoTagRequestCopyWith<$Res> {
  factory _$$UpdateVideoTagRequestImplCopyWith(
          _$UpdateVideoTagRequestImpl value,
          $Res Function(_$UpdateVideoTagRequestImpl) then) =
      __$$UpdateVideoTagRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tagId,
      String? title,
      String? description,
      Map<String, dynamic>? tagData,
      double? timestampSeconds});
}

/// @nodoc
class __$$UpdateVideoTagRequestImplCopyWithImpl<$Res>
    extends _$UpdateVideoTagRequestCopyWithImpl<$Res,
        _$UpdateVideoTagRequestImpl>
    implements _$$UpdateVideoTagRequestImplCopyWith<$Res> {
  __$$UpdateVideoTagRequestImplCopyWithImpl(_$UpdateVideoTagRequestImpl _value,
      $Res Function(_$UpdateVideoTagRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagId = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? tagData = freezed,
    Object? timestampSeconds = freezed,
  }) {
    return _then(_$UpdateVideoTagRequestImpl(
      tagId: null == tagId
          ? _value.tagId
          : tagId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tagData: freezed == tagData
          ? _value._tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      timestampSeconds: freezed == timestampSeconds
          ? _value.timestampSeconds
          : timestampSeconds // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateVideoTagRequestImpl
    with DiagnosticableTreeMixin
    implements _UpdateVideoTagRequest {
  const _$UpdateVideoTagRequestImpl(
      {required this.tagId,
      this.title,
      this.description,
      final Map<String, dynamic>? tagData,
      this.timestampSeconds})
      : _tagData = tagData;

  factory _$UpdateVideoTagRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateVideoTagRequestImplFromJson(json);

  @override
  final String tagId;
  @override
  final String? title;
  @override
  final String? description;
  final Map<String, dynamic>? _tagData;
  @override
  Map<String, dynamic>? get tagData {
    final value = _tagData;
    if (value == null) return null;
    if (_tagData is EqualUnmodifiableMapView) return _tagData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final double? timestampSeconds;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdateVideoTagRequest(tagId: $tagId, title: $title, description: $description, tagData: $tagData, timestampSeconds: $timestampSeconds)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UpdateVideoTagRequest'))
      ..add(DiagnosticsProperty('tagId', tagId))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('tagData', tagData))
      ..add(DiagnosticsProperty('timestampSeconds', timestampSeconds));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateVideoTagRequestImpl &&
            (identical(other.tagId, tagId) || other.tagId == tagId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tagData, _tagData) &&
            (identical(other.timestampSeconds, timestampSeconds) ||
                other.timestampSeconds == timestampSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tagId, title, description,
      const DeepCollectionEquality().hash(_tagData), timestampSeconds);

  /// Create a copy of UpdateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateVideoTagRequestImplCopyWith<_$UpdateVideoTagRequestImpl>
      get copyWith => __$$UpdateVideoTagRequestImplCopyWithImpl<
          _$UpdateVideoTagRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateVideoTagRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateVideoTagRequest implements UpdateVideoTagRequest {
  const factory _UpdateVideoTagRequest(
      {required final String tagId,
      final String? title,
      final String? description,
      final Map<String, dynamic>? tagData,
      final double? timestampSeconds}) = _$UpdateVideoTagRequestImpl;

  factory _UpdateVideoTagRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateVideoTagRequestImpl.fromJson;

  @override
  String get tagId;
  @override
  String? get title;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get tagData;
  @override
  double? get timestampSeconds;

  /// Create a copy of UpdateVideoTagRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateVideoTagRequestImplCopyWith<_$UpdateVideoTagRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VideoTagFilter _$VideoTagFilterFromJson(Map<String, dynamic> json) {
  return _VideoTagFilter.fromJson(json);
}

/// @nodoc
mixin _$VideoTagFilter {
  String? get videoId => throw _privateConstructorUsedError;
  String? get organizationId => throw _privateConstructorUsedError;
  List<VideoTagType>? get tagTypes => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  double? get timestampStart => throw _privateConstructorUsedError;
  double? get timestampEnd => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Serializes this VideoTagFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoTagFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoTagFilterCopyWith<VideoTagFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoTagFilterCopyWith<$Res> {
  factory $VideoTagFilterCopyWith(
          VideoTagFilter value, $Res Function(VideoTagFilter) then) =
      _$VideoTagFilterCopyWithImpl<$Res, VideoTagFilter>;
  @useResult
  $Res call(
      {String? videoId,
      String? organizationId,
      List<VideoTagType>? tagTypes,
      String? createdBy,
      DateTime? createdAfter,
      DateTime? createdBefore,
      double? timestampStart,
      double? timestampEnd,
      String? searchQuery,
      int limit,
      int offset});
}

/// @nodoc
class _$VideoTagFilterCopyWithImpl<$Res, $Val extends VideoTagFilter>
    implements $VideoTagFilterCopyWith<$Res> {
  _$VideoTagFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoTagFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = freezed,
    Object? organizationId = freezed,
    Object? tagTypes = freezed,
    Object? createdBy = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? timestampStart = freezed,
    Object? timestampEnd = freezed,
    Object? searchQuery = freezed,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_value.copyWith(
      videoId: freezed == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      tagTypes: freezed == tagTypes
          ? _value.tagTypes
          : tagTypes // ignore: cast_nullable_to_non_nullable
              as List<VideoTagType>?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestampStart: freezed == timestampStart
          ? _value.timestampStart
          : timestampStart // ignore: cast_nullable_to_non_nullable
              as double?,
      timestampEnd: freezed == timestampEnd
          ? _value.timestampEnd
          : timestampEnd // ignore: cast_nullable_to_non_nullable
              as double?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoTagFilterImplCopyWith<$Res>
    implements $VideoTagFilterCopyWith<$Res> {
  factory _$$VideoTagFilterImplCopyWith(_$VideoTagFilterImpl value,
          $Res Function(_$VideoTagFilterImpl) then) =
      __$$VideoTagFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? videoId,
      String? organizationId,
      List<VideoTagType>? tagTypes,
      String? createdBy,
      DateTime? createdAfter,
      DateTime? createdBefore,
      double? timestampStart,
      double? timestampEnd,
      String? searchQuery,
      int limit,
      int offset});
}

/// @nodoc
class __$$VideoTagFilterImplCopyWithImpl<$Res>
    extends _$VideoTagFilterCopyWithImpl<$Res, _$VideoTagFilterImpl>
    implements _$$VideoTagFilterImplCopyWith<$Res> {
  __$$VideoTagFilterImplCopyWithImpl(
      _$VideoTagFilterImpl _value, $Res Function(_$VideoTagFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoTagFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = freezed,
    Object? organizationId = freezed,
    Object? tagTypes = freezed,
    Object? createdBy = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? timestampStart = freezed,
    Object? timestampEnd = freezed,
    Object? searchQuery = freezed,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(_$VideoTagFilterImpl(
      videoId: freezed == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationId: freezed == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String?,
      tagTypes: freezed == tagTypes
          ? _value._tagTypes
          : tagTypes // ignore: cast_nullable_to_non_nullable
              as List<VideoTagType>?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestampStart: freezed == timestampStart
          ? _value.timestampStart
          : timestampStart // ignore: cast_nullable_to_non_nullable
              as double?,
      timestampEnd: freezed == timestampEnd
          ? _value.timestampEnd
          : timestampEnd // ignore: cast_nullable_to_non_nullable
              as double?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoTagFilterImpl extends _VideoTagFilter
    with DiagnosticableTreeMixin {
  const _$VideoTagFilterImpl(
      {this.videoId,
      this.organizationId,
      final List<VideoTagType>? tagTypes,
      this.createdBy,
      this.createdAfter,
      this.createdBefore,
      this.timestampStart,
      this.timestampEnd,
      this.searchQuery,
      this.limit = 50,
      this.offset = 0})
      : _tagTypes = tagTypes,
        super._();

  factory _$VideoTagFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoTagFilterImplFromJson(json);

  @override
  final String? videoId;
  @override
  final String? organizationId;
  final List<VideoTagType>? _tagTypes;
  @override
  List<VideoTagType>? get tagTypes {
    final value = _tagTypes;
    if (value == null) return null;
    if (_tagTypes is EqualUnmodifiableListView) return _tagTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? createdBy;
  @override
  final DateTime? createdAfter;
  @override
  final DateTime? createdBefore;
  @override
  final double? timestampStart;
  @override
  final double? timestampEnd;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int offset;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTagFilter(videoId: $videoId, organizationId: $organizationId, tagTypes: $tagTypes, createdBy: $createdBy, createdAfter: $createdAfter, createdBefore: $createdBefore, timestampStart: $timestampStart, timestampEnd: $timestampEnd, searchQuery: $searchQuery, limit: $limit, offset: $offset)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTagFilter'))
      ..add(DiagnosticsProperty('videoId', videoId))
      ..add(DiagnosticsProperty('organizationId', organizationId))
      ..add(DiagnosticsProperty('tagTypes', tagTypes))
      ..add(DiagnosticsProperty('createdBy', createdBy))
      ..add(DiagnosticsProperty('createdAfter', createdAfter))
      ..add(DiagnosticsProperty('createdBefore', createdBefore))
      ..add(DiagnosticsProperty('timestampStart', timestampStart))
      ..add(DiagnosticsProperty('timestampEnd', timestampEnd))
      ..add(DiagnosticsProperty('searchQuery', searchQuery))
      ..add(DiagnosticsProperty('limit', limit))
      ..add(DiagnosticsProperty('offset', offset));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTagFilterImpl &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            const DeepCollectionEquality().equals(other._tagTypes, _tagTypes) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.timestampStart, timestampStart) ||
                other.timestampStart == timestampStart) &&
            (identical(other.timestampEnd, timestampEnd) ||
                other.timestampEnd == timestampEnd) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      videoId,
      organizationId,
      const DeepCollectionEquality().hash(_tagTypes),
      createdBy,
      createdAfter,
      createdBefore,
      timestampStart,
      timestampEnd,
      searchQuery,
      limit,
      offset);

  /// Create a copy of VideoTagFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTagFilterImplCopyWith<_$VideoTagFilterImpl> get copyWith =>
      __$$VideoTagFilterImplCopyWithImpl<_$VideoTagFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoTagFilterImplToJson(
      this,
    );
  }
}

abstract class _VideoTagFilter extends VideoTagFilter {
  const factory _VideoTagFilter(
      {final String? videoId,
      final String? organizationId,
      final List<VideoTagType>? tagTypes,
      final String? createdBy,
      final DateTime? createdAfter,
      final DateTime? createdBefore,
      final double? timestampStart,
      final double? timestampEnd,
      final String? searchQuery,
      final int limit,
      final int offset}) = _$VideoTagFilterImpl;
  const _VideoTagFilter._() : super._();

  factory _VideoTagFilter.fromJson(Map<String, dynamic> json) =
      _$VideoTagFilterImpl.fromJson;

  @override
  String? get videoId;
  @override
  String? get organizationId;
  @override
  List<VideoTagType>? get tagTypes;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAfter;
  @override
  DateTime? get createdBefore;
  @override
  double? get timestampStart;
  @override
  double? get timestampEnd;
  @override
  String? get searchQuery;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of VideoTagFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTagFilterImplCopyWith<_$VideoTagFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoTagAnalytics _$VideoTagAnalyticsFromJson(Map<String, dynamic> json) {
  return _VideoTagAnalytics.fromJson(json);
}

/// @nodoc
mixin _$VideoTagAnalytics {
  int get totalTags => throw _privateConstructorUsedError;
  Map<VideoTagType, int> get tagsByType => throw _privateConstructorUsedError;
  Map<String, int> get tagsByCreator => throw _privateConstructorUsedError;
  double get averageTagsPerMinute => throw _privateConstructorUsedError;
  List<VideoTagHotspot> get hotspots => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this VideoTagAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoTagAnalyticsCopyWith<VideoTagAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoTagAnalyticsCopyWith<$Res> {
  factory $VideoTagAnalyticsCopyWith(
          VideoTagAnalytics value, $Res Function(VideoTagAnalytics) then) =
      _$VideoTagAnalyticsCopyWithImpl<$Res, VideoTagAnalytics>;
  @useResult
  $Res call(
      {int totalTags,
      Map<VideoTagType, int> tagsByType,
      Map<String, int> tagsByCreator,
      double averageTagsPerMinute,
      List<VideoTagHotspot> hotspots,
      DateTime generatedAt});
}

/// @nodoc
class _$VideoTagAnalyticsCopyWithImpl<$Res, $Val extends VideoTagAnalytics>
    implements $VideoTagAnalyticsCopyWith<$Res> {
  _$VideoTagAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTags = null,
    Object? tagsByType = null,
    Object? tagsByCreator = null,
    Object? averageTagsPerMinute = null,
    Object? hotspots = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      totalTags: null == totalTags
          ? _value.totalTags
          : totalTags // ignore: cast_nullable_to_non_nullable
              as int,
      tagsByType: null == tagsByType
          ? _value.tagsByType
          : tagsByType // ignore: cast_nullable_to_non_nullable
              as Map<VideoTagType, int>,
      tagsByCreator: null == tagsByCreator
          ? _value.tagsByCreator
          : tagsByCreator // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageTagsPerMinute: null == averageTagsPerMinute
          ? _value.averageTagsPerMinute
          : averageTagsPerMinute // ignore: cast_nullable_to_non_nullable
              as double,
      hotspots: null == hotspots
          ? _value.hotspots
          : hotspots // ignore: cast_nullable_to_non_nullable
              as List<VideoTagHotspot>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoTagAnalyticsImplCopyWith<$Res>
    implements $VideoTagAnalyticsCopyWith<$Res> {
  factory _$$VideoTagAnalyticsImplCopyWith(_$VideoTagAnalyticsImpl value,
          $Res Function(_$VideoTagAnalyticsImpl) then) =
      __$$VideoTagAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalTags,
      Map<VideoTagType, int> tagsByType,
      Map<String, int> tagsByCreator,
      double averageTagsPerMinute,
      List<VideoTagHotspot> hotspots,
      DateTime generatedAt});
}

/// @nodoc
class __$$VideoTagAnalyticsImplCopyWithImpl<$Res>
    extends _$VideoTagAnalyticsCopyWithImpl<$Res, _$VideoTagAnalyticsImpl>
    implements _$$VideoTagAnalyticsImplCopyWith<$Res> {
  __$$VideoTagAnalyticsImplCopyWithImpl(_$VideoTagAnalyticsImpl _value,
      $Res Function(_$VideoTagAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTags = null,
    Object? tagsByType = null,
    Object? tagsByCreator = null,
    Object? averageTagsPerMinute = null,
    Object? hotspots = null,
    Object? generatedAt = null,
  }) {
    return _then(_$VideoTagAnalyticsImpl(
      totalTags: null == totalTags
          ? _value.totalTags
          : totalTags // ignore: cast_nullable_to_non_nullable
              as int,
      tagsByType: null == tagsByType
          ? _value._tagsByType
          : tagsByType // ignore: cast_nullable_to_non_nullable
              as Map<VideoTagType, int>,
      tagsByCreator: null == tagsByCreator
          ? _value._tagsByCreator
          : tagsByCreator // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageTagsPerMinute: null == averageTagsPerMinute
          ? _value.averageTagsPerMinute
          : averageTagsPerMinute // ignore: cast_nullable_to_non_nullable
              as double,
      hotspots: null == hotspots
          ? _value._hotspots
          : hotspots // ignore: cast_nullable_to_non_nullable
              as List<VideoTagHotspot>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoTagAnalyticsImpl
    with DiagnosticableTreeMixin
    implements _VideoTagAnalytics {
  const _$VideoTagAnalyticsImpl(
      {required this.totalTags,
      required final Map<VideoTagType, int> tagsByType,
      required final Map<String, int> tagsByCreator,
      required this.averageTagsPerMinute,
      required final List<VideoTagHotspot> hotspots,
      required this.generatedAt})
      : _tagsByType = tagsByType,
        _tagsByCreator = tagsByCreator,
        _hotspots = hotspots;

  factory _$VideoTagAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoTagAnalyticsImplFromJson(json);

  @override
  final int totalTags;
  final Map<VideoTagType, int> _tagsByType;
  @override
  Map<VideoTagType, int> get tagsByType {
    if (_tagsByType is EqualUnmodifiableMapView) return _tagsByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tagsByType);
  }

  final Map<String, int> _tagsByCreator;
  @override
  Map<String, int> get tagsByCreator {
    if (_tagsByCreator is EqualUnmodifiableMapView) return _tagsByCreator;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tagsByCreator);
  }

  @override
  final double averageTagsPerMinute;
  final List<VideoTagHotspot> _hotspots;
  @override
  List<VideoTagHotspot> get hotspots {
    if (_hotspots is EqualUnmodifiableListView) return _hotspots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hotspots);
  }

  @override
  final DateTime generatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTagAnalytics(totalTags: $totalTags, tagsByType: $tagsByType, tagsByCreator: $tagsByCreator, averageTagsPerMinute: $averageTagsPerMinute, hotspots: $hotspots, generatedAt: $generatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTagAnalytics'))
      ..add(DiagnosticsProperty('totalTags', totalTags))
      ..add(DiagnosticsProperty('tagsByType', tagsByType))
      ..add(DiagnosticsProperty('tagsByCreator', tagsByCreator))
      ..add(DiagnosticsProperty('averageTagsPerMinute', averageTagsPerMinute))
      ..add(DiagnosticsProperty('hotspots', hotspots))
      ..add(DiagnosticsProperty('generatedAt', generatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTagAnalyticsImpl &&
            (identical(other.totalTags, totalTags) ||
                other.totalTags == totalTags) &&
            const DeepCollectionEquality()
                .equals(other._tagsByType, _tagsByType) &&
            const DeepCollectionEquality()
                .equals(other._tagsByCreator, _tagsByCreator) &&
            (identical(other.averageTagsPerMinute, averageTagsPerMinute) ||
                other.averageTagsPerMinute == averageTagsPerMinute) &&
            const DeepCollectionEquality().equals(other._hotspots, _hotspots) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalTags,
      const DeepCollectionEquality().hash(_tagsByType),
      const DeepCollectionEquality().hash(_tagsByCreator),
      averageTagsPerMinute,
      const DeepCollectionEquality().hash(_hotspots),
      generatedAt);

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTagAnalyticsImplCopyWith<_$VideoTagAnalyticsImpl> get copyWith =>
      __$$VideoTagAnalyticsImplCopyWithImpl<_$VideoTagAnalyticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoTagAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _VideoTagAnalytics implements VideoTagAnalytics {
  const factory _VideoTagAnalytics(
      {required final int totalTags,
      required final Map<VideoTagType, int> tagsByType,
      required final Map<String, int> tagsByCreator,
      required final double averageTagsPerMinute,
      required final List<VideoTagHotspot> hotspots,
      required final DateTime generatedAt}) = _$VideoTagAnalyticsImpl;

  factory _VideoTagAnalytics.fromJson(Map<String, dynamic> json) =
      _$VideoTagAnalyticsImpl.fromJson;

  @override
  int get totalTags;
  @override
  Map<VideoTagType, int> get tagsByType;
  @override
  Map<String, int> get tagsByCreator;
  @override
  double get averageTagsPerMinute;
  @override
  List<VideoTagHotspot> get hotspots;
  @override
  DateTime get generatedAt;

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTagAnalyticsImplCopyWith<_$VideoTagAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoTagHotspot _$VideoTagHotspotFromJson(Map<String, dynamic> json) {
  return _VideoTagHotspot.fromJson(json);
}

/// @nodoc
mixin _$VideoTagHotspot {
  double get startSeconds => throw _privateConstructorUsedError;
  double get endSeconds => throw _privateConstructorUsedError;
  int get tagCount => throw _privateConstructorUsedError;
  List<VideoTagType> get dominantTagTypes => throw _privateConstructorUsedError;

  /// Serializes this VideoTagHotspot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoTagHotspotCopyWith<VideoTagHotspot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoTagHotspotCopyWith<$Res> {
  factory $VideoTagHotspotCopyWith(
          VideoTagHotspot value, $Res Function(VideoTagHotspot) then) =
      _$VideoTagHotspotCopyWithImpl<$Res, VideoTagHotspot>;
  @useResult
  $Res call(
      {double startSeconds,
      double endSeconds,
      int tagCount,
      List<VideoTagType> dominantTagTypes});
}

/// @nodoc
class _$VideoTagHotspotCopyWithImpl<$Res, $Val extends VideoTagHotspot>
    implements $VideoTagHotspotCopyWith<$Res> {
  _$VideoTagHotspotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startSeconds = null,
    Object? endSeconds = null,
    Object? tagCount = null,
    Object? dominantTagTypes = null,
  }) {
    return _then(_value.copyWith(
      startSeconds: null == startSeconds
          ? _value.startSeconds
          : startSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      endSeconds: null == endSeconds
          ? _value.endSeconds
          : endSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      tagCount: null == tagCount
          ? _value.tagCount
          : tagCount // ignore: cast_nullable_to_non_nullable
              as int,
      dominantTagTypes: null == dominantTagTypes
          ? _value.dominantTagTypes
          : dominantTagTypes // ignore: cast_nullable_to_non_nullable
              as List<VideoTagType>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoTagHotspotImplCopyWith<$Res>
    implements $VideoTagHotspotCopyWith<$Res> {
  factory _$$VideoTagHotspotImplCopyWith(_$VideoTagHotspotImpl value,
          $Res Function(_$VideoTagHotspotImpl) then) =
      __$$VideoTagHotspotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double startSeconds,
      double endSeconds,
      int tagCount,
      List<VideoTagType> dominantTagTypes});
}

/// @nodoc
class __$$VideoTagHotspotImplCopyWithImpl<$Res>
    extends _$VideoTagHotspotCopyWithImpl<$Res, _$VideoTagHotspotImpl>
    implements _$$VideoTagHotspotImplCopyWith<$Res> {
  __$$VideoTagHotspotImplCopyWithImpl(
      _$VideoTagHotspotImpl _value, $Res Function(_$VideoTagHotspotImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startSeconds = null,
    Object? endSeconds = null,
    Object? tagCount = null,
    Object? dominantTagTypes = null,
  }) {
    return _then(_$VideoTagHotspotImpl(
      startSeconds: null == startSeconds
          ? _value.startSeconds
          : startSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      endSeconds: null == endSeconds
          ? _value.endSeconds
          : endSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      tagCount: null == tagCount
          ? _value.tagCount
          : tagCount // ignore: cast_nullable_to_non_nullable
              as int,
      dominantTagTypes: null == dominantTagTypes
          ? _value._dominantTagTypes
          : dominantTagTypes // ignore: cast_nullable_to_non_nullable
              as List<VideoTagType>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoTagHotspotImpl extends _VideoTagHotspot
    with DiagnosticableTreeMixin {
  const _$VideoTagHotspotImpl(
      {required this.startSeconds,
      required this.endSeconds,
      required this.tagCount,
      required final List<VideoTagType> dominantTagTypes})
      : _dominantTagTypes = dominantTagTypes,
        super._();

  factory _$VideoTagHotspotImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoTagHotspotImplFromJson(json);

  @override
  final double startSeconds;
  @override
  final double endSeconds;
  @override
  final int tagCount;
  final List<VideoTagType> _dominantTagTypes;
  @override
  List<VideoTagType> get dominantTagTypes {
    if (_dominantTagTypes is EqualUnmodifiableListView)
      return _dominantTagTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dominantTagTypes);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTagHotspot(startSeconds: $startSeconds, endSeconds: $endSeconds, tagCount: $tagCount, dominantTagTypes: $dominantTagTypes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTagHotspot'))
      ..add(DiagnosticsProperty('startSeconds', startSeconds))
      ..add(DiagnosticsProperty('endSeconds', endSeconds))
      ..add(DiagnosticsProperty('tagCount', tagCount))
      ..add(DiagnosticsProperty('dominantTagTypes', dominantTagTypes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTagHotspotImpl &&
            (identical(other.startSeconds, startSeconds) ||
                other.startSeconds == startSeconds) &&
            (identical(other.endSeconds, endSeconds) ||
                other.endSeconds == endSeconds) &&
            (identical(other.tagCount, tagCount) ||
                other.tagCount == tagCount) &&
            const DeepCollectionEquality()
                .equals(other._dominantTagTypes, _dominantTagTypes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startSeconds, endSeconds,
      tagCount, const DeepCollectionEquality().hash(_dominantTagTypes));

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTagHotspotImplCopyWith<_$VideoTagHotspotImpl> get copyWith =>
      __$$VideoTagHotspotImplCopyWithImpl<_$VideoTagHotspotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoTagHotspotImplToJson(
      this,
    );
  }
}

abstract class _VideoTagHotspot extends VideoTagHotspot {
  const factory _VideoTagHotspot(
          {required final double startSeconds,
          required final double endSeconds,
          required final int tagCount,
          required final List<VideoTagType> dominantTagTypes}) =
      _$VideoTagHotspotImpl;
  const _VideoTagHotspot._() : super._();

  factory _VideoTagHotspot.fromJson(Map<String, dynamic> json) =
      _$VideoTagHotspotImpl.fromJson;

  @override
  double get startSeconds;
  @override
  double get endSeconds;
  @override
  int get tagCount;
  @override
  List<VideoTagType> get dominantTagTypes;

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTagHotspotImplCopyWith<_$VideoTagHotspotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
