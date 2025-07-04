// Dart imports:
import 'dart:convert';
import 'dart:math';

// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles creation and retrieval of the AES-256 encryption key for Hive boxes.
/// The key is stored securely using `flutter_secure_storage` on mobile/desktop.
/// On web, we fall back to `window.localStorage` (not ideal but acceptable for
/// non-sensitive demo data). This utility is synchronous after first call.
class HiveKeyManager {
  HiveKeyManager({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _kKeyName = 'hive_encryption_key';
  final FlutterSecureStorage _storage;
  List<int>? _cached;

  /// Returns a 32-byte key for Hive encryption. Generates one if absent.
  Future<List<int>> getKey() async {
    if (_cached != null) return _cached!;

    final existing = await _storage.read(key: _kKeyName);
    if (existing != null) {
      _cached = base64Decode(existing);
      return _cached!;
    }

    // Generate 256-bit key
    final random = Random.secure();
    final key = List<int>.generate(32, (_) => random.nextInt(256));
    await _storage.write(key: _kKeyName, value: base64Encode(key));
    _cached = key;
    return key;
  }

  /// Deletes the stored encryption key (e.g., on user logout).
  Future<void> deleteKey() async {
    _cached = null;
    await _storage.delete(key: _kKeyName);
  }
}
