import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jo17_tactical_manager/config/supabase_config.dart';

import '../models/video_tag.dart';
import '../models/tag_type.dart';
import 'tag_repository.dart';

class SupabaseTagRepository implements TagRepository {
  SupabaseTagRepository(this.client);

  final SupabaseClient client;

  @override
  Future<VideoTag> create(VideoTag tag) async {
    final data =
        await client.from('video_tags').insert(tag.toJson()).select().single();
    return VideoTag.fromJson(data);
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
        .map(
          (rows) => rows
              .map<Map<String, dynamic>>(Map<String, dynamic>.from)
              .where((row) =>
                  row['video_id'] ==
                  videoId) // Client-side filter for organization
              .map(VideoTag.fromJson)
              .toList(),
        );
  }

  @override
  Future<List<VideoTag>> search({
    String? playerId,
    TagType? type,
    String? videoId,
  }) async {
    // OPTIMIZED PATTERN: Start with organization-based filtering; use RPC with metadata fallback
    final orgId = await client.getOrganizationIdWithFallback();
    if (orgId == null) {
      return <VideoTag>[];
    }
    var query = client.from('video_tags').select().eq('organization_id', orgId);

    // Apply additional filters on top of optimized base query
    if (playerId != null) query = query.eq('player_id', playerId);
    if (type != null) query = query.eq('type', type.name);
    if (videoId != null) query = query.eq('video_id', videoId);

    final rows = (await query)
        .map<Map<String, dynamic>>(Map<String, dynamic>.from)
        .toList();
    return rows.map(VideoTag.fromJson).toList();
  }
}
