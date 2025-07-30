// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Video _$VideoFromJson(Map<String, dynamic> json) {
  return _Video.fromJson(json);
}

/// @nodoc
mixin _$Video {
  String get id => throw _privateConstructorUsedError;
  String get organizationId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get playerId => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String? get videoUrl =>
      throw _privateConstructorUsedError; // Legacy field - use fileUrl for new videos
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  int get resolutionWidth => throw _privateConstructorUsedError;
  int get resolutionHeight => throw _privateConstructorUsedError;
  String get encodingFormat => throw _privateConstructorUsedError;
  VideoProcessingStatus get processingStatus =>
      throw _privateConstructorUsedError;
  String? get processingError => throw _privateConstructorUsedError;
  Map<String, dynamic> get videoMetadata => throw _privateConstructorUsedError;
  Map<String, dynamic> get tagData => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<VideoTimeCode> get timeCodes => throw _privateConstructorUsedError;
  List<VideoCoordinate> get coordinates => throw _privateConstructorUsedError;
  double get aiConfidence => throw _privateConstructorUsedError;
  bool get aiProcessed => throw _privateConstructorUsedError;
  DateTime? get aiProcessedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this Video to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCopyWith<Video> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCopyWith<$Res> {
  factory $VideoCopyWith(Video value, $Res Function(Video) then) =
      _$VideoCopyWithImpl<$Res, Video>;
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String title,
      String? description,
      String? playerId,
      String fileUrl,
      String? videoUrl,
      String? thumbnailUrl,
      int durationSeconds,
      int fileSizeBytes,
      int resolutionWidth,
      int resolutionHeight,
      String encodingFormat,
      VideoProcessingStatus processingStatus,
      String? processingError,
      Map<String, dynamic> videoMetadata,
      Map<String, dynamic> tagData,
      List<String> tags,
      List<VideoTimeCode> timeCodes,
      List<VideoCoordinate> coordinates,
      double aiConfidence,
      bool aiProcessed,
      DateTime? aiProcessedAt,
      DateTime createdAt,
      DateTime updatedAt,
      String? createdBy});
}

/// @nodoc
class _$VideoCopyWithImpl<$Res, $Val extends Video>
    implements $VideoCopyWith<$Res> {
  _$VideoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? title = null,
    Object? description = freezed,
    Object? playerId = freezed,
    Object? fileUrl = null,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? durationSeconds = null,
    Object? fileSizeBytes = null,
    Object? resolutionWidth = null,
    Object? resolutionHeight = null,
    Object? encodingFormat = null,
    Object? processingStatus = null,
    Object? processingError = freezed,
    Object? videoMetadata = null,
    Object? tagData = null,
    Object? tags = null,
    Object? timeCodes = null,
    Object? coordinates = null,
    Object? aiConfidence = null,
    Object? aiProcessed = null,
    Object? aiProcessedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      resolutionWidth: null == resolutionWidth
          ? _value.resolutionWidth
          : resolutionWidth // ignore: cast_nullable_to_non_nullable
              as int,
      resolutionHeight: null == resolutionHeight
          ? _value.resolutionHeight
          : resolutionHeight // ignore: cast_nullable_to_non_nullable
              as int,
      encodingFormat: null == encodingFormat
          ? _value.encodingFormat
          : encodingFormat // ignore: cast_nullable_to_non_nullable
              as String,
      processingStatus: null == processingStatus
          ? _value.processingStatus
          : processingStatus // ignore: cast_nullable_to_non_nullable
              as VideoProcessingStatus,
      processingError: freezed == processingError
          ? _value.processingError
          : processingError // ignore: cast_nullable_to_non_nullable
              as String?,
      videoMetadata: null == videoMetadata
          ? _value.videoMetadata
          : videoMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      tagData: null == tagData
          ? _value.tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeCodes: null == timeCodes
          ? _value.timeCodes
          : timeCodes // ignore: cast_nullable_to_non_nullable
              as List<VideoTimeCode>,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<VideoCoordinate>,
      aiConfidence: null == aiConfidence
          ? _value.aiConfidence
          : aiConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      aiProcessed: null == aiProcessed
          ? _value.aiProcessed
          : aiProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      aiProcessedAt: freezed == aiProcessedAt
          ? _value.aiProcessedAt
          : aiProcessedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoImplCopyWith<$Res> implements $VideoCopyWith<$Res> {
  factory _$$VideoImplCopyWith(
          _$VideoImpl value, $Res Function(_$VideoImpl) then) =
      __$$VideoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String organizationId,
      String title,
      String? description,
      String? playerId,
      String fileUrl,
      String? videoUrl,
      String? thumbnailUrl,
      int durationSeconds,
      int fileSizeBytes,
      int resolutionWidth,
      int resolutionHeight,
      String encodingFormat,
      VideoProcessingStatus processingStatus,
      String? processingError,
      Map<String, dynamic> videoMetadata,
      Map<String, dynamic> tagData,
      List<String> tags,
      List<VideoTimeCode> timeCodes,
      List<VideoCoordinate> coordinates,
      double aiConfidence,
      bool aiProcessed,
      DateTime? aiProcessedAt,
      DateTime createdAt,
      DateTime updatedAt,
      String? createdBy});
}

