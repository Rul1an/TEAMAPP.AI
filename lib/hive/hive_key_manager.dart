// Dart imports:
import 'dart:convert';
import 'dart:math';

// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Handles creation and retrieval of the AES-256 encryption key for Hive boxes.
/// The key is stored securely using `flutter_secure_storage` on mobile/desktop.
/// On web, we fall back to `window.localStorage` (not ideal but acceptable for
/// non-sensitive demo data). This utility is synchronous after first call.
class HiveKeyManager {
  HiveKeyManager({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  /// Creates an in-memory key manager for unit tests, bypassing platform
  /// channels from `flutter_secure_storage`.
  factory HiveKeyManager.inMemory() =>
      HiveKeyManager(storage: _InMemorySecureStorage());

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

/// Minimal in-memory stub for [FlutterSecureStorage] used in tests.
class _InMemorySecureStorage implements FlutterSecureStorage {
  final Map<String, String> _store = {};
  final Map<String, List<ValueChanged<String?>>> _listeners = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _store[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _store.remove(key);
    } else {
      _store[key] = value;
    }
    _listeners[key]?.forEach((listener) => listener(value));
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.remove(key);
    _listeners[key]?.forEach((listener) => listener(null));
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _store.clear();
    for (final key in _listeners.keys) {
      _listeners[key]?.forEach((l) => l(null));
    }
  }

  // The rest of the API methods are no-op for this stub
  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => Map.of(_store);

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _store.containsKey(key);

  // Listener management -------------------------------------------------

  @override
  void registerListener({
    required String key,
    required ValueChanged<String?> listener,
  }) {
    _listeners.putIfAbsent(key, () => []).add(listener);
  }

  @override
  void unregisterListener({
    required String key,
    required ValueChanged<String?> listener,
  }) {
    _listeners[key]?.remove(listener);
  }

  @override
  void unregisterAllListenersForKey({required String key}) {
    _listeners[key]?.clear();
  }

  @override
  void unregisterAllListeners() {
    _listeners.clear();
  }

  @override
  Future<bool?> isCupertinoProtectedDataAvailable() async => false;
}
