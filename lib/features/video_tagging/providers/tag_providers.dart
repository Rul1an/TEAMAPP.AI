import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/supabase_tag_repository.dart';
import '../repositories/tag_repository.dart';
import '../models/video_tag.dart';
import '../models/tag_type.dart';

final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseTagRepository(client);
});

final videoTagsProvider =
    StreamProvider.family<List<VideoTag>, String>((ref, videoId) {
  return ref.watch(tagRepositoryProvider).watchByVideo(videoId);
});

final searchTagsProvider = FutureProvider.family<List<VideoTag>,
    ({String? playerId, TagType? type, String? videoId})>((ref, params) {
  return ref.watch(tagRepositoryProvider).search(
        playerId: params.playerId,
        type: params.type,
        videoId: params.videoId,
      );
});
