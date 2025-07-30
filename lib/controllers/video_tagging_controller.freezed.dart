// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_tagging_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoTaggingState {
  List<VideoTag> get tags => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  String? get selectedTagId => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  VideoTagAnalytics? get analytics => throw _privateConstructorUsedError;
  List<VideoTagHotspot> get hotspots => throw _privateConstructorUsedError;

  /// Create a copy of VideoTaggingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoTaggingStateCopyWith<VideoTaggingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoTaggingStateCopyWith<$Res> {
  factory $VideoTaggingStateCopyWith(
          VideoTaggingState value, $Res Function(VideoTaggingState) then) =
      _$VideoTaggingStateCopyWithImpl<$Res, VideoTaggingState>;
  @useResult
  $Res call(
      {List<VideoTag> tags,
      bool isLoading,
      bool isCreating,
      bool isUpdating,
      String? selectedTagId,
      String? error,
      VideoTagAnalytics? analytics,
      List<VideoTagHotspot> hotspots});

  $VideoTagAnalyticsCopyWith<$Res>? get analytics;
}

/// @nodoc
class _$VideoTaggingStateCopyWithImpl<$Res, $Val extends VideoTaggingState>
    implements $VideoTaggingStateCopyWith<$Res> {
  _$VideoTaggingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoTaggingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? isUpdating = null,
    Object? selectedTagId = freezed,
    Object? error = freezed,
    Object? analytics = freezed,
    Object? hotspots = null,
  }) {
    return _then(_value.copyWith(
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<VideoTag>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTagId: freezed == selectedTagId
          ? _value.selectedTagId
          : selectedTagId // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      analytics: freezed == analytics
          ? _value.analytics
          : analytics // ignore: cast_nullable_to_non_nullable
              as VideoTagAnalytics?,
      hotspots: null == hotspots
          ? _value.hotspots
          : hotspots // ignore: cast_nullable_to_non_nullable
              as List<VideoTagHotspot>,
    ) as $Val);
  }

  /// Create a copy of VideoTaggingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VideoTagAnalyticsCopyWith<$Res>? get analytics {
    if (_value.analytics == null) {
      return null;
    }

    return $VideoTagAnalyticsCopyWith<$Res>(_value.analytics!, (value) {
      return _then(_value.copyWith(analytics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VideoTaggingStateImplCopyWith<$Res>
    implements $VideoTaggingStateCopyWith<$Res> {
  factory _$$VideoTaggingStateImplCopyWith(_$VideoTaggingStateImpl value,
          $Res Function(_$VideoTaggingStateImpl) then) =
      __$$VideoTaggingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<VideoTag> tags,
      bool isLoading,
      bool isCreating,
      bool isUpdating,
      String? selectedTagId,
      String? error,
      VideoTagAnalytics? analytics,
      List<VideoTagHotspot> hotspots});

  @override
  $VideoTagAnalyticsCopyWith<$Res>? get analytics;
}

/// @nodoc
class __$$VideoTaggingStateImplCopyWithImpl<$Res>
    extends _$VideoTaggingStateCopyWithImpl<$Res, _$VideoTaggingStateImpl>
    implements _$$VideoTaggingStateImplCopyWith<$Res> {
  __$$VideoTaggingStateImplCopyWithImpl(_$VideoTaggingStateImpl _value,
      $Res Function(_$VideoTaggingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoTaggingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? isUpdating = null,
    Object? selectedTagId = freezed,
    Object? error = freezed,
    Object? analytics = freezed,
    Object? hotspots = null,
  }) {
    return _then(_$VideoTaggingStateImpl(
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<VideoTag>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _value.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedTagId: freezed == selectedTagId
          ? _value.selectedTagId
          : selectedTagId // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      analytics: freezed == analytics
          ? _value.analytics
          : analytics // ignore: cast_nullable_to_non_nullable
              as VideoTagAnalytics?,
      hotspots: null == hotspots
          ? _value._hotspots
          : hotspots // ignore: cast_nullable_to_non_nullable
              as List<VideoTagHotspot>,
    ));
  }
}

/// @nodoc

class _$VideoTaggingStateImpl
    with DiagnosticableTreeMixin
    implements _VideoTaggingState {
  const _$VideoTaggingStateImpl(
      {final List<VideoTag> tags = const [],
      this.isLoading = false,
      this.isCreating = false,
      this.isUpdating = false,
      this.selectedTagId,
      this.error,
      this.analytics,
      final List<VideoTagHotspot> hotspots = const []})
      : _tags = tags,
        _hotspots = hotspots;

  final List<VideoTag> _tags;
  @override
  @JsonKey()
  List<VideoTag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  final String? selectedTagId;
  @override
  final String? error;
  @override
  final VideoTagAnalytics? analytics;
  final List<VideoTagHotspot> _hotspots;
  @override
  @JsonKey()
  List<VideoTagHotspot> get hotspots {
    if (_hotspots is EqualUnmodifiableListView) return _hotspots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hotspots);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTaggingState(tags: $tags, isLoading: $isLoading, isCreating: $isCreating, isUpdating: $isUpdating, selectedTagId: $selectedTagId, error: $error, analytics: $analytics, hotspots: $hotspots)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTaggingState'))
      ..add(DiagnosticsProperty('tags', tags))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('isCreating', isCreating))
      ..add(DiagnosticsProperty('isUpdating', isUpdating))
      ..add(DiagnosticsProperty('selectedTagId', selectedTagId))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('analytics', analytics))
      ..add(DiagnosticsProperty('hotspots', hotspots));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTaggingStateImpl &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.selectedTagId, selectedTagId) ||
                other.selectedTagId == selectedTagId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics) &&
            const DeepCollectionEquality().equals(other._hotspots, _hotspots));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tags),
      isLoading,
      isCreating,
      isUpdating,
      selectedTagId,
      error,
      analytics,
      const DeepCollectionEquality().hash(_hotspots));

  /// Create a copy of VideoTaggingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTaggingStateImplCopyWith<_$VideoTaggingStateImpl> get copyWith =>
      __$$VideoTaggingStateImplCopyWithImpl<_$VideoTaggingStateImpl>(
          this, _$identity);
}

