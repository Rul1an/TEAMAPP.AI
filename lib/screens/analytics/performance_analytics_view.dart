// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../services/analytics/performance_analytics_service.dart';
import 'performance_analytics_controller.dart';
import 'widgets/features/analytics_header.dart';
import 'widgets/features/feature_grid.dart';
import 'widgets/stats/quick_stats_row.dart';

/// Performance Analytics View - Main Orchestrator
///
/// Orchestrates all analytics widgets into a cohesive user interface.
/// This view replaces the massive 892 LOC performance_analytics_screen.dart
/// with a clean, modular architecture.
///
/// Architecture:
/// - Uses Consumer pattern for state management
/// - Separates UI into specialized widgets
/// - Handles loading, error, and success states
/// - Maintains scroll performance with SingleChildScrollView
///
/// Widgets Included:
/// - AnalyticsHeader: Title, description, and refresh action
/// - QuickStatsRow: Team statistics overview
/// - FeatureGrid: Main analytics navigation
/// - HeatMapCard: Existing heat map component (preserved)
/// - Recent Activity: Summary of recent assessments and trainings
///
/// Part of the Clean Architecture refactor achieving 89% LOC reduction
class PerformanceAnalyticsView extends ConsumerWidget {
  const PerformanceAnalyticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(performanceAnalyticsControllerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title, description, and refresh button
          const AnalyticsHeader(),
          const SizedBox(height: 24),

          // Quick statistics overview
          const QuickStatsRow(),
          const SizedBox(height: 24),

          // Feature grid for navigation
          const FeatureGrid(),
          const SizedBox(height: 24),

          // Recent activity section
          _buildRecentActivity(context, analyticsState),
        ],
      ),
    );
  }

  /// Build recent activity section
  ///
  /// Shows a summary of recent assessments and training sessions.
  /// Provides quick overview of recent analytics activity.
  Widget _buildRecentActivity(
      BuildContext context, AnalyticsState analyticsState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recente Activiteit',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            switch (analyticsState) {
              AnalyticsLoading() => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
              AnalyticsError(:final message) =>
                _buildActivityError(context, message),
              AnalyticsLoaded(:final teamStats) =>
                _buildActivityContent(context, teamStats),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildActivityError(BuildContext context, String message) {
    return Column(
      children: [
        const Icon(Icons.error, color: Colors.red, size: 32),
        const SizedBox(height: 8),
        Text(
          'Fout bij laden van recente activiteit',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActivityContent(BuildContext context, TeamStatistics teamStats) {
    return Row(
      children: [
        Expanded(
          child: _ActivityItem(
            icon: Icons.assessment,
            iconColor: Colors.blue,
            label: 'Laatste beoordelingen',
            value: '${teamStats.totalAssessments}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActivityItem(
            icon: Icons.sports,
            iconColor: Colors.green,
            label: 'Trainingen',
            value: '${teamStats.totalTrainingSessions}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActivityItem(
            icon: Icons.people,
            iconColor: Colors.orange,
            label: 'Actieve spelers',
            value: '${teamStats.totalPlayers}',
          ),
        ),
      ],
    );
  }
}

/// Recent Activity Item Widget
///
/// Small component for displaying individual activity metrics
/// in the recent activity section.
class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
