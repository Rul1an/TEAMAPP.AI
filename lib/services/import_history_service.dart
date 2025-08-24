import 'package:flutter/foundation.dart';

import '../models/import_transaction.dart';

/// Singleton service that stores a stack of import transactions so they can
/// be undone (rolled back).
class ImportHistoryService with ChangeNotifier {
  ImportHistoryService._internal();

  static final ImportHistoryService _instance = ImportHistoryService._internal();

  /// Global history instance.
  static ImportHistoryService get instance => _instance;

  // Internal stack (LIFO) – newest import last.
  final List<ImportTransaction<dynamic>> _stack = [];

  List<ImportTransaction<dynamic>> get transactions => List.unmodifiable(_stack);

  /// Push a new transaction onto the stack.
  void push<T>(ImportTransaction<T> tx) {
    _stack.add(tx);
    notifyListeners();
  }

  /// Pop the latest transaction. Returns `null` if the stack is empty.
  ImportTransaction<dynamic>? undo() {
    if (_stack.isEmpty) return null;
    final tx = _stack.removeLast();
    notifyListeners();
    return tx;
  }

  bool get canUndo => _stack.isNotEmpty;

  void clear() {
    _stack.clear();
    notifyListeners();
  }
}