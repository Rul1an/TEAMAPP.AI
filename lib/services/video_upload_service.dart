import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import '../core/result.dart';
import '../models/video.dart';
import '../repositories/video_repository.dart';

/// Professional video upload service with compression, validation, and progress tracking
/// Implements 2025 best practices for Flutter video processing
class VideoUploadService {
  final VideoRepository _videoRepository;
  final Uuid _uuid = const Uuid();

  VideoUploadService(this._videoRepository);

  /// Upload video with comprehensive validation, compression, and progress tracking
  Future<Result<Video>> uploadVideoWithProgress({
    required String organizationId,
    required String title,
    String? description,
    String? playerId,
    PlatformFile? platformFile,
    String? localFilePath,
    void Function(VideoUploadProgress)? onProgress,
  }) async {
    final uploadId = _uuid.v4();

    try {
      // Step 1: Initialize upload progress
      _updateProgress(onProgress, VideoUploadProgress(
        videoId: uploadId,
        title: title,
        status: VideoUploadStatus.preparing,
        progress: 0.0,
        startedAt: DateTime.now(),
      ));

      // Step 2: Validate input
      final file = await _validateAndGetFile(platformFile, localFilePath);
      if (file == null) {
        return const Failure(ValidationFailure('No valid file provided'));
      }

      // Step 3: Pre-upload validation
      final validationResult = await _validateVideoFile(file, organizationId);
      if (!validationResult.isSuccess) {
        _updateProgress(onProgress, VideoUploadProgress(
          videoId: uploadId,
          title: title,
          status: VideoUploadStatus.failed,
          progress: 0.0,
          errorMessage: validationResult.errorOrNull?.toString(),
          startedAt: DateTime.now(),
        ));
        return Failure(validationResult.errorOrNull!);
      }

      // Step 4: Extract metadata
      _updateProgress(onProgress, VideoUploadProgress(
        videoId: uploadId,
        title: title,
        status: VideoUploadStatus.preparing,
        progress: 0.1,
      ));

      final metadataResult = await _extractVideoMetadata(file.path);
      if (!metadataResult.isSuccess) {
        return Failure(metadataResult.errorOrNull!);
      }
      // Metadata extracted for potential future use
      final _ = metadataResult.dataOrNull!;

      // Step 5: Compress video if needed
      final compressionResult = await _compressVideoIfNeeded(
        file,
        onProgress: (progress) => _updateProgress(onProgress, VideoUploadProgress(
          videoId: uploadId,
          title: title,
          status: VideoUploadStatus.compressing,
          progress: 0.1 + (progress * 0.3), // 10-40% for compression
        )),
      );

      if (!compressionResult.isSuccess) {
        return Failure(compressionResult.errorOrNull!);
      }

      final finalFile = compressionResult.dataOrNull!;

      // Step 6: Upload to repository
      _updateProgress(onProgress, VideoUploadProgress(
        videoId: uploadId,
        title: title,
        status: VideoUploadStatus.uploading,
        progress: 0.4,
        fileSizeBytes: await finalFile.length(),
      ));

      final uploadRequest = VideoUploadRequest(
        organizationId: organizationId,
        title: title,
        description: description,
        playerId: playerId,
        localFilePath: finalFile.path,
        onProgress: (progress) async {
          final fileSize = await finalFile.length();
          _updateProgress(onProgress, VideoUploadProgress(
            videoId: uploadId,
            title: title,
            status: VideoUploadStatus.uploading,
            progress: 0.4 + (progress * 0.5), // 40-90% for upload
            fileSizeBytes: fileSize,
            uploadedBytes: (fileSize * progress).round(),
          ));
        },
      );

      final uploadResult = await _videoRepository.uploadVideo(
        request: uploadRequest,
      );

      if (!uploadResult.isSuccess) {
        _updateProgress(onProgress, VideoUploadProgress(
          videoId: uploadId,
          title: title,
          status: VideoUploadStatus.failed,
          progress: 0.4,
          errorMessage: uploadResult.errorOrNull?.toString(),
        ));
        return Failure(uploadResult.errorOrNull!);
      }

      // Step 7: Post-processing
      final video = uploadResult.dataOrNull!;
      _updateProgress(onProgress, VideoUploadProgress(
        videoId: video.id,
        title: title,
        status: VideoUploadStatus.processing,
        progress: 0.95,
      ));

      // Trigger background processing if needed
      await _triggerBackgroundProcessing(video.id);

      // Step 8: Complete
      _updateProgress(onProgress, VideoUploadProgress(
        videoId: video.id,
        title: title,
        status: VideoUploadStatus.completed,
        progress: 1.0,
        completedAt: DateTime.now(),
      ));

      // Cleanup temporary files
      if (finalFile.path != file.path) {
        try {
          await finalFile.delete();
        } catch (e) {
          debugPrint('Warning: Could not delete temporary file: $e');
        }
      }

      return Success(video);

    } catch (e) {
      _updateProgress(onProgress, VideoUploadProgress(
        videoId: uploadId,
        title: title,
        status: VideoUploadStatus.failed,
        progress: 0.0,
        errorMessage: e.toString(),
      ));
      return Failure(NetworkFailure('Upload failed: $e'));
    }
  }

