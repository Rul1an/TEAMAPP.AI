import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/training.dart';

/// Raw Supabase I/O for the `trainings` table.
class SupabaseTrainingDataSource {
  SupabaseTrainingDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;
  static const _table = 'trainings';

  Future<List<Training>> fetchAll() async {
    final data = await _supabase.from(_table).select();
    return (data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_fromRow)
        .toList();
  }

  Future<Training?> fetchById(String id) async {
    final data =
        await _supabase.from(_table).select().eq('id', id).maybeSingle();
    return data == null ? null : _fromRow(data);
  }

  Future<void> add(Training t) async =>
      _supabase.from(_table).insert(_toRow(t));
  Future<void> update(Training t) async =>
      _supabase.from(_table).update(_toRow(t)).eq('id', t.id);
  Future<void> delete(String id) async =>
      _supabase.from(_table).delete().eq('id', id);

  Stream<List<Training>> subscribe() => _supabase
      .from(_table)
      .stream(primaryKey: ['id'])
      .map(_rowsToTrainings)
      .distinct(_listEquals);

  // helpers ----------------------------------------------------
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

  static Training _fromRow(Map<String, dynamic> r) {
    final t = Training()
      ..id = r['id'] as String? ?? ''
      ..date = DateTime.parse(r['date'] as String)
      ..duration = r['duration'] as int? ?? 0
      ..focus = _focus(r['focus'] as String?)
      ..intensity = _intensity(r['intensity'] as String?)
      ..status = _status(r['status'] as String?)
      ..location = r['location'] as String?
      ..description = r['description'] as String?
      ..objectives = r['objectives'] as String?
      ..drills = (r['drills'] as List<dynamic>? ?? []).cast<String>()
      ..presentPlayerIds = (r['present'] as List<dynamic>? ?? []).cast<String>()
      ..absentPlayerIds = (r['absent'] as List<dynamic>? ?? []).cast<String>()
      ..injuredPlayerIds = (r['injured'] as List<dynamic>? ?? []).cast<String>()
      ..latePlayerIds = (r['late'] as List<dynamic>? ?? []).cast<String>()
      ..coachNotes = r['coach_notes'] as String?
      ..performanceNotes = r['performance_notes'] as String?
      ..createdAt = DateTime.parse(r['created_at'] as String)
      ..updatedAt = DateTime.parse(r['updated_at'] as String);
    return t;
  }

  static Map<String, dynamic> _toRow(Training t) => <String, dynamic>{
        'id': t.id,
        'date': t.date.toIso8601String(),
        'duration': t.duration,
        'focus': t.focus.name,
        'intensity': t.intensity.name,
        'status': t.status.name,
        'location': t.location,
        'description': t.description,
        'objectives': t.objectives,
        'drills': t.drills,
        'present': t.presentPlayerIds,
        'absent': t.absentPlayerIds,
        'injured': t.injuredPlayerIds,
        'late': t.latePlayerIds,
        'coach_notes': t.coachNotes,
        'performance_notes': t.performanceNotes,
        'created_at': t.createdAt.toIso8601String(),
        'updated_at': t.updatedAt.toIso8601String(),
      }..removeWhere((_, v) => v == null);

  static List<Training> _rowsToTrainings(List<dynamic> rows) =>
      rows.cast<Map<String, dynamic>>().map(_fromRow).toList();

  static bool _listEquals(List<Training> a, List<Training> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].updatedAt != b[i].updatedAt) return false;
    }
    return true;
  }

  static TrainingFocus _focus(String? s) => TrainingFocus.values.firstWhere(
        (e) => e.name == (s ?? '').toLowerCase(),
        orElse: () => TrainingFocus.technical,
      );
  static TrainingIntensity _intensity(String? s) =>
      TrainingIntensity.values.firstWhere(
        (e) => e.name == (s ?? '').toLowerCase(),
        orElse: () => TrainingIntensity.medium,
      );
  static TrainingStatus _status(String? s) => TrainingStatus.values.firstWhere(
        (e) => e.name == (s ?? '').toLowerCase(),
        orElse: () => TrainingStatus.planned,
      );
}
