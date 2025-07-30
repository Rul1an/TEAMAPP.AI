import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import '../core/result.dart';

/// Professional video thumbnail generation service using FFmpeg
/// Optimized for coaching video thumbnails with multiple formats
class VideoThumbnailService {
  /// Generate multiple thumbnails at different timestamps
  Future<Result<List<String>>> generateThumbnails({
    required String videoPath,
    required String outputDirectory,
    String videoId = '',
    List<double> timestampPercents = const [0.1, 0.3, 0.5, 0.7, 0.9],
    ThumbnailQuality quality = ThumbnailQuality.medium,
  }) async {
    try {
      // Ensure output directory exists
      final outputDir = Directory(outputDirectory);
      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      // Get video duration first
      final durationResult = await _getVideoDuration(videoPath);
      if (!durationResult.isSuccess) {
        return Failure(durationResult.errorOrNull!);
      }

      final duration = durationResult.dataOrNull!;
      final thumbnailPaths = <String>[];

      // Generate thumbnails at specified timestamps
      for (int i = 0; i < timestampPercents.length; i++) {
        final timestamp = duration * timestampPercents[i];
        final outputPath = path.join(
          outputDirectory,
          '${videoId.isNotEmpty ? '${videoId}_' : ''}thumbnail_${i + 1}.jpg',
        );

        final result = await _generateSingleThumbnail(
          videoPath: videoPath,
          outputPath: outputPath,
          timestamp: timestamp,
          quality: quality,
        );

        if (result.isSuccess) {
          thumbnailPaths.add(result.dataOrNull!);
        } else {
          debugPrint('Warning: Failed to generate thumbnail at ${timestamp}s: ${result.errorOrNull}');
        }
      }

      if (thumbnailPaths.isEmpty) {
        return const Failure(ProcessingFailure('No thumbnails could be generated'));
      }

      return Success(thumbnailPaths);
    } catch (e) {
      return Failure(ProcessingFailure('Thumbnail generation failed: $e'));
    }
  }

  /// Generate a single thumbnail at specific timestamp
  Future<Result<String>> generateSingleThumbnail({
    required String videoPath,
    required String outputPath,
    required double timestamp,
    ThumbnailQuality quality = ThumbnailQuality.medium,
  }) async {
    return _generateSingleThumbnail(
      videoPath: videoPath,
      outputPath: outputPath,
      timestamp: timestamp,
      quality: quality,
    );
  }

