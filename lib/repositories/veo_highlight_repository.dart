// ignore_for_file: unused_import, unnecessary_import
import 'dart:convert'; // potential future JSON parsing

import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/veo_highlight.dart';

class VeoHighlightRepository {
  const VeoHighlightRepository(this._client);

  final SupabaseClient _client;

  /// Fetch highlights for a given match using Edge Function `veo_fetch_clips`.
  Future<List<VeoHighlight>> fetchHighlightsByMatch(String matchId) async {
    final dynamic response = await _client.functions.invoke(
      'veo_fetch_clips',
      body: <String, dynamic>{'matchId': matchId},
    );

    final resp = Map<String, dynamic>.from(response.data as Map);
    if (resp['error'] != null) {
      throw Exception(resp['error']);
    }

    final clips = (resp['clips'] as List<dynamic>? ?? [])
        .map((e) => VeoHighlight.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return clips;
  }

  /// Get presigned playback URL for highlight (lazy-load on demand)
  Future<String> getPlaybackUrl(String highlightId) async {
    final dynamic response = await _client.functions.invoke(
      'veo_get_clip_url',
      body: <String, dynamic>{'highlightId': highlightId},
    );
    final resp = Map<String, dynamic>.from(response.data as Map);
    if (resp['error'] != null) {
      throw Exception(resp['error']);
    }
    return resp['url'] as String;
  }
}
