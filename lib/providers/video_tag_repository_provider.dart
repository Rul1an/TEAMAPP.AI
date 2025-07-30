// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/video_tag.dart';
import '../repositories/video_tag_repository.dart';
import '../repositories/supabase_video_tag_repository.dart';

// Repository --------------------------------------------------------------

final videoTagRepositoryProvider = Provider<VideoTagRepository>((ref) {
  final supabaseClient = Supabase.instance.client;
  return SupabaseVideoTagRepository(supabaseClient);
});

// Video tag data providers -----------------------------------------------

final videoTagsProvider = FutureProvider.family<List<VideoTag>, String>((ref, videoId) async {
  final repo = ref.read(videoTagRepositoryProvider);
  final result = await repo.getTagsForVideo(videoId);
  return result.fold(
    (error) => throw error,
    (tags) => tags,
  );
});

final videoTagsByFilterProvider = FutureProvider.family<List<VideoTag>, VideoTagFilter>((ref, filter) async {
  final repo = ref.read(videoTagRepositoryProvider);
  final result = await repo.getTags(filter);
  return result.fold(
    (error) => throw error,
    (tags) => tags,
  );
});

final videoTagAnalyticsProvider = FutureProvider.family<VideoTagAnalytics, String>((ref, videoId) async {
  final repo = ref.read(videoTagRepositoryProvider);
  final result = await repo.getTagAnalytics(videoId);
  return result.fold(
    (error) => throw error,
    (analytics) => analytics,
  );
});

// Video tag state management ---------------------------------------------

final videoTagsNotifierProvider =
    StateNotifierProvider.family<VideoTagsNotifier, AsyncValue<List<VideoTag>>, String>(
  (ref, videoId) => VideoTagsNotifier(ref, videoId),
);

class VideoTagsNotifier extends StateNotifier<AsyncValue<List<VideoTag>>> {
  VideoTagsNotifier(this._ref, this._videoId) : super(const AsyncValue.loading()) {
    loadTags();
  }

  final Ref _ref;
  final String _videoId;

  VideoTagRepository get _repo => _ref.read(videoTagRepositoryProvider);

  Future<void> loadTags() async {
    state = const AsyncValue.loading();
    final result = await _repo.getTagsForVideo(_videoId);
    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (tags) => AsyncValue.data(tags),
    );
  }

  Future<void> createTag(CreateVideoTagRequest request) async {
    final result = await _repo.createTag(request);
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (newTag) {
        // Add tag to current list
        final currentTags = state.value ?? [];
        final updatedTags = [...currentTags, newTag]
          ..sort((a, b) => a.timestampSeconds.compareTo(b.timestampSeconds));
        state = AsyncValue.data(updatedTags);
      },
    );
  }

  Future<void> updateTag(UpdateVideoTagRequest request) async {
    final result = await _repo.updateTag(request);
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (updatedTag) {
        // Update tag in current list
        final currentTags = state.value ?? [];
        final updatedTags = currentTags
            .map((t) => t.id == request.tagId ? updatedTag : t)
            .toList();
        state = AsyncValue.data(updatedTags);
      },
    );
  }

  Future<void> deleteTag(String tagId) async {
    final result = await _repo.deleteTag(tagId);
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (_) {
        // Remove tag from current list
        final currentTags = state.value ?? [];
        final updatedTags = currentTags.where((t) => t.id != tagId).toList();
        state = AsyncValue.data(updatedTags);
      },
    );
  }

  Future<void> bulkUpdateTags(List<VideoTag> tags) async {
    final result = await _repo.createBulkTags(
      tags.map((tag) => CreateVideoTagRequest(
        videoId: tag.videoId,
        organizationId: tag.organizationId,
        tagType: tag.tagType,
        timestampSeconds: tag.timestampSeconds,
        title: tag.title,
        description: tag.description,
        tagData: {
          ...tag.tagData,
          if (tag.playerId != null) 'playerId': tag.playerId,
        },
      )).toList(),
    );
    result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
      (updatedTags) {
        state = AsyncValue.data(updatedTags);
      },
    );
  }

  // Helper methods for filtering
  List<VideoTag> getTagsByType(VideoTagType tagType) {
    final tags = state.value ?? [];
    return tags.where((tag) => tag.tagType == tagType).toList();
  }

  List<VideoTag> getTagsInTimeRange(double startSeconds, double endSeconds) {
    final tags = state.value ?? [];
    return tags.where((tag) =>
      tag.timestampSeconds >= startSeconds &&
      tag.timestampSeconds <= endSeconds
    ).toList();
  }
}
