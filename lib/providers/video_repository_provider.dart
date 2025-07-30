// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/video.dart';
import '../repositories/video_repository.dart';
import '../repositories/supabase_video_repository.dart';

// Low-level singletons -----------------------------------------------------

final supabaseClientProvider =
    Provider<SupabaseClient>((_) => Supabase.instance.client);

// Repository --------------------------------------------------------------

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final supabaseClient = ref.read(supabaseClientProvider);
  return SupabaseVideoRepository(supabaseClient);
});

// Video data providers ----------------------------------------------------

final videosProvider =
    FutureProvider.family<List<Video>, String>((ref, organizationId) async {
  final repo = ref.read(videoRepositoryProvider);
  final result = await repo.getVideos(organizationId: organizationId);
  return result.fold(
    (error) => throw error,
    (videos) => videos,
  );
});

final videoByIdProvider =
    FutureProvider.family<Video?, String>((ref, videoId) async {
  final repo = ref.read(videoRepositoryProvider);
  final result = await repo.getVideoById(videoId);
  return result.fold(
    (_) => null,
    (video) => video,
  );
});

// Video state management --------------------------------------------------

final videosNotifierProvider = StateNotifierProvider.family<VideosNotifier,
    AsyncValue<List<Video>>, String>(
  VideosNotifier.new,
);

class VideosNotifier extends StateNotifier<AsyncValue<List<Video>>> {
  VideosNotifier(this._ref, this._organizationId)
      : super(const AsyncValue.loading()) {
    loadVideos();
  }

  final Ref _ref;
  final String _organizationId;

  VideoRepository get _repo => _ref.read(videoRepositoryProvider);

  Future<void> loadVideos() async {
    state = const AsyncValue.loading();
    final result = await _repo.getVideos(organizationId: _organizationId);
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      AsyncValue.data,
    );
  }

  Future<void> uploadVideo({
    required String title,
    String? description,
    String? playerId,
    required String localFilePath,
    List<String>? initialTags,
    void Function(double progress)? onProgress,
  }) async {
    final request = VideoUploadRequest(
      organizationId: _organizationId,
      title: title,
      description: description,
      playerId: playerId,
      localFilePath: localFilePath,
      initialTags: initialTags ?? [],
      onProgress: onProgress,
    );

    final result = await _repo.uploadVideo(request: request);

    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (video) {
        // Add video to current list
        final currentVideos = state.value ?? [];
        state = AsyncValue.data([video, ...currentVideos]);
      },
    );
  }

  Future<void> deleteVideo(String videoId) async {
    final result = await _repo.deleteVideo(videoId);
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (_) {
        // Remove video from current list
        final currentVideos = state.value ?? [];
        final updatedVideos =
            currentVideos.where((v) => v.id != videoId).toList();
        state = AsyncValue.data(updatedVideos);
      },
    );
  }

  Future<void> updateVideoMetadata({
    required String videoId,
    String? title,
    String? description,
  }) async {
    final result = await _repo.updateVideoMetadata(
      videoId: videoId,
      title: title,
      description: description,
    );

    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (updatedVideo) {
        // Update video in current list
        final currentVideos = state.value ?? [];
        final updatedVideos = currentVideos
            .map((v) => v.id == videoId ? updatedVideo : v)
            .toList();
        state = AsyncValue.data(updatedVideos);
      },
    );
  }
}
