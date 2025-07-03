import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/profile.dart';
import 'hive_key_manager.dart';

class HiveProfileCache {
  HiveProfileCache();
  static const _boxName = 'profiles_box';
  static const _key = 'current_profile_json';

  Future<Box<String>> _openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      // No adapter needed; we store JSON string.
    }
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

  Future<Profile?> read() async {
    final box = await _openBox();
    final jsonStr = box.get(_key);
    if (jsonStr == null) return null;
    return Profile.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  Future<void> write(Profile profile) async {
    final box = await _openBox();
    await box.put(_key, jsonEncode(profile.toJson()));
  }
}
