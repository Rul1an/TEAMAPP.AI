// Package imports:
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../services/video_upload_service.dart';

/// Provides a singleton [VideoUploadService] backed by the global Supabase client.
final videoUploadServiceProvider = Provider<VideoUploadService>((ref) {
  final client = Supabase.instance.client;
  return VideoUploadService(client);
});

/// Family provider that kicks off an upload stream for the given [file].
/// By default the path inside the bucket is derived from the file basename.
final videoUploadStatusProvider = StreamProvider.family.autoDispose<UploadStatus, File>(
  (ref, file) {
    final service = ref.watch(videoUploadServiceProvider);
    final destPath = p.basename(file.path);
    return service.queueUpload(
      file,
      bucket: 'videos',
      path: destPath,
    );
  },
);