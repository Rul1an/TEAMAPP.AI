/// Represents a segment in the match video.
class VideoClip {
  const VideoClip({
    required this.id,
    required this.startMs,
    required this.endMs,
  });

  final String id;
  final int startMs;
  final int endMs;

  factory VideoClip.fromJson(Map<String, dynamic> json) => VideoClip(
        id: json['id'] as String,
        startMs: json['start_ms'] as int,
        endMs: json['end_ms'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'start_ms': startMs,
        'end_ms': endMs,
      };
}