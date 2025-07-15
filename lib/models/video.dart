enum VideoType { match, training, highlight, tutorial }

enum ProcessingStatus { uploading, ready, failed, transcoding }

enum VideoVisibility { private, org, publicHighlight }

/// Represents an uploaded video (match footage, training demo, etc.).
///
/// Mirrors the `videos` table in Supabase (see docs/specs/video_module_spec.md).
class Video {
  const Video({
    required this.id,
    required this.orgId,
    required this.title,
    this.description,
    required this.type,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.fileSize,
    required this.duration,
    required this.status,
    this.metadata,
    this.matchId,
    this.trainingId,
    this.visibility,
    this.allowedRoles,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json['id'] as String,
        orgId: json['org_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        type: _videoTypeFromString(json['type'] as String?),
        uploadedBy: json['uploaded_by'] as String,
        uploadedAt: DateTime.parse(json['uploaded_at'] as String),
        videoUrl: json['video_url'] as String,
        thumbnailUrl: json['thumbnail_url'] as String?,
        fileSize: json['file_size'] as int,
        duration: json['duration'] as int,
        status: _statusFromString(json['status'] as String?),
        metadata: json['metadata'] as Map<String, dynamic>?,
        matchId: json['match_id'] as String?,
        trainingId: json['training_id'] as String?,
        visibility: _videoVisibilityFromString(json['visibility'] as String?),
        allowedRoles: json['allowed_roles'] as List<String>?,
      );

  final String id;
  final String orgId;
  final String title;
  final String? description;
  final VideoType type;
  final String uploadedBy;
  final DateTime uploadedAt;

  // Storage
  final String videoUrl;
  final String? thumbnailUrl;
  final int fileSize; // bytes
  final int duration; // seconds

  // Processing
  final ProcessingStatus status;
  final Map<String, dynamic>? metadata;

  // Relations (nullable)
  final String? matchId;
  final String? trainingId;

  final VideoVisibility? visibility;
  final List<String>? allowedRoles;

  Map<String, dynamic> toJson() => {
        'id': id,
        'org_id': orgId,
        'title': title,
        'description': description,
        'type': type.name,
        'uploaded_by': uploadedBy,
        'uploaded_at': uploadedAt.toIso8601String(),
        'video_url': videoUrl,
        'thumbnail_url': thumbnailUrl,
        'file_size': fileSize,
        'duration': duration,
        'status': status.name,
        'metadata': metadata,
        'match_id': matchId,
        'training_id': trainingId,
        'visibility': visibility?.name,
        'allowed_roles': allowedRoles,
      };

  Video copyWith({
    String? id,
    String? orgId,
    String? title,
    String? description,
    VideoType? type,
    String? uploadedBy,
    DateTime? uploadedAt,
    String? videoUrl,
    String? thumbnailUrl,
    int? fileSize,
    int? duration,
    ProcessingStatus? status,
    Map<String, dynamic>? metadata,
    String? matchId,
    String? trainingId,
    VideoVisibility? visibility,
    List<String>? allowedRoles,
  }) =>
      Video(
        id: id ?? this.id,
        orgId: orgId ?? this.orgId,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        uploadedBy: uploadedBy ?? this.uploadedBy,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        videoUrl: videoUrl ?? this.videoUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        fileSize: fileSize ?? this.fileSize,
        duration: duration ?? this.duration,
        status: status ?? this.status,
        metadata: metadata ?? this.metadata,
        matchId: matchId ?? this.matchId,
        trainingId: trainingId ?? this.trainingId,
        visibility: visibility ?? this.visibility,
        allowedRoles: allowedRoles ?? this.allowedRoles,
      );

  static VideoType _videoTypeFromString(String? value) {
    return VideoType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => VideoType.match,
    );
  }

  static ProcessingStatus _statusFromString(String? value) {
    return ProcessingStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProcessingStatus.ready,
    );
  }

  static VideoVisibility _videoVisibilityFromString(String? value) {
    return VideoVisibility.values.firstWhere(
      (e) => e.name == value,
      orElse: () => VideoVisibility.private,
    );
  }
}