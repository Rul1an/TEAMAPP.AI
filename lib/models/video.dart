import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';
part 'video.g.dart';

/// Video entity representing training videos with full metadata
@freezed
class Video with _$Video {
  const factory Video({
    required String id,
    required String organizationId,
    required String title,
    String? description,
    String? playerId,
    required String fileUrl,
    String? videoUrl, // Legacy field - use fileUrl for new videos
    String? thumbnailUrl,
    required int durationSeconds,
    required int fileSizeBytes,
    required int resolutionWidth,
    required int resolutionHeight,
    @Default('mp4') String encodingFormat,
    @Default(VideoProcessingStatus.pending) VideoProcessingStatus processingStatus,
    String? processingError,
    @Default({}) Map<String, dynamic> videoMetadata,
    @Default({}) Map<String, dynamic> tagData,
    @Default([]) List<String> tags,
    @Default([]) List<VideoTimeCode> timeCodes,
    @Default([]) List<VideoCoordinate> coordinates,
    @Default(0.0) double aiConfidence,
    @Default(false) bool aiProcessed,
    DateTime? aiProcessedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
  }) = _Video;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  /// Create a placeholder video for optimistic updates
  factory Video.placeholder({required String title}) {
    final now = DateTime.now();
    return Video(
      id: 'temp_${now.millisecondsSinceEpoch}',
      organizationId: '',
      title: title,
      fileUrl: '',
      durationSeconds: 0,
      fileSizeBytes: 0,
      resolutionWidth: 0,
      resolutionHeight: 0,
      processingStatus: VideoProcessingStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Video processing status enum
enum VideoProcessingStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('ready')
  ready,
  @JsonValue('error')
  error,
  @JsonValue('archived')
  archived;

  /// Check if video is ready for playback
  bool get isReady => this == VideoProcessingStatus.ready;

  /// Check if video has failed processing
  bool get hasError => this == VideoProcessingStatus.error;

  /// Check if video is currently being processed
  bool get isProcessing => this == VideoProcessingStatus.processing;

  /// Get user-friendly status message
  String get displayName {
    switch (this) {
      case VideoProcessingStatus.pending:
        return 'Waiting to process';
      case VideoProcessingStatus.processing:
        return 'Processing video';
      case VideoProcessingStatus.ready:
        return 'Ready to play';
      case VideoProcessingStatus.error:
        return 'Processing failed';
      case VideoProcessingStatus.archived:
        return 'Archived';
    }
  }
}

/// Time-based tag for video analysis
@freezed
class VideoTimeCode with _$VideoTimeCode {
  const factory VideoTimeCode({
    required double startSeconds,
    required double endSeconds,
    required String tag,
    String? description,
    @Default({}) Map<String, dynamic> metadata,
  }) = _VideoTimeCode;

  factory VideoTimeCode.fromJson(Map<String, dynamic> json) => _$VideoTimeCodeFromJson(json);
}

/// Coordinate-based tag for spatial video analysis
@freezed
class VideoCoordinate with _$VideoCoordinate {
  const factory VideoCoordinate({
    required double x,
    required double y,
    required double timeSeconds,
    String? playerId,
    String? action,
    @Default({}) Map<String, dynamic> metadata,
  }) = _VideoCoordinate;

  factory VideoCoordinate.fromJson(Map<String, dynamic> json) => _$VideoCoordinateFromJson(json);
}

/// Video analytics data for organization dashboard
@freezed
class VideoAnalytics with _$VideoAnalytics {
  const factory VideoAnalytics({
    required String organizationId,
    required int totalVideos,
    required int readyVideos,
    required int processingVideos,
    required int errorVideos,
    required int totalStorageBytes,
    required int totalDurationSeconds,
    required double avgDurationSeconds,
    required int videosLast30Days,
    required int videosLast7Days,
  }) = _VideoAnalytics;

  factory VideoAnalytics.fromJson(Map<String, dynamic> json) => _$VideoAnalyticsFromJson(json);
}

/// Video upload progress tracking
@freezed
class VideoUploadProgress with _$VideoUploadProgress {
  const factory VideoUploadProgress({
    required String videoId,
    required String title,
    required VideoUploadStatus status,
    @Default(0.0) double progress,
    String? errorMessage,
    int? fileSizeBytes,
    int? uploadedBytes,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _VideoUploadProgress;

  factory VideoUploadProgress.fromJson(Map<String, dynamic> json) => _$VideoUploadProgressFromJson(json);
}

/// Video upload status enum
enum VideoUploadStatus {
  @JsonValue('preparing')
  preparing,
  @JsonValue('compressing')
  compressing,
  @JsonValue('uploading')
  uploading,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled;

  /// Check if upload is in progress
  bool get isInProgress => [
        VideoUploadStatus.preparing,
        VideoUploadStatus.compressing,
        VideoUploadStatus.uploading,
        VideoUploadStatus.processing,
      ].contains(this);

  /// Check if upload has finished successfully
  bool get isCompleted => this == VideoUploadStatus.completed;

  /// Check if upload has failed
  bool get hasFailed => this == VideoUploadStatus.failed;

  /// Get user-friendly status message
  String get displayName {
    switch (this) {
      case VideoUploadStatus.preparing:
        return 'Preparing video';
      case VideoUploadStatus.compressing:
        return 'Compressing video';
      case VideoUploadStatus.uploading:
        return 'Uploading to server';
      case VideoUploadStatus.processing:
        return 'Processing video';
      case VideoUploadStatus.completed:
        return 'Upload complete';
      case VideoUploadStatus.failed:
        return 'Upload failed';
      case VideoUploadStatus.cancelled:
        return 'Upload cancelled';
    }
  }
}

/// Request object for video uploads
@freezed
class VideoUploadRequest with _$VideoUploadRequest {
  const factory VideoUploadRequest({
    required String organizationId,
    required String title,
    String? description,
    String? playerId,
    required String localFilePath,
    @Default([]) List<String> initialTags,
    void Function(double progress)? onProgress,
  }) = _VideoUploadRequest;
}

/// Video search filters
@freezed
class VideoSearchFilters with _$VideoSearchFilters {
  const factory VideoSearchFilters({
    String? searchQuery,
    List<String>? tags,
    VideoProcessingStatus? status,
    String? playerId,
    DateTime? createdAfter,
    DateTime? createdBefore,
    int? minDurationSeconds,
    int? maxDurationSeconds,
  }) = _VideoSearchFilters;

  factory VideoSearchFilters.fromJson(Map<String, dynamic> json) => _$VideoSearchFiltersFromJson(json);
}

/// Extensions for Video model
extension VideoExtensions on Video {
  /// Get the URL to use for playback (prefers fileUrl over legacy videoUrl)
  String get playbackUrl => fileUrl.isNotEmpty ? fileUrl : (videoUrl ?? '');

  /// Get human-readable file size
  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    if (fileSizeBytes < 1024 * 1024 * 1024) return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(fileSizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get human-readable duration
  String get durationFormatted {
    final duration = Duration(seconds: durationSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Get video resolution as string
  String get resolutionFormatted => '${resolutionWidth}x$resolutionHeight';

  /// Get video aspect ratio
  double get aspectRatio {
    if (resolutionHeight == 0) return 16 / 9; // Default aspect ratio
    return resolutionWidth / resolutionHeight;
  }

  /// Check if video has valid metadata
  bool get hasValidMetadata =>
      durationSeconds > 0 &&
      fileSizeBytes > 0 &&
      resolutionWidth > 0 &&
      resolutionHeight > 0;

  /// Get the number of tags
  int get tagCount => tags.length;

  /// Get the number of time codes
  int get timeCodeCount => timeCodes.length;

  /// Check if video has AI analysis
  bool get hasAiAnalysis => aiProcessed && aiConfidence > 0;
}
