// ignore_for_file: unused_import, unnecessary_import
import 'dart:convert'; // potential future JSON parsing

import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/result.dart';

import '../config/supabase_config.dart';
import '../models/veo_highlight.dart';

abstract class VeoHighlightRepository {
  Future<Result<List<VeoHighlight>>> fetchHighlightsByMatch(String matchId);
  Future<Result<String>> getPlaybackUrl(String highlightId);
}

class SupabaseVeoHighlightRepository implements VeoHighlightRepository {
  const SupabaseVeoHighlightRepository(this._client);

  final SupabaseClient _client;

  /// Fetch highlights for a given match using Edge Function `veo_fetch_clips`.
  @override
  Future<Result<List<VeoHighlight>>> fetchHighlightsByMatch(
      String matchId) async {
    final dynamic response = await _client.functions.invoke(
      'veo_fetch_clips',
      body: <String, dynamic>{'matchId': matchId},
    );

    final respMap = Map<String, dynamic>.from(response.data as Map);
    if (respMap['error'] != null) {
      return Failure(
          NetworkFailure(respMap['error']?.toString() ?? 'Unknown error'));
    }

    final clips = (respMap['clips'] as List<dynamic>? ?? [])
        .map((e) => VeoHighlight.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return Success(clips);
  }

  /// Get presigned playback URL for highlight (lazy-load on demand)
  @override
  Future<Result<String>> getPlaybackUrl(String highlightId) async {
    final dynamic response = await _client.functions.invoke(
      'veo_get_clip_url',
      body: <String, dynamic>{'highlightId': highlightId},
    );
    final respMap = Map<String, dynamic>.from(response.data as Map);
    if (respMap['error'] != null) {
      return Failure(
          NetworkFailure(respMap['error']?.toString() ?? 'Unknown error'));
    }
    return Success(respMap['url'] as String);
  }
}