  /// Generate thumbnail from video frame at specific timestamp
  Future<Result<String>> _generateSingleThumbnail({
    required String videoPath,
    required String outputPath,
    required double timestamp,
    required ThumbnailQuality quality,
  }) async {
    try {
      // Get quality settings
      final settings = _getQualitySettings(quality);

      // FFmpeg command to extract frame at specific timestamp
      final command = '-i "$videoPath" '
          '-ss ${timestamp.toStringAsFixed(2)} '
          '-vframes 1 '
          '-vf scale=${settings.width}:${settings.height}:force_original_aspect_ratio=decrease,pad=${settings.width}:${settings.height}:(ow-iw)/2:(oh-ih)/2:black '
          '-q:v ${settings.quality} '
          '-f image2 '
          '"$outputPath"';

      debugPrint('Generating thumbnail: $command');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getLogs();
        final errorMessage = logs.isNotEmpty
          ? logs.map((log) => log.getMessage()).join('\n')
          : 'Unknown thumbnail generation error';
        return Failure(ProcessingFailure('Thumbnail generation failed: $errorMessage'));
      }

      // Verify thumbnail was created
      final thumbnailFile = File(outputPath);
      if (!await thumbnailFile.exists()) {
        return const Failure(ProcessingFailure('Thumbnail file was not created'));
      }

      // Verify file has content
      final fileSize = await thumbnailFile.length();
      if (fileSize < 1024) { // Less than 1KB is probably not a valid image
        return const Failure(ProcessingFailure('Generated thumbnail is too small'));
      }

      debugPrint('Thumbnail generated successfully: $outputPath (${(fileSize / 1024).toStringAsFixed(1)}KB)');
      return Success(outputPath);
    } catch (e) {
      return Failure(ProcessingFailure('Thumbnail generation error: $e'));
    }
  }

  /// Get video duration in seconds
  Future<Result<double>> _getVideoDuration(String videoPath) async {
    try {
      // Use FFprobe to get duration
      final command = '-v quiet -show_entries format=duration -of csv=p=0 "$videoPath"';
      final session = await FFmpegKit.execute('ffprobe $command');
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return const Failure(ProcessingFailure('Failed to get video duration'));
      }

      final output = await session.getOutput();
      if (output == null || output.trim().isEmpty) {
        return const Failure(ProcessingFailure('No duration output received'));
      }

      final duration = double.tryParse(output.trim());
      if (duration == null || duration <= 0) {
        return const Failure(ProcessingFailure('Invalid duration value'));
      }

      return Success(duration);
    } catch (e) {
      return Failure(ProcessingFailure('Duration extraction error: $e'));
    }
  }

  /// Get quality settings for thumbnail generation
  ThumbnailSettings _getQualitySettings(ThumbnailQuality quality) {
    switch (quality) {
      case ThumbnailQuality.low:
        return const ThumbnailSettings(width: 320, height: 180, quality: 8);
      case ThumbnailQuality.medium:
        return const ThumbnailSettings(width: 640, height: 360, quality: 5);
      case ThumbnailQuality.high:
        return const ThumbnailSettings(width: 1280, height: 720, quality: 2);
    }
  }

  /// Generate animated thumbnail (GIF) for preview
  Future<Result<String>> generateAnimatedThumbnail({
    required String videoPath,
    required String outputPath,
    double startTime = 0.0,
    double duration = 3.0,
    int fps = 10,
    int width = 320,
  }) async {
    try {
      // Calculate aspect ratio height
      final height = (width * 9 / 16).round(); // 16:9 aspect ratio

      // FFmpeg command for animated GIF
      final command = '-i "$videoPath" '
          '-ss ${startTime.toStringAsFixed(2)} '
          '-t ${duration.toStringAsFixed(2)} '
          '-vf scale=$width:$height:force_original_aspect_ratio=decrease,pad=$width:$height:(ow-iw)/2:(oh-ih)/2:black,fps=$fps '
          '-loop 0 '
          '"$outputPath"';

      debugPrint('Generating animated thumbnail: $command');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getLogs();
        final errorMessage = logs.isNotEmpty
          ? logs.map((log) => log.getMessage()).join('\n')
          : 'Unknown animated thumbnail error';
        return Failure(ProcessingFailure('Animated thumbnail failed: $errorMessage'));
      }

      // Verify output file
      final outputFile = File(outputPath);
      if (!await outputFile.exists()) {
        return const Failure(ProcessingFailure('Animated thumbnail was not created'));
      }

      final fileSize = await outputFile.length();
      debugPrint('Animated thumbnail generated: $outputPath (${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB)');

      return Success(outputPath);
    } catch (e) {
      return Failure(ProcessingFailure('Animated thumbnail error: $e'));
    }
  }

  /// Clean up generated thumbnails
  Future<void> cleanupThumbnails(List<String> thumbnailPaths) async {
    for (final path in thumbnailPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Cleaned up thumbnail: $path');
        }
      } catch (e) {
        debugPrint('Warning: Could not delete thumbnail $path: $e');
      }
    }
  }
}

/// Thumbnail quality levels
enum ThumbnailQuality {
  low,
  medium,
  high,
}

/// Thumbnail generation settings
class ThumbnailSettings {
  final int width;
  final int height;
  final int quality; // FFmpeg -q:v parameter (lower = better quality)

  const ThumbnailSettings({
    required this.width,
    required this.height,
    required this.quality,
  });
}

/// Processing failure for video operations
class ProcessingFailure extends AppFailure {
  const ProcessingFailure(super.message);
}
