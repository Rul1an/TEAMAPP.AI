import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_compress/video_compress.dart';

/// Handles pre-compression of video files and uploading them to Supabase
/// Storage. Designed to be injected into Riverpod providers for testability.
class VideoUploadManager {
  VideoUploadManager({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;

  static SupabaseClient _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      // Allows unit tests to pass without initializing SupabaseFlutter.
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }

  /// Compresses [rawFile] using `video_compress` and uploads the result to the
  /// `videos` bucket. Returns the public URL of the uploaded file.
  ///
  /// When [onProgress] is supplied, the callback is invoked with values in the
  /// range 0-1 indicating upload progress. Compression progress is currently
  /// not reported by `video_compress` and therefore not reflected here.
  Future<String> compressAndUpload(
    io.File rawFile, {
    void Function(double pct)? onProgress,
  }) async {
    // 1. Compress
    final info = await VideoCompress.compressVideo(
      rawFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );

    final compressedPath = info?.path ?? rawFile.path;
    final compressedFile = io.File(compressedPath);

    // 2. Prepare upload path
    final ext = p.extension(compressedFile.path).replaceFirst('.', '');
    final filename = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final uid = _supabase.auth.currentUser?.id ?? 'anonymous';
    final pathInBucket = '$uid/$filename';

    // 3. Read bytes
    final bytes = await compressedFile.readAsBytes();

    // 4. Upload — Supabase Storage currently does not expose upload progress
    //    for binary uploads. We therefore emit 0 → 1 progress updates when
    //    provided a callback.
    if (onProgress != null) onProgress(0);

    final storage = _supabase.storage.from('videos');
    await storage.uploadBinary(
      pathInBucket,
      bytes,
      fileOptions: FileOptions(contentType: 'video/$ext'),
    );

    if (onProgress != null) onProgress(1);

    // 5. Return public URL
    return storage.getPublicUrl(pathInBucket);
  }
}