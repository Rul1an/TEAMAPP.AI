// Project imports:
import '../models/organization.dart';
import 'base_hive_cache.dart';

class HiveOrganizationCache {
  HiveOrganizationCache()
      : _cache = BaseHiveCache<List<Organization>>(
          boxName: _box,
          valueKey: _key,
          fromJson: _fromJson,
          toJson: _toJson,
        );
  static const _box = 'org_box';
  static const _key = 'org_json';

  final BaseHiveCache<List<Organization>> _cache;

  Future<List<Organization>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(List<Organization> orgs) => _cache.write(orgs);
  Future<void> clear() => _cache.clear();

  static List<Organization> _fromJson(Map<String, dynamic> map) =>
      (map['orgs'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Organization.fromJson)
          .toList();

  static Map<String, dynamic> _toJson(List<Organization> list) => {
        'orgs': list.map((o) => o.toJson()).toList(),
      };
}
