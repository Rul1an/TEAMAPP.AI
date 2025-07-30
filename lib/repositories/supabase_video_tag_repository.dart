// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../core/result.dart';
import '../models/video_tag.dart';
import 'video_tag_repository.dart';

/// Supabase implementation of VideoTagRepository
class SupabaseVideoTagRepository implements VideoTagRepository {
  final SupabaseClient _supabase;

  SupabaseVideoTagRepository(this._supabase);

  @override
  Future<Result<List<VideoTag>>> getTagsForVideo(String videoId) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('video_id', videoId)
          .order('timestamp_seconds');

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to get video tags: $e'));
    }
  }

  @override
  Future<Result<List<VideoTag>>> getTags(VideoTagFilter filter) async {
    try {
      var query = _supabase.from('video_tags').select('*');

      // Apply filters
      if (filter.videoId != null) {
        query = query.eq('video_id', filter.videoId!);
      }

      if (filter.organizationId != null) {
        query = query.eq('organization_id', filter.organizationId!);
      }

      if (filter.tagTypes != null && filter.tagTypes!.isNotEmpty) {
        final tagTypeValues =
            filter.tagTypes!.map((type) => type.name).toList();
        query = query.inFilter('tag_type', tagTypeValues);
      }

      if (filter.createdBy != null) {
        query = query.eq('created_by', filter.createdBy!);
      }

      if (filter.createdAfter != null) {
        query = query.gte('created_at', filter.createdAfter!.toIso8601String());
      }

      if (filter.createdBefore != null) {
        query =
            query.lte('created_at', filter.createdBefore!.toIso8601String());
      }

      if (filter.timestampStart != null) {
        query = query.gte('timestamp_seconds', filter.timestampStart!);
      }

      if (filter.timestampEnd != null) {
        query = query.lte('timestamp_seconds', filter.timestampEnd!);
      }

      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        query = query.or('title.ilike.%${filter.searchQuery}%,'
            'description.ilike.%${filter.searchQuery}%');
      }

      // Apply pagination and execute query
      final response = await query
          .range(filter.offset, filter.offset + filter.limit - 1)
          .order('created_at', ascending: false);

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to get tags: $e'));
    }
  }

  @override
  Future<Result<VideoTag>> createTag(CreateVideoTagRequest request) async {
    try {
      final tagData = {
        'video_id': request.videoId,
        'organization_id': request.organizationId,
        'tag_type': request.tagType.name,
        'timestamp_seconds': request.timestampSeconds,
        'title': request.title,
        'description': request.description,
        'tag_data': request.tagData,
        'created_by': _supabase.auth.currentUser?.id,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response =
          await _supabase.from('video_tags').insert(tagData).select().single();

      final tag = VideoTag.fromJson(response);
      return Result.success(tag);
    } catch (e) {
      return Result.failure(Exception('Failed to create tag: $e'));
    }
  }

  @override
  Future<Result<VideoTag>> updateTag(UpdateVideoTagRequest request) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (request.title != null) {
        updateData['title'] = request.title;
      }

      if (request.description != null) {
        updateData['description'] = request.description;
      }

      if (request.tagData != null) {
        updateData['tag_data'] = request.tagData;
      }

      if (request.timestampSeconds != null) {
        updateData['timestamp_seconds'] = request.timestampSeconds;
      }

      final response = await _supabase
          .from('video_tags')
          .update(updateData)
          .eq('id', request.tagId)
          .select()
          .single();

      final tag = VideoTag.fromJson(response);
      return Result.success(tag);
    } catch (e) {
      return Result.failure(Exception('Failed to update tag: $e'));
    }
  }

  @override
  Future<Result<void>> deleteTag(String tagId) async {
    try {
      await _supabase.from('video_tags').delete().eq('id', tagId);

      return Result.success(null);
    } catch (e) {
      return Result.failure(Exception('Failed to delete tag: $e'));
    }
  }

  @override
  Future<Result<VideoTagAnalytics>> getTagAnalytics(String videoId) async {
    try {
      // Get all tags for the video
      final tagsResult = await getTagsForVideo(videoId);
      if (tagsResult.isFailure) {
        return Result.failure(Exception('Failed to get tags for analytics'));
      }

      final tags = tagsResult.value;

      // Calculate analytics
      final tagsByType = <VideoTagType, int>{};
      final tagsByCreator = <String, int>{};

      for (final tag in tags) {
        // Count by type
        tagsByType[tag.tagType] = (tagsByType[tag.tagType] ?? 0) + 1;

        // Count by creator
        final creator = tag.createdBy ?? 'Unknown';
        tagsByCreator[creator] = (tagsByCreator[creator] ?? 0) + 1;
      }

      // Get video duration for average calculation
      final videoDuration = await _getVideoDuration(videoId);
      final averageTagsPerMinute =
          videoDuration > 0 ? (tags.length / (videoDuration / 60.0)) : 0.0;

      // Generate hotspots
      final hotspots = _generateHotspots(tags, videoDuration);

      final analytics = VideoTagAnalytics(
        totalTags: tags.length,
        tagsByType: tagsByType,
        tagsByCreator: tagsByCreator,
        averageTagsPerMinute: averageTagsPerMinute,
        hotspots: hotspots,
        generatedAt: DateTime.now(),
      );

      return Result.success(analytics);
    } catch (e) {
      return Result.failure(Exception('Failed to get tag analytics: $e'));
    }
  }

  @override
  Future<Result<List<VideoTag>>> searchTags({
    required String organizationId,
    required String searchQuery,
    List<VideoTagType>? tagTypes,
    int limit = 50,
  }) async {
    try {
      var query = _supabase
          .from('video_tags')
          .select('*')
          .eq('organization_id', organizationId);

      // Search in title and description
      if (searchQuery.isNotEmpty) {
        query = query.or('title.ilike.%$searchQuery%,'
            'description.ilike.%$searchQuery%');
      }

      // Filter by tag types
      if (tagTypes != null && tagTypes.isNotEmpty) {
        final typeNames = tagTypes.map((type) => type.name).toList();
        query = query.inFilter('tag_type', typeNames);
      }

      final response =
          await query.order('created_at', ascending: false).limit(limit);

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to search tags: $e'));
    }
  }

  @override
  Future<Result<List<VideoTag>>> getRecentTags({
    required String organizationId,
    String? createdBy,
    int limit = 20,
  }) async {
    try {
      var query = _supabase
          .from('video_tags')
          .select('*')
          .eq('organization_id', organizationId);

      if (createdBy != null) {
        query = query.eq('created_by', createdBy);
      }

      final response =
          await query.order('created_at', ascending: false).limit(limit);

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to get recent tags: $e'));
    }
  }

  @override
  Future<Result<List<VideoTag>>> createBulkTags(
    List<CreateVideoTagRequest> requests,
  ) async {
    try {
      final tagDataList = requests
          .map((request) => {
                'video_id': request.videoId,
                'organization_id': request.organizationId,
                'tag_type': request.tagType.name,
                'timestamp_seconds': request.timestampSeconds,
                'title': request.title,
                'description': request.description,
                'tag_data': request.tagData,
                'created_by': _supabase.auth.currentUser?.id,
                'created_at': DateTime.now().toIso8601String(),
              })
          .toList();

      final response =
          await _supabase.from('video_tags').insert(tagDataList).select();

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to create bulk tags: $e'));
    }
  }

  @override
  Future<Result<List<VideoTagHotspot>>> getTagHotspots({
    required String videoId,
    int segmentCount = 20,
  }) async {
    try {
      final tagsResult = await getTagsForVideo(videoId);
      if (tagsResult.isFailure) {
        return Result.failure(Exception('Failed to get tags for hotspots'));
      }

      final tags = tagsResult.value;
      final videoDuration = await _getVideoDuration(videoId);

      if (videoDuration <= 0) {
        return Result.success([]);
      }

      final hotspots = _generateHotspots(tags, videoDuration, segmentCount);
      return Result.success(hotspots);
    } catch (e) {
      return Result.failure(Exception('Failed to get tag hotspots: $e'));
    }
  }

  @override
  Future<Result<List<VideoTag>>> getTagsInTimeRange({
    required String videoId,
    required double startSeconds,
    required double endSeconds,
  }) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('video_id', videoId)
          .gte('timestamp_seconds', startSeconds)
          .lte('timestamp_seconds', endSeconds)
          .order('timestamp_seconds');

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to get tags in time range: $e'));
    }
  }

  /// Get video duration from the videos table
  Future<double> _getVideoDuration(String videoId) async {
    try {
      final response = await _supabase
          .from('videos')
          .select('duration_seconds')
          .eq('id', videoId)
          .single();

      return (response['duration_seconds'] as num?)?.toDouble() ?? 0.0;
    } catch (e) {
      return 0.0; // Return 0 if video not found or error
    }
  }

  // COMPATIBILITY METHODS FOR TESTS
  // These methods provide compatibility with test expectations

  /// Compatibility method for tests - creates a video tag
  Future<Result<VideoTag>> createVideoTag(CreateVideoTagRequest request) async {
    return createTag(request);
  }

  /// Compatibility method for tests - gets a single video tag by ID
  Future<Result<VideoTag>> getVideoTag(String tagId) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('id', tagId)
          .single();

      final tag = VideoTag.fromJson(response);
      return Result.success(tag);
    } catch (e) {
      return Result.failure(Exception('Failed to get video tag: $e'));
    }
  }

  /// Compatibility method for tests - updates a video tag
  Future<Result<VideoTag>> updateVideoTag(UpdateVideoTagRequest request) async {
    return updateTag(request);
  }

  /// Compatibility method for tests - deletes a video tag
  Future<Result<void>> deleteVideoTag(String tagId) async {
    return deleteTag(tagId);
  }

  /// Compatibility method for tests - gets tags for a video
  Future<Result<List<VideoTag>>> getVideoTagsForVideo(String videoId) async {
    return getTagsForVideo(videoId);
  }

  /// Compatibility method for tests - gets tags by type
  Future<Result<List<VideoTag>>> getVideoTagsByType(
    String videoId,
    VideoTagType tagType,
  ) async {
    try {
      final response = await _supabase
          .from('video_tags')
          .select('*')
          .eq('video_id', videoId)
          .eq('tag_type', tagType.name)
          .order('timestamp_seconds');

      final tags = (response as List)
          .map((json) => VideoTag.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(tags);
    } catch (e) {
      return Result.failure(Exception('Failed to get tags by type: $e'));
    }
  }

  /// Compatibility method for tests - gets tags in range
  Future<Result<List<VideoTag>>> getVideoTagsInRange(
    String videoId,
    double startSeconds,
    double endSeconds,
  ) async {
    return getTagsInTimeRange(
      videoId: videoId,
      startSeconds: startSeconds,
      endSeconds: endSeconds,
    );
  }

  /// Generate hotspots from tags
  List<VideoTagHotspot> _generateHotspots(
    List<VideoTag> tags,
    double videoDuration, [
    int segmentCount = 20,
  ]) {
    if (tags.isEmpty || videoDuration <= 0) {
      return [];
    }

    final segmentDuration = videoDuration / segmentCount;
    final segments = <int, List<VideoTag>>{};

    // Group tags by segments
    for (final tag in tags) {
      final segmentIndex = (tag.timestampSeconds / segmentDuration).floor();
      final clampedIndex = segmentIndex.clamp(0, segmentCount - 1);

      segments[clampedIndex] ??= [];
      segments[clampedIndex]!.add(tag);
    }

    // Create hotspots for segments with multiple tags
    final hotspots = <VideoTagHotspot>[];

    for (final entry in segments.entries) {
      final segmentIndex = entry.key;
      final segmentTags = entry.value;

      if (segmentTags.length >= 2) {
        // Minimum 2 tags for a hotspot
        final startSeconds = segmentIndex * segmentDuration;
        final endSeconds = (segmentIndex + 1) * segmentDuration;

        // Find dominant tag types
        final typeCount = <VideoTagType, int>{};
        for (final tag in segmentTags) {
          typeCount[tag.tagType] = (typeCount[tag.tagType] ?? 0) + 1;
        }

        final dominantTypes = typeCount.entries
            .where((entry) => entry.value >= 1)
            .map((entry) => entry.key)
            .toList();

        hotspots.add(VideoTagHotspot(
          startSeconds: startSeconds,
          endSeconds: endSeconds.clamp(0, videoDuration),
          tagCount: segmentTags.length,
          dominantTagTypes: dominantTypes,
        ));
      }
    }

    // Sort hotspots by timestamp
    hotspots.sort((a, b) => a.startSeconds.compareTo(b.startSeconds));

    return hotspots;
  }
}
