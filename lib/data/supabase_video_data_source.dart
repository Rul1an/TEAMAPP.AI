// Dart imports:
import 'dart:io' as io;

// Package imports:
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/video.dart';

/// Low-level access to Supabase Storage + `videos` table.
///
/// Higher layers (repository) should handle error mapping & business logic.
class SupabaseVideoDataSource {
  SupabaseVideoDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;
  static const _table = 'videos';
  static const _bucket = 'videos';

  Future<Video> upload({
    required io.File file,
    required String title,
    String? description,
    VideoType type = VideoType.match,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Cannot upload video without authenticated user');
    }

    // Generate deterministic object key: {uid}/{timestamp}.{ext}
    final ext = p.extension(file.path).replaceFirst('.', '');
    final filename = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final pathInBucket = '$uid/$filename';

    final storage = _supabase.storage.from(_bucket);

    // 1. Upload binary (resumable disabled for now)
    await storage.uploadBinary(
      pathInBucket,
      await file.readAsBytes(),
      fileOptions: FileOptions(contentType: 'video/$ext'),
    );

    // 2. Insert row in `videos` table
    final publicUrl = storage.getPublicUrl(pathInBucket);
    final row = {
      'title': title,
      'description': description,
      'type': type.name,
      'uploaded_by': uid,
      'video_url': publicUrl,
      'file_size': await file.length(),
      'duration': 0, // will be updated later by metadata extractor
      'status': ProcessingStatus.ready.name,
      'visibility': VideoVisibility.org.name,
      'allowed_roles': ['bestuurder', 'hoofdcoach', 'assistent_coach'],
    }..removeWhere((_, v) => v == null);

    final inserted = await _supabase.from(_table).insert(row).select().single();

    return Video.fromJson(inserted);
  }

  Stream<List<Video>> subscribeAll() => _supabase
      .from(_table)
      .stream(primaryKey: ['id'])
      .map((rows) => rows
          .cast<Map<String, dynamic>>()
          .map(Video.fromJson)
          .toList())
      .distinct(_videosChanged);

  Future<Video?> fetchById(String id) async {
    final data = await _supabase.from(_table).select().eq('id', id).maybeSingle();
    return data == null ? null : Video.fromJson(data);
  }

  // helpers
  static SupabaseClient _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }

  static bool _videosChanged(List<Video> a, List<Video> b) {
    if (a.length != b.length) return true;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].status != b[i].status) return true;
    }
    return false;
  }
}