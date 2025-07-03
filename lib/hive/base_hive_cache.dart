import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'hive_key_manager.dart';

/// Generic encrypted, TTL-aware Hive cache. Stores a single entry [T] in JSON
/// form. Concrete caches (e.g. `HivePlayerCache`) compose this base class and
/// pass custom `fromJson` / `toJson` mappers.
class BaseHiveCache<T> {
  BaseHiveCache({
    required String boxName,
    required String valueKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    Duration defaultTtl = const Duration(minutes: 10),
  })  : _boxName = boxName,
        _valueKey = valueKey,
        _fromJson = fromJson,
        _toJson = toJson,
        _defaultTtl = defaultTtl,
        _tsKey = '${valueKey}_ts';

  final String _boxName;
  final String _valueKey;
  final String _tsKey;

  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;
  final Duration _defaultTtl;

  Future<Box<String>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      final key = await HiveKeyManager().getKey();
      await Hive.initFlutter();
      return Hive.openBox<String>(
        _boxName,
        encryptionCipher: HiveAesCipher(key),
      );
    }
    return Hive.box<String>(_boxName);
  }

  /// Reads cached value when present and not stale.
  Future<T?> read({Duration? ttl}) async {
    final box = await _openBox();
    final tsStr = box.get(_tsKey);
    if (tsStr == null) return null;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(int.parse(tsStr));
    if (DateTime.now().difference(cachedAt) > (ttl ?? _defaultTtl)) {
      await clear();
      return null;
    }

    final jsonStr = box.get(_valueKey);
    if (jsonStr == null) return null;
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _fromJson(map);
  }

  /// Writes value and timestamp.
  Future<void> write(T value) async {
    final box = await _openBox();
    await box.putAll({
      _valueKey: jsonEncode(_toJson(value)),
      _tsKey: DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  /// Clears value and timestamp.
  Future<void> clear() async {
    final box = await _openBox();
    await box.delete(_valueKey);
    await box.delete(_tsKey);
  }
}
