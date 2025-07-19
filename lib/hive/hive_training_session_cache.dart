// Project imports:
import '../models/training_session/training_session.dart';
import 'base_hive_cache.dart';

/// Offline Hive cache for [TrainingSession] lists.
class HiveTrainingSessionCache {
  HiveTrainingSessionCache()
      : _cache = BaseHiveCache<List<TrainingSession>>(
          boxName: _box,
          valueKey: _key,
          fromJson: _fromJson,
          toJson: _toJson,
        );

  static const _box = 'training_sessions_box';
  static const _key = 'training_sessions_json';

  final BaseHiveCache<List<TrainingSession>> _cache;

  Future<List<TrainingSession>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(List<TrainingSession> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  // JSON helpers
  static List<TrainingSession> _fromJson(Map<String, dynamic> map) {
    final raw =
        (map['sessions'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return raw.map(TrainingSession.fromJson).toList();
  }

  static Map<String, dynamic> _toJson(List<TrainingSession> list) => {
        'sessions': list.map((s) => s.toJson()).toList(),
      };
}