/// @nodoc
class __$$VideoImplCopyWithImpl<$Res>
    extends _$VideoCopyWithImpl<$Res, _$VideoImpl>
    implements _$$VideoImplCopyWith<$Res> {
  __$$VideoImplCopyWithImpl(
      _$VideoImpl _value, $Res Function(_$VideoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? organizationId = null,
    Object? title = null,
    Object? description = freezed,
    Object? playerId = freezed,
    Object? fileUrl = null,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? durationSeconds = null,
    Object? fileSizeBytes = null,
    Object? resolutionWidth = null,
    Object? resolutionHeight = null,
    Object? encodingFormat = null,
    Object? processingStatus = null,
    Object? processingError = freezed,
    Object? videoMetadata = null,
    Object? tagData = null,
    Object? tags = null,
    Object? timeCodes = null,
    Object? coordinates = null,
    Object? aiConfidence = null,
    Object? aiProcessed = null,
    Object? aiProcessedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
  }) {
    return _then(_$VideoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: freezed == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      durationSeconds: null == durationSeconds
          ? _value.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      resolutionWidth: null == resolutionWidth
          ? _value.resolutionWidth
          : resolutionWidth // ignore: cast_nullable_to_non_nullable
              as int,
      resolutionHeight: null == resolutionHeight
          ? _value.resolutionHeight
          : resolutionHeight // ignore: cast_nullable_to_non_nullable
              as int,
      encodingFormat: null == encodingFormat
          ? _value.encodingFormat
          : encodingFormat // ignore: cast_nullable_to_non_nullable
              as String,
      processingStatus: null == processingStatus
          ? _value.processingStatus
          : processingStatus // ignore: cast_nullable_to_non_nullable
              as VideoProcessingStatus,
      processingError: freezed == processingError
          ? _value.processingError
          : processingError // ignore: cast_nullable_to_non_nullable
              as String?,
      videoMetadata: null == videoMetadata
          ? _value._videoMetadata
          : videoMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      tagData: null == tagData
          ? _value._tagData
          : tagData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeCodes: null == timeCodes
          ? _value._timeCodes
          : timeCodes // ignore: cast_nullable_to_non_nullable
              as List<VideoTimeCode>,
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<VideoCoordinate>,
      aiConfidence: null == aiConfidence
          ? _value.aiConfidence
          : aiConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      aiProcessed: null == aiProcessed
          ? _value.aiProcessed
          : aiProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      aiProcessedAt: freezed == aiProcessedAt
          ? _value.aiProcessedAt
          : aiProcessedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoImpl implements _Video {
  const _$VideoImpl(
      {required this.id,
      required this.organizationId,
      required this.title,
      this.description,
      this.playerId,
      required this.fileUrl,
      this.videoUrl,
      this.thumbnailUrl,
      required this.durationSeconds,
      required this.fileSizeBytes,
      required this.resolutionWidth,
      required this.resolutionHeight,
      this.encodingFormat = 'mp4',
      this.processingStatus = VideoProcessingStatus.pending,
      this.processingError,
      final Map<String, dynamic> videoMetadata = const {},
      final Map<String, dynamic> tagData = const {},
      final List<String> tags = const [],
      final List<VideoTimeCode> timeCodes = const [],
      final List<VideoCoordinate> coordinates = const [],
      this.aiConfidence = 0.0,
      this.aiProcessed = false,
      this.aiProcessedAt,
      required this.createdAt,
      required this.updatedAt,
      this.createdBy})
      : _videoMetadata = videoMetadata,
        _tagData = tagData,
        _tags = tags,
        _timeCodes = timeCodes,
        _coordinates = coordinates;

  factory _$VideoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoImplFromJson(json);

  @override
  final String id;
  @override
  final String organizationId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? playerId;
  @override
  final String fileUrl;
  @override
  final String? videoUrl;
// Legacy field - use fileUrl for new videos
  @override
  final String? thumbnailUrl;
  @override
  final int durationSeconds;
  @override
  final int fileSizeBytes;
  @override
  final int resolutionWidth;
  @override
  final int resolutionHeight;
  @override
  @JsonKey()
  final String encodingFormat;
  @override
  @JsonKey()
  final VideoProcessingStatus processingStatus;
  @override
  final String? processingError;
  final Map<String, dynamic> _videoMetadata;
  @override
  @JsonKey()
  Map<String, dynamic> get videoMetadata {
    if (_videoMetadata is EqualUnmodifiableMapView) return _videoMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_videoMetadata);
  }

  final Map<String, dynamic> _tagData;
  @override
  @JsonKey()
  Map<String, dynamic> get tagData {
    if (_tagData is EqualUnmodifiableMapView) return _tagData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tagData);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<VideoTimeCode> _timeCodes;
  @override
  @JsonKey()
  List<VideoTimeCode> get timeCodes {
    if (_timeCodes is EqualUnmodifiableListView) return _timeCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeCodes);
  }

  final List<VideoCoordinate> _coordinates;
  @override
  @JsonKey()
  List<VideoCoordinate> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  @JsonKey()
  final double aiConfidence;
  @override
  @JsonKey()
  final bool aiProcessed;
  @override
  final DateTime? aiProcessedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'Video(id: $id, organizationId: $organizationId, title: $title, description: $description, playerId: $playerId, fileUrl: $fileUrl, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, durationSeconds: $durationSeconds, fileSizeBytes: $fileSizeBytes, resolutionWidth: $resolutionWidth, resolutionHeight: $resolutionHeight, encodingFormat: $encodingFormat, processingStatus: $processingStatus, processingError: $processingError, videoMetadata: $videoMetadata, tagData: $tagData, tags: $tags, timeCodes: $timeCodes, coordinates: $coordinates, aiConfidence: $aiConfidence, aiProcessed: $aiProcessed, aiProcessedAt: $aiProcessedAt, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.resolutionWidth, resolutionWidth) ||
                other.resolutionWidth == resolutionWidth) &&
            (identical(other.resolutionHeight, resolutionHeight) ||
                other.resolutionHeight == resolutionHeight) &&
            (identical(other.encodingFormat, encodingFormat) ||
                other.encodingFormat == encodingFormat) &&
            (identical(other.processingStatus, processingStatus) ||
                other.processingStatus == processingStatus) &&
            (identical(other.processingError, processingError) ||
                other.processingError == processingError) &&
            const DeepCollectionEquality()
                .equals(other._videoMetadata, _videoMetadata) &&
            const DeepCollectionEquality().equals(other._tagData, _tagData) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._timeCodes, _timeCodes) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates) &&
            (identical(other.aiConfidence, aiConfidence) ||
                other.aiConfidence == aiConfidence) &&
            (identical(other.aiProcessed, aiProcessed) ||
                other.aiProcessed == aiProcessed) &&
            (identical(other.aiProcessedAt, aiProcessedAt) ||
                other.aiProcessedAt == aiProcessedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        organizationId,
        title,
        description,
        playerId,
        fileUrl,
        videoUrl,
        thumbnailUrl,
        durationSeconds,
        fileSizeBytes,
        resolutionWidth,
        resolutionHeight,
        encodingFormat,
        processingStatus,
        processingError,
        const DeepCollectionEquality().hash(_videoMetadata),
        const DeepCollectionEquality().hash(_tagData),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_timeCodes),
        const DeepCollectionEquality().hash(_coordinates),
        aiConfidence,
        aiProcessed,
        aiProcessedAt,
        createdAt,
        updatedAt,
        createdBy
      ]);

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      __$$VideoImplCopyWithImpl<_$VideoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoImplToJson(
      this,
    );
  }
}

