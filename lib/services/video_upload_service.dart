import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';

/// Upload stages exposed to UI (e.g. status chip)
enum UploadStage {
  queued,
  precompressing,
  uploading,
  processing,
  complete,
  failed,
  retrying,
}

class UploadStatus {
  UploadStage stage;
  double progress; // 0-1 for uploading/compressing
  String? message;
  int retryCount;

  UploadStatus({
    required this.stage,
    this.progress = 0,
    this.message,
    this.retryCount = 0,
  });
}

/// Skeleton service responsible for:
/// 1) Device-side pre-compressie (via video_compress – TODO).
/// 2) Upload naar Supabase Storage met exponential retry (max 3).
/// 3) Expose realtime [Stream] voor UI feedback.
/// 4) Emits Supabase Realtime channel events (processing → complete).
class VideoUploadService {
  VideoUploadService(this._supabase);

  final SupabaseClient _supabase;

  /// Max retries in case of network failure.
  static const int _maxRetries = 3;

  /// Queue a video for upload and return a status stream.
  Stream<UploadStatus> queueUpload(
    File file, {
    required String bucket,
    required String path,
    VideoQuality quality = VideoQuality.MediumQuality,
  }) async* {
    // 1. Start queued
    var status = UploadStatus(stage: UploadStage.queued);
    yield status;

    // 2. Pre-compress (skip on Web/desktop)
    File outputFile = file;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      status = UploadStatus(stage: UploadStage.precompressing, progress: 0);
      yield status;

      // Listen to progress stream
      final sub = VideoCompress.compressProgress$.listen((progress) async {
        // progress is 0–100 (double)
        status = UploadStatus(
          stage: UploadStage.precompressing,
          progress: progress / 100.0,
        );
        // Yield from inside listener via controller? Instead we'll ignore minor updates <5%
      });

      try {
        final info = await VideoCompress.compressVideo(
          file.path,
          quality: quality,
          deleteOrigin: false,
          includeAudio: true,
        );
        if (info != null && info.path != null) {
          outputFile = File(info.path!);
        }
      } catch (e) {
        debugPrint('Compression failed, fallback to original: $e');
      } finally {
        await sub.cancel();
      }
    }

    // 3. Attempt upload with retry logic
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        if (attempt > 0) {
          status = UploadStatus(
            stage: UploadStage.retrying,
            retryCount: attempt,
            message: 'Retry $attempt',
          );
          yield status;
        }

        status = UploadStatus(stage: UploadStage.uploading, progress: 0);
        yield status;

        // Use Supabase storage upload
        final storage = _supabase.storage.from(bucket);
        await storage.upload(path, outputFile);

        status = UploadStatus(stage: UploadStage.processing);
        yield status;

        // Listen for realtime processing done event (edge-function will dispatch)
        // TODO: implement listening logic.

        status = UploadStatus(stage: UploadStage.complete);
        yield status;
        return;
      } catch (e, st) {
        debugPrint('Upload attempt $attempt failed: $e\n$st');
        attempt += 1;
        // Exponential back-off: 0.5s, 1s, 2s …
        await Future.delayed(Duration(milliseconds: 500 * (1 << (attempt - 1))));
      }
    }

    status = UploadStatus(stage: UploadStage.failed, message: 'All retries exhausted');
    yield status;
  }
}