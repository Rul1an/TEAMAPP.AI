class VeoHighlight {
  VeoHighlight({
    required this.id,
    this.title,
    required this.startMs,
    required this.endMs,
    this.videoUrl,
    this.storagePath,
  });

  final String id;
  final String? title;
  final int startMs;
  final int endMs;
  final String? videoUrl;
  final String? storagePath;

  factory VeoHighlight.fromJson(Map<String, dynamic> json) {
    return VeoHighlight(
      id: json['id'] as String,
      title: json['title'] as String?,
      startMs: json['startMs'] as int? ?? json['start'] as int? ?? 0,
      endMs: json['endMs'] as int? ?? json['end'] as int? ?? 0,
      videoUrl: json['videoUrl'] as String?,
      storagePath: json['storagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'startMs': startMs,
        'endMs': endMs,
        'videoUrl': videoUrl,
        'storagePath': storagePath,
      };
}