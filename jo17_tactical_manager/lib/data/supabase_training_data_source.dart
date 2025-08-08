// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/utils/error_sanitizer.dart';

/// Raw Supabase I/O for the `trainings` table.
class SupabaseTrainingDataSource {
  SupabaseTrainingDataSource({SupabaseClient? client})
      : _supabase = client ?? _tryGetClient();

  final SupabaseClient _supabase;
  static const _table = 'trainings';

  Future<List<Training>> fetchAll() async {
    try {
      final data = await _supabase.from(_table).select();
      return (data as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_fromRow)
          .toList();
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  Future<Training?> fetchById(String id) async {
    try {
      final data =
          await _supabase.from(_table).select().eq('id', id).maybeSingle();
      return data == null ? null : _fromRow(data);
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  Future<void> add(Training t) async {
    try {
      await _supabase.from(_table).insert(_toRow(t));
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  Future<void> update(Training t) async {
    try {
      await _supabase.from(_table).update(_toRow(t)).eq('id', t.id);
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  Future<void> delete(String id) async {
    try {
      await _supabase.from(_table).delete().eq('id', id);
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

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
    // Convert Supabase row format to Training.fromJson format
    final normalizedData = <String, dynamic>{
      'id': r['id'] as String? ?? '',
      'date': r['date'] as String? ?? DateTime.now().toIso8601String(),
      'duration': r['duration'] as int? ?? 0,
      'trainingNumber': r['training_number'] as int? ?? 1,
      'focus': (r['focus'] as String? ?? 'technical').toLowerCase(),
      'intensity': (r['intensity'] as String? ?? 'medium').toLowerCase(),
      'status': (r['status'] as String? ?? 'planned').toLowerCase(),
      'location': r['location'] as String?,
      'description': r['description'] as String?,
      'objectives': r['objectives'] as String?,
      'drills': r['drills'] as List? ?? [],
      'presentPlayerIds': r['present'] as List? ?? [],
      'absentPlayerIds': r['absent'] as List? ?? [],
      'injuredPlayerIds': r['injured'] as List? ?? [],
      'latePlayerIds': r['late'] as List? ?? [],
      'coachNotes': r['coach_notes'] as String?,
      'performanceNotes': r['performance_notes'] as String?,
      'createdAt': r['created_at'] as String? ?? DateTime.now().toIso8601String(),
      'updatedAt': r['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    };

    return Training.fromJson(normalizedData);
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
}
