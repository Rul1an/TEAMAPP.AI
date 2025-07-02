import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile.dart';

class ProfileService {
  ProfileService({SupabaseClient? client})
      : _supabase = client ?? _tryGetSupabaseInstance();

  final SupabaseClient _supabase;

  static SupabaseClient _tryGetSupabaseInstance() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }

  /// Returns the profile for the authenticated user or null if not found.
  Future<Profile?> getCurrentProfile() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return null;

    final res = await _supabase
        .from('profiles')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (res == null) return null;
    return Profile.fromJson(res);
  }

  /// Updates profile fields. Pass null to leave unchanged.
  Future<Profile> updateProfile({
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

    final res = await _supabase
        .from('profiles')
        .update(update)
        .eq('user_id', uid)
        .select()
        .single();

    return Profile.fromJson(res);
  }

  /// Realtime stream of profile updates for authenticated user.
  Stream<Profile> subscribeProfile() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      return const Stream.empty();
    }

    // Use the typed Postgrest stream helper instead of RealtimeChannel.stream
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', uid)
        .where((rows) => rows.isNotEmpty)
        .map((rows) => Profile.fromJson(rows.first))
        .distinct((a, b) => a.updatedAt == b.updatedAt);
  }

  /// Uploads an avatar image to the `avatars` storage bucket and updates the
  /// profile with the returned public URL. Returns the updated [Profile].
  ///
  /// The file is stored at path `<userId>/<timestamp>.<ext>` so that users can
  /// update their avatar without filename collisions. Old avatars are not
  /// deleted automatically.
  Future<Profile> uploadAvatar(io.File file) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Cannot upload avatar without authenticated user');
    }

    final ext = path.extension(file.path).replaceFirst('.', '');
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final storagePath = '$uid/$fileName';

    final storage = _supabase.storage.from('avatars');
    try {
      await storage.uploadBinary(
        storagePath,
        await file.readAsBytes(),
        fileOptions: FileOptions(contentType: 'image/$ext'),
      );
    } on StorageException catch (e) {
      throw Exception('Avatar upload failed: ${e.message}');
    }

    final publicUrl = storage.getPublicUrl(storagePath);

    // Update profile record with new avatar URL
    final updated = await updateProfile(avatarUrl: publicUrl);
    return updated;
  }
}
