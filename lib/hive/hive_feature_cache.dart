// Project imports:
import 'base_hive_cache.dart';

class HiveFeatureCache {
  HiveFeatureCache()
    : _cache = BaseHiveCache<Map<String, bool>>(
        boxName: _box,
        valueKey: _key,
        fromJson: (map) => (map['features'] as Map).cast<String, bool>(),
        toJson: (value) => {'features': value},
      );
  static const _box = 'feature_box';
  static const _key = 'feature_json';

  final BaseHiveCache<Map<String, bool>> _cache;

  Future<Map<String, bool>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(Map<String, bool> data) => _cache.write(data);
  Future<void> clear() => _cache.clear();
}
