import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/match.dart';

/// Raw Supabase access for `matches` table.
class SupabaseMatchDataSource {
  SupabaseMatchDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;
  static const _table = 'matches';

  // fetch operations
  Future<List<Match>> fetchAll() async {
    final data = await _supabase.from(_table).select();
    return (data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_fromRow)
        .toList();
  }

  Future<Match?> fetchById(String id) async {
    final data =
        await _supabase.from(_table).select().eq('id', id).maybeSingle();
    return data == null ? null : _fromRow(data);
  }

  Future<void> add(Match match) async {
    await _supabase.from(_table).insert(_toRow(match));
  }

  Future<void> update(Match match) async {
    await _supabase.from(_table).update(_toRow(match)).eq('id', match.id);
  }

  Future<void> delete(String id) async {
    await _supabase.from(_table).delete().eq('id', id);
  }

  Stream<List<Match>> subscribe() => _supabase
      .from(_table)
      .stream(
        primaryKey: ['id'],
      )
      .map(_rowsToMatches)
      .distinct(_listEquals);

  // helpers
  static List<Match> _rowsToMatches(List<dynamic> rows) =>
      rows.cast<Map<String, dynamic>>().map(_fromRow).toList();

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

  static Match _fromRow(Map<String, dynamic> row) {
    final m = Match()
      ..id = row['id'] as String? ?? ''
      ..date = DateTime.parse(
        row['date'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..opponent = row['opponent'] as String? ?? ''
      ..location = Location.values.firstWhere(
        (e) => e.name == (row['location'] as String? ?? '').toLowerCase(),
        orElse: () => Location.home,
      )
      ..competition = Competition.values.firstWhere(
        (e) => e.name == (row['competition'] as String? ?? '').toLowerCase(),
        orElse: () => Competition.league,
      )
      ..status = MatchStatus.values.firstWhere(
        (e) => e.name == (row['status'] as String? ?? '').toLowerCase(),
        orElse: () => MatchStatus.scheduled,
      )
      ..teamScore = row['team_score'] as int?
      ..opponentScore = row['opponent_score'] as int?
      ..createdAt = DateTime.parse(
        row['created_at'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..updatedAt = DateTime.parse(
        row['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      );
    return m;
  }

  static Map<String, dynamic> _toRow(Match m) => <String, dynamic>{
        'id': m.id,
        'date': m.date.toIso8601String(),
        'opponent': m.opponent,
        'location': m.location.name,
        'competition': m.competition.name,
        'status': m.status.name,
        'team_score': m.teamScore,
        'opponent_score': m.opponentScore,
        'created_at': m.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }..removeWhere((_, v) => v == null);

  static bool _listEquals(List<Match> a, List<Match> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].updatedAt != b[i].updatedAt) return false;
    }
    return true;
  }
}
