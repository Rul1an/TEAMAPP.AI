import 'package:flutter/foundation.dart';

/// Minimal no-op stub that mimics the public API of `FlutterSecureStorage`.
/// Used for platforms where `dart:html`, `dart:js` or platform channels
/// are unavailable (e.g. WebAssembly builds).
class FlutterSecureStorage {
  final Map<String, String?> _memory = {};

  FlutterSecureStorage();

  Future<String?> read(
          {required String key,
          dynamic iOptions,
          dynamic aOptions,
          dynamic lOptions,
          dynamic webOptions,
          dynamic mOptions,
          dynamic wOptions}) async =>
      _memory[key];

  Future<void> write(
      {required String key,
      required String? value,
      dynamic iOptions,
      dynamic aOptions,
      dynamic lOptions,
      dynamic webOptions,
      dynamic mOptions,
      dynamic wOptions}) async {
    _memory[key] = value;
    _listeners[key]?.forEach((l) => l(value));
  }

  Future<void> delete(
      {required String key,
      dynamic iOptions,
      dynamic aOptions,
      dynamic lOptions,
      dynamic webOptions,
      dynamic mOptions,
      dynamic wOptions}) async {
    _memory.remove(key);
    _listeners[key]?.forEach((l) => l(null));
  }

  Future<void> deleteAll(
      {dynamic iOptions,
      dynamic aOptions,
      dynamic lOptions,
      dynamic webOptions,
      dynamic mOptions,
      dynamic wOptions}) async {
    _memory.clear();
    for (final list in _listeners.values) {
      for (final l in list) l(null);
    }
  }

  Future<Map<String, String?>> readAll(
          {dynamic iOptions,
          dynamic aOptions,
          dynamic lOptions,
          dynamic webOptions,
          dynamic mOptions,
          dynamic wOptions}) async =>
      Map.from(_memory);

  // Listener helpers (subset of API)
  final Map<String, List<ValueChanged<String?>>> _listeners = {};

  void addListener(String key, ValueChanged<String?> listener) {
    _listeners.putIfAbsent(key, () => []).add(listener);
  }

  void removeListener(String key, ValueChanged<String?> listener) {
    _listeners[key]?.remove(listener);
  }
}
