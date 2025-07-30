// Package imports:
import '../core/result.dart';
import '../models/video_tag.dart';

/// Abstract repository for video tag operations
abstract class VideoTagRepository {
  /// Get all tags for a specific video
  Future<Result<List<VideoTag>>> getTagsForVideo(String videoId);

  /// Get tags with filters
  Future<Result<List<VideoTag>>> getTags(VideoTagFilter filter);

  /// Create a new video tag
  Future<Result<VideoTag>> createTag(CreateVideoTagRequest request);

  /// Update an existing video tag
  Future<Result<VideoTag>> updateTag(UpdateVideoTagRequest request);

  /// Delete a video tag
  Future<Result<void>> deleteTag(String tagId);

  /// Get tag analytics for a video
  Future<Result<VideoTagAnalytics>> getTagAnalytics(String videoId);

  /// Search tags by content
  Future<Result<List<VideoTag>>> searchTags({
    required String organizationId,
    required String searchQuery,
    List<VideoTagType>? tagTypes,
    int limit = 50,
  });

  /// Get recent tags by user
  Future<Result<List<VideoTag>>> getRecentTags({
    required String organizationId,
    String? createdBy,
    int limit = 20,
  });

  /// Bulk create tags (for importing or batch operations)
  Future<Result<List<VideoTag>>> createBulkTags(
    List<CreateVideoTagRequest> requests,
  );

  /// Get tag hotspots for video timeline visualization
  Future<Result<List<VideoTagHotspot>>> getTagHotspots({
    required String videoId,
    int segmentCount = 20,
  });

  /// Get tags within a time range
  Future<Result<List<VideoTag>>> getTagsInTimeRange({
    required String videoId,
    required double startSeconds,
    required double endSeconds,
  });
}
