// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../config/supabase_config.dart';
import '../core/result.dart';
import '../models/match.dart';
import 'match_repository.dart';

class SupabaseMatchRepository implements MatchRepository {
  SupabaseMatchRepository({SupabaseClient? client})
    : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;
  static const _table = 'matches';

  Match _fromRow(Map<String, dynamic> row) {
    final m = Match()
      ..id = row['id'] as String
      ..date = DateTime.parse(row['date'] as String)
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
      ..createdAt = DateTime.parse(row['created_at'] as String)
      ..updatedAt = DateTime.parse(row['updated_at'] as String);
    return m;
  }

  Map<String, dynamic> _toRow(Match m) => {
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
  }..removeWhere((k, v) => v == null);

  // region CRUD

  @override
  Future<Result<void>> add(Match match) async {
    try {
      await _client.from(_table).insert(_toRow(match));
      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Match match) async {
    try {
      await _client.from(_table).update(_toRow(match)).eq('id', match.id);
      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getAll() async {
    try {
      final data = await _client.from(_table).select();
      final matches = (data as List<dynamic>)
          .map((e) => _fromRow(e as Map<String, dynamic>))
          .toList();
      return Success(matches);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getUpcoming() async {
    try {
      final nowIso = DateTime.now().toIso8601String();
      final data = await _client
          .from(_table)
          .select()
          .gte('date', nowIso)
          .order('date');
      final matches = (data as List<dynamic>)
          .map((e) => _fromRow(e as Map<String, dynamic>))
          .toList();
      return Success(matches);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Match>>> getRecent() async {
    try {
      final nowIso = DateTime.now().toIso8601String();
      final data = await _client
          .from(_table)
          .select()
          .lt('date', nowIso)
          .order('date', ascending: false)
          .limit(20);
      final matches = (data as List<dynamic>)
          .map((e) => _fromRow(e as Map<String, dynamic>))
          .toList();
      return Success(matches);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<Match?>> getById(String id) async {
    try {
      final data = await _client.from(_table).select().eq('id', id).single();
      return Success(_fromRow(data));
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  // endregion
}
