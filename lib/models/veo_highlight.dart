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
        id: _parseString(json['id']) ?? '',
        startMs: _parseInt(json['startMs']) ?? 0,
        endMs: _parseInt(json['endMs']) ?? 0,
        title: _parseString(json['title']),
        videoUrl: _parseString(json['videoUrl']),
        storagePath: _parseString(json['storagePath']),
      );

  // Helper methods for JSON parsing
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

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
