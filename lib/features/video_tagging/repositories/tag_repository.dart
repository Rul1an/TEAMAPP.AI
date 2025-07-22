import '../models/video_tag.dart';
import '../models/tag_type.dart';

/// Abstract repository for CRUD operations on [VideoTag]s.
abstract class TagRepository {
  /// Create a new tag and return the created object (with server-generated id).
  Future<VideoTag> create(VideoTag tag);

  /// Update an existing tag.
  Future<void> update(VideoTag tag);

  /// Delete a tag by id.
  Future<void> delete(String tagId);

  /// Stream tags for a particular video (realtime updates).
  Stream<List<VideoTag>> watchByVideo(String videoId);

  /// Search tags with optional filters.
  Future<List<VideoTag>> search({
    String? playerId,
    TagType? type,
    String? videoId,
  });
}
