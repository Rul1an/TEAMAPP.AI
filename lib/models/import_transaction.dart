// Model to track an import action for undo capability.

class ImportTransaction {
  ImportTransaction({
    required this.id,
    required this.timestamp,
    required this.entityType,
    required this.createdIds,
    required this.mergedIds,
  });

  final String id;
  final DateTime timestamp;
  final String entityType; // e.g. 'player', 'match', 'training'
  final List<String> createdIds; // ids inserted in this import
  final Map<String, String> mergedIds; // duplicateId -> keptId
}