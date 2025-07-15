// A simplistic in-memory import history manager. In production this should persist to Isar.

import 'package:uuid/uuid.dart';

import '../models/import_transaction.dart';
import '../core/result.dart';

class ImportHistoryService {
  static final ImportHistoryService instance = ImportHistoryService._();
  ImportHistoryService._();

  final _transactions = <ImportTransaction>[];
  final _uuid = const Uuid();

  ImportTransaction addTransaction({
    required String entityType,
    required List<String> createdIds,
    Map<String, String>? mergedIds,
  }) {
    final tx = ImportTransaction(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      entityType: entityType,
      createdIds: createdIds,
      mergedIds: mergedIds ?? {},
    );
    _transactions.add(tx);
    return tx;
  }

  ImportTransaction? get lastTransaction => _transactions.isNotEmpty ? _transactions.last : null;

  Future<Result<void>> undoLast({required Future<void> Function(ImportTransaction tx) rollback}) async {
    if (_transactions.isEmpty) {
      return const Failure(CacheFailure('Geen transactie om terug te draaien'));
    }
    final tx = _transactions.removeLast();
    try {
      await rollback(tx);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  List<ImportTransaction> get history => List.unmodifiable(_transactions);
}