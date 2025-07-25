// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../config/supabase_config.dart';
import '../core/result.dart';
import '../models/training_session/training_session.dart';
import 'training_session_repository.dart';

/// Production repository backed by Supabase tables.
/// Assumes the following schema:
///   Table: training_sessions
///   Columns: id (uuid, pk), team_id, date, training_number, type, phases (jsonb)
/// The [TrainingSession] <-> DB mapping lives here for now; consider
/// code-gen with `supabase_flutter` types later.
class SupabaseTrainingSessionRepository implements TrainingSessionRepository {
  SupabaseTrainingSessionRepository({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  static const _table = 'training_sessions';

  @override
  Future<Result<List<TrainingSession>>> getAll() async {
    try {
      final data = await _client.from(_table).select();
      final sessions = (data as List<dynamic>)
          .map((e) => TrainingSession.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(sessions);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TrainingSession>>> getUpcoming() async {
    try {
      final nowIso = DateTime.now().toIso8601String();
      final data = await _client
          .from(_table)
          .select()
          .gte('date', nowIso)
          .order('date')
          .limit(20);

      final sessions = (data as List<dynamic>)
          .map((e) => TrainingSession.fromJson(e as Map<String, dynamic>))
          .toList();
      return Success(sessions);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(TrainingSession session) async {
    try {
      final payload = session.toJson();
      await _client.from(_table).update(payload).eq('id', session.id);
      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
