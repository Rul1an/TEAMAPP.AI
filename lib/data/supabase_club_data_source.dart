// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/club/club.dart';

/// Raw Supabase I/O for the `clubs` table.
class SupabaseClubDataSource {
  SupabaseClubDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;
  static const _table = 'clubs';

  Future<Club?> fetchById(String id) async {
    final data =
        await _supabase.from(_table).select().eq('id', id).maybeSingle();
    return data == null ? null : Club.fromJson(data);
  }

  Future<List<Club>> fetchAll() async {
    final data = await _supabase.from(_table).select();
    return (data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Club.fromJson)
        .toList();
  }

  Future<void> add(Club club) async {
    await _supabase.from(_table).insert(club.toJson());
  }

  Future<void> update(Club club) async {
    await _supabase.from(_table).update(club.toJson()).eq('id', club.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from(_table).delete().eq('id', id);
  }

  // Helpers --------------------------------------------------------------
  static SupabaseClient _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return SupabaseClient(
        'http://localhost',
        'public-anon-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      );
    }
  }
}
