// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/player.dart';
import '../../services/analytics/performance_analytics_service.dart';

/// Analytics State - Immutable state for performance analytics screen
@immutable
sealed class AnalyticsState {
  const AnalyticsState();
}

/// Initial loading state
class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

/// Error state with message
class AnalyticsError extends AnalyticsState {
  const AnalyticsError(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// Success state with all loaded data
class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded({
    required this.teamStats,
    required this.topPerformers,
    required this.topAttendance,
    required this.positionDistribution,
    required this.latestAssessment,
    this.isRefreshing = false,
  });

  final TeamStatistics teamStats;
  final List<PlayerPerformanceData> topPerformers;
  final List<AttendanceData> topAttendance;
  final Map<Position, List<Player>> positionDistribution;
  final AssessmentRadarData? latestAssessment;
  final bool isRefreshing;

  /// Create a copy with optional parameter updates
  AnalyticsLoaded copyWith({
    TeamStatistics? teamStats,
    List<PlayerPerformanceData>? topPerformers,
    List<AttendanceData>? topAttendance,
    Map<Position, List<Player>>? positionDistribution,
    AssessmentRadarData? latestAssessment,
    bool? isRefreshing,
  }) {
    return AnalyticsLoaded(
      teamStats: teamStats ?? this.teamStats,
      topPerformers: topPerformers ?? this.topPerformers,
      topAttendance: topAttendance ?? this.topAttendance,
      positionDistribution: positionDistribution ?? this.positionDistribution,
      latestAssessment: latestAssessment ?? this.latestAssessment,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsLoaded &&
          runtimeType == other.runtimeType &&
          teamStats == other.teamStats &&
          listEquals(topPerformers, other.topPerformers) &&
          listEquals(topAttendance, other.topAttendance) &&
          mapEquals(positionDistribution, other.positionDistribution) &&
          latestAssessment == other.latestAssessment &&
          isRefreshing == other.isRefreshing;

  @override
  int get hashCode =>
      teamStats.hashCode ^
      topPerformers.hashCode ^
      topAttendance.hashCode ^
      positionDistribution.hashCode ^
      latestAssessment.hashCode ^
      isRefreshing.hashCode;
}

/// Performance Analytics Controller - State Management Layer
///
/// Manages the state for the performance analytics screen using StateNotifier pattern.
/// Coordinates with the service layer for data operations and provides clean UI state.
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class PerformanceAnalyticsController extends StateNotifier<AnalyticsState> {
  PerformanceAnalyticsController({
    required this.analyticsService,
  }) : super(const AnalyticsLoading()) {
    _initialize();
  }

  final PerformanceAnalyticsService analyticsService;

  /// Initialize the controller and load initial data
  Future<void> _initialize() async {
    await loadAnalyticsData();
  }

  /// Load all analytics data
  Future<void> loadAnalyticsData() async {
    try {
      state = const AnalyticsLoading();

      // Load all data concurrently for better performance
      final results = await Future.wait([
        analyticsService.calculateTeamStatistics(),
        analyticsService.getTopPerformingPlayers(),
        analyticsService.getTopAttendancePlayers(),
        analyticsService.getPositionDistribution(),
        analyticsService.getLatestAssessmentForRadar(),
      ]);

      state = AnalyticsLoaded(
        teamStats: results[0] as TeamStatistics,
        topPerformers: results[1] as List<PlayerPerformanceData>,
        topAttendance: results[2] as List<AttendanceData>,
        positionDistribution: results[3] as Map<Position, List<Player>>,
        latestAssessment: results[4] as AssessmentRadarData?,
      );
    } catch (e, stackTrace) {
      debugPrint('Error loading analytics data: $e');
      debugPrint('Stack trace: $stackTrace');
      state = AnalyticsError('Fout bij laden van analytics data: ${e.toString()}');
    }
  }

  /// Refresh all analytics data
  Future<void> refreshData() async {
    final currentState = state;
    if (currentState is AnalyticsLoaded) {
      // Show refresh indicator on current data
      state = currentState.copyWith(isRefreshing: true);
    }

    try {
      // Refresh underlying data
      await analyticsService.refreshData();

      // Reload analytics data
      await loadAnalyticsData();
    } catch (e) {
      debugPrint('Error refreshing analytics data: $e');

      // If we had loaded data, restore it without refresh indicator
      if (currentState is AnalyticsLoaded) {
        state = currentState.copyWith(isRefreshing: false);
      } else {
        state = AnalyticsError('Fout bij verversen van data: ${e.toString()}');
      }
    }
  }

  /// Handle feature navigation actions
  Future<void> handleFeatureAction(AnalyticsFeature feature) async {
    switch (feature) {
      case AnalyticsFeature.playerDevelopment:
        await _handlePlayerDevelopment();
        break;
      case AnalyticsFeature.trainingEffectiveness:
        await _handleTrainingEffectiveness();
        break;
      case AnalyticsFeature.teamOverview:
        await _handleTeamOverview();
        break;
      case AnalyticsFeature.skillRadar:
        await _handleSkillRadar();
        break;
    }
  }

  Future<void> _handlePlayerDevelopment() async {
    // This will be handled by the dialog widget
    debugPrint('Player development dialog requested');
  }

  Future<void> _handleTrainingEffectiveness() async {
    // This will be handled by the dialog widget
    debugPrint('Training effectiveness dialog requested');
  }

  Future<void> _handleTeamOverview() async {
    // This will be handled by the dialog widget
    debugPrint('Team overview dialog requested');
  }

  Future<void> _handleSkillRadar() async {
    // This will be handled by navigation to assessment detail screen
    debugPrint('Skill radar navigation requested');
  }

  /// Get attendance color based on percentage
  static Color getAttendanceColor(double percentage) {
    if (percentage >= 85) return const Color(0xFF4CAF50); // Green
    if (percentage >= 70) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  /// Get position color for charts
  static Color getPositionColor(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return const Color(0xFFFF9800); // Orange
      case Position.defender:
        return const Color(0xFF2196F3); // Blue
      case Position.midfielder:
        return const Color(0xFF4CAF50); // Green
      case Position.forward:
        return const Color(0xFFF44336); // Red
    }
  }

}

/// Analytics feature enumeration for navigation
enum AnalyticsFeature {
  playerDevelopment,
  trainingEffectiveness,
  teamOverview,
  skillRadar,
}

/// Provider for the Performance Analytics Controller
final performanceAnalyticsControllerProvider =
    StateNotifierProvider<PerformanceAnalyticsController, AnalyticsState>((ref) {
  final analyticsService = ref.watch(performanceAnalyticsServiceProvider);
  return PerformanceAnalyticsController(analyticsService: analyticsService);
});

/// Convenience provider for easy access to loaded state
final analyticsLoadedStateProvider = Provider<AnalyticsLoaded?>((ref) {
  final state = ref.watch(performanceAnalyticsControllerProvider);
  return state is AnalyticsLoaded ? state : null;
});
