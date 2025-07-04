import 'package:supabase_flutter/supabase_flutter.dart';

class SupabasePermissionDataSource {
  SupabasePermissionDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryClient();

  final SupabaseClient _supabase;
  static const _table = 'role_permissions'; // columns: role, action, allowed

  Future<Map<String, bool>> fetchPermissions(String role) async {
    final data = await _supabase
        .from(_table)
        .select('action, allowed')
        .eq('role', role);
    final list = (data as List<dynamic>)
        .cast<Map<String, dynamic>>();
    return {
      for (final row in list) row['action'] as String: (row['allowed'] as bool?) ?? false,
    };
  }

  static SupabaseClient _tryClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }
}
