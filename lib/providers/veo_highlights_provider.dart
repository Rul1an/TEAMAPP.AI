import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/supabase_config.dart';
import '../models/veo_highlight.dart';
import '../repositories/veo_highlight_repository.dart';

final _veoRepositoryProvider = Provider<VeoHighlightRepository>((ref) {
  return SupabaseVeoHighlightRepository(SupabaseConfig.client);
});

/// Fetch highlights for given match id lazily.
final veoHighlightsProvider =
    FutureProvider.family<List<VeoHighlight>, String>((ref, matchId) async {
  final repo = ref.watch(_veoRepositoryProvider);
  final res = await repo.fetchHighlightsByMatch(matchId);
  return res.when(
    success: (data) => data,
    failure: (err) => throw Exception(err.message),
  );
});

/// Provider to fetch playback URL when requested.
final highlightPlaybackUrlProvider =
    FutureProvider.family<String, String>((ref, highlightId) async {
  final repo = ref.watch(_veoRepositoryProvider);
  final res = await repo.getPlaybackUrl(highlightId);
  return res.when(
    success: (data) => data,
    failure: (err) => throw Exception(err.message),
  );
});
