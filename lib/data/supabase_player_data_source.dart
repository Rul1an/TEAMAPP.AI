// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../config/supabase_config.dart';
import '../models/player.dart';

/// Raw Supabase I/O for the `players` table.
///
/// Higher-level layers (repositories) compose this data-source with
/// together with an encrypted Hive cache to provide read-through caching and
/// unified error handling.
class SupabasePlayerDataSource {
  SupabasePlayerDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;

  static const _table = 'players';

  // region Public API -------------------------------------------------------

  Future<List<Player>> fetchAll() async {
    // Scope by organization for performance and RLS alignment
    try {
      final orgId = await _supabase.getOrganizationIdWithFallback();
      if (orgId == null || orgId.isEmpty) {
        return <Player>[];
      }
      final data = await _supabase
          .from(_table)
          .select()
          .eq('organization_id', orgId)
          .order('last_name');
      return (data as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_fromRow)
          .toList();
    } catch (_) {
      return <Player>[];
    }
  }

  Future<Player?> fetchById(String id) async {
    final data =
        await _supabase.from(_table).select().eq('id', id).maybeSingle();
    return data == null ? null : _fromRow(data);
  }

  Future<void> add(Player player) async {
    // Ensure organization context is present and include it in insert
    final orgId = await _supabase.getOrganizationIdWithFallback();
    if (orgId == null || orgId.isEmpty) {
      throw StateError('Cannot add player: no organization selected');
    }
    await _supabase
        .from(_table)
        .insert({..._toRow(player), 'organization_id': orgId});
  }

  Future<void> update(Player player) async {
    await _supabase.from(_table).update(_toRow(player)).eq('id', player.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from(_table).delete().eq('id', id);
  }

  /// Realtime stream of all players for the current team/tenant.
  ///
  /// Consumers should perform `.distinct()` or other deduplication if needed.
  Stream<List<Player>> subscribe() {
    return _supabase
        .from(_table)
        .stream(primaryKey: ['id'])
        .map(_rowsToPlayers)
        .distinct(_listEquals);
  }

  // endregion --------------------------------------------------------------

  // region Helpers ---------------------------------------------------------

  static SupabaseClient _tryGetClient() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      // Allows unit tests to run without initializing SupabaseFlutter.
      return SupabaseClient(
        'http://localhost',
        'public-anon-key',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      );
    }
  }

  static Player _fromRow(Map<String, dynamic> row) {
    // Prefer using domain JSON constructor for consistency and type safety
    return Player.fromJson({
      'id': row['id'] as String? ?? '',
      'firstName': row['first_name'] as String? ?? '',
      'lastName': row['last_name'] as String? ?? '',
      'jerseyNumber': row['jersey_number'] ?? 0,
      'birthDate':
          row['birth_date'] as String? ?? DateTime.now().toIso8601String(),
      'position': (row['position'] as String?)?.toLowerCase() ?? 'midfielder',
      'preferredFoot':
          (row['preferred_foot'] as String?)?.toLowerCase() ?? 'right',
      'height': (row['height_cm'] as num?)?.toDouble() ?? 0.0,
      'weight': (row['weight_kg'] as num?)?.toDouble() ?? 0.0,
      'phoneNumber': row['phone'] as String?,
      'email': row['email'] as String?,
      'parentContact': row['parent_contact'] as String?,
      'matchesPlayed': row['matches_played'] as int? ?? 0,
      'matchesInSelection': row['matches_in_selection'] as int? ?? 0,
      'minutesPlayed': row['minutes_played'] as int? ?? 0,
      'goals': row['goals'] as int? ?? 0,
      'assists': row['assists'] as int? ?? 0,
      'yellowCards': row['yellow_cards'] as int? ?? 0,
      'redCards': row['red_cards'] as int? ?? 0,
      'trainingsAttended': row['trainings_attended'] as int? ?? 0,
      'trainingsTotal': row['trainings_total'] as int? ?? 0,
      'createdAt':
          row['created_at'] as String? ?? DateTime.now().toIso8601String(),
      'updatedAt':
          row['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    });
  }

  static Map<String, dynamic> _toRow(Player p) {
    final map = <String, dynamic>{
      'id': p.id,
      'first_name': p.firstName,
      'last_name': p.lastName,
      'jersey_number': p.jerseyNumber,
      'birth_date': p.birthDate.toIso8601String(),
      'position': p.position.name,
      'preferred_foot': p.preferredFoot.name,
      'height_cm': p.height,
      'weight_kg': p.weight,
      'phone': p.phoneNumber,
      'email': p.email,
      'parent_contact': p.parentContact,
      'matches_played': p.matchesPlayed,
      'matches_in_selection': p.matchesInSelection,
      'minutes_played': p.minutesPlayed,
      'goals': p.goals,
      'assists': p.assists,
      'yellow_cards': p.yellowCards,
      'red_cards': p.redCards,
      'trainings_attended': p.trainingsAttended,
      'trainings_total': p.trainingsTotal,
      'created_at': p.createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }..removeWhere((_, v) => v == null);

    // Do not send an empty UUID; let the DB default generate it
    final id = map['id'] as String?;
    if (id == null || id.isEmpty) {
      map.remove('id');
    }
    return map;
  }

  static bool _listEquals(List<Player> a, List<Player> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].updatedAt != b[i].updatedAt) {
        return false;
      }
    }
    return true;
  }

  static List<Player> _rowsToPlayers(List<dynamic> rows) =>
      rows.cast<Map<String, dynamic>>().map(_fromRow).toList();

  // endregion --------------------------------------------------------------
}
