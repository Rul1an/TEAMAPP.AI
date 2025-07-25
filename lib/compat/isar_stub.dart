// Minimal stub to replace Isar dependency when targeting Web.
// Provides only the annotations used in models so existing code compiles.

/// Mirrors `EnumType` from `package:isar/isar.dart` but with no functionality.
enum EnumType { name, ordinal }

/// Dummy annotation mirroring `@Enumerated` from Isar.
class Enumerated {
  final EnumType? value;
  const Enumerated([this.value]);
}

class Ignore {
  final String? reason;
  const Ignore([this.reason]);
}

// Lowercase constant so existing '@ignore' annotations compile.
const ignore = Ignore();

// Minimal dummy Isar and Collection to satisfy migration helper when targeting web.
class Isar {
  Future<T> writeTxn<T>(Future<T> Function() fn) async => fn();
  Collection<T> collection<T>() => Collection<T>();
}

class Collection<T> {
  _QueryBuilder<T> where() => _QueryBuilder<T>();
  Future<void> putAll(List<T> items) async {}
}

class _QueryBuilder<T> {
  Future<List<T>> findAll() async => <T>[];
}
