// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../config/supabase_config.dart';
import '../core/result.dart';
import '../models/player.dart';
import 'player_repository.dart';

class SupabasePlayerRepository implements PlayerRepository {
  SupabasePlayerRepository({SupabaseClient? client})
    : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;
  static const _table = 'players';

  // region Helpers
  Player _fromRow(Map<String, dynamic> row) {
    final p = Player()
      ..id = row['id'] as String
      ..firstName = row['first_name'] as String? ?? ''
      ..lastName = row['last_name'] as String? ?? ''
      ..jerseyNumber = (row['jersey_number'] ?? 0) as int
      ..birthDate = DateTime.parse(
        row['birth_date'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..position = Position.values.firstWhere(
        (e) => e.name == (row['position'] as String? ?? '').toLowerCase(),
        orElse: () => Position.defender,
      )
      ..preferredFoot = PreferredFoot.values.firstWhere(
        (e) => e.name == (row['preferred_foot'] as String? ?? '').toLowerCase(),
        orElse: () => PreferredFoot.right,
      )
      ..height = (row['height_cm'] as num?)?.toDouble() ?? 0
      ..weight = (row['weight_kg'] as num?)?.toDouble() ?? 0
      ..phoneNumber = row['phone'] as String?
      ..email = row['email'] as String?
      ..parentContact = row['parent_contact'] as String?
      ..matchesPlayed = row['matches_played'] as int? ?? 0
      ..matchesInSelection = row['matches_in_selection'] as int? ?? 0
      ..minutesPlayed = row['minutes_played'] as int? ?? 0
      ..goals = row['goals'] as int? ?? 0
      ..assists = row['assists'] as int? ?? 0
      ..yellowCards = row['yellow_cards'] as int? ?? 0
      ..redCards = row['red_cards'] as int? ?? 0
      ..trainingsAttended = row['trainings_attended'] as int? ?? 0
      ..trainingsTotal = row['trainings_total'] as int? ?? 0
      ..createdAt = DateTime.parse(
        row['created_at'] as String? ?? DateTime.now().toIso8601String(),
      )
      ..updatedAt = DateTime.parse(
        row['updated_at'] as String? ?? DateTime.now().toIso8601String(),
      );

    return p;
  }

  Map<String, dynamic> _toRow(Player p) => {
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
  }..removeWhere((key, value) => value == null);

  // endregion

  @override
  Future<Result<void>> add(Player player) async {
    try {
      final payload = _toRow(player);
      await _client.from(_table).insert(payload);
      return const Success(null);
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

  @override
  Future<Result<List<Player>>> getAll() async {
    try {
      final data = await _client.from(_table).select();
      final players = (data as List<dynamic>)
          .map((e) => _fromRow(e as Map<String, dynamic>))
          .toList();
      return Success(players);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<Player?>> getById(String id) async {
    try {
      final data = await _client.from(_table).select().eq('id', id).single();
      return Success(_fromRow(data));
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async {
    try {
      final data = await _client
          .from(_table)
          .select()
          .eq('position', position.name);
      final players = (data as List<dynamic>)
          .map((e) => _fromRow(e as Map<String, dynamic>))
          .toList();
      return Success(players);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> update(Player player) async {
    try {
      final payload = _toRow(player);
      await _client.from(_table).update(payload).eq('id', player.id);
      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