  /// Pick video file from device storage
  Future<Result<PlatformFile>> pickVideoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'avi', 'webm'],
        allowMultiple: false,
        withData: false, // Don't load file data into memory
        withReadStream: true, // Use stream for large files
      );

      if (result == null || result.files.isEmpty) {
        return const Failure(ValidationFailure('No file selected'));
      }

      final file = result.files.first;

      // Validate file selection
      if (file.path == null) {
        return const Failure(ValidationFailure('Invalid file path'));
      }

      return Success(file);
    } catch (e) {
      return Failure(NetworkFailure('File picker error: $e'));
    }
  }

  /// Validate video file before upload
  Future<Result<void>> _validateVideoFile(File file, String organizationId) async {
    try {
      // Check file existence
      if (!await file.exists()) {
        return const Failure(ValidationFailure('File does not exist'));
      }

      // Check file size (500MB limit)
      const maxSizeBytes = 500 * 1024 * 1024;
      final fileSize = await file.length();
      if (fileSize > maxSizeBytes) {
        return Failure(ValidationFailure(
          'File too large: ${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB. '
          'Maximum allowed: 500MB'
        ));
      }

      if (fileSize < 1024) {
        return const Failure(ValidationFailure('File too small (minimum 1KB)'));
      }

      // Check file extension
      const supportedFormats = ['.mp4', '.mov', '.avi', '.webm'];
      final extension = path.extension(file.path).toLowerCase();
      if (!supportedFormats.contains(extension)) {
        return Failure(ValidationFailure(
          'Unsupported format: $extension. '
          'Supported formats: ${supportedFormats.join(', ')}'
        ));
      }

      // Check storage quota
      final quotaResult = await _videoRepository.getStorageUsage(organizationId);
      if (quotaResult.isSuccess) {
        const maxQuotaBytes = 5 * 1024 * 1024 * 1024; // 5GB default
        final currentUsage = quotaResult.dataOrNull!;

        if (currentUsage + fileSize > maxQuotaBytes) {
          return Failure(ValidationFailure(
            'Upload would exceed storage quota. '
            'Current usage: ${(currentUsage / (1024 * 1024)).toStringAsFixed(0)}MB, '
            'File size: ${(fileSize / (1024 * 1024)).toStringAsFixed(0)}MB, '
            'Available: ${((maxQuotaBytes - currentUsage) / (1024 * 1024)).toStringAsFixed(0)}MB'
          ));
        }
      }

      return const Success(null);
    } catch (e) {
      return Failure(ValidationFailure('Validation error: $e'));
    }
  }

  /// Extract video metadata using FFmpeg
  Future<Result<Map<String, dynamic>>> _extractVideoMetadata(String filePath) async {
    try {
      // Use FFprobe to get video information
      const command = '-v quiet -print_format json -show_format -show_streams';
      final session = await FFmpegKit.execute('$command "$filePath"');
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return const Failure(ProcessingFailure('Failed to extract video metadata'));
      }

      final output = await session.getOutput();
      if (output == null || output.isEmpty) {
        return const Failure(ProcessingFailure('No metadata output received'));
      }

      // Parse FFprobe JSON output
      // Note: In a real implementation, you would parse the JSON response
      // For now, we'll return estimated values based on file analysis
      final file = File(filePath);
      final fileSize = await file.length();

      // Estimate duration and resolution (placeholder)
      // In production, parse the actual FFprobe JSON output
      final metadata = {
        'duration_seconds': _estimateDuration(fileSize),
        'width': 1920,
        'height': 1080,
        'format': path.extension(filePath).substring(1),
        'bitrate': _estimateBitrate(fileSize),
        'frame_rate': 30.0,
        'file_size_bytes': fileSize,
        'codec': 'h264',
        'audio_codec': 'aac',
        'created_at': DateTime.now().toIso8601String(),
      };

      return Success(metadata);
    } catch (e) {
      return Failure(ProcessingFailure('Metadata extraction failed: $e'));
    }
  }

  /// Compress video if it exceeds size threshold
  Future<Result<File>> _compressVideoIfNeeded(
    File originalFile, {
    void Function(double progress)? onProgress,
  }) async {
    try {
      final fileSize = await originalFile.length();
      const compressionThreshold = 100 * 1024 * 1024; // 100MB

      if (fileSize < compressionThreshold) {
        onProgress?.call(1.0);
        return Success(originalFile); // No compression needed
      }

      onProgress?.call(0.1);

      // Create output path for compressed video
      final originalPath = originalFile.path;
      final directory = path.dirname(originalPath);
      final basename = path.basenameWithoutExtension(originalPath);
      final outputPath = path.join(directory, '${basename}_compressed.mp4');

      onProgress?.call(0.2);

      // FFmpeg compression command optimized for mobile coaching videos
      // Target: 720p, H.264, moderate bitrate for mobile optimization
      final compressionCommand = '-i "$originalPath" '
          '-vcodec h264 '
          '-acodec aac '
          '-vf scale=1280:720 '
          '-b:v 2000k '
          '-b:a 128k '
          '-preset medium '
          '-crf 28 '
          '-movflags +faststart ' // Optimize for streaming
          '"$outputPath"';

      onProgress?.call(0.3);

      // Execute compression
      final session = await FFmpegKit.execute(compressionCommand);
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getLogs();
        final errorMessage = logs.isNotEmpty ? logs.last.getMessage() : 'Unknown compression error';
        return Failure(ProcessingFailure('Video compression failed: $errorMessage'));
      }

      onProgress?.call(0.9);

      // Verify compressed file exists and is smaller
      final compressedFile = File(outputPath);
      if (!await compressedFile.exists()) {
        return const Failure(ProcessingFailure('Compressed file was not created'));
      }

      final compressedSize = await compressedFile.length();
      if (compressedSize >= fileSize) {
        // Compression didn't help, use original
        await compressedFile.delete();
        onProgress?.call(1.0);
        return Success(originalFile);
      }

      onProgress?.call(1.0);
      debugPrint('Video compressed: ${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB → ${(compressedSize / (1024 * 1024)).toStringAsFixed(1)}MB');

      return Success(compressedFile);
    } catch (e) {
      return Failure(ProcessingFailure('Compression error: $e'));
    }
  }

  /// Trigger background processing for video
  Future<void> _triggerBackgroundProcessing(String videoId) async {
    try {
      // Update processing status to trigger background job
      await _videoRepository.updateProcessingStatus(
        videoId: videoId,
        status: VideoProcessingStatus.processing,
      );

      // In a full implementation, this would trigger a Supabase Edge Function
      // or other background processing service
      debugPrint('Background processing triggered for video: $videoId');
    } catch (e) {
      debugPrint('Warning: Could not trigger background processing: $e');
    }
  }

  /// Get file from platform file or local path
  Future<File?> _validateAndGetFile(PlatformFile? platformFile, String? localFilePath) async {
    if (platformFile != null && platformFile.path != null) {
      return File(platformFile.path!);
    }

    if (localFilePath != null && localFilePath.isNotEmpty) {
      final file = File(localFilePath);
      if (await file.exists()) {
        return file;
      }
    }

    return null;
  }

  /// Update progress callback
  void _updateProgress(
    void Function(VideoUploadProgress)? onProgress,
    VideoUploadProgress progress,
  ) {
    onProgress?.call(progress);
  }

  /// Estimate video duration based on file size (rough approximation)
  int _estimateDuration(int fileSizeBytes) {
    // Rough estimation: ~1MB per 10 seconds for compressed video
    // This is very approximate and should be replaced with actual FFprobe parsing
    const bytesPerSecond = 100 * 1024; // ~100KB per second
    return (fileSizeBytes / bytesPerSecond).round().clamp(1, 1800); // Max 30 minutes
  }

  /// Estimate bitrate based on file size
  int _estimateBitrate(int fileSizeBytes) {
    // Rough estimation for typical video bitrates
    const duration = 120; // Assume 2 minutes average
    return ((fileSizeBytes * 8) / duration).round(); // bits per second
  }
}
