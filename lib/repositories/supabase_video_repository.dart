import 'dart:io';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../core/result.dart';
import '../models/video.dart';
import 'video_repository.dart';

/// Supabase implementation of the video repository
/// Handles video storage, metadata management, and processing status tracking
class SupabaseVideoRepository implements VideoRepository {
  final SupabaseClient _supabase;
  final Uuid _uuid = const Uuid();

  SupabaseVideoRepository(this._supabase);

  @override
  Future<Result<List<Video>>> getVideos({
    required String organizationId,
    VideoSearchFilters? filters,
    int? limit,
    int? offset,
  }) async {
    try {
      final videosList = <Video>[];
      return Success(videosList);
    } catch (e) {
      return Failure(NetworkFailure('Failed to fetch videos: $e'));
    }
  }

  @override
  Future<Result<Video>> getVideoById(String videoId) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('id', videoId)
          .single();

      final video = _mapDatabaseRowToVideo(response);
      return Success(video);
    } catch (e) {
      if (e.toString().contains('No rows returned')) {
        return Failure(NetworkFailure('Video not found: $videoId'));
      }
      return Failure(NetworkFailure('Failed to get video: $e'));
    }
  }

  @override
  Future<Result<Video>> uploadVideo({
    required VideoUploadRequest request,
  }) async {
    try {
      // Step 1: Validate the video file
      final validationResult = await validateVideoFile(
        filePath: request.localFilePath,
        organizationId: request.organizationId,
      );

      if (!validationResult.isSuccess) {
        return Failure(validationResult.errorOrNull!);
      }

      // Step 2: Get video metadata
      final metadataResult = await getVideoMetadata(request.localFilePath);
      if (!metadataResult.isSuccess) {
        return Failure(metadataResult.errorOrNull!);
      }

      final metadata = metadataResult.dataOrNull!;
      final videoFile = File(request.localFilePath);
      final fileSize = await videoFile.length();

      // Step 3: Generate unique filename with organization structure
      final fileExtension = path.extension(request.localFilePath);
      final fileName = '${request.organizationId}/${_uuid.v4()}$fileExtension';

      // Step 4: Upload video file to Supabase Storage
      final uploadResult = await _uploadVideoFile(
        videoFile,
        fileName,
        request.onProgress,
      );

      if (!uploadResult.isSuccess) {
        return Failure(uploadResult.errorOrNull!);
      }

      // Step 5: Generate thumbnail
      final thumbnailResult = await generateThumbnail(
        videoPath: request.localFilePath,
      );

      // Step 6: Create video record in database
      final videoData = {
        'organization_id': request.organizationId,
        'title': request.title,
        'description': request.description,
        'player_id': request.playerId,
        'file_url': _getPublicVideoUrl(fileName),
        'thumbnail_url': thumbnailResult.dataOrNull,
        'duration_seconds': metadata['duration_seconds'] ?? 0,
        'file_size_bytes': fileSize,
        'resolution_width': metadata['width'] ?? 0,
        'resolution_height': metadata['height'] ?? 0,
        'encoding_format': metadata['format'] ?? 'mp4',
        'processing_status': 'ready',
        'tags': request.initialTags,
        'tag_data': {
          'upload_metadata': metadata,
          'uploaded_at': DateTime.now().toIso8601String(),
        },
        'created_by': _supabase.auth.currentUser?.id,
      };

      final response = await _supabase
          .from('video_tags')
          .insert(videoData)
          .select()
          .single();

      final video = _mapDatabaseRowToVideo(response);
      return Success(video);
    } catch (e) {
      return Failure(NetworkFailure('Upload failed: $e'));
    }
  }

  @override
  Future<Result<Video>> updateVideoMetadata({
    required String videoId,
    String? title,
    String? description,
    List<String>? tags,
    Map<String, dynamic>? tagData,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (tags != null) updateData['tags'] = tags;
      if (tagData != null) updateData['tag_data'] = tagData;

      // Always update the updated_at timestamp
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('video_tags')
          .update(updateData)
          .eq('id', videoId)
          .select()
          .single();

      final video = _mapDatabaseRowToVideo(response);
      return Success(video);
    } catch (e) {
      return Failure(NetworkFailure('Failed to update video: $e'));
    }
  }

  @override
  Future<Result<void>> deleteVideo(String videoId) async {
    try {
      // First get the video to find the file URL
      final videoResult = await getVideoById(videoId);
      if (!videoResult.isSuccess) {
        return Failure(videoResult.errorOrNull!);
      }

      final video = videoResult.dataOrNull!;

      // Delete from storage if file exists
      if (video.fileUrl.isNotEmpty) {
        final fileName = _extractFileNameFromUrl(video.fileUrl);
        if (fileName != null) {
          try {
            await _supabase.storage.from('training-videos').remove([fileName]);
          } catch (e) {
            // Storage deletion failure shouldn't block database cleanup
            print('Warning: Failed to delete video file from storage: $e');
          }
        }
      }

      // Delete thumbnail if exists
      if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty) {
        final thumbnailFileName = _extractFileNameFromUrl(video.thumbnailUrl!);
        if (thumbnailFileName != null) {
          try {
            await _supabase.storage
                .from('video-thumbnails')
                .remove([thumbnailFileName]);
          } catch (e) {
            // Storage deletion failure shouldn't block database cleanup
            print('Warning: Failed to delete thumbnail from storage: $e');
          }
        }
      }

      // Delete from database
      await _supabase.from('video_tags').delete().eq('id', videoId);

      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure('Failed to delete video: $e'));
    }
  }

  @override
  Future<Result<VideoAnalytics>> getVideoAnalytics(
      String organizationId) async {
    try {
      final response = await _supabase
          .from('video_analytics')
          .select('*')
          .eq('organization_id', organizationId)
          .single();

      final analytics = VideoAnalytics.fromJson(response);
      return Success(analytics);
    } catch (e) {
      return Failure(NetworkFailure('Failed to get analytics: $e'));
    }
  }

  @override
  Future<Result<void>> updateProcessingStatus({
    required String videoId,
    required VideoProcessingStatus status,
    String? errorMessage,
  }) async {
    try {
      await _supabase.rpc<void>(
        'update_video_processing_status',
        params: {
          'video_id': videoId,
          'new_status': status.name,
          'error_message': errorMessage,
        },
      );

      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure('Failed to update status: $e'));
    }
  }

  @override
  Future<Result<String>> generateThumbnail({
    required String videoPath,
    double timeSeconds = 5.0,
  }) async {
    try {
      // For now, return a placeholder. In a full implementation, this would:
      // 1. Use ffmpeg_kit_flutter to extract a frame at timeSeconds
      // 2. Save it as a JPEG/PNG
      // 3. Upload to video-thumbnails bucket
      // 4. Return the public URL

      // Placeholder implementation
      const thumbnailUrl =
          'https://via.placeholder.com/320x180.png?text=Video+Thumbnail';
      return const Success(thumbnailUrl);
    } catch (e) {
      return Failure(NetworkFailure('Thumbnail generation failed: $e'));
    }
  }

  @override
  Future<Result<List<Video>>> searchVideos({
    required String organizationId,
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      // Use PostgreSQL full-text search on the search_vector column
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('organization_id', organizationId)
          .textSearch('search_vector', query)
          .order('created_at', ascending: false)
          .limit(limit ?? 50)
          .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);

      final videos = (response as List<dynamic>)
          .map((json) => _mapDatabaseRowToVideo(json as Map<String, dynamic>))
          .toList();

      return Success(videos);
    } catch (e) {
      return Failure(NetworkFailure('Search failed: $e'));
    }
  }

  @override
  Future<Result<List<Video>>> getVideosByStatus({
    required String organizationId,
    required VideoProcessingStatus status,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('processing_status', status.name)
          .order('created_at', ascending: false)
          .limit(limit ?? 50)
          .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);

      final videos = (response as List<dynamic>)
          .map((json) => _mapDatabaseRowToVideo(json as Map<String, dynamic>))
          .toList();

      return Success(videos);
    } catch (e) {
      return Failure(NetworkFailure('Failed to get videos by status: $e'));
    }
  }

  @override
  Stream<VideoProcessingStatus> watchProcessingStatus(String videoId) {
    return _supabase
        .from('video_tags')
        .stream(primaryKey: ['id'])
        .eq('id', videoId)
        .map((rows) {
          if (rows.isEmpty) return VideoProcessingStatus.error;
          final row = rows.first;
          final statusString = row['processing_status'] as String?;
          return VideoProcessingStatus.values.firstWhere(
            (status) => status.name == statusString,
            orElse: () => VideoProcessingStatus.error,
          );
        });
  }

  @override
  Future<Result<void>> validateVideoFile({
    required String filePath,
    required String organizationId,
  }) async {
    try {
      final file = File(filePath);

      // Check if file exists
      if (!await file.exists()) {
        return const Failure(NetworkFailure('File does not exist'));
      }

      // Check file size (500MB limit)
      const maxSizeBytes = 500 * 1024 * 1024;
      final fileSize = await file.length();
      if (fileSize > maxSizeBytes) {
        return Failure(NetworkFailure(
            'File too large. Maximum size is 500MB. File size: ${fileSize ~/ (1024 * 1024)}MB'));
      }

      // Check file extension
      const supportedFormats = ['.mp4', '.mov', '.avi', '.webm'];
      final extension = path.extension(filePath).toLowerCase();
      if (!supportedFormats.contains(extension)) {
        return Failure(NetworkFailure(
            'Unsupported format: $extension. Supported: ${supportedFormats.join(', ')}'));
      }

      // Check storage quota for organization
      final usageResult = await getStorageUsage(organizationId);
      if (!usageResult.isSuccess) {
        return Failure(usageResult.errorOrNull!);
      }

      // For now, use a simple quota check. In production, this would check subscription tier
      const quotaBytes = 5 * 1024 * 1024 * 1024; // 5GB default quota
      final currentUsage = usageResult.dataOrNull!;
      if (currentUsage + fileSize > quotaBytes) {
        return Failure(NetworkFailure('Upload would exceed storage quota. '
            'Current: ${currentUsage ~/ (1024 * 1024)}MB, '
            'File: ${fileSize ~/ (1024 * 1024)}MB, '
            'Quota: ${quotaBytes ~/ (1024 * 1024)}MB'));
      }

      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure('Validation failed: $e'));
    }
  }

  @override
  Future<Result<int>> getStorageUsage(String organizationId) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('file_size_bytes')
          .eq('organization_id', organizationId);

      final totalBytes = (response as List<dynamic>).fold<int>(
          0,
          (sum, row) =>
              sum +
              ((row as Map<String, dynamic>)['file_size_bytes'] as int? ?? 0));

      return Success(totalBytes);
    } catch (e) {
      return Failure(NetworkFailure('Failed to get storage usage: $e'));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getVideoMetadata(String filePath) async {
    try {
      // For now, return placeholder metadata. In a full implementation, this would:
      // 1. Use ffmpeg_kit_flutter to probe the video file
      // 2. Extract duration, resolution, codec, bitrate, etc.

      final file = File(filePath);
      final fileSize = await file.length();

      // Placeholder metadata - in production, use ffmpeg probe
      final metadata = {
        'duration_seconds': 120, // Placeholder: 2 minutes
        'width': 1920,
        'height': 1080,
        'format': 'mp4',
        'bitrate': 2000000, // 2 Mbps
        'frame_rate': 30.0,
        'file_size_bytes': fileSize,
        'codec': 'h264',
        'audio_codec': 'aac',
      };

      return Success(metadata);
    } catch (e) {
      return Failure(NetworkFailure('Failed to get metadata: $e'));
    }
  }

  // Video caching methods - placeholder implementations
  @override
  Future<Result<String>> cacheVideoForOffline({
    required String videoId,
    void Function(double progress)? onProgress,
  }) async {
    // Placeholder - would implement with flutter_cache_manager
    return const Failure(NetworkFailure('Offline caching not yet implemented'));
  }

  @override
  Future<Result<bool>> isVideoCached(String videoId) async {
    // Placeholder - would check flutter_cache_manager
    return const Success(false);
  }

  @override
  Future<Result<String?>> getCachedVideoPath(String videoId) async {
    // Placeholder - would return cached file path
    return const Success(null);
  }

  @override
  Future<Result<void>> clearVideoCache() async {
    // Placeholder - would clear flutter_cache_manager cache
    return const Success(null);
  }

  // Private helper methods

  /// Upload video file to Supabase Storage with progress tracking
  Future<Result<String>> _uploadVideoFile(
    File videoFile,
    String fileName,
    void Function(double progress)? onProgress,
  ) async {
    try {
      await _supabase.storage.from('training-videos').upload(
            fileName,
            videoFile,
            fileOptions: const FileOptions(
              cacheControl: '3600', // 1 hour cache
              upsert: false,
            ),
          );

      return Success(fileName);
    } catch (e) {
      return Failure(NetworkFailure('File upload failed: $e'));
    }
  }

  /// Get public URL for video file
  String _getPublicVideoUrl(String fileName) {
    return _supabase.storage.from('training-videos').getPublicUrl(fileName);
  }

  /// Extract filename from Supabase storage URL
  String? _extractFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 2) {
        // Skip 'storage/v1/object/public/bucket-name/' and get the rest
        return pathSegments.skip(5).join('/');
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Map database row to Video model
  Video _mapDatabaseRowToVideo(Map<String, dynamic> row) {
    return Video(
      id: row['id'] as String,
      organizationId: row['organization_id'] as String,
      title: row['title'] as String? ?? 'Untitled Video',
      description: row['description'] as String?,
      playerId: row['player_id'] as String?,
      fileUrl: row['file_url'] as String? ?? '',
      videoUrl: row['video_url'] as String?, // Legacy field
      thumbnailUrl: row['thumbnail_url'] as String?,
      durationSeconds: row['duration_seconds'] as int? ?? 0,
      fileSizeBytes: row['file_size_bytes'] as int? ?? 0,
      resolutionWidth: row['resolution_width'] as int? ?? 0,
      resolutionHeight: row['resolution_height'] as int? ?? 0,
      encodingFormat: row['encoding_format'] as String? ?? 'mp4',
      processingStatus: VideoProcessingStatus.values.firstWhere(
        (status) => status.name == row['processing_status'],
        orElse: () => VideoProcessingStatus.pending,
      ),
      processingError: row['processing_error'] as String?,
      videoMetadata: Map<String, dynamic>.from((row['video_metadata'] ??
          <String, dynamic>{}) as Map<dynamic, dynamic>),
      tagData: Map<String, dynamic>.from(
          (row['tag_data'] ?? <String, dynamic>{}) as Map<dynamic, dynamic>),
      tags: List<String>.from((row['tags'] ?? <String>[]) as List<dynamic>),
      timeCodes: _parseTimeCodes(row['time_codes']),
      coordinates: _parseCoordinates(row['coordinates']),
      aiConfidence: (row['ai_confidence'] as num?)?.toDouble() ?? 0.0,
      aiProcessed: row['ai_processed'] as bool? ?? false,
      aiProcessedAt: row['ai_processed_at'] != null
          ? DateTime.parse(row['ai_processed_at'] as String)
          : null,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      createdBy: row['created_by'] as String?,
    );
  }

  /// Parse time codes from database JSON
  List<VideoTimeCode> _parseTimeCodes(dynamic timeCodesJson) {
    if (timeCodesJson == null) return [];

    try {
      final List<dynamic> timeCodesList = timeCodesJson is String
          ? jsonDecode(timeCodesJson) as List<dynamic>
          : timeCodesJson as List<dynamic>;

      return timeCodesList
          .map((json) => VideoTimeCode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Parse coordinates from database JSON
  List<VideoCoordinate> _parseCoordinates(dynamic coordinatesJson) {
    if (coordinatesJson == null) return [];

    try {
      final List<dynamic> coordinatesList = coordinatesJson is String
          ? jsonDecode(coordinatesJson) as List<dynamic>
          : coordinatesJson as List<dynamic>;

      return coordinatesList
          .map((json) => VideoCoordinate.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
