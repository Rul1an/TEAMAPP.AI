// Project imports:
import 'base_hive_cache.dart';

class HivePermissionCache {
  HivePermissionCache()
      : _cache = BaseHiveCache<Map<String, bool>>(
          boxName: _box,
          valueKey: _key,
          fromJson: (map) => (map['permissions'] as Map).cast<String, bool>(),
          toJson: (value) => {'permissions': value},
        );
  static const _box = 'perm_box';
  static const _key = 'perm_json';

  final BaseHiveCache<Map<String, bool>> _cache;

  Future<Map<String, bool>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(Map<String, bool> data) => _cache.write(data);
  Future<void> clear() => _cache.clear();
}
