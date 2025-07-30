import '../core/result.dart';
import '../models/video.dart';

/// Abstract repository interface for video management
/// Follows the established repository pattern with Result<T> error handling
abstract class VideoRepository {
  /// Get videos for an organization with optional filtering
  Future<Result<List<Video>>> getVideos({
    required String organizationId,
    VideoSearchFilters? filters,
    int? limit,
    int? offset,
  });

  /// Get a specific video by ID
  Future<Result<Video>> getVideoById(String videoId);

  /// Upload a new video with progress tracking
  Future<Result<Video>> uploadVideo({
    required VideoUploadRequest request,
  });

  /// Update video metadata (title, description, tags)
  Future<Result<Video>> updateVideoMetadata({
    required String videoId,
    String? title,
    String? description,
    List<String>? tags,
    Map<String, dynamic>? tagData,
  });

  /// Delete a video and its associated files
  Future<Result<void>> deleteVideo(String videoId);

  /// Get video analytics for an organization
  Future<Result<VideoAnalytics>> getVideoAnalytics(String organizationId);

  /// Update video processing status (typically called by background processes)
  Future<Result<void>> updateProcessingStatus({
    required String videoId,
    required VideoProcessingStatus status,
    String? errorMessage,
  });

  /// Generate thumbnail for a video file
  Future<Result<String>> generateThumbnail({
    required String videoPath,
    double timeSeconds = 5.0,
  });

  /// Search videos with full-text search
  Future<Result<List<Video>>> searchVideos({
    required String organizationId,
    required String query,
    int? limit,
    int? offset,
  });

  /// Get videos by processing status
  Future<Result<List<Video>>> getVideosByStatus({
    required String organizationId,
    required VideoProcessingStatus status,
    int? limit,
    int? offset,
  });

  /// Stream video processing status updates
  Stream<VideoProcessingStatus> watchProcessingStatus(String videoId);

  /// Validate video file before upload
  Future<Result<void>> validateVideoFile({
    required String filePath,
    required String organizationId,
  });

  /// Get video storage usage for organization
  Future<Result<int>> getStorageUsage(String organizationId);

  /// Cache video for offline playback
  Future<Result<String>> cacheVideoForOffline({
    required String videoId,
    void Function(double progress)? onProgress,
  });

  /// Check if video is cached for offline playback
  Future<Result<bool>> isVideoCached(String videoId);

  /// Get cached video path if available
  Future<Result<String?>> getCachedVideoPath(String videoId);

  /// Clear video cache
  Future<Result<void>> clearVideoCache();

  /// Get video file metadata without uploading
  Future<Result<Map<String, dynamic>>> getVideoMetadata(String filePath);
}

/// Video repository provider keys for dependency injection
class VideoRepositoryKeys {
  static const String supabase = 'supabase_video_repository';
  static const String local = 'local_video_repository';
  static const String cached = 'cached_video_repository';
}
