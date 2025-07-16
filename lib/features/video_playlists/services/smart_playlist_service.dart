import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import '../../video_tagging/models/tag_type.dart';
import '../../video_tagging/models/video_tag.dart';
import '../models/video_playlist.dart';

class SmartPlaylistService {
  /// Generate player highlight playlist – one playlist per player ID
  List<VideoPlaylist> generatePlayerPlaylists(List<VideoTag> tags) {
    final byPlayer = groupBy(tags.where((t) => t.playerId != null), (VideoTag t) => t.playerId!);
    return byPlayer.entries.map((e) {
      final vids = e.value.map((t) => t.videoId).toSet().toList();
      return VideoPlaylist(
        id: const Uuid().v4(),
        name: 'Highlights – Player ${e.key}',
        videoIds: vids,
        description: 'Auto-generated highs for player ${e.key}',
      );
    }).toList();
  }

  /// Generate match highlights playlist based on goal/assist/save tags
  VideoPlaylist generateMatchHighlights(List<VideoTag> tags, String matchId) {
    final highlightTags = tags.where((t) => {
          TagType.goal,
          TagType.assist,
          TagType.save,
        }.contains(t.type));
    final vids = highlightTags.map((t) => t.videoId).toSet().toList();
    return VideoPlaylist(
      id: const Uuid().v4(),
      name: 'Match $matchId Highlights',
      videoIds: vids,
    );
  }
}