abstract class _VideoTaggingState implements VideoTaggingState {
  const factory _VideoTaggingState(
      {final List<VideoTag> tags,
      final bool isLoading,
      final bool isCreating,
      final bool isUpdating,
      final String? selectedTagId,
      final String? error,
      final VideoTagAnalytics? analytics,
      final List<VideoTagHotspot> hotspots}) = _$VideoTaggingStateImpl;

  @override
  List<VideoTag> get tags;
  @override
  bool get isLoading;
  @override
  bool get isCreating;
  @override
  bool get isUpdating;
  @override
  String? get selectedTagId;
  @override
  String? get error;
  @override
  VideoTagAnalytics? get analytics;
  @override
  List<VideoTagHotspot> get hotspots;

  /// Create a copy of VideoTaggingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTaggingStateImplCopyWith<_$VideoTaggingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VideoTagAnalytics {
  int get totalTags => throw _privateConstructorUsedError;
  int get uniqueEvents => throw _privateConstructorUsedError;
  Map<String, int> get eventTypeCounts => throw _privateConstructorUsedError;
  Map<String, int> get playerTagCounts => throw _privateConstructorUsedError;
  double get averageTagsPerMinute => throw _privateConstructorUsedError;

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
      int uniqueEvents,
      Map<String, int> eventTypeCounts,
      Map<String, int> playerTagCounts,
      double averageTagsPerMinute});
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
    Object? uniqueEvents = null,
    Object? eventTypeCounts = null,
    Object? playerTagCounts = null,
    Object? averageTagsPerMinute = null,
  }) {
    return _then(_value.copyWith(
      totalTags: null == totalTags
          ? _value.totalTags
          : totalTags // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueEvents: null == uniqueEvents
          ? _value.uniqueEvents
          : uniqueEvents // ignore: cast_nullable_to_non_nullable
              as int,
      eventTypeCounts: null == eventTypeCounts
          ? _value.eventTypeCounts
          : eventTypeCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      playerTagCounts: null == playerTagCounts
          ? _value.playerTagCounts
          : playerTagCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageTagsPerMinute: null == averageTagsPerMinute
          ? _value.averageTagsPerMinute
          : averageTagsPerMinute // ignore: cast_nullable_to_non_nullable
              as double,
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
      int uniqueEvents,
      Map<String, int> eventTypeCounts,
      Map<String, int> playerTagCounts,
      double averageTagsPerMinute});
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
    Object? uniqueEvents = null,
    Object? eventTypeCounts = null,
    Object? playerTagCounts = null,
    Object? averageTagsPerMinute = null,
  }) {
    return _then(_$VideoTagAnalyticsImpl(
      totalTags: null == totalTags
          ? _value.totalTags
          : totalTags // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueEvents: null == uniqueEvents
          ? _value.uniqueEvents
          : uniqueEvents // ignore: cast_nullable_to_non_nullable
              as int,
      eventTypeCounts: null == eventTypeCounts
          ? _value._eventTypeCounts
          : eventTypeCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      playerTagCounts: null == playerTagCounts
          ? _value._playerTagCounts
          : playerTagCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averageTagsPerMinute: null == averageTagsPerMinute
          ? _value.averageTagsPerMinute
          : averageTagsPerMinute // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$VideoTagAnalyticsImpl
    with DiagnosticableTreeMixin
    implements _VideoTagAnalytics {
  const _$VideoTagAnalyticsImpl(
      {this.totalTags = 0,
      this.uniqueEvents = 0,
      final Map<String, int> eventTypeCounts = const {},
      final Map<String, int> playerTagCounts = const {},
      this.averageTagsPerMinute = 0.0})
      : _eventTypeCounts = eventTypeCounts,
        _playerTagCounts = playerTagCounts;

  @override
  @JsonKey()
  final int totalTags;
  @override
  @JsonKey()
  final int uniqueEvents;
  final Map<String, int> _eventTypeCounts;
  @override
  @JsonKey()
  Map<String, int> get eventTypeCounts {
    if (_eventTypeCounts is EqualUnmodifiableMapView) return _eventTypeCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_eventTypeCounts);
  }

  final Map<String, int> _playerTagCounts;
  @override
  @JsonKey()
  Map<String, int> get playerTagCounts {
    if (_playerTagCounts is EqualUnmodifiableMapView) return _playerTagCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_playerTagCounts);
  }

  @override
  @JsonKey()
  final double averageTagsPerMinute;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTagAnalytics(totalTags: $totalTags, uniqueEvents: $uniqueEvents, eventTypeCounts: $eventTypeCounts, playerTagCounts: $playerTagCounts, averageTagsPerMinute: $averageTagsPerMinute)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTagAnalytics'))
      ..add(DiagnosticsProperty('totalTags', totalTags))
      ..add(DiagnosticsProperty('uniqueEvents', uniqueEvents))
      ..add(DiagnosticsProperty('eventTypeCounts', eventTypeCounts))
      ..add(DiagnosticsProperty('playerTagCounts', playerTagCounts))
      ..add(DiagnosticsProperty('averageTagsPerMinute', averageTagsPerMinute));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTagAnalyticsImpl &&
            (identical(other.totalTags, totalTags) ||
                other.totalTags == totalTags) &&
            (identical(other.uniqueEvents, uniqueEvents) ||
                other.uniqueEvents == uniqueEvents) &&
            const DeepCollectionEquality()
                .equals(other._eventTypeCounts, _eventTypeCounts) &&
            const DeepCollectionEquality()
                .equals(other._playerTagCounts, _playerTagCounts) &&
            (identical(other.averageTagsPerMinute, averageTagsPerMinute) ||
                other.averageTagsPerMinute == averageTagsPerMinute));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalTags,
      uniqueEvents,
      const DeepCollectionEquality().hash(_eventTypeCounts),
      const DeepCollectionEquality().hash(_playerTagCounts),
      averageTagsPerMinute);

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTagAnalyticsImplCopyWith<_$VideoTagAnalyticsImpl> get copyWith =>
      __$$VideoTagAnalyticsImplCopyWithImpl<_$VideoTagAnalyticsImpl>(
          this, _$identity);
}

