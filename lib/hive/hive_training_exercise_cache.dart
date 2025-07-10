// Project imports:
import '../models/training_session/training_exercise.dart';
import 'base_hive_cache.dart';

class HiveTrainingExerciseCache {
  HiveTrainingExerciseCache()
    : _cache = BaseHiveCache<List<TrainingExercise>>(
        boxName: _box,
        valueKey: _key,
        fromJson: _fromJson,
        toJson: _toJson,
      );

  static const _box = 'training_exercises_box';
  static const _key = 'training_exercises_json';

  final BaseHiveCache<List<TrainingExercise>> _cache;

  Future<List<TrainingExercise>?> read({Duration? ttl}) =>
      _cache.read(ttl: ttl);
  Future<void> write(List<TrainingExercise> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<TrainingExercise> _fromJson(Map<String, dynamic> map) {
    final raw = (map['exercises'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return raw.map(TrainingExercise.fromJson).toList();
  }

  static Map<String, dynamic> _toJson(List<TrainingExercise> list) => {
    'exercises': list.map((e) => e.toJson()).toList(),
  };
}