abstract class _Video implements Video {
  const factory _Video(
      {required final String id,
      required final String organizationId,
      required final String title,
      final String? description,
      final String? playerId,
      required final String fileUrl,
      final String? videoUrl,
      final String? thumbnailUrl,
      required final int durationSeconds,
      required final int fileSizeBytes,
      required final int resolutionWidth,
      required final int resolutionHeight,
      final String encodingFormat,
      final VideoProcessingStatus processingStatus,
      final String? processingError,
      final Map<String, dynamic> videoMetadata,
      final Map<String, dynamic> tagData,
      final List<String> tags,
      final List<VideoTimeCode> timeCodes,
      final List<VideoCoordinate> coordinates,
      final double aiConfidence,
      final bool aiProcessed,
      final DateTime? aiProcessedAt,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? createdBy}) = _$VideoImpl;

  factory _Video.fromJson(Map<String, dynamic> json) = _$VideoImpl.fromJson;

  @override
  String get id;
  @override
  String get organizationId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get playerId;
  @override
  String get fileUrl;
  @override
  String? get videoUrl; // Legacy field - use fileUrl for new videos
  @override
  String? get thumbnailUrl;
  @override
  int get durationSeconds;
  @override
  int get fileSizeBytes;
  @override
  int get resolutionWidth;
  @override
  int get resolutionHeight;
  @override
  String get encodingFormat;
  @override
  VideoProcessingStatus get processingStatus;
  @override
  String? get processingError;
  @override
  Map<String, dynamic> get videoMetadata;
  @override
  Map<String, dynamic> get tagData;
  @override
  List<String> get tags;
  @override
  List<VideoTimeCode> get timeCodes;
  @override
  List<VideoCoordinate> get coordinates;
  @override
  double get aiConfidence;
  @override
  bool get aiProcessed;
  @override
  DateTime? get aiProcessedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get createdBy;

