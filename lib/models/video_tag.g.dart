// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoTagImpl _$$VideoTagImplFromJson(Map<String, dynamic> json) =>
    _$VideoTagImpl(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      organizationId: json['organizationId'] as String,
      tagType: $enumDecode(_$VideoTagTypeEnumMap, json['tagType']),
      timestampSeconds: (json['timestampSeconds'] as num).toDouble(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      tagData: json['tagData'] as Map<String, dynamic>,
      createdBy: json['createdBy'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VideoTagImplToJson(_$VideoTagImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'videoId': instance.videoId,
      'organizationId': instance.organizationId,
      'tagType': _$VideoTagTypeEnumMap[instance.tagType]!,
      'timestampSeconds': instance.timestampSeconds,
      'title': instance.title,
      'description': instance.description,
      'tagData': instance.tagData,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$VideoTagTypeEnumMap = {
  VideoTagType.drill: 'drill',
  VideoTagType.moment: 'moment',
  VideoTagType.player: 'player',
  VideoTagType.tactic: 'tactic',
  VideoTagType.mistake: 'mistake',
  VideoTagType.skill: 'skill',
};

_$CreateVideoTagRequestImpl _$$CreateVideoTagRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateVideoTagRequestImpl(
      videoId: json['videoId'] as String,
      organizationId: json['organizationId'] as String,
      tagType: $enumDecode(_$VideoTagTypeEnumMap, json['tagType']),
      timestampSeconds: (json['timestampSeconds'] as num).toDouble(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      tagData: json['tagData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$CreateVideoTagRequestImplToJson(
        _$CreateVideoTagRequestImpl instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'organizationId': instance.organizationId,
      'tagType': _$VideoTagTypeEnumMap[instance.tagType]!,
      'timestampSeconds': instance.timestampSeconds,
      'title': instance.title,
      'description': instance.description,
      'tagData': instance.tagData,
    };

_$UpdateVideoTagRequestImpl _$$UpdateVideoTagRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateVideoTagRequestImpl(
      tagId: json['tagId'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      tagData: json['tagData'] as Map<String, dynamic>?,
      timestampSeconds: (json['timestampSeconds'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UpdateVideoTagRequestImplToJson(
        _$UpdateVideoTagRequestImpl instance) =>
    <String, dynamic>{
      'tagId': instance.tagId,
      'title': instance.title,
      'description': instance.description,
      'tagData': instance.tagData,
      'timestampSeconds': instance.timestampSeconds,
    };

_$VideoTagFilterImpl _$$VideoTagFilterImplFromJson(Map<String, dynamic> json) =>
    _$VideoTagFilterImpl(
      videoId: json['videoId'] as String?,
      organizationId: json['organizationId'] as String?,
      tagTypes: (json['tagTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$VideoTagTypeEnumMap, e))
          .toList(),
      createdBy: json['createdBy'] as String?,
      createdAfter: json['createdAfter'] == null
          ? null
          : DateTime.parse(json['createdAfter'] as String),
      createdBefore: json['createdBefore'] == null
          ? null
          : DateTime.parse(json['createdBefore'] as String),
      timestampStart: (json['timestampStart'] as num?)?.toDouble(),
      timestampEnd: (json['timestampEnd'] as num?)?.toDouble(),
      searchQuery: json['searchQuery'] as String?,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$VideoTagFilterImplToJson(
        _$VideoTagFilterImpl instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'organizationId': instance.organizationId,
      'tagTypes':
          instance.tagTypes?.map((e) => _$VideoTagTypeEnumMap[e]!).toList(),
      'createdBy': instance.createdBy,
      'createdAfter': instance.createdAfter?.toIso8601String(),
      'createdBefore': instance.createdBefore?.toIso8601String(),
      'timestampStart': instance.timestampStart,
      'timestampEnd': instance.timestampEnd,
      'searchQuery': instance.searchQuery,
      'limit': instance.limit,
      'offset': instance.offset,
    };

_$VideoTagAnalyticsImpl _$$VideoTagAnalyticsImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoTagAnalyticsImpl(
      totalTags: (json['totalTags'] as num).toInt(),
      tagsByType: (json['tagsByType'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry($enumDecode(_$VideoTagTypeEnumMap, k), (e as num).toInt()),
      ),
      tagsByCreator: Map<String, int>.from(json['tagsByCreator'] as Map),
      averageTagsPerMinute: (json['averageTagsPerMinute'] as num).toDouble(),
      hotspots: (json['hotspots'] as List<dynamic>)
          .map((e) => VideoTagHotspot.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$VideoTagAnalyticsImplToJson(
        _$VideoTagAnalyticsImpl instance) =>
    <String, dynamic>{
      'totalTags': instance.totalTags,
      'tagsByType': instance.tagsByType
          .map((k, e) => MapEntry(_$VideoTagTypeEnumMap[k]!, e)),
      'tagsByCreator': instance.tagsByCreator,
      'averageTagsPerMinute': instance.averageTagsPerMinute,
      'hotspots': instance.hotspots,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };

_$VideoTagHotspotImpl _$$VideoTagHotspotImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoTagHotspotImpl(
      startSeconds: (json['startSeconds'] as num).toDouble(),
      endSeconds: (json['endSeconds'] as num).toDouble(),
      tagCount: (json['tagCount'] as num).toInt(),
      dominantTagTypes: (json['dominantTagTypes'] as List<dynamic>)
          .map((e) => $enumDecode(_$VideoTagTypeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$VideoTagHotspotImplToJson(
        _$VideoTagHotspotImpl instance) =>
    <String, dynamic>{
      'startSeconds': instance.startSeconds,
      'endSeconds': instance.endSeconds,
      'tagCount': instance.tagCount,
      'dominantTagTypes': instance.dominantTagTypes
          .map((e) => _$VideoTagTypeEnumMap[e]!)
          .toList(),
    };
