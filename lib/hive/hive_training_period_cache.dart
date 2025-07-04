import '../models/annual_planning/training_period.dart';
import 'base_hive_cache.dart';

class HiveTrainingPeriodCache {
  HiveTrainingPeriodCache()
      : _cache = BaseHiveCache<List<TrainingPeriod>>(
          boxName: _box,
          valueKey: _key,
          fromJson: _fromJson,
          toJson: _toJson,
        );

  static const _box = 'training_periods_box';
  static const _key = 'training_periods_json';

  final BaseHiveCache<List<TrainingPeriod>> _cache;

  Future<List<TrainingPeriod>?> read({Duration? ttl}) =>
      _cache.read(ttl: ttl);
  Future<void> write(List<TrainingPeriod> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<TrainingPeriod> _fromJson(Map<String, dynamic> map) {
    final raw =
        (map['periods'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return raw.map(TrainingPeriod.fromJson).toList();
  }

  static Map<String, dynamic> _toJson(List<TrainingPeriod> list) => {
        'periods': list.map((e) => e.toJson()).toList(),
      };
}
