// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

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

/// Controller for video tagging operations
class VideoTaggingController extends StateNotifier<VideoTaggingState> {
  final VideoTagRepository _repository;

  VideoTaggingController(this._repository) : super(const VideoTaggingState());

  /// Load tags for a specific video
  Future<void> loadVideoTags(String videoId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getTagsForVideo(videoId);

    result.fold(
      (error) => state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      ),
      (tags) {
        final analytics = _calculateAnalytics(tags);
        final hotspots = _generateHotspots(tags);

        state = state.copyWith(
          isLoading: false,
          tags: tags,
          analytics: analytics,
          hotspots: hotspots,
          error: null,
        );
      },
    );
  }

  /// Create a new video tag
  Future<bool> createTag(CreateVideoTagRequest request) async {
    state = state.copyWith(isCreating: true, error: null);

    final result = await _repository.createTag(request);

    return result.fold(
      (error) {
        state = state.copyWith(
          isCreating: false,
          error: error.toString(),
        );
        return false;
      },
      (newTag) {
        final updatedTags = [...state.tags, newTag];
        final analytics = _calculateAnalytics(updatedTags);
        final hotspots = _generateHotspots(updatedTags);

        state = state.copyWith(
          isCreating: false,
          tags: updatedTags,
          analytics: analytics,
          hotspots: hotspots,
          error: null,
        );
        return true;
      },
    );
  }

  /// Update an existing tag
  Future<bool> updateTag(UpdateVideoTagRequest request) async {
    state = state.copyWith(isUpdating: true, error: null);

    final result = await _repository.updateTag(request);

    return result.fold(
      (error) {
        state = state.copyWith(
          isUpdating: false,
          error: error.toString(),
        );
        return false;
      },
      (updatedTag) {
        final updatedTags = state.tags
            .map((tag) => tag.id == updatedTag.id ? updatedTag : tag)
            .toList();

        final analytics = _calculateAnalytics(updatedTags);
        final hotspots = _generateHotspots(updatedTags);

        state = state.copyWith(
          isUpdating: false,
          tags: updatedTags,
          analytics: analytics,
          hotspots: hotspots,
          error: null,
        );
        return true;
      },
    );
  }

  /// Delete a tag
  Future<bool> deleteTag(String tagId) async {
    state = state.copyWith(error: null);

    final result = await _repository.deleteTag(tagId);

    return result.fold(
      (error) {
        state = state.copyWith(error: error.toString());
        return false;
      },
      (_) {
        final updatedTags = state.tags.where((tag) => tag.id != tagId).toList();

        final analytics = _calculateAnalytics(updatedTags);
        final hotspots = _generateHotspots(updatedTags);

        state = state.copyWith(
          tags: updatedTags,
          analytics: analytics,
          hotspots: hotspots,
          selectedTagId:
              state.selectedTagId == tagId ? null : state.selectedTagId,
          error: null,
        );
        return true;
      },
    );
  }

  /// Select a tag for editing/viewing
  void selectTag(String? tagId) {
    state = state.copyWith(selectedTagId: tagId);
  }

  /// Clear all state
  void clearState() {
    state = const VideoTaggingState();
  }

  /// Get tags by event type
  List<VideoTag> getTagsByEventType(VideoEventType eventType) {
    return state.tags.where((tag) => tag.eventType == eventType).toList();
  }

  /// Get tags by player
  List<VideoTag> getTagsByPlayer(String playerId) {
    return state.tags.where((tag) => tag.playerId == playerId).toList();
  }

  /// Get tags within a time range
  List<VideoTag> getTagsInTimeRange(double startTime, double endTime) {
    return state.tags
        .where((tag) =>
            tag.timestampSeconds >= startTime &&
            tag.timestampSeconds <= endTime)
        .toList();
  }

  /// Calculate analytics for the current tags
  VideoTagAnalytics _calculateAnalytics(List<VideoTag> tags) {
    if (tags.isEmpty) {
      return VideoTagAnalytics(
        totalTags: 0,
        tagsByType: const {},
        tagsByCreator: const {},
        averageTagsPerMinute: 0.0,
        hotspots: const [],
        generatedAt: DateTime.now(),
      );
    }

    final tagsByType = <VideoTagType, int>{};
    final tagsByCreator = <String, int>{};

    for (final tag in tags) {
      // Count by tag type
      tagsByType[tag.tagType] = (tagsByType[tag.tagType] ?? 0) + 1;

      // Count by creator
      if (tag.createdBy != null) {
        final createdBy = tag.createdBy!;
        tagsByCreator[createdBy] = (tagsByCreator[createdBy] ?? 0) + 1;
      }
    }

    // Calculate tags per minute
    final lastTimestamp =
        tags.map((t) => t.timestampSeconds).reduce((a, b) => a > b ? a : b);
    final avgTagsPerMinute =
        lastTimestamp > 0 ? (tags.length / (lastTimestamp / 60)) : 0.0;

    return VideoTagAnalytics(
      totalTags: tags.length,
      tagsByType: tagsByType,
      tagsByCreator: tagsByCreator,
      averageTagsPerMinute: avgTagsPerMinute,
      hotspots: const [], // Will be calculated separately for timeline display
      generatedAt: DateTime.now(),
    );
  }

  /// Generate hotspots for video timeline
  List<VideoTagHotspot> _generateHotspots(List<VideoTag> tags) {
    if (tags.isEmpty) return [];

    const hotspotInterval = 30.0; // 30-second intervals
    final hotspotMap = <double, List<VideoTag>>{};

    // Group tags by time intervals
    for (final tag in tags) {
      final intervalStart =
          (tag.timestampSeconds / hotspotInterval).floor() * hotspotInterval;
      hotspotMap.putIfAbsent(intervalStart, () => []).add(tag);
    }

    // Convert to hotspot objects using the model definition
    return hotspotMap.entries.map((entry) {
      final timestamp = entry.key;
      final intervalTags = entry.value;
      final dominantTypes = intervalTags.map((t) => t.tagType).toSet().toList();

      return VideoTagHotspot(
        startSeconds: timestamp,
        endSeconds: timestamp + hotspotInterval,
        tagCount: intervalTags.length,
        dominantTagTypes: dominantTypes,
      );
    }).toList()
      ..sort((a, b) => a.startSeconds.compareTo(b.startSeconds));
  }
}
