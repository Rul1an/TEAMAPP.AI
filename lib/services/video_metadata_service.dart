import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import '../core/result.dart';

/// Professional video metadata extraction service using FFprobe
/// Provides comprehensive video analysis for coaching applications
class VideoMetadataService {
  /// Extract comprehensive metadata from video file
  Future<Result<VideoMetadata>> extractMetadata(String videoPath) async {
    try {
      // Verify file exists
      final file = File(videoPath);
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        return const Failure(MetadataFailure('Video file does not exist'));
      }

      // Extract basic metadata
      final basicResult = await _extractBasicMetadata(videoPath);
      if (!basicResult.isSuccess) {
        return Failure(basicResult.errorOrNull!);
      }
      final basicData = basicResult.dataOrNull!;

      // Extract stream information
      final streamResult = await _extractStreamInfo(videoPath);
      if (!streamResult.isSuccess) {
        return Failure(streamResult.errorOrNull!);
      }
      final streamData = streamResult.dataOrNull!;

      // Get file stats
      // ignore: avoid_slow_async_io
      final fileSize = await file.length();
      // ignore: avoid_slow_async_io
      final lastModified = await file.lastModified();

      // Create comprehensive metadata
      final metadata = VideoMetadata(
        filePath: videoPath,
        fileName: path.basename(videoPath),
        fileSize: fileSize,
        duration: basicData['duration'] as double,
        width: streamData['width'] as int,
        height: streamData['height'] as int,
        frameRate: streamData['frame_rate'] as double,
        bitrate: basicData['bitrate'] as int,
        format: basicData['format'] as String,
        videoCodec: streamData['video_codec'] as String,
        audioCodec: streamData['audio_codec'] as String,
        aspectRatio: _calculateAspectRatio(
          streamData['width'] as int,
          streamData['height'] as int,
        ),
        orientation: _determineOrientation(
          streamData['width'] as int,
          streamData['height'] as int,
        ),
        hasAudio: streamData['has_audio'] as bool,
        audioChannels: streamData['audio_channels'] as int?,
        audioSampleRate: streamData['audio_sample_rate'] as int?,
        createdAt: lastModified,
        extractedAt: DateTime.now(),
        quality: _assessVideoQuality(
          streamData['width'] as int,
          streamData['height'] as int,
          basicData['bitrate'] as int,
        ),
        isHdr: streamData['is_hdr'] as bool,
        colorSpace: streamData['color_space'] as String?,
        pixelFormat: streamData['pixel_format'] as String?,
        frameCount: _estimateFrameCount(
          basicData['duration'] as double,
          streamData['frame_rate'] as double,
        ),
      );

      return Success(metadata);
    } catch (e) {
      return Failure(MetadataFailure('Metadata extraction failed: $e'));
    }
  }

  /// Extract basic format information using FFprobe
  Future<Result<Map<String, dynamic>>> _extractBasicMetadata(
      String videoPath) async {
    try {
      // FFprobe command for format information
      final command = '-v quiet -print_format json -show_format "$videoPath"';
      final session = await FFmpegKit.execute('ffprobe $command');
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return const Failure(
            MetadataFailure('Failed to extract format metadata'));
      }

      final output = await session.getOutput();
      if (output == null || output.trim().isEmpty) {
        return const Failure(MetadataFailure('No format metadata received'));
      }

      final jsonData = json.decode(output) as Map<String, dynamic>;
      final format = jsonData['format'] as Map<String, dynamic>;

      // Parse duration
      final durationStr = format['duration'] as String?;
      final duration =
          durationStr != null ? double.tryParse(durationStr) ?? 0.0 : 0.0;

      // Parse bitrate
      final bitrateStr = format['bit_rate'] as String?;
      final bitrate = bitrateStr != null ? int.tryParse(bitrateStr) ?? 0 : 0;

      // Get format name
      final formatName = format['format_name'] as String? ?? 'unknown';

      return Success({
        'duration': duration,
        'bitrate': bitrate,
        'format': formatName.split(',').first, // Take first format
      });
    } catch (e) {
      return Failure(MetadataFailure('Basic metadata extraction error: $e'));
    }
  }

  /// Extract stream information (video and audio streams)
  Future<Result<Map<String, dynamic>>> _extractStreamInfo(
      String videoPath) async {
    try {
      // FFprobe command for stream information
      final command = '-v quiet -print_format json -show_streams "$videoPath"';
      final session = await FFmpegKit.execute('ffprobe $command');
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return const Failure(
            MetadataFailure('Failed to extract stream metadata'));
      }

      final output = await session.getOutput();
      if (output == null || output.trim().isEmpty) {
        return const Failure(MetadataFailure('No stream metadata received'));
      }

      final jsonData = json.decode(output) as Map<String, dynamic>;
      final streams = jsonData['streams'] as List<dynamic>;

      if (streams.isEmpty) {
        return const Failure(MetadataFailure('No streams found in video'));
      }

      // Find video stream
      Map<String, dynamic>? videoStream;
      try {
        videoStream = streams.firstWhere(
          (stream) => stream['codec_type'] == 'video',
        ) as Map<String, dynamic>?;
      } catch (e) {
        return const Failure(MetadataFailure('No video stream found'));
      }

      if (videoStream == null) {
        return const Failure(MetadataFailure('No video stream found'));
      }

      // Find audio stream (optional)
      Map<String, dynamic>? audioStream;
      try {
        audioStream = streams.firstWhere(
          (stream) => stream['codec_type'] == 'audio',
        ) as Map<String, dynamic>?;
      } catch (e) {
        audioStream = null; // No audio stream found
      }

      // Parse frame rate
      final frameRateStr = videoStream['avg_frame_rate'] as String? ?? '30/1';
      final frameRate = _parseFrameRate(frameRateStr);

      // Parse video dimensions
      final width = videoStream['width'] as int? ?? 0;
      final height = videoStream['height'] as int? ?? 0;

      // Video codec
      final videoCodec = videoStream['codec_name'] as String? ?? 'unknown';

      // Color information
      final colorSpace = videoStream['color_space'] as String?;
      final pixelFormat = videoStream['pix_fmt'] as String?;
      final isHdr = _detectHdr(colorSpace, pixelFormat);

      // Audio information
      final hasAudio = audioStream != null;
      final audioCodec = audioStream?['codec_name'] as String? ?? 'none';
      final audioChannels = audioStream?['channels'] as int?;
      int? audioSampleRate;
      if (audioStream != null) {
        final sampleRateStr = audioStream['sample_rate'] as String?;
        if (sampleRateStr != null) {
          audioSampleRate = int.tryParse(sampleRateStr);
        }
      }

      return Success({
        'width': width,
        'height': height,
        'frame_rate': frameRate,
        'video_codec': videoCodec,
        'audio_codec': audioCodec,
        'has_audio': hasAudio,
        'audio_channels': audioChannels,
        'audio_sample_rate': audioSampleRate,
        'is_hdr': isHdr,
        'color_space': colorSpace,
        'pixel_format': pixelFormat,
      });
    } catch (e) {
      return Failure(MetadataFailure('Stream metadata extraction error: $e'));
    }
  }

  /// Parse frame rate from FFprobe format (e.g., "30/1" -> 30.0)
  double _parseFrameRate(String frameRateStr) {
    try {
      if (frameRateStr.contains('/')) {
        final parts = frameRateStr.split('/');
        if (parts.length == 2) {
          final num = double.tryParse(parts[0]) ?? 30.0;
          final den = double.tryParse(parts[1]) ?? 1.0;
          return den != 0 ? num / den : 30.0;
        }
      }
      return double.tryParse(frameRateStr) ?? 30.0;
    } catch (e) {
      return 30.0; // Default fallback
    }
  }

  /// Calculate aspect ratio string (e.g., "16:9")
  String _calculateAspectRatio(int width, int height) {
    if (width == 0 || height == 0) return 'unknown';

    // Common aspect ratios
    final ratio = width / height;
    if ((ratio - 16 / 9).abs() < 0.1) return '16:9';
    if ((ratio - 4 / 3).abs() < 0.1) return '4:3';
    if ((ratio - 21 / 9).abs() < 0.1) return '21:9';
    if ((ratio - 1.0).abs() < 0.1) return '1:1';

    // Calculate GCD for custom ratios
    final gcd = _gcd(width, height);
    return '${width ~/ gcd}:${height ~/ gcd}';
  }

  /// Determine video orientation
  VideoOrientation _determineOrientation(int width, int height) {
    if (width > height) return VideoOrientation.landscape;
    if (height > width) return VideoOrientation.portrait;
    return VideoOrientation.square;
  }

  /// Assess video quality based on resolution and bitrate
  VideoQuality _assessVideoQuality(int width, int height, int bitrate) {
    final pixels = width * height;

    // 4K and above
    if (pixels >= 3840 * 2160) return VideoQuality.ultra;

    // 1080p
    if (pixels >= 1920 * 1080) {
      return bitrate > 5000000 ? VideoQuality.high : VideoQuality.medium;
    }

    // 720p
    if (pixels >= 1280 * 720) {
      return bitrate > 2000000 ? VideoQuality.medium : VideoQuality.low;
    }

    // Below 720p
    return VideoQuality.low;
  }

  /// Detect HDR content
  bool _detectHdr(String? colorSpace, String? pixelFormat) {
    if (colorSpace == null || pixelFormat == null) return false;

    // Common HDR indicators
    const hdrColorSpaces = ['bt2020nc', 'bt2020c', 'smpte2084', 'arib-std-b67'];
    const hdrPixelFormats = ['yuv420p10le', 'yuv422p10le', 'yuv444p10le'];

    return hdrColorSpaces.contains(colorSpace.toLowerCase()) ||
        hdrPixelFormats.contains(pixelFormat.toLowerCase());
  }

  /// Estimate total frame count
  int _estimateFrameCount(double duration, double frameRate) {
    return (duration * frameRate).round();
  }

  /// Calculate Greatest Common Divisor
  int _gcd(int a, int b) {
    int tempA = a;
    int tempB = b;
    while (tempB != 0) {
      final temp = tempB;
      tempB = tempA % tempB;
      tempA = temp;
    }
    return tempA;
  }

  /// Quick metadata extraction for upload validation
  Future<Result<Map<String, dynamic>>> extractQuickMetadata(
      String videoPath) async {
    try {
      final file = File(videoPath);
      // ignore: avoid_slow_async_io
      if (!await file.exists()) {
        return const Failure(MetadataFailure('File does not exist'));
      }

      // Quick duration and resolution check
      final command =
          '-v quiet -show_entries stream=width,height,duration,codec_name:format=duration -of csv=p=0 "$videoPath"';
      final session = await FFmpegKit.execute('ffprobe $command');
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        return const Failure(
            MetadataFailure('Quick metadata extraction failed'));
      }

      final output = await session.getOutput();
      if (output == null || output.trim().isEmpty) {
        return const Failure(MetadataFailure('No quick metadata received'));
      }

      // Parse CSV output (simplified)
      final fileSize = await file.length();

      // Basic validation data
      return Success({
        'file_size': fileSize,
        'duration_estimate': 120, // Placeholder - parse from actual output
        'width_estimate': 1920, // Placeholder - parse from actual output
        'height_estimate': 1080, // Placeholder - parse from actual output
      });
    } catch (e) {
      return Failure(MetadataFailure('Quick metadata error: $e'));
    }
  }
}

