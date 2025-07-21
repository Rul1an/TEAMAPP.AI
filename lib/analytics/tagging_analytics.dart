import 'package:firebase_analytics/firebase_analytics.dart';
import '../features/video_tagging/models/video_tag.dart';
import '../features/video_playlists/models/video_playlist.dart';

class TaggingAnalytics {
  TaggingAnalytics(this._analytics);
  final FirebaseAnalytics _analytics;

  Future<void> logTagAdded(VideoTag tag) {
    return _analytics.logEvent(name: 'video_tag_added', parameters: {
      'video_id': tag.videoId,
      'tag_type': tag.type.name,
      'timestamp': tag.timestamp,
    });
  }

  Future<void> logPlaylistGenerated(VideoPlaylist playlist) {
    return _analytics.logEvent(name: 'playlist_generated', parameters: {
      'playlist_id': playlist.id,
      'video_count': playlist.videoIds.length,
    });
  }
}
