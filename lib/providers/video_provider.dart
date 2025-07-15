// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../data/supabase_video_data_source.dart';
import '../repositories/supabase_video_repository.dart';
import '../repositories/video_repository.dart';
import '../models/video.dart';

// Remote data-source -------------------------------------------------------

final videoRemoteProvider = Provider<SupabaseVideoDataSource>((_) {
  return SupabaseVideoDataSource();
});

// Repository ---------------------------------------------------------------

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  return SupabaseVideoRepository(
    dataSource: ref.read(videoRemoteProvider),
  );
});

final videosProvider = StreamProvider<List<Video>>((ref) {
  final repo = ref.read(videoRepositoryProvider);
  return repo.watchAll();
});

final videoStorageUsageProvider = FutureProvider<int>((ref) {
  final repo = ref.read(videoRepositoryProvider);
  return repo.totalBytes();
});