import '../models/video_tag.dart';
import '../models/tag_type.dart';

abstract class TagRepository {
  Future<VideoTag> create(VideoTag tag);
  Future<void> update(VideoTag tag);
  Future<void> delete(String tagId);
  Stream<List<VideoTag>> watchByVideo(String videoId);
  Future<List<VideoTag>> search({String? playerId, TagType? type, String? videoId});
}