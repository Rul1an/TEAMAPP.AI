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

class _$VideoTaggingStateImpl implements _VideoTaggingState {
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
  String toString() {
    return 'VideoTaggingState(tags: $tags, isLoading: $isLoading, isCreating: $isCreating, isUpdating: $isUpdating, selectedTagId: $selectedTagId, error: $error, analytics: $analytics, hotspots: $hotspots)';
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
