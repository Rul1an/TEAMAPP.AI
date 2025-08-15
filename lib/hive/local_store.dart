// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'base_hive_cache.dart';
import 'hive_key_manager.dart';

/// LocalStore is a thin wrapper around [BaseHiveCache] that adds schema
/// versioning support. Use this for all new Local*Repository classes.
///
/// Features:
/// • JSON (de)serialisation + TTL via [BaseHiveCache].
/// • Schema version key stored alongside the payload (e.g. `<box>_version`).
/// • Optional [onUpgrade] callback for destructive migrations.
class LocalStore<T> {
  LocalStore({
    required String boxName,
    required String valueKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    Duration defaultTtl = const Duration(hours: 24),
    int schemaVersion = 1,
    Future<void> Function(int oldVersion, int newVersion)? onUpgrade,
  })  : _cache = BaseHiveCache<T>(
          boxName: boxName,
          valueKey: valueKey,
          fromJson: fromJson,
          toJson: toJson,
          defaultTtl: defaultTtl,
        ),
        _boxName = boxName,
        _versionKey = '${boxName}_version',
        _schemaVersion = schemaVersion,
        _onUpgrade = onUpgrade {
    // Check schema version asynchronously.
    _ensureVersion();
  }

  final BaseHiveCache<T> _cache;
  final String _boxName;
  final String _versionKey;
  final int _schemaVersion;
  final Future<void> Function(int oldVersion, int newVersion)? _onUpgrade;

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

  Future<void> _ensureVersion() async {
    try {
      final box = await _openBox();
      final storedRaw = box.get(_versionKey);
      final storedVersion = int.tryParse(storedRaw ?? '0') ?? 0;

      if (storedVersion == _schemaVersion) return;

      // Execute custom migration logic if provided.
      await _onUpgrade?.call(storedVersion, _schemaVersion);

      // Clear cached data for incompatible schema by default
      await _cache.clear();
      await box.put(_versionKey, _schemaVersion.toString());
    } catch (_) {
      // If version access fails due to corruption, nuke the box.
      try {
        if (Hive.isBoxOpen(_boxName)) {
          await Hive.box<String>(_boxName).close();
        }
      } catch (_) {}
      try {
        await Hive.deleteBoxFromDisk(_boxName);
      } catch (_) {}
    }
  }

  Future<T?> read({Duration? ttl}) => _cache.read(ttl: ttl);

  Future<void> write(T value) => _cache.write(value);

  Future<void> clear() => _cache.clear();
}