abstract class _VideoTagAnalytics implements VideoTagAnalytics {
  const factory _VideoTagAnalytics(
      {final int totalTags,
      final int uniqueEvents,
      final Map<String, int> eventTypeCounts,
      final Map<String, int> playerTagCounts,
      final double averageTagsPerMinute}) = _$VideoTagAnalyticsImpl;

  @override
  int get totalTags;
  @override
  int get uniqueEvents;
  @override
  Map<String, int> get eventTypeCounts;
  @override
  Map<String, int> get playerTagCounts;
  @override
  double get averageTagsPerMinute;

  /// Create a copy of VideoTagAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTagAnalyticsImplCopyWith<_$VideoTagAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VideoTagHotspot {
  double get timestamp => throw _privateConstructorUsedError;
  int get tagCount => throw _privateConstructorUsedError;
  List<String> get eventTypes => throw _privateConstructorUsedError;

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
  $Res call({double timestamp, int tagCount, List<String> eventTypes});
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
    Object? timestamp = null,
    Object? tagCount = null,
    Object? eventTypes = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      tagCount: null == tagCount
          ? _value.tagCount
          : tagCount // ignore: cast_nullable_to_non_nullable
              as int,
      eventTypes: null == eventTypes
          ? _value.eventTypes
          : eventTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
  $Res call({double timestamp, int tagCount, List<String> eventTypes});
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
    Object? timestamp = null,
    Object? tagCount = null,
    Object? eventTypes = null,
  }) {
    return _then(_$VideoTagHotspotImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as double,
      tagCount: null == tagCount
          ? _value.tagCount
          : tagCount // ignore: cast_nullable_to_non_nullable
              as int,
      eventTypes: null == eventTypes
          ? _value._eventTypes
          : eventTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$VideoTagHotspotImpl
    with DiagnosticableTreeMixin
    implements _VideoTagHotspot {
  const _$VideoTagHotspotImpl(
      {required this.timestamp,
      required this.tagCount,
      required final List<String> eventTypes})
      : _eventTypes = eventTypes;

  @override
  final double timestamp;
  @override
  final int tagCount;
  final List<String> _eventTypes;
  @override
  List<String> get eventTypes {
    if (_eventTypes is EqualUnmodifiableListView) return _eventTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eventTypes);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoTagHotspot(timestamp: $timestamp, tagCount: $tagCount, eventTypes: $eventTypes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoTagHotspot'))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('tagCount', tagCount))
      ..add(DiagnosticsProperty('eventTypes', eventTypes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoTagHotspotImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.tagCount, tagCount) ||
                other.tagCount == tagCount) &&
            const DeepCollectionEquality()
                .equals(other._eventTypes, _eventTypes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, timestamp, tagCount,
      const DeepCollectionEquality().hash(_eventTypes));

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoTagHotspotImplCopyWith<_$VideoTagHotspotImpl> get copyWith =>
      __$$VideoTagHotspotImplCopyWithImpl<_$VideoTagHotspotImpl>(
          this, _$identity);
}

abstract class _VideoTagHotspot implements VideoTagHotspot {
  const factory _VideoTagHotspot(
      {required final double timestamp,
      required final int tagCount,
      required final List<String> eventTypes}) = _$VideoTagHotspotImpl;

  @override
  double get timestamp;
  @override
  int get tagCount;
  @override
  List<String> get eventTypes;

  /// Create a copy of VideoTagHotspot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoTagHotspotImplCopyWith<_$VideoTagHotspotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
