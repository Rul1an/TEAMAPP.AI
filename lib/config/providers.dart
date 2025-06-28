import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/club_provider.dart';
import '../providers/training_sessions_provider.dart';
import '../services/club_service.dart';
import '../services/feature_service.dart';

// Export all providers for easy access
export '../providers/organization_provider.dart';
export '../providers/demo_mode_provider.dart';
export '../providers/auth_provider.dart';

// Club service provider
final clubServiceProvider = Provider<ClubService>((ref) {
  return ClubService();
});

// Feature service provider
final featureServiceProvider = Provider<FeatureService>((ref) {
  return FeatureService();
});

// Club provider
final clubProvider = ChangeNotifierProvider<ClubProvider>((ref) {
  final clubService = ref.watch(clubServiceProvider);
  return ClubProvider(clubService: clubService);
});

// Calendar provider
final calendarProvider = ChangeNotifierProvider<CalendarProvider>((ref) {
  return CalendarProvider();
});

// Training sessions provider
final trainingSessionsProvider = ChangeNotifierProvider<TrainingSessionsProvider>((ref) {
  return TrainingSessionsProvider();
});

// Player tracking provider
final playerTrackingProvider = ChangeNotifierProvider<PlayerTrackingProvider>((ref) {
  return PlayerTrackingProvider();
});

// Calendar provider implementation
class CalendarProvider extends ChangeNotifier {
  final List<CalendarEvent> _events = [];

  List<CalendarEvent> get events => List.unmodifiable(_events);

  void addEvent(CalendarEvent event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String eventId) {
    _events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.date.year == date.year &&
             event.date.month == date.month &&
             event.date.day == date.day;
    }).toList();
  }
}

// Calendar event model
class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String? description;
  final String type; // 'training', 'match', 'meeting', etc.

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    required this.type,
  });
}

// Player tracking provider implementation
class PlayerTrackingProvider extends ChangeNotifier {
  final Map<String, PlayerPerformanceData> _performanceData = {};

  Map<String, PlayerPerformanceData> get performanceData =>
      Map.unmodifiable(_performanceData);

  void updatePlayerData(String playerId, PlayerPerformanceData data) {
    _performanceData[playerId] = data;
    notifyListeners();
  }
}

// Player performance data model
class PlayerPerformanceData {
  final String playerId;
  final DateTime date;
  final Map<String, double> metrics;

  PlayerPerformanceData({
    required this.playerId,
    required this.date,
    required this.metrics,
  });
}
