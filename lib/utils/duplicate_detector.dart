// A generic duplicate detector that prevents processing of duplicate items.
//
// The detector maintains an in-memory set of hashes. An item is considered a
// duplicate when its hash is **already present** in the set. You can optionally
// seed the detector with pre-existing hashes (e.g. from the database) to catch
// duplicates across application restarts.
//
// Usage example for `Player`:
// ```dart
// final existingHashes = players.map(playerHash).toSet();
// final detector = DuplicateDetector<String>(initialHashes: existingHashes);
//
// if (detector.isDuplicate(playerHash(newPlayer))) {
//   // skip or merge
// }
// ```
//
// Best-practice 2025 notes:
// • Keep the detector **stateless** outside of the hash-set to enable easy
//   disposal and testing.
// • Provide type safety via generics.
// • Expose a read-only view of the seen hashes for debugging/analytics.

class DuplicateDetector<T> {
  DuplicateDetector({Iterable<T>? initialHashes}) {
    if (initialHashes != null) _seen.addAll(initialHashes);
  }

  final Set<T> _seen = <T>{};

  /// Returns `true` if [value] is a duplicate (already seen) **and** does NOT
  /// add the value to the set. Returns `false` when the value has not been
  /// seen before – in that case it will be added to the set.
  bool isDuplicate(T value) {
    if (_seen.contains(value)) return true;
    _seen.add(value);
    return false;
  }

  /// Exposes the internal set for read-only purposes.
  Set<T> get seenValues => Set.unmodifiable(_seen);

  /// Clears the internal state.
  void clear() => _seen.clear();
}