import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/video_event.dart';
import '../services/video_event_detector_service.dart';

/// Exposes a singleton of [VideoEventDetectorService] so other layers can share
/// one Supabase subscription per match and avoid duplicate connections.
final videoEventDetectorServiceProvider =
    Provider<VideoEventDetectorService>((ref) {
  return VideoEventDetectorService();
});

/// Returns a [Stream] of [VideoEvent]s for the given match ID. Components can
/// `watch` this to rebuild in real-time when new events come in.
final videoEventsStreamProvider =
    StreamProvider.family<VideoEvent, String>((ref, matchId) {
  final service = ref.watch(videoEventDetectorServiceProvider);
  return service.streamEvents(matchId: matchId);
});