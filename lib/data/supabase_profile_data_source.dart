// Dart imports:
import 'dart:io' as io;

// Package imports:
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../core/result.dart';
import '../models/profile.dart';

/// Data-source responsible for raw Supabase I/O for the `profiles` table.
///
/// Higher-level layers (repository, providers) should map exceptions to
/// domain-specific failures and wrap results into [Result].
class SupabaseProfileDataSource {
  SupabaseProfileDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;

  static SupabaseClient _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      // Allows unit tests to pass without initializing SupabaseFlutter.
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }

  /// Fetches the current authenticated user's profile or `null` if missing /
  /// unauthenticated.
  Future<Profile?> fetchCurrent() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return null;

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (data == null) return null;
    return Profile.fromJson(data);
  }

  /// Partial update of current user's profile.
  Future<Profile> update({
    String? username,
    String? avatarUrl,
    String? website,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Cannot update profile without authenticated user');
    }

    final update = <String, dynamic>{
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (website != null) 'website': website,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final data = await _supabase
        .from('profiles')
        .update(update)
        .eq('user_id', uid)
        .select()
        .single();

    return Profile.fromJson(data);
  }

  /// Realtime stream of the profile row.
  Stream<Profile> subscribe() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return const Stream.empty();

    return _supabase
        .from('profiles')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', uid)
        .where((rows) => rows.isNotEmpty)
        .map((rows) => Profile.fromJson(rows.first))
        .distinct((a, b) => a.updatedAt == b.updatedAt);
  }

  /// Uploads an avatar image to storage bucket and updates the profile with the
  /// public URL.
  Future<Profile> uploadAvatar(io.File file) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Cannot upload avatar without authenticated user');
    }

    final ext = p.extension(file.path).replaceFirst('.', '');
    final filename = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final pathInBucket = '$uid/$filename';

    final storage = _supabase.storage.from('avatars');
    try {
      await storage.uploadBinary(
        pathInBucket,
        await file.readAsBytes(),
        fileOptions: FileOptions(contentType: 'image/$ext'),
      );
    } on StorageException catch (e) {
      throw Exception('Avatar upload failed: ${e.message}');
    }

    final publicUrl = storage.getPublicUrl(pathInBucket);
    return update(avatarUrl: publicUrl);
  }
}
