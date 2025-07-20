import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/video_tag.dart';
import '../models/tag_type.dart';
import 'tag_repository.dart';

class SupabaseTagRepository implements TagRepository {
  SupabaseTagRepository(this.client);

  final SupabaseClient client;

  @override
  Future<VideoTag> create(VideoTag tag) async {
    final data = await client
        .from('video_tags')
        .insert(tag.toJson())
        .select()
        .single();
    return VideoTag.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> update(VideoTag tag) async {
    await client.from('video_tags').update(tag.toJson()).eq('id', tag.id);
  }

  @override
  Future<void> delete(String tagId) async {
    await client.from('video_tags').delete().eq('id', tagId);
  }

  @override
  Stream<List<VideoTag>> watchByVideo(String videoId) {
    return client
        .from('video_tags')
        .stream(primaryKey: ['id'])
        .eq('video_id', videoId)
        .map((rows) => rows
            .map((e) => VideoTag.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<List<VideoTag>> search({
    String? playerId,
    TagType? type,
    String? videoId,
  }) async {
    var query = client.from('video_tags').select();
    if (playerId != null) query = query.eq('player_id', playerId);
    if (type != null) query = query.eq('type', type.name);
    if (videoId != null) query = query.eq('video_id', videoId);
    final list = await query;
    return (list as List<dynamic>)
        .map((e) => VideoTag.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
