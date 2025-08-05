import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/annual_planning/season_plan.dart';
import '../../models/match.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/matches_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../screens/dashboard/dashboard_screen.dart';

/// Holds aggregated dashboard data and exposes [AsyncValue]s so the UI can
/// remain dumb. Rebuilds propagate only when underlying providers change.
class DashboardController extends ChangeNotifier {
  DashboardController(this._ref) {
    _init();
  }

  final Ref _ref;

  // Cached values -----------------------------------------------------------
  AsyncValue<SeasonPlan?> _season = const AsyncLoading();
  AsyncValue<Map<String, dynamic>> _statistics = const AsyncLoading();
  AsyncValue<List<Match>> _matches = const AsyncLoading();
  AsyncValue<List<TrainingSession>> _trainings = const AsyncLoading();

  AsyncValue<SeasonPlan?> get season => _season;
  AsyncValue<Map<String, dynamic>> get statistics => _statistics;
  AsyncValue<List<Match>> get upcomingMatches => _matches;
  AsyncValue<List<TrainingSession>> get upcomingTrainingSessions => _trainings;

  void _init() {
    // Listen to each provider; when it changes, cache and notify listeners.
    _ref.listen<AsyncValue<SeasonPlan?>>(dashboardSeasonProvider, (prev, next) {
      _season = next;
      notifyListeners();
    }, fireImmediately: true);

    _ref.listen<AsyncValue<Map<String, dynamic>>>(statisticsProvider,
        (prev, next) {
      _statistics = next;
      notifyListeners();
    }, fireImmediately: true);

    _ref.listen<AsyncValue<List<Match>>>(upcomingMatchesProvider, (prev, next) {
      _matches = next;
      notifyListeners();
    }, fireImmediately: true);

    _ref.listen<AsyncValue<List<TrainingSession>>>(
        dashboardTrainingSessionsProvider, (prev, next) {
      _trainings = next;
      notifyListeners();
    }, fireImmediately: true);
  }
}

/// Riverpod provider exposing the [DashboardController]. Auto-disposed so it
/// cleans up when dashboard screen is popped.
final dashboardControllerProvider = ChangeNotifierProvider<DashboardController>(
  DashboardController.new,
);
