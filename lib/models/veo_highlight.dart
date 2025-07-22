class VeoHighlight {
  const VeoHighlight({
    required this.id,
    required this.startMs,
    required this.endMs,
    this.title,
    this.videoUrl,
    this.storagePath,
  });

  factory VeoHighlight.fromJson(Map<String, dynamic> json) => VeoHighlight(
        id: json['id'] as String,
        startMs: json['startMs'] as int? ?? 0,
        endMs: json['endMs'] as int? ?? 0,
        title: json['title'] as String?,
        videoUrl: json['videoUrl'] as String?,
        storagePath: json['storagePath'] as String?,
      );

  final String id;
  final int startMs;
  final int endMs;
  final String? title;
  final String? videoUrl;
  final String? storagePath;

  Map<String, dynamic> toJson() => {
        'id': id,
        'startMs': startMs,
        'endMs': endMs,
        'title': title,
        'videoUrl': videoUrl,
        'storagePath': storagePath,
      };
}
