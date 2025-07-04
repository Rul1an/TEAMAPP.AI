import 'dart:collection';

import 'base_hive_cache.dart';

class HiveStatisticsCache {
  HiveStatisticsCache()
      : _cache = BaseHiveCache<Map<String, dynamic>>(
          boxName: _box,
          valueKey: _key,
          fromJson: _fromJson,
          toJson: _toJson,
        );

  static const _box = 'statistics_box';
  static const _key = 'statistics_json';

  final BaseHiveCache<Map<String, dynamic>> _cache;

  Future<Map<String, dynamic>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(Map<String, dynamic> data) => _cache.write(data);
  Future<void> clear() => _cache.clear();

  static Map<String, dynamic> _fromJson(Map<String, dynamic> map) {
    // Return an unmodifiable map to prevent accidental mutations outside cache
    return UnmodifiableMapView(map['stats'] as Map<String, dynamic>? ?? {});
  }

  static Map<String, dynamic> _toJson(Map<String, dynamic> data) => {
        'stats': data,
      };
}
