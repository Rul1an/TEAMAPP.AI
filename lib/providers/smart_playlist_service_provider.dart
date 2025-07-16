import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_playlist.dart';
import '../services/smart_playlist_service.dart';

final smartPlaylistServiceProvider = Provider<SmartPlaylistService>((ref) {
  return const SmartPlaylistService();
});

final smartPlaylistProvider = FutureProvider.family
    .autoDispose<VideoPlaylist, (String matchId, TacticalPattern pattern)>(
  (ref, tuple) async {
    final (matchId, pattern) = tuple;
    final service = ref.read(smartPlaylistServiceProvider);
    return service.generatePlaylist(matchId: matchId, pattern: pattern);
  },
);