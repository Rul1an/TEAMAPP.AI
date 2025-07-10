// Project imports:
import '../models/performance_rating.dart';
import 'base_hive_cache.dart';

class HivePerformanceRatingCache {
  HivePerformanceRatingCache()
    : _cache = BaseHiveCache<List<PerformanceRating>>(
        boxName: _box,
        valueKey: _key,
        fromJson: _fromJson,
        toJson: _toJson,
      );

  static const _box = 'performance_ratings_box';
  static const _key = 'performance_ratings_json';

  final BaseHiveCache<List<PerformanceRating>> _cache;

  Future<List<PerformanceRating>?> read({Duration? ttl}) =>
      _cache.read(ttl: ttl);
  Future<void> write(List<PerformanceRating> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  static List<PerformanceRating> _fromJson(Map<String, dynamic> map) {
    final raw = (map['ratings'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    return raw.map(PerformanceRating.fromJson).toList();
  }

  static Map<String, dynamic> _toJson(List<PerformanceRating> list) => {
    'ratings': list.map((e) => e.toJson()).toList(),
  };
}
