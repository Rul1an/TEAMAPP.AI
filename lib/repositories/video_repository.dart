import 'dart:io' as io;

import '../core/result.dart';
import '../models/video.dart';

abstract interface class VideoRepository {
  /// Uploads a video file and returns the created [Video] row when successful.
  ///
  /// The implementation must:
  /// 1. Upload the binary to Supabase Storage (`videos` bucket).
  /// 2. Insert a row into `videos` table with `status = uploading`.
  /// 3. Update the row to `ready` once the file is fully uploaded (Phase-1)
  ///    or transcoding completed (Phase-2).
  Future<Result<Video>> upload({
    required io.File file,
    required String title,
    String? description,
    VideoType type = VideoType.match,
  });

  /// Emits the list of all videos for the signed-in organisation.
  /// Stream must be backed by `supabase.from('videos').stream()` so updates are
  /// received in real-time when status or metadata changes.
  Stream<List<Video>> watchAll();

  /// Fetches a single video by its id.
  Future<Result<Video>> getById(String id);

  Future<int> totalBytes();

  Future<Result<void>> delete(Video video);
}