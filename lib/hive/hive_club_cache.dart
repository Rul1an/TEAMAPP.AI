// Project imports:
import '../models/club/club.dart';
import 'base_hive_cache.dart';

/// Offline cache for a list of [Club] objects.
class HiveClubCache {
  HiveClubCache()
      : _cache = BaseHiveCache<List<Club>>(
          boxName: _boxName,
          valueKey: _valueKey,
          fromJson: _listFromJson,
          toJson: _listToJson,
        );

  static const _boxName = 'clubs_box';
  static const _valueKey = 'clubs_json';

  final BaseHiveCache<List<Club>> _cache;

  Future<List<Club>?> read({Duration? ttl}) => _cache.read(ttl: ttl);
  Future<void> write(List<Club> list) => _cache.write(list);
  Future<void> clear() => _cache.clear();

  // JSON helpers ---------------------------------------------------------
  static List<Club> _listFromJson(Map<String, dynamic> map) {
    final list =
        (map['clubs'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    return list.map(Club.fromJson).toList();
  }

  static Map<String, dynamic> _listToJson(List<Club> list) => {
        'clubs': list.map((c) => c.toJson()).toList(),
      };
}
