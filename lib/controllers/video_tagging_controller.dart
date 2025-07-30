// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../models/video_tag.dart';
import '../repositories/video_tag_repository.dart';

part 'video_tagging_controller.freezed.dart';

/// State for video tagging functionality
@freezed
class VideoTaggingState with _$VideoTaggingState {
  const factory VideoTaggingState({
    @Default([]) List<VideoTag> tags,
    @Default(false) bool isLoading,
    @Default(false) bool isCreating,
    @Default(false) bool isUpdating,
    String? selectedTagId,
    String? error,
    VideoTagAnalytics? analytics,
    @Default([]) List<VideoTagHotspot> hotspots,
  }) = _VideoTaggingState;
}

/// Analytics data for video tags
@freezed
class VideoTagAnalytics with _$VideoTagAnalytics {
  const factory VideoTagAnalytics({
    @Default(0) int totalTags,
    @Default(0) int uniqueEvents,
    @Default({}) Map<String, int> eventTypeCounts,
    @Default({}) Map<String, int> playerTagCounts,
    @Default(0.0) double averageTagsPerMinute,
  }) = _VideoTagAnalytics;
}

/// Hotspot data for video timeline
@freezed
class VideoTagHotspot with _$VideoTagHotspot {
  const factory VideoTagHotspot({
    required double timestamp,
    required int tagCount,
    required List<String> eventTypes,
  }) = _VideoTagHotspot;
}

/// Controller for video tagging operations
class VideoTaggingController extends ChangeNotifier {
  final VideoTagRepository _repository;

  VideoTaggingState _state = const VideoTaggingState();
  VideoTaggingState get state => _state;

  VideoTaggingController(this._repository);

  /// Load tags for a specific video
  Future<void> loadVideoTags(String videoId) async {
    _updateState(_state.copyWith(isLoading: true, error: null));

    final result = await _repository.getTagsForVideo(videoId);

    result.fold(
      (error) => _updateState(_state.copyWith(
        isLoading: false,
        error: error.toString(),
      )),
      (tags) {
        final analytics = _calculateAnalytics(tags);
        final hotspots = _generateHotspots(tags);

        _updateState(_state.copyWith(
          isLoading: false,
          tags: tags,
          analytics: analytics,
          hotspots: hotspots,
          error: null,
        ));
      },
    );
  }

  /// Create a new video tag
  Future<bool> createTag(CreateVideoTagRequest request) async {
    _updateState(_state.copyWith(isCreating: true, error: null));

    final result = await _repository.createTag(request);

    return result.fold(
      (error) {
        _updateState(_state.copyWith(
          isCreating: false,
          error: error.toString(),
        ));
        return false;
      },
      (newTag) {
        final updatedTags = [..._state.tags, newTag];
        final analytics = _calculateAnalytics(updatedTags);
        final hotspots = _generateHotspots(updatedTags);

        _updateState(_state.copyWith(
          isCreating: false,
          tags: updatedTags,
          analytics: analytics,
          hotspots: hotspots,
          error: null,
        ));
        return true;
      },
    );
  }

  /// Update an existing tag
  Future<bool> updateTag(UpdateVideoTagRequest request) async {
    _updateState(_state.copyWith(isUpdating: true, error: null));

    final result = await _repository.updateTag(request);

    return result.fold(
      (error) {
        _updateState(_state.copyWith(
          isUpdating: false,
          error: error.toString(),
        ));
        return false;
      },
      (updatedTag) {
        final updatedTags = _state.tags
            .map((tag) => tag.id == updatedTag.id ? updatedTag : tag)
            .toList();

        final analytics = _calculateAnalytics(updatedTags);
        final hotspots = _generateHotspots(updatedTags);

        _updateState(_state.copyWith(
          isUpdating: false,
          tags: updatedTags,
          analytics: analytics,
          hotspots: hotspots,
          error: null,
        ));
        return true;
      },
    );
  }

