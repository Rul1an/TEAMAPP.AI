import 'package:flutter/foundation.dart';
import '../models/training_session/training_session.dart';
import '../services/database_service.dart';

/// Provider for managing training sessions
class TrainingSessionsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<TrainingSession> _sessions = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<TrainingSession> get sessions => List.unmodifiable(_sessions);

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Public methods
  Future<void> loadSessions() async {
    _setLoading(true);
    _setError(null);

    try {
      final db = DatabaseService();
      _sessions = await db.getAllTrainingSessions();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createQuickTraining({
    String? id,
    required String name,
    required DateTime dateTime,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final session = TrainingSession.create(
        teamId: 'jo17-1',
        date: dateTime,
        trainingNumber:
            DateTime.now().millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24),
        type: TrainingType.technicalSession,
      );

      if (id != null) {
        session.id = id;
      }

      final db = DatabaseService();
      await db.saveTrainingSession(session);

      // Reload sessions
      await loadSessions();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveSession(TrainingSession session) async {
    _setLoading(true);
    _setError(null);

    try {
      final db = DatabaseService();
      await db.saveTrainingSession(session);
      await loadSessions();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    _setLoading(true);
    _setError(null);

    try {
      // Remove from local list
      _sessions.removeWhere((session) => session.id == sessionId);
      notifyListeners();

      // TODO(author): Implement actual deletion from database when available
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
