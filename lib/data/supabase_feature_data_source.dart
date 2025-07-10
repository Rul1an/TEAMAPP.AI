// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/organization.dart';

class SupabaseFeatureDataSource {
  SupabaseFeatureDataSource({SupabaseClient? client})
    : _supabase = client ?? _tryClient();

  final SupabaseClient _supabase;
  static const _table = 'tier_features'; // columns: tier, feature, enabled

  Future<Map<String, bool>> fetchFeatures(OrganizationTier tier) async {
    final data = await _supabase
        .from(_table)
        .select('feature, enabled')
        .eq('tier', tier.name);
    final list = (data as List<dynamic>).cast<Map<String, dynamic>>();
    return {
      for (final row in list)
        row['feature'] as String: (row['enabled'] as bool?) ?? false,
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
