// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoImpl _$$VideoImplFromJson(Map<String, dynamic> json) => _$VideoImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      playerId: json['playerId'] as String?,
      fileUrl: json['fileUrl'] as String,
      videoUrl: json['videoUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      resolutionWidth: (json['resolutionWidth'] as num).toInt(),
      resolutionHeight: (json['resolutionHeight'] as num).toInt(),
      encodingFormat: json['encodingFormat'] as String? ?? 'mp4',
      processingStatus: $enumDecodeNullable(
              _$VideoProcessingStatusEnumMap, json['processingStatus']) ??
          VideoProcessingStatus.pending,
      processingError: json['processingError'] as String?,
      videoMetadata: json['videoMetadata'] as Map<String, dynamic>? ?? const {},
      tagData: json['tagData'] as Map<String, dynamic>? ?? const {},
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      timeCodes: (json['timeCodes'] as List<dynamic>?)
              ?.map((e) => VideoTimeCode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => VideoCoordinate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble() ?? 0.0,
      aiProcessed: json['aiProcessed'] as bool? ?? false,
      aiProcessedAt: json['aiProcessedAt'] == null
          ? null
          : DateTime.parse(json['aiProcessedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$VideoImplToJson(_$VideoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'title': instance.title,
      'description': instance.description,
      'playerId': instance.playerId,
      'fileUrl': instance.fileUrl,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'durationSeconds': instance.durationSeconds,
      'fileSizeBytes': instance.fileSizeBytes,
      'resolutionWidth': instance.resolutionWidth,
      'resolutionHeight': instance.resolutionHeight,
      'encodingFormat': instance.encodingFormat,
      'processingStatus':
          _$VideoProcessingStatusEnumMap[instance.processingStatus]!,
      'processingError': instance.processingError,
      'videoMetadata': instance.videoMetadata,
      'tagData': instance.tagData,
      'tags': instance.tags,
      'timeCodes': instance.timeCodes,
      'coordinates': instance.coordinates,
      'aiConfidence': instance.aiConfidence,
      'aiProcessed': instance.aiProcessed,
      'aiProcessedAt': instance.aiProcessedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$VideoProcessingStatusEnumMap = {
  VideoProcessingStatus.pending: 'pending',
  VideoProcessingStatus.processing: 'processing',
  VideoProcessingStatus.ready: 'ready',
  VideoProcessingStatus.error: 'error',
  VideoProcessingStatus.archived: 'archived',
};

_$VideoTimeCodeImpl _$$VideoTimeCodeImplFromJson(Map<String, dynamic> json) =>
    _$VideoTimeCodeImpl(
      startSeconds: (json['startSeconds'] as num).toDouble(),
      endSeconds: (json['endSeconds'] as num).toDouble(),
      tag: json['tag'] as String,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$VideoTimeCodeImplToJson(_$VideoTimeCodeImpl instance) =>
    <String, dynamic>{
      'startSeconds': instance.startSeconds,
      'endSeconds': instance.endSeconds,
      'tag': instance.tag,
      'description': instance.description,
      'metadata': instance.metadata,
    };

_$VideoCoordinateImpl _$$VideoCoordinateImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoCoordinateImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      timeSeconds: (json['timeSeconds'] as num).toDouble(),
      playerId: json['playerId'] as String?,
      action: json['action'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$VideoCoordinateImplToJson(
        _$VideoCoordinateImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'timeSeconds': instance.timeSeconds,
      'playerId': instance.playerId,
      'action': instance.action,
      'metadata': instance.metadata,
    };

_$VideoAnalyticsImpl _$$VideoAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$VideoAnalyticsImpl(
      organizationId: json['organizationId'] as String,
      totalVideos: (json['totalVideos'] as num).toInt(),
      readyVideos: (json['readyVideos'] as num).toInt(),
      processingVideos: (json['processingVideos'] as num).toInt(),
      errorVideos: (json['errorVideos'] as num).toInt(),
      totalStorageBytes: (json['totalStorageBytes'] as num).toInt(),
      totalDurationSeconds: (json['totalDurationSeconds'] as num).toInt(),
      avgDurationSeconds: (json['avgDurationSeconds'] as num).toDouble(),
      videosLast30Days: (json['videosLast30Days'] as num).toInt(),
      videosLast7Days: (json['videosLast7Days'] as num).toInt(),
    );

Map<String, dynamic> _$$VideoAnalyticsImplToJson(
        _$VideoAnalyticsImpl instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'totalVideos': instance.totalVideos,
      'readyVideos': instance.readyVideos,
      'processingVideos': instance.processingVideos,
      'errorVideos': instance.errorVideos,
      'totalStorageBytes': instance.totalStorageBytes,
      'totalDurationSeconds': instance.totalDurationSeconds,
      'avgDurationSeconds': instance.avgDurationSeconds,
      'videosLast30Days': instance.videosLast30Days,
      'videosLast7Days': instance.videosLast7Days,
    };

_$VideoUploadProgressImpl _$$VideoUploadProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoUploadProgressImpl(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      status: $enumDecode(_$VideoUploadStatusEnumMap, json['status']),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      errorMessage: json['errorMessage'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      uploadedBytes: (json['uploadedBytes'] as num?)?.toInt(),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$VideoUploadProgressImplToJson(
        _$VideoUploadProgressImpl instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'title': instance.title,
      'status': _$VideoUploadStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'errorMessage': instance.errorMessage,
      'fileSizeBytes': instance.fileSizeBytes,
      'uploadedBytes': instance.uploadedBytes,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$VideoUploadStatusEnumMap = {
  VideoUploadStatus.preparing: 'preparing',
  VideoUploadStatus.compressing: 'compressing',
  VideoUploadStatus.uploading: 'uploading',
  VideoUploadStatus.processing: 'processing',
  VideoUploadStatus.completed: 'completed',
  VideoUploadStatus.failed: 'failed',
  VideoUploadStatus.cancelled: 'cancelled',
};

_$VideoSearchFiltersImpl _$$VideoSearchFiltersImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoSearchFiltersImpl(
      searchQuery: json['searchQuery'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status:
          $enumDecodeNullable(_$VideoProcessingStatusEnumMap, json['status']),
      playerId: json['playerId'] as String?,
      createdAfter: json['createdAfter'] == null
          ? null
          : DateTime.parse(json['createdAfter'] as String),
      createdBefore: json['createdBefore'] == null
          ? null
          : DateTime.parse(json['createdBefore'] as String),
      minDurationSeconds: (json['minDurationSeconds'] as num?)?.toInt(),
      maxDurationSeconds: (json['maxDurationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$VideoSearchFiltersImplToJson(
        _$VideoSearchFiltersImpl instance) =>
    <String, dynamic>{
      'searchQuery': instance.searchQuery,
      'tags': instance.tags,
      'status': _$VideoProcessingStatusEnumMap[instance.status],
      'playerId': instance.playerId,
      'createdAfter': instance.createdAfter?.toIso8601String(),
      'createdBefore': instance.createdBefore?.toIso8601String(),
      'minDurationSeconds': instance.minDurationSeconds,
      'maxDurationSeconds': instance.maxDurationSeconds,
    };
