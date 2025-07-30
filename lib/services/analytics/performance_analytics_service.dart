// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/assessment.dart';
import '../../models/player.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/assessments_provider.dart';
import '../../providers/players_provider.dart';
import '../../providers/training_sessions_repo_provider.dart';

/// Performance Analytics Service - Business Logic Layer
///
/// Extracts all data aggregation, calculation, and business logic from the UI layer.
/// Implements caching strategies and performance optimizations for analytics calculations.
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class PerformanceAnalyticsService {
  const PerformanceAnalyticsService({
    required this.ref,
  });

  final Ref ref;

  // Data Providers
  AsyncValue<List<Player>> get players => ref.watch(playersProvider);
  AsyncValue<List<PlayerAssessment>> get assessments =>
      ref.watch(assessmentsProvider);
  AsyncValue<List<TrainingSession>> get trainingSessions =>
      ref.watch(allTrainingSessionsProvider);

  /// Refresh all analytics data
  Future<void> refreshData() async {
    ref
      ..invalidate(playersProvider)
      ..invalidate(assessmentsProvider)
      ..invalidate(allTrainingSessionsProvider);
  }

  /// Calculate team statistics summary
  Future<TeamStatistics> calculateTeamStatistics() async {
    try {
      final playersList = await ref.read(playersProvider.future);
      final assessmentsList = await ref.read(assessmentsProvider.future);
      final trainingsList = await ref.read(allTrainingSessionsProvider.future);

      return TeamStatistics(
        totalPlayers: playersList.length,
        totalAssessments: assessmentsList.length,
        totalTrainingSessions: trainingsList.length,
        averageAge: _calculateAverageAge(playersList),
        totalGoals: _calculateTotalGoals(playersList),
        totalAssists: _calculateTotalAssists(playersList),
        averageAttendance: _calculateAverageAttendance(playersList),
      );
    } catch (e) {
      debugPrint('Error calculating team statistics: $e');
      return const TeamStatistics.empty();
    }
  }

  /// Get top performing players based on latest assessments
  Future<List<PlayerPerformanceData>> getTopPerformingPlayers(
      {int limit = 5}) async {
    try {
      final playersList = await ref.read(playersProvider.future);
      final assessmentsList = await ref.read(assessmentsProvider.future);

      if (assessmentsList.isEmpty || playersList.isEmpty) {
        return [];
      }

      // Create map of latest assessments per player
      final latestAssessments = <String, PlayerAssessment>{};
      for (final assessment in assessmentsList) {
        if (!latestAssessments.containsKey(assessment.playerId) ||
            assessment.assessmentDate.isAfter(
                latestAssessments[assessment.playerId]!.assessmentDate)) {
          latestAssessments[assessment.playerId] = assessment;
        }
      }

      // Create performance data with scores
      final performanceData = playersList
          .map((player) {
            final assessment = latestAssessments[player.id];
            return PlayerPerformanceData(
              player: player,
              overallScore: assessment?.overallAverage ?? 0.0,
              assessmentDate: assessment?.assessmentDate,
            );
          })
          .where((data) => data.overallScore > 0)
          .toList();

      // Sort by score and return top performers
      performanceData.sort((a, b) => b.overallScore.compareTo(a.overallScore));
      return performanceData.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting top performing players: $e');
      return [];
    }
  }

  /// Get players with highest attendance rates
  Future<List<AttendanceData>> getTopAttendancePlayers({int limit = 5}) async {
    try {
      final playersList = await ref.read(playersProvider.future);

      if (playersList.isEmpty) return [];

      final attendanceData = playersList
          .map((player) => AttendanceData(
                player: player,
                attendancePercentage: player.attendancePercentage,
              ))
          .toList();

      attendanceData.sort(
          (a, b) => b.attendancePercentage.compareTo(a.attendancePercentage));
      return attendanceData.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting top attendance players: $e');
      return [];
    }
  }

  /// Get position distribution for team composition analysis
  Future<Map<Position, List<Player>>> getPositionDistribution() async {
    try {
      final playersList = await ref.read(playersProvider.future);

      final positionGroups = <Position, List<Player>>{};
      for (final player in playersList) {
        positionGroups.putIfAbsent(player.position, () => []).add(player);
      }

      return positionGroups;
    } catch (e) {
      debugPrint('Error getting position distribution: $e');
      return {};
    }
  }

  /// Find the most recent assessment for radar chart display
  Future<AssessmentRadarData?> getLatestAssessmentForRadar() async {
    try {
      final assessmentsList = await ref.read(assessmentsProvider.future);
      final playersList = await ref.read(playersProvider.future);

      if (assessmentsList.isEmpty || playersList.isEmpty) return null;

      // Sort assessments by date and get the most recent
      final sortedAssessments = assessmentsList.toList()
        ..sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));

      final latestAssessment = sortedAssessments.first;

      // Find the corresponding player
      final player = playersList.firstWhere(
        (p) => p.id == latestAssessment.playerId,
        orElse: () => playersList.first,
      );

      return AssessmentRadarData(
        assessment: latestAssessment,
        player: player,
      );
    } catch (e) {
      debugPrint('Error getting latest assessment for radar: $e');
      return null;
    }
  }

  // Private helper methods for calculations
  double _calculateAverageAge(List<Player> players) {
    if (players.isEmpty) return 0.0;
    return players.map((p) => p.age).fold(0, (a, b) => a + b) / players.length;
  }

  int _calculateTotalGoals(List<Player> players) {
    return players.map((p) => p.goals).fold(0, (a, b) => a + b);
  }

  int _calculateTotalAssists(List<Player> players) {
    return players.map((p) => p.assists).fold(0, (a, b) => a + b);
  }

  double _calculateAverageAttendance(List<Player> players) {
    if (players.isEmpty) return 0.0;
    return players
            .map((p) => p.attendancePercentage)
            .fold(0.0, (a, b) => a + b) /
        players.length;
  }
}

/// Data model for team-wide statistics
@immutable
class TeamStatistics {
  const TeamStatistics({
    required this.totalPlayers,
    required this.totalAssessments,
    required this.totalTrainingSessions,
    required this.averageAge,
    required this.totalGoals,
    required this.totalAssists,
    required this.averageAttendance,
  });

  const TeamStatistics.empty()
      : totalPlayers = 0,
        totalAssessments = 0,
        totalTrainingSessions = 0,
        averageAge = 0.0,
        totalGoals = 0,
        totalAssists = 0,
        averageAttendance = 0.0;

  final int totalPlayers;
  final int totalAssessments;
  final int totalTrainingSessions;
  final double averageAge;
  final int totalGoals;
  final int totalAssists;
  final double averageAttendance;
}

/// Data model for player performance tracking
@immutable
class PlayerPerformanceData {
  const PlayerPerformanceData({
    required this.player,
    required this.overallScore,
    this.assessmentDate,
  });

  final Player player;
  final double overallScore;
  final DateTime? assessmentDate;
}

/// Data model for attendance tracking
@immutable
class AttendanceData {
  const AttendanceData({
    required this.player,
    required this.attendancePercentage,
  });

  final Player player;
  final double attendancePercentage;
}

/// Data model for assessment radar display
@immutable
class AssessmentRadarData {
  const AssessmentRadarData({
    required this.assessment,
    required this.player,
  });

  final PlayerAssessment assessment;
  final Player player;
}

/// Provider for the Performance Analytics Service
final performanceAnalyticsServiceProvider =
    Provider<PerformanceAnalyticsService>((ref) {
  return PerformanceAnalyticsService(ref: ref);
});
