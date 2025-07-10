// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import '../models/profile.dart';
import 'hive_key_manager.dart';

class HiveProfileCache {
  HiveProfileCache({HiveKeyManager? keyManager}) : _keyManager = keyManager ?? HiveKeyManager();

  final HiveKeyManager _keyManager;
  static const _boxName = 'profiles_box';
  static const _key = 'current_profile_json';
  static const _tsKey = 'current_profile_ts';

  /// Default time-to-live for cached profile data.
  static const _defaultTtl = Duration(minutes: 10);

  Future<Box<String>> _openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      // No adapter needed; we store JSON string.
    }
    if (!Hive.isBoxOpen(_boxName)) {
      final key = await _keyManager.getKey();
      await Hive.initFlutter();
      return Hive.openBox<String>(
        _boxName,
        encryptionCipher: HiveAesCipher(key),
      );
    }
    return Hive.box<String>(_boxName);
  }

  /// Reads the cached [Profile] if it exists and has not expired. Returns
  /// `null` when no cache is present or the entry is stale.
  Future<Profile?> read({Duration ttl = _defaultTtl}) async {
    final box = await _openBox();

    // Verify timestamp first to avoid unnecessary JSON parsing.
    final tsStr = box.get(_tsKey);
    if (tsStr == null) return null;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(int.parse(tsStr));
    if (DateTime.now().difference(cachedAt) > ttl) {
      await clear();
      return null;
    }

    final jsonStr = box.get(_key);
    if (jsonStr == null) return null;
    return Profile.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  /// Persists the given [profile] and updates the timestamp.
  Future<void> write(Profile profile) async {
    final box = await _openBox();
    await box.putAll({
      _key: jsonEncode(profile.toJson()),
      _tsKey: DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  /// Clears the cached profile and its timestamp.
  Future<void> clear() async {
    final box = await _openBox();
    await box.delete(_key);
    await box.delete(_tsKey);
  }
}