  /// Create a copy of Video
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoImplCopyWith<_$VideoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoTimeCode _$VideoTimeCodeFromJson(Map<String, dynamic> json) {
  return _VideoTimeCode.fromJson(json);
}

/// @nodoc
mixin _$VideoTimeCode {
  double get startSeconds => throw _privateConstructorUsedError;
  double get endSeconds => throw _privateConstructorUsedError;
  String get tag => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this VideoTimeCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoTimeCodeCopyWith<VideoTimeCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoTimeCodeCopyWith<$Res> {
  factory $VideoTimeCodeCopyWith(
          VideoTimeCode value, $Res Function(VideoTimeCode) then) =
      _$VideoTimeCodeCopyWithImpl<$Res, VideoTimeCode>;
  @useResult
  $Res call(
      {double startSeconds,
      double endSeconds,
      String tag,
      String? description,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$VideoTimeCodeCopyWithImpl<$Res, $Val extends VideoTimeCode>
    implements $VideoTimeCodeCopyWith<$Res> {
  _$VideoTimeCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startSeconds = null,
    Object? endSeconds = null,
    Object? tag = null,
    Object? description = freezed,
    Object? metadata = null,
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
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoTimeCodeImplCopyWith<$Res>
    implements $VideoTimeCodeCopyWith<$Res> {
  factory _$$VideoTimeCodeImplCopyWith(
          _$VideoTimeCodeImpl value, $Res Function(_$VideoTimeCodeImpl) then) =
      __$$VideoTimeCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double startSeconds,
      double endSeconds,
      String tag,
      String? description,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$VideoTimeCodeImplCopyWithImpl<$Res>
    extends _$VideoTimeCodeCopyWithImpl<$Res, _$VideoTimeCodeImpl>
    implements _$$VideoTimeCodeImplCopyWith<$Res> {
  __$$VideoTimeCodeImplCopyWithImpl(
      _$VideoTimeCodeImpl _value, $Res Function(_$VideoTimeCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startSeconds = null,
    Object? endSeconds = null,
    Object? tag = null,
    Object? description = freezed,
    Object? metadata = null,
  }) {
    return _then(_$VideoTimeCodeImpl(
      startSeconds: null == startSeconds
          ? _value.startSeconds
          : startSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      endSeconds: null == endSeconds
          ? _value.endSeconds
          : endSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoTimeCodeImpl implements _VideoTimeCode {
  const _$VideoTimeCodeImpl(
      {required this.startSeconds,
      required this.endSeconds,
      required this.tag,
      this.description,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$VideoTimeCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoTimeCodeImplFromJson(json);

  @override
  final double startSeconds;
  @override
  final double endSeconds;
  @override
  final String tag;
  @override
  final String? description;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'VideoTimeCode(startSeconds: $startSeconds, endSeconds: $endSeconds, tag: $tag, description: $description, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTimeCodeImpl &&
            (identical(other.startSeconds, startSeconds) ||
                other.startSeconds == startSeconds) &&
            (identical(other.endSeconds, endSeconds) ||
                other.endSeconds == endSeconds) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startSeconds, endSeconds, tag,
      description, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of VideoTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTimeCodeImplCopyWith<_$VideoTimeCodeImpl> get copyWith =>
      __$$VideoTimeCodeImplCopyWithImpl<_$VideoTimeCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoTimeCodeImplToJson(
      this,
    );
  }
}

abstract class _VideoTimeCode implements VideoTimeCode {
  const factory _VideoTimeCode(
      {required final double startSeconds,
      required final double endSeconds,
      required final String tag,
      final String? description,
      final Map<String, dynamic> metadata}) = _$VideoTimeCodeImpl;

  factory _VideoTimeCode.fromJson(Map<String, dynamic> json) =
      _$VideoTimeCodeImpl.fromJson;

  @override
  double get startSeconds;
  @override
  double get endSeconds;
  @override
  String get tag;
  @override
  String? get description;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of VideoTimeCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTimeCodeImplCopyWith<_$VideoTimeCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoCoordinate _$VideoCoordinateFromJson(Map<String, dynamic> json) {
  return _VideoCoordinate.fromJson(json);
}

/// @nodoc
mixin _$VideoCoordinate {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get timeSeconds => throw _privateConstructorUsedError;
  String? get playerId => throw _privateConstructorUsedError;
  String? get action => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this VideoCoordinate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoCoordinateCopyWith<VideoCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoCoordinateCopyWith<$Res> {
  factory $VideoCoordinateCopyWith(
          VideoCoordinate value, $Res Function(VideoCoordinate) then) =
      _$VideoCoordinateCopyWithImpl<$Res, VideoCoordinate>;
  @useResult
  $Res call(
      {double x,
      double y,
      double timeSeconds,
      String? playerId,
      String? action,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$VideoCoordinateCopyWithImpl<$Res, $Val extends VideoCoordinate>
    implements $VideoCoordinateCopyWith<$Res> {
  _$VideoCoordinateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? timeSeconds = null,
    Object? playerId = freezed,
    Object? action = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      timeSeconds: null == timeSeconds
          ? _value.timeSeconds
          : timeSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoCoordinateImplCopyWith<$Res>
    implements $VideoCoordinateCopyWith<$Res> {
  factory _$$VideoCoordinateImplCopyWith(_$VideoCoordinateImpl value,
          $Res Function(_$VideoCoordinateImpl) then) =
      __$$VideoCoordinateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double x,
      double y,
      double timeSeconds,
      String? playerId,
      String? action,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$VideoCoordinateImplCopyWithImpl<$Res>
    extends _$VideoCoordinateCopyWithImpl<$Res, _$VideoCoordinateImpl>
    implements _$$VideoCoordinateImplCopyWith<$Res> {
  __$$VideoCoordinateImplCopyWithImpl(
      _$VideoCoordinateImpl _value, $Res Function(_$VideoCoordinateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? timeSeconds = null,
    Object? playerId = freezed,
    Object? action = freezed,
    Object? metadata = null,
  }) {
    return _then(_$VideoCoordinateImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      timeSeconds: null == timeSeconds
          ? _value.timeSeconds
          : timeSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoCoordinateImpl implements _VideoCoordinate {
  const _$VideoCoordinateImpl(
      {required this.x,
      required this.y,
      required this.timeSeconds,
      this.playerId,
      this.action,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$VideoCoordinateImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoCoordinateImplFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  final double timeSeconds;
  @override
  final String? playerId;
  @override
  final String? action;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'VideoCoordinate(x: $x, y: $y, timeSeconds: $timeSeconds, playerId: $playerId, action: $action, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoCoordinateImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.timeSeconds, timeSeconds) ||
                other.timeSeconds == timeSeconds) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, timeSeconds, playerId,
      action, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of VideoCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoCoordinateImplCopyWith<_$VideoCoordinateImpl> get copyWith =>
      __$$VideoCoordinateImplCopyWithImpl<_$VideoCoordinateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoCoordinateImplToJson(
      this,
    );
  }
}

abstract class _VideoCoordinate implements VideoCoordinate {
  const factory _VideoCoordinate(
      {required final double x,
      required final double y,
      required final double timeSeconds,
      final String? playerId,
      final String? action,
      final Map<String, dynamic> metadata}) = _$VideoCoordinateImpl;

  factory _VideoCoordinate.fromJson(Map<String, dynamic> json) =
      _$VideoCoordinateImpl.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get timeSeconds;
  @override
  String? get playerId;
  @override
  String? get action;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of VideoCoordinate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoCoordinateImplCopyWith<_$VideoCoordinateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoAnalytics _$VideoAnalyticsFromJson(Map<String, dynamic> json) {
  return _VideoAnalytics.fromJson(json);
}

/// @nodoc
mixin _$VideoAnalytics {
  String get organizationId => throw _privateConstructorUsedError;
  int get totalVideos => throw _privateConstructorUsedError;
  int get readyVideos => throw _privateConstructorUsedError;
  int get processingVideos => throw _privateConstructorUsedError;
  int get errorVideos => throw _privateConstructorUsedError;
  int get totalStorageBytes => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;
  double get avgDurationSeconds => throw _privateConstructorUsedError;
  int get videosLast30Days => throw _privateConstructorUsedError;
  int get videosLast7Days => throw _privateConstructorUsedError;

  /// Serializes this VideoAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoAnalyticsCopyWith<VideoAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoAnalyticsCopyWith<$Res> {
  factory $VideoAnalyticsCopyWith(
          VideoAnalytics value, $Res Function(VideoAnalytics) then) =
      _$VideoAnalyticsCopyWithImpl<$Res, VideoAnalytics>;
  @useResult
  $Res call(
      {String organizationId,
      int totalVideos,
      int readyVideos,
      int processingVideos,
      int errorVideos,
      int totalStorageBytes,
      int totalDurationSeconds,
      double avgDurationSeconds,
      int videosLast30Days,
      int videosLast7Days});
}

/// @nodoc
class _$VideoAnalyticsCopyWithImpl<$Res, $Val extends VideoAnalytics>
    implements $VideoAnalyticsCopyWith<$Res> {
  _$VideoAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? totalVideos = null,
    Object? readyVideos = null,
    Object? processingVideos = null,
    Object? errorVideos = null,
    Object? totalStorageBytes = null,
    Object? totalDurationSeconds = null,
    Object? avgDurationSeconds = null,
    Object? videosLast30Days = null,
    Object? videosLast7Days = null,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      totalVideos: null == totalVideos
          ? _value.totalVideos
          : totalVideos // ignore: cast_nullable_to_non_nullable
              as int,
      readyVideos: null == readyVideos
          ? _value.readyVideos
          : readyVideos // ignore: cast_nullable_to_non_nullable
              as int,
      processingVideos: null == processingVideos
          ? _value.processingVideos
          : processingVideos // ignore: cast_nullable_to_non_nullable
              as int,
      errorVideos: null == errorVideos
          ? _value.errorVideos
          : errorVideos // ignore: cast_nullable_to_non_nullable
              as int,
      totalStorageBytes: null == totalStorageBytes
          ? _value.totalStorageBytes
          : totalStorageBytes // ignore: cast_nullable_to_non_nullable
              as int,
      totalDurationSeconds: null == totalDurationSeconds
          ? _value.totalDurationSeconds
          : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      avgDurationSeconds: null == avgDurationSeconds
          ? _value.avgDurationSeconds
          : avgDurationSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      videosLast30Days: null == videosLast30Days
          ? _value.videosLast30Days
          : videosLast30Days // ignore: cast_nullable_to_non_nullable
              as int,
      videosLast7Days: null == videosLast7Days
          ? _value.videosLast7Days
          : videosLast7Days // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoAnalyticsImplCopyWith<$Res>
    implements $VideoAnalyticsCopyWith<$Res> {
  factory _$$VideoAnalyticsImplCopyWith(_$VideoAnalyticsImpl value,
          $Res Function(_$VideoAnalyticsImpl) then) =
      __$$VideoAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String organizationId,
      int totalVideos,
      int readyVideos,
      int processingVideos,
      int errorVideos,
      int totalStorageBytes,
      int totalDurationSeconds,
      double avgDurationSeconds,
      int videosLast30Days,
      int videosLast7Days});
}

/// @nodoc
class __$$VideoAnalyticsImplCopyWithImpl<$Res>
    extends _$VideoAnalyticsCopyWithImpl<$Res, _$VideoAnalyticsImpl>
    implements _$$VideoAnalyticsImplCopyWith<$Res> {
  __$$VideoAnalyticsImplCopyWithImpl(
      _$VideoAnalyticsImpl _value, $Res Function(_$VideoAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? totalVideos = null,
    Object? readyVideos = null,
    Object? processingVideos = null,
    Object? errorVideos = null,
    Object? totalStorageBytes = null,
    Object? totalDurationSeconds = null,
    Object? avgDurationSeconds = null,
    Object? videosLast30Days = null,
    Object? videosLast7Days = null,
  }) {
    return _then(_$VideoAnalyticsImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      totalVideos: null == totalVideos
          ? _value.totalVideos
          : totalVideos // ignore: cast_nullable_to_non_nullable
              as int,
      readyVideos: null == readyVideos
          ? _value.readyVideos
          : readyVideos // ignore: cast_nullable_to_non_nullable
              as int,
      processingVideos: null == processingVideos
          ? _value.processingVideos
          : processingVideos // ignore: cast_nullable_to_non_nullable
              as int,
      errorVideos: null == errorVideos
          ? _value.errorVideos
          : errorVideos // ignore: cast_nullable_to_non_nullable
              as int,
      totalStorageBytes: null == totalStorageBytes
          ? _value.totalStorageBytes
          : totalStorageBytes // ignore: cast_nullable_to_non_nullable
              as int,
      totalDurationSeconds: null == totalDurationSeconds
          ? _value.totalDurationSeconds
          : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      avgDurationSeconds: null == avgDurationSeconds
          ? _value.avgDurationSeconds
          : avgDurationSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      videosLast30Days: null == videosLast30Days
          ? _value.videosLast30Days
          : videosLast30Days // ignore: cast_nullable_to_non_nullable
              as int,
      videosLast7Days: null == videosLast7Days
          ? _value.videosLast7Days
          : videosLast7Days // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoAnalyticsImpl implements _VideoAnalytics {
  const _$VideoAnalyticsImpl(
      {required this.organizationId,
      required this.totalVideos,
      required this.readyVideos,
      required this.processingVideos,
      required this.errorVideos,
      required this.totalStorageBytes,
      required this.totalDurationSeconds,
      required this.avgDurationSeconds,
      required this.videosLast30Days,
      required this.videosLast7Days});

  factory _$VideoAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoAnalyticsImplFromJson(json);

  @override
  final String organizationId;
  @override
  final int totalVideos;
  @override
  final int readyVideos;
  @override
  final int processingVideos;
  @override
  final int errorVideos;
  @override
  final int totalStorageBytes;
  @override
  final int totalDurationSeconds;
  @override
  final double avgDurationSeconds;
  @override
  final int videosLast30Days;
  @override
  final int videosLast7Days;

  @override
  String toString() {
    return 'VideoAnalytics(organizationId: $organizationId, totalVideos: $totalVideos, readyVideos: $readyVideos, processingVideos: $processingVideos, errorVideos: $errorVideos, totalStorageBytes: $totalStorageBytes, totalDurationSeconds: $totalDurationSeconds, avgDurationSeconds: $avgDurationSeconds, videosLast30Days: $videosLast30Days, videosLast7Days: $videosLast7Days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoAnalyticsImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.totalVideos, totalVideos) ||
                other.totalVideos == totalVideos) &&
            (identical(other.readyVideos, readyVideos) ||
                other.readyVideos == readyVideos) &&
            (identical(other.processingVideos, processingVideos) ||
                other.processingVideos == processingVideos) &&
            (identical(other.errorVideos, errorVideos) ||
                other.errorVideos == errorVideos) &&
            (identical(other.totalStorageBytes, totalStorageBytes) ||
                other.totalStorageBytes == totalStorageBytes) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            (identical(other.avgDurationSeconds, avgDurationSeconds) ||
                other.avgDurationSeconds == avgDurationSeconds) &&
            (identical(other.videosLast30Days, videosLast30Days) ||
                other.videosLast30Days == videosLast30Days) &&
            (identical(other.videosLast7Days, videosLast7Days) ||
                other.videosLast7Days == videosLast7Days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      organizationId,
      totalVideos,
      readyVideos,
      processingVideos,
      errorVideos,
      totalStorageBytes,
      totalDurationSeconds,
      avgDurationSeconds,
      videosLast30Days,
      videosLast7Days);

  /// Create a copy of VideoAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoAnalyticsImplCopyWith<_$VideoAnalyticsImpl> get copyWith =>
      __$$VideoAnalyticsImplCopyWithImpl<_$VideoAnalyticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _VideoAnalytics implements VideoAnalytics {
  const factory _VideoAnalytics(
      {required final String organizationId,
      required final int totalVideos,
      required final int readyVideos,
      required final int processingVideos,
      required final int errorVideos,
      required final int totalStorageBytes,
      required final int totalDurationSeconds,
      required final double avgDurationSeconds,
      required final int videosLast30Days,
      required final int videosLast7Days}) = _$VideoAnalyticsImpl;

  factory _VideoAnalytics.fromJson(Map<String, dynamic> json) =
      _$VideoAnalyticsImpl.fromJson;

  @override
  String get organizationId;
  @override
  int get totalVideos;
  @override
  int get readyVideos;
  @override
  int get processingVideos;
  @override
  int get errorVideos;
  @override
  int get totalStorageBytes;
  @override
  int get totalDurationSeconds;
  @override
  double get avgDurationSeconds;
  @override
  int get videosLast30Days;
  @override
  int get videosLast7Days;

  /// Create a copy of VideoAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoAnalyticsImplCopyWith<_$VideoAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoUploadProgress _$VideoUploadProgressFromJson(Map<String, dynamic> json) {
  return _VideoUploadProgress.fromJson(json);
}

/// @nodoc
mixin _$VideoUploadProgress {
  String get videoId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  VideoUploadStatus get status => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int? get fileSizeBytes => throw _privateConstructorUsedError;
  int? get uploadedBytes => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this VideoUploadProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoUploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoUploadProgressCopyWith<VideoUploadProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoUploadProgressCopyWith<$Res> {
  factory $VideoUploadProgressCopyWith(
          VideoUploadProgress value, $Res Function(VideoUploadProgress) then) =
      _$VideoUploadProgressCopyWithImpl<$Res, VideoUploadProgress>;
  @useResult
  $Res call(
      {String videoId,
      String title,
      VideoUploadStatus status,
      double progress,
      String? errorMessage,
      int? fileSizeBytes,
      int? uploadedBytes,
      DateTime? startedAt,
      DateTime? completedAt});
}

/// @nodoc
class _$VideoUploadProgressCopyWithImpl<$Res, $Val extends VideoUploadProgress>
    implements $VideoUploadProgressCopyWith<$Res> {
  _$VideoUploadProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoUploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? title = null,
    Object? status = null,
    Object? progress = null,
    Object? errorMessage = freezed,
    Object? fileSizeBytes = freezed,
    Object? uploadedBytes = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoUploadStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSizeBytes: freezed == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      uploadedBytes: freezed == uploadedBytes
          ? _value.uploadedBytes
          : uploadedBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoUploadProgressImplCopyWith<$Res>
    implements $VideoUploadProgressCopyWith<$Res> {
  factory _$$VideoUploadProgressImplCopyWith(_$VideoUploadProgressImpl value,
          $Res Function(_$VideoUploadProgressImpl) then) =
      __$$VideoUploadProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String videoId,
      String title,
      VideoUploadStatus status,
      double progress,
      String? errorMessage,
      int? fileSizeBytes,
      int? uploadedBytes,
      DateTime? startedAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$VideoUploadProgressImplCopyWithImpl<$Res>
    extends _$VideoUploadProgressCopyWithImpl<$Res, _$VideoUploadProgressImpl>
    implements _$$VideoUploadProgressImplCopyWith<$Res> {
  __$$VideoUploadProgressImplCopyWithImpl(_$VideoUploadProgressImpl _value,
      $Res Function(_$VideoUploadProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoUploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? title = null,
    Object? status = null,
    Object? progress = null,
    Object? errorMessage = freezed,
    Object? fileSizeBytes = freezed,
    Object? uploadedBytes = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$VideoUploadProgressImpl(
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoUploadStatus,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSizeBytes: freezed == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      uploadedBytes: freezed == uploadedBytes
          ? _value.uploadedBytes
          : uploadedBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoUploadProgressImpl implements _VideoUploadProgress {
  const _$VideoUploadProgressImpl(
      {required this.videoId,
      required this.title,
      required this.status,
      this.progress = 0.0,
      this.errorMessage,
      this.fileSizeBytes,
      this.uploadedBytes,
      this.startedAt,
      this.completedAt});

  factory _$VideoUploadProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoUploadProgressImplFromJson(json);

  @override
  final String videoId;
  @override
  final String title;
  @override
  final VideoUploadStatus status;
  @override
  @JsonKey()
  final double progress;
  @override
  final String? errorMessage;
  @override
  final int? fileSizeBytes;
  @override
  final int? uploadedBytes;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'VideoUploadProgress(videoId: $videoId, title: $title, status: $status, progress: $progress, errorMessage: $errorMessage, fileSizeBytes: $fileSizeBytes, uploadedBytes: $uploadedBytes, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoUploadProgressImpl &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.uploadedBytes, uploadedBytes) ||
                other.uploadedBytes == uploadedBytes) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, videoId, title, status, progress,
      errorMessage, fileSizeBytes, uploadedBytes, startedAt, completedAt);

  /// Create a copy of VideoUploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoUploadProgressImplCopyWith<_$VideoUploadProgressImpl> get copyWith =>
      __$$VideoUploadProgressImplCopyWithImpl<_$VideoUploadProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoUploadProgressImplToJson(
      this,
    );
  }
}

abstract class _VideoUploadProgress implements VideoUploadProgress {
  const factory _VideoUploadProgress(
      {required final String videoId,
      required final String title,
      required final VideoUploadStatus status,
      final double progress,
      final String? errorMessage,
      final int? fileSizeBytes,
      final int? uploadedBytes,
      final DateTime? startedAt,
      final DateTime? completedAt}) = _$VideoUploadProgressImpl;

  factory _VideoUploadProgress.fromJson(Map<String, dynamic> json) =
      _$VideoUploadProgressImpl.fromJson;

  @override
  String get videoId;
  @override
  String get title;
  @override
  VideoUploadStatus get status;
  @override
  double get progress;
  @override
  String? get errorMessage;
  @override
  int? get fileSizeBytes;
  @override
  int? get uploadedBytes;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of VideoUploadProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoUploadProgressImplCopyWith<_$VideoUploadProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VideoUploadRequest {
  String get organizationId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get playerId => throw _privateConstructorUsedError;
  String get localFilePath => throw _privateConstructorUsedError;
  List<String> get initialTags => throw _privateConstructorUsedError;
  void Function(double)? get onProgress => throw _privateConstructorUsedError;

  /// Create a copy of VideoUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoUploadRequestCopyWith<VideoUploadRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoUploadRequestCopyWith<$Res> {
  factory $VideoUploadRequestCopyWith(
          VideoUploadRequest value, $Res Function(VideoUploadRequest) then) =
      _$VideoUploadRequestCopyWithImpl<$Res, VideoUploadRequest>;
  @useResult
  $Res call(
      {String organizationId,
      String title,
      String? description,
      String? playerId,
      String localFilePath,
      List<String> initialTags,
      void Function(double)? onProgress});
}

/// @nodoc
class _$VideoUploadRequestCopyWithImpl<$Res, $Val extends VideoUploadRequest>
    implements $VideoUploadRequestCopyWith<$Res> {
  _$VideoUploadRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? title = null,
    Object? description = freezed,
    Object? playerId = freezed,
    Object? localFilePath = null,
    Object? initialTags = null,
    Object? onProgress = freezed,
  }) {
    return _then(_value.copyWith(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      localFilePath: null == localFilePath
          ? _value.localFilePath
          : localFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      initialTags: null == initialTags
          ? _value.initialTags
          : initialTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      onProgress: freezed == onProgress
          ? _value.onProgress
          : onProgress // ignore: cast_nullable_to_non_nullable
              as void Function(double)?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoUploadRequestImplCopyWith<$Res>
    implements $VideoUploadRequestCopyWith<$Res> {
  factory _$$VideoUploadRequestImplCopyWith(_$VideoUploadRequestImpl value,
          $Res Function(_$VideoUploadRequestImpl) then) =
      __$$VideoUploadRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String organizationId,
      String title,
      String? description,
      String? playerId,
      String localFilePath,
      List<String> initialTags,
      void Function(double)? onProgress});
}

/// @nodoc
class __$$VideoUploadRequestImplCopyWithImpl<$Res>
    extends _$VideoUploadRequestCopyWithImpl<$Res, _$VideoUploadRequestImpl>
    implements _$$VideoUploadRequestImplCopyWith<$Res> {
  __$$VideoUploadRequestImplCopyWithImpl(_$VideoUploadRequestImpl _value,
      $Res Function(_$VideoUploadRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? title = null,
    Object? description = freezed,
    Object? playerId = freezed,
    Object? localFilePath = null,
    Object? initialTags = null,
    Object? onProgress = freezed,
  }) {
    return _then(_$VideoUploadRequestImpl(
      organizationId: null == organizationId
          ? _value.organizationId
          : organizationId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      localFilePath: null == localFilePath
          ? _value.localFilePath
          : localFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      initialTags: null == initialTags
          ? _value._initialTags
          : initialTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      onProgress: freezed == onProgress
          ? _value.onProgress
          : onProgress // ignore: cast_nullable_to_non_nullable
              as void Function(double)?,
    ));
  }
}

/// @nodoc

class _$VideoUploadRequestImpl implements _VideoUploadRequest {
  const _$VideoUploadRequestImpl(
      {required this.organizationId,
      required this.title,
      this.description,
      this.playerId,
      required this.localFilePath,
      final List<String> initialTags = const [],
      this.onProgress})
      : _initialTags = initialTags;

  @override
  final String organizationId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? playerId;
  @override
  final String localFilePath;
  final List<String> _initialTags;
  @override
  @JsonKey()
  List<String> get initialTags {
    if (_initialTags is EqualUnmodifiableListView) return _initialTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_initialTags);
  }

  @override
  final void Function(double)? onProgress;

  @override
  String toString() {
    return 'VideoUploadRequest(organizationId: $organizationId, title: $title, description: $description, playerId: $playerId, localFilePath: $localFilePath, initialTags: $initialTags, onProgress: $onProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoUploadRequestImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.localFilePath, localFilePath) ||
                other.localFilePath == localFilePath) &&
            const DeepCollectionEquality()
                .equals(other._initialTags, _initialTags) &&
            (identical(other.onProgress, onProgress) ||
                other.onProgress == onProgress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      organizationId,
      title,
      description,
      playerId,
      localFilePath,
      const DeepCollectionEquality().hash(_initialTags),
      onProgress);

  /// Create a copy of VideoUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoUploadRequestImplCopyWith<_$VideoUploadRequestImpl> get copyWith =>
      __$$VideoUploadRequestImplCopyWithImpl<_$VideoUploadRequestImpl>(
          this, _$identity);
}

abstract class _VideoUploadRequest implements VideoUploadRequest {
  const factory _VideoUploadRequest(
      {required final String organizationId,
      required final String title,
      final String? description,
      final String? playerId,
      required final String localFilePath,
      final List<String> initialTags,
      final void Function(double)? onProgress}) = _$VideoUploadRequestImpl;

  @override
  String get organizationId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get playerId;
  @override
  String get localFilePath;
  @override
  List<String> get initialTags;
  @override
  void Function(double)? get onProgress;

  /// Create a copy of VideoUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoUploadRequestImplCopyWith<_$VideoUploadRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoSearchFilters _$VideoSearchFiltersFromJson(Map<String, dynamic> json) {
  return _VideoSearchFilters.fromJson(json);
}

/// @nodoc
mixin _$VideoSearchFilters {
  String? get searchQuery => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  VideoProcessingStatus? get status => throw _privateConstructorUsedError;
  String? get playerId => throw _privateConstructorUsedError;
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  int? get minDurationSeconds => throw _privateConstructorUsedError;
  int? get maxDurationSeconds => throw _privateConstructorUsedError;

  /// Serializes this VideoSearchFilters to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoSearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoSearchFiltersCopyWith<VideoSearchFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoSearchFiltersCopyWith<$Res> {
  factory $VideoSearchFiltersCopyWith(
          VideoSearchFilters value, $Res Function(VideoSearchFilters) then) =
      _$VideoSearchFiltersCopyWithImpl<$Res, VideoSearchFilters>;
  @useResult
  $Res call(
      {String? searchQuery,
      List<String>? tags,
      VideoProcessingStatus? status,
      String? playerId,
      DateTime? createdAfter,
      DateTime? createdBefore,
      int? minDurationSeconds,
      int? maxDurationSeconds});
}

/// @nodoc
class _$VideoSearchFiltersCopyWithImpl<$Res, $Val extends VideoSearchFilters>
    implements $VideoSearchFiltersCopyWith<$Res> {
  _$VideoSearchFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoSearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? tags = freezed,
    Object? status = freezed,
    Object? playerId = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? minDurationSeconds = freezed,
    Object? maxDurationSeconds = freezed,
  }) {
    return _then(_value.copyWith(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoProcessingStatus?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minDurationSeconds: freezed == minDurationSeconds
          ? _value.minDurationSeconds
          : minDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      maxDurationSeconds: freezed == maxDurationSeconds
          ? _value.maxDurationSeconds
          : maxDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoSearchFiltersImplCopyWith<$Res>
    implements $VideoSearchFiltersCopyWith<$Res> {
  factory _$$VideoSearchFiltersImplCopyWith(_$VideoSearchFiltersImpl value,
          $Res Function(_$VideoSearchFiltersImpl) then) =
      __$$VideoSearchFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? searchQuery,
      List<String>? tags,
      VideoProcessingStatus? status,
      String? playerId,
      DateTime? createdAfter,
      DateTime? createdBefore,
      int? minDurationSeconds,
      int? maxDurationSeconds});
}

/// @nodoc
class __$$VideoSearchFiltersImplCopyWithImpl<$Res>
    extends _$VideoSearchFiltersCopyWithImpl<$Res, _$VideoSearchFiltersImpl>
    implements _$$VideoSearchFiltersImplCopyWith<$Res> {
  __$$VideoSearchFiltersImplCopyWithImpl(_$VideoSearchFiltersImpl _value,
      $Res Function(_$VideoSearchFiltersImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoSearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? tags = freezed,
    Object? status = freezed,
    Object? playerId = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? minDurationSeconds = freezed,
    Object? maxDurationSeconds = freezed,
  }) {
    return _then(_$VideoSearchFiltersImpl(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VideoProcessingStatus?,
      playerId: freezed == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minDurationSeconds: freezed == minDurationSeconds
          ? _value.minDurationSeconds
          : minDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      maxDurationSeconds: freezed == maxDurationSeconds
          ? _value.maxDurationSeconds
          : maxDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoSearchFiltersImpl implements _VideoSearchFilters {
  const _$VideoSearchFiltersImpl(
      {this.searchQuery,
      final List<String>? tags,
      this.status,
      this.playerId,
      this.createdAfter,
      this.createdBefore,
      this.minDurationSeconds,
      this.maxDurationSeconds})
      : _tags = tags;

  factory _$VideoSearchFiltersImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoSearchFiltersImplFromJson(json);

  @override
  final String? searchQuery;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final VideoProcessingStatus? status;
  @override
  final String? playerId;
  @override
  final DateTime? createdAfter;
  @override
  final DateTime? createdBefore;
  @override
  final int? minDurationSeconds;
  @override
  final int? maxDurationSeconds;

  @override
  String toString() {
    return 'VideoSearchFilters(searchQuery: $searchQuery, tags: $tags, status: $status, playerId: $playerId, createdAfter: $createdAfter, createdBefore: $createdBefore, minDurationSeconds: $minDurationSeconds, maxDurationSeconds: $maxDurationSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoSearchFiltersImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.minDurationSeconds, minDurationSeconds) ||
                other.minDurationSeconds == minDurationSeconds) &&
            (identical(other.maxDurationSeconds, maxDurationSeconds) ||
                other.maxDurationSeconds == maxDurationSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchQuery,
      const DeepCollectionEquality().hash(_tags),
      status,
      playerId,
      createdAfter,
      createdBefore,
      minDurationSeconds,
      maxDurationSeconds);

  /// Create a copy of VideoSearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoSearchFiltersImplCopyWith<_$VideoSearchFiltersImpl> get copyWith =>
      __$$VideoSearchFiltersImplCopyWithImpl<_$VideoSearchFiltersImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoSearchFiltersImplToJson(
      this,
    );
  }
}

abstract class _VideoSearchFilters implements VideoSearchFilters {
  const factory _VideoSearchFilters(
      {final String? searchQuery,
      final List<String>? tags,
      final VideoProcessingStatus? status,
      final String? playerId,
      final DateTime? createdAfter,
      final DateTime? createdBefore,
      final int? minDurationSeconds,
      final int? maxDurationSeconds}) = _$VideoSearchFiltersImpl;

  factory _VideoSearchFilters.fromJson(Map<String, dynamic> json) =
      _$VideoSearchFiltersImpl.fromJson;

  @override
  String? get searchQuery;
  @override
  List<String>? get tags;
  @override
  VideoProcessingStatus? get status;
  @override
  String? get playerId;
  @override
  DateTime? get createdAfter;
  @override
  DateTime? get createdBefore;
  @override
  int? get minDurationSeconds;
  @override
  int? get maxDurationSeconds;

  /// Create a copy of VideoSearchFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoSearchFiltersImplCopyWith<_$VideoSearchFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
