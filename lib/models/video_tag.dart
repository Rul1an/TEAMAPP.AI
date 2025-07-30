// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_tag.freezed.dart';
part 'video_tag.g.dart';

/// Represents a tagged moment in a video for tactical analysis
@freezed
class VideoTag with _$VideoTag {
  const factory VideoTag({
    required String id,
    required String videoId,
    required String organizationId,
    required VideoTagType tagType,
    required double timestampSeconds,
    String? title,
    String? description,
    required Map<String, dynamic> tagData,
    String? createdBy,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _VideoTag;

  const VideoTag._();

  factory VideoTag.fromJson(Map<String, dynamic> json) => _$VideoTagFromJson(json);

  /// Create a placeholder tag for optimistic updates
  factory VideoTag.placeholder({
    required String videoId,
    required String organizationId,
    required VideoTagType tagType,
    required double timestampSeconds,
    String? title,
    String? description,
    Map<String, dynamic>? tagData,
  }) {
    return VideoTag(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      videoId: videoId,
      organizationId: organizationId,
      tagType: tagType,
      timestampSeconds: timestampSeconds,
      title: title,
      description: description,
      tagData: tagData ?? {},
      createdAt: DateTime.now(),
    );
  }

  /// Get formatted timestamp for display
  String get formattedTimestamp {
    final duration = Duration(seconds: timestampSeconds.round());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get tag color based on type
  int get tagColor {
    return switch (tagType) {
      VideoTagType.drill => 0xFF4CAF50, // Green
      VideoTagType.moment => 0xFFFF9800, // Orange
      VideoTagType.player => 0xFF2196F3, // Blue
      VideoTagType.tactic => 0xFF9C27B0, // Purple
      VideoTagType.mistake => 0xFFF44336, // Red
      VideoTagType.skill => 0xFF00BCD4, // Cyan
    };
  }

  /// Get tag icon based on type
  String get tagIcon {
    return switch (tagType) {
      VideoTagType.drill => '⚽',
      VideoTagType.moment => '⭐',
      VideoTagType.player => '👤',
      VideoTagType.tactic => '📋',
      VideoTagType.mistake => '⚠️',
      VideoTagType.skill => '🎯',
    };
  }

  /// Get display name for tag type
  String get tagTypeDisplayName {
    return switch (tagType) {
      VideoTagType.drill => 'Drill',
      VideoTagType.moment => 'Key Moment',
      VideoTagType.player => 'Player Focus',
      VideoTagType.tactic => 'Tactical',
      VideoTagType.mistake => 'Mistake',
      VideoTagType.skill => 'Skill',
    };
  }

  /// Check if tag has specific player data
  bool get hasPlayerData {
    return tagData.containsKey('playerIds') &&
           (tagData['playerIds'] as List?)?.isNotEmpty == true;
  }

  /// Get player names from tag data
  List<String> get playerNames {
    final playerIds = tagData['playerIds'] as List?;
    final playerNames = tagData['playerNames'] as List?;

    if (playerNames != null) {
      return List<String>.from(playerNames);
    }

    if (playerIds != null) {
      return List<String>.from(playerIds.map((id) => 'Player $id'));
    }

    return [];
  }

  /// Get tactical phase from tag data
  String? get tacticalPhase {
    return tagData['phase'] as String?;
  }

  /// Get drill type from tag data
  String? get drillType {
    return tagData['drillType'] as String?;
  }

  /// Get intensity level from tag data
  String? get intensityLevel {
    return tagData['intensity'] as String?;
  }

  /// Get action type from tag data
  String? get actionType {
    return tagData['action'] as String?;
  }

  /// Get importance level for moments
  String? get importanceLevel {
    return tagData['importance'] as String?;
  }

  /// Backward compatibility getters
  VideoTagType get eventType => tagType; // Alias for backward compatibility

  String? get playerId => tagData['playerId'] as String?; // Get player ID from tag data

  String? get notes => description; // Alias for backward compatibility
}

/// Types of video tags for tactical analysis
enum VideoTagType {
  @JsonValue('drill')
  drill,

  @JsonValue('moment')
  moment,

  @JsonValue('player')
  player,

  @JsonValue('tactic')
  tactic,

  @JsonValue('mistake')
  mistake,

  @JsonValue('skill')
  skill,
}

/// Backward compatibility alias for VideoEventType
typedef VideoEventType = VideoTagType;

/// Request model for creating video tags
@freezed
class CreateVideoTagRequest with _$CreateVideoTagRequest {
  const factory CreateVideoTagRequest({
    required String videoId,
    required String organizationId,
    required VideoTagType tagType,
    required double timestampSeconds,
    String? title,
    String? description,
    @Default({}) Map<String, dynamic> tagData,
  }) = _CreateVideoTagRequest;

  factory CreateVideoTagRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateVideoTagRequestFromJson(json);
}

/// Request model for updating video tags
@freezed
class UpdateVideoTagRequest with _$UpdateVideoTagRequest {
  const factory UpdateVideoTagRequest({
    required String tagId,
    String? title,
    String? description,
    Map<String, dynamic>? tagData,
    double? timestampSeconds,
  }) = _UpdateVideoTagRequest;

  factory UpdateVideoTagRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateVideoTagRequestFromJson(json);
}

/// Filters for video tag queries
@freezed
class VideoTagFilter with _$VideoTagFilter {
  const factory VideoTagFilter({
    String? videoId,
    String? organizationId,
    List<VideoTagType>? tagTypes,
    String? createdBy,
    DateTime? createdAfter,
    DateTime? createdBefore,
    double? timestampStart,
    double? timestampEnd,
    String? searchQuery,
    @Default(50) int limit,
    @Default(0) int offset,
  }) = _VideoTagFilter;

  factory VideoTagFilter.fromJson(Map<String, dynamic> json) =>
      _$VideoTagFilterFromJson(json);

  const VideoTagFilter._();

  /// Create filter for specific video
  factory VideoTagFilter.forVideo(String videoId) {
    return VideoTagFilter(videoId: videoId);
  }

  /// Create filter for specific tag types
  factory VideoTagFilter.forTagTypes(List<VideoTagType> tagTypes) {
    return VideoTagFilter(tagTypes: tagTypes);
  }

  /// Create filter for timestamp range
  factory VideoTagFilter.forTimeRange({
    required double startSeconds,
    required double endSeconds,
  }) {
    return VideoTagFilter(
      timestampStart: startSeconds,
      timestampEnd: endSeconds,
    );
  }
}

/// Analytics data for video tags
@freezed
class VideoTagAnalytics with _$VideoTagAnalytics {
  const factory VideoTagAnalytics({
    required int totalTags,
    required Map<VideoTagType, int> tagsByType,
    required Map<String, int> tagsByCreator,
    required double averageTagsPerMinute,
    required List<VideoTagHotspot> hotspots,
    required DateTime generatedAt,
  }) = _VideoTagAnalytics;

  factory VideoTagAnalytics.fromJson(Map<String, dynamic> json) =>
      _$VideoTagAnalyticsFromJson(json);
}

/// Represents a high-activity area in video timeline
@freezed
class VideoTagHotspot with _$VideoTagHotspot {
  const factory VideoTagHotspot({
    required double startSeconds,
    required double endSeconds,
    required int tagCount,
    required List<VideoTagType> dominantTagTypes,
  }) = _VideoTagHotspot;

  const VideoTagHotspot._();

  factory VideoTagHotspot.fromJson(Map<String, dynamic> json) =>
      _$VideoTagHotspotFromJson(json);

  /// Get duration of hotspot in seconds
  double get durationSeconds => endSeconds - startSeconds;

  /// Get formatted time range
  String get formattedTimeRange {
    final start = Duration(seconds: startSeconds.round());
    final end = Duration(seconds: endSeconds.round());

    String formatDuration(Duration d) {
      final minutes = d.inMinutes;
      final seconds = d.inSeconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${formatDuration(start)} - ${formatDuration(end)}';
  }
}