/// Comprehensive video metadata model
class VideoMetadata {
  final String filePath;
  final String fileName;
  final int fileSize;
  final double duration;
  final int width;
  final int height;
  final double frameRate;
  final int bitrate;
  final String format;
  final String videoCodec;
  final String audioCodec;
  final String aspectRatio;
  final VideoOrientation orientation;
  final bool hasAudio;
  final int? audioChannels;
  final int? audioSampleRate;
  final DateTime createdAt;
  final DateTime extractedAt;
  final VideoQuality quality;
  final bool isHdr;
  final String? colorSpace;
  final String? pixelFormat;
  final int frameCount;

  const VideoMetadata({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.duration,
    required this.width,
    required this.height,
    required this.frameRate,
    required this.bitrate,
    required this.format,
    required this.videoCodec,
    required this.audioCodec,
    required this.aspectRatio,
    required this.orientation,
    required this.hasAudio,
    this.audioChannels,
    this.audioSampleRate,
    required this.createdAt,
    required this.extractedAt,
    required this.quality,
    required this.isHdr,
    this.colorSpace,
    this.pixelFormat,
    required this.frameCount,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'fileName': fileName,
        'fileSize': fileSize,
        'duration': duration,
        'width': width,
        'height': height,
        'frameRate': frameRate,
        'bitrate': bitrate,
        'format': format,
        'videoCodec': videoCodec,
        'audioCodec': audioCodec,
        'aspectRatio': aspectRatio,
        'orientation': orientation.name,
        'hasAudio': hasAudio,
        'audioChannels': audioChannels,
        'audioSampleRate': audioSampleRate,
        'createdAt': createdAt.toIso8601String(),
        'extractedAt': extractedAt.toIso8601String(),
        'quality': quality.name,
        'isHdr': isHdr,
        'colorSpace': colorSpace,
        'pixelFormat': pixelFormat,
        'frameCount': frameCount,
      };

  /// Human-readable summary
  String get summary => '${width}x$height $aspectRatio, '
      '${(duration / 60).toStringAsFixed(1)}min, '
      '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB, '
      '${quality.displayName}';
}

/// Video orientation enum
enum VideoOrientation {
  landscape,
  portrait,
  square,
}

/// Video quality assessment
enum VideoQuality {
  low,
  medium,
  high,
  ultra;

  String get displayName {
    switch (this) {
      case VideoQuality.low:
        return 'Low Quality';
      case VideoQuality.medium:
        return 'Medium Quality';
      case VideoQuality.high:
        return 'High Quality';
      case VideoQuality.ultra:
        return 'Ultra Quality';
    }
  }
}
