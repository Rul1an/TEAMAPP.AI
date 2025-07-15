// Dart imports:
import 'dart:io' as io;

// Project imports:
import '../core/result.dart';
import '../data/supabase_video_data_source.dart';
import '../models/video.dart';
import 'video_repository.dart';

class SupabaseVideoRepository implements VideoRepository {
  SupabaseVideoRepository({SupabaseVideoDataSource? dataSource})
      : _ds = dataSource ?? SupabaseVideoDataSource();

  final SupabaseVideoDataSource _ds;

  @override
  Future<Result<Video>> upload({
    required io.File file,
    required String title,
    String? description,
    VideoType type = VideoType.match,
  }) async {
    try {
      final video = await _ds.upload(
        file: file,
        title: title,
        description: description,
        type: type,
      );
      return Success(video);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Stream<List<Video>> watchAll() => _ds.subscribeAll();

  @override
  Future<Result<Video>> getById(String id) async {
    try {
      final v = await _ds.fetchById(id);
      if (v == null) {
        return Failure(CacheFailure('Video not found'));
      }
      return Success(v);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}