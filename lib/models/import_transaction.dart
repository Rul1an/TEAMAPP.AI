class ImportTransaction<T> {
  ImportTransaction({required this.items});

  /// Imported items (e.g. Player instances).
  final List<T> items;

  /// Timestamp of the transaction.
  final DateTime timestamp = DateTime.now();
}