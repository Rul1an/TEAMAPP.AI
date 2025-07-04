import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/organization.dart';

class SupabaseOrganizationDataSource {
  SupabaseOrganizationDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryClient();

  final SupabaseClient _supabase;
  static const _table = 'organizations';

  Future<Organization?> fetchById(String id) async {
    final data =
        await _supabase.from(_table).select().eq('id', id).maybeSingle();
    return data == null ? null : Organization.fromJson(data);
  }

  Future<List<Organization>> fetchByUser(String userId) async {
    final data = await _supabase
        .from('organization_members')
        .select('organizations!inner(*)')
        .eq('user_id', userId);
    final rows = (data as List<dynamic>)
        .map((e) => (e['organizations'] as Map<String, dynamic>))
        .toList();
    return rows.map(Organization.fromJson).toList();
  }

  Future<void> insert(Organization org) async {
    await _supabase.from(_table).insert(org.toJson());
  }

  Future<void> update(Organization org) async {
    await _supabase.from(_table).update(org.toJson()).eq('id', org.id);
  }

  Future<bool> slugAvailable(String slug) async {
    final exists = await _supabase
        .from(_table)
        .select('id')
        .eq('slug', slug)
        .maybeSingle();
    return exists == null;
  }

  static SupabaseClient _tryClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }
}
