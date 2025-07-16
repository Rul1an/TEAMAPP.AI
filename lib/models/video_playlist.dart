import 'video_clip.dart';

enum TacticalPattern { highPress, counterAttack }

extension TacticalPatternName on TacticalPattern {
  String get dbName => switch (this) {
        TacticalPattern.highPress => 'high_press',
        TacticalPattern.counterAttack => 'counter_attack',
      };

  String get displayName => switch (this) {
        TacticalPattern.highPress => 'High Press',
        TacticalPattern.counterAttack => 'Counter-Attack',
      };
}

class VideoPlaylist {
  const VideoPlaylist({
    required this.id,
    required this.pattern,
    required this.clips,
  });

  final String id;
  final TacticalPattern pattern;
  final List<VideoClip> clips;

  int get durationMs => clips.fold(0, (sum, c) => sum + (c.endMs - c.startMs));

  // --------------------- JSON ----------------------- //
  factory VideoPlaylist.fromJson(Map<String, dynamic> json) => VideoPlaylist(
        id: json['id'] as String,
        pattern: TacticalPattern.values.firstWhere(
          (p) => p.dbName == json['pattern'],
          orElse: () => TacticalPattern.highPress,
        ),
        clips: (json['clips'] as List<dynamic>)
            .map((e) => VideoClip.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pattern': pattern.dbName,
        'clips': clips.map((c) => c.toJson()).toList(),
      };
}