  /// Delete a tag
  Future<bool> deleteTag(String tagId) async {
    _updateState(_state.copyWith(error: null));

    final result = await _repository.deleteTag(tagId);

    return result.fold(
      (error) {
        _updateState(_state.copyWith(error: error.toString()));
        return false;
      },
      (_) {
        final updatedTags = _state.tags
            .where((tag) => tag.id != tagId)
            .toList();

        final analytics = _calculateAnalytics(updatedTags);
        final hotspots = _generateHotspots(updatedTags);

        _updateState(_state.copyWith(
          tags: updatedTags,
          analytics: analytics,
          hotspots: hotspots,
          selectedTagId: _state.selectedTagId == tagId ? null : _state.selectedTagId,
          error: null,
        ));
        return true;
      },
    );
  }

  /// Select a tag for editing/viewing
  void selectTag(String? tagId) {
    _updateState(_state.copyWith(selectedTagId: tagId));
  }

  /// Clear all state
  void clearState() {
    _updateState(const VideoTaggingState());
  }

  /// Get tags by event type
  List<VideoTag> getTagsByEventType(VideoEventType eventType) {
    return _state.tags.where((tag) => tag.eventType == eventType).toList();
  }

  /// Get tags by player
  List<VideoTag> getTagsByPlayer(String playerId) {
    return _state.tags.where((tag) => tag.playerId == playerId).toList();
  }

  /// Get tags within a time range
  List<VideoTag> getTagsInTimeRange(double startTime, double endTime) {
    return _state.tags.where((tag) =>
      tag.timestampSeconds >= startTime && tag.timestampSeconds <= endTime
    ).toList();
  }

  /// Calculate analytics for the current tags
  VideoTagAnalytics _calculateAnalytics(List<VideoTag> tags) {
    if (tags.isEmpty) {
      return const VideoTagAnalytics();
    }

    final eventTypeCounts = <String, int>{};
    final playerTagCounts = <String, int>{};
    final uniqueEvents = <VideoEventType>{};

    for (final tag in tags) {
      // Count event types
      final eventTypeKey = tag.eventType.name;
      eventTypeCounts[eventTypeKey] = (eventTypeCounts[eventTypeKey] ?? 0) + 1;
      uniqueEvents.add(tag.eventType);

      // Count player tags
      if (tag.playerId != null) {
        final playerId = tag.playerId!;
        playerTagCounts[playerId] = (playerTagCounts[playerId] ?? 0) + 1;
      }
    }

    // Calculate tags per minute
    final lastTimestamp = tags.map((t) => t.timestampSeconds).reduce((a, b) => a > b ? a : b);
    final avgTagsPerMinute = lastTimestamp > 0 ? (tags.length / (lastTimestamp / 60)) : 0.0;

    return VideoTagAnalytics(
      totalTags: tags.length,
      uniqueEvents: uniqueEvents.length,
      eventTypeCounts: eventTypeCounts,
      playerTagCounts: playerTagCounts,
      averageTagsPerMinute: avgTagsPerMinute,
    );
  }

  /// Generate hotspots for video timeline
  List<VideoTagHotspot> _generateHotspots(List<VideoTag> tags) {
    if (tags.isEmpty) return [];

    const hotspotInterval = 30.0; // 30-second intervals
    final hotspotMap = <double, List<VideoTag>>{};

    // Group tags by time intervals
    for (final tag in tags) {
      final intervalStart = (tag.timestampSeconds / hotspotInterval).floor() * hotspotInterval;
      hotspotMap.putIfAbsent(intervalStart, () => []).add(tag);
    }

    // Convert to hotspot objects
    return hotspotMap.entries.map((entry) {
      final timestamp = entry.key;
      final intervalTags = entry.value;
      final eventTypes = intervalTags.map((t) => t.eventType.name).toSet().toList();

      return VideoTagHotspot(
        timestamp: timestamp,
        tagCount: intervalTags.length,
        eventTypes: eventTypes,
      );
    }).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  void _updateState(VideoTaggingState newState) {
    _state = newState;
    notifyListeners();
  }
}
