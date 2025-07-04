import '../models/training.dart';
import 'base_hive_cache.dart';

/// Offline cache for [Training] list using encrypted Hive.
class HiveTrainingCache {
  HiveTrainingCache()
      : _cache = BaseHiveCache<List<Training>>(
          boxName: _boxName,
          valueKey: _valueKey,
          fromJson: _fromJson,
          toJson: _toJson,
        );

  // Box/value identifiers --------------------------------------------------
  static const _boxName = 'trainings_box';
  static const _valueKey = 'trainings_json';

  final BaseHiveCache<List<Training>> _cache;

  /// Reads cached trainings if present & not stale.
  Future<List<Training>?> read({Duration? ttl}) => _cache.read(ttl: ttl);

  /// Writes the given list to cache.
  Future<void> write(List<Training> list) => _cache.write(list);

  /// Clears the cache completely.
  Future<void> clear() => _cache.clear();

  // region JSON helpers ----------------------------------------------------
  static List<Training> _fromJson(Map<String, dynamic> map) {
    final list = (map['trainings'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return list.map(_trainingFromJson).toList();
  }

  static Map<String, dynamic> _toJson(List<Training> list) => {
        'trainings': list.map(_trainingToJson).toList(),
      };

  static Training _trainingFromJson(Map<String, dynamic> json) {
    final t = Training()
      ..id = json['id'] as String? ?? ''
      ..date = DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now()
      ..duration = json['duration'] as int? ?? 0
      ..focus = _focus(json['focus'] as String?)
      ..intensity = _intensity(json['intensity'] as String?)
      ..status = _status(json['status'] as String?)
      ..location = json['location'] as String?
      ..description = json['description'] as String?
      ..objectives = json['objectives'] as String?
      ..drills = (json['drills'] as List<dynamic>? ?? []).cast<String>()
      ..presentPlayerIds =
          (json['present'] as List<dynamic>? ?? []).cast<String>()
      ..absentPlayerIds =
          (json['absent'] as List<dynamic>? ?? []).cast<String>()
      ..injuredPlayerIds =
          (json['injured'] as List<dynamic>? ?? []).cast<String>()
      ..latePlayerIds = (json['late'] as List<dynamic>? ?? []).cast<String>()
      ..coachNotes = json['coach_notes'] as String?
      ..performanceNotes = json['performance_notes'] as String?
      ..createdAt = DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now()
      ..updatedAt = DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now();
    return t;
  }

  static Map<String, dynamic> _trainingToJson(Training t) => <String, dynamic>{
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
  // endregion --------------------------------------------------------------
}
