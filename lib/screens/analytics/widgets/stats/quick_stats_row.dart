// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../../services/analytics/performance_analytics_service.dart';
import '../../performance_analytics_controller.dart';

/// Quick Stats Row Widget - Team Statistics Overview
///
/// Displays key team metrics in a horizontal row of cards:
/// - Total Players count
/// - Total Assessments count
/// - Total Training Sessions count
///
/// Features:
/// - Loading state handling
/// - Error state handling
/// - Responsive design
/// - Consistent theming
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class QuickStatsRow extends ConsumerWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(performanceAnalyticsControllerProvider);

    return switch (analyticsState) {
      AnalyticsLoading() => _buildLoadingState(),
      AnalyticsError(:final message) => _buildErrorState(context, message),
      AnalyticsLoaded(:final teamStats) =>
        _buildLoadedState(context, teamStats),
    };
  }

  Widget _buildLoadingState() {
    return const Row(
      children: [
        Expanded(child: _StatCard.loading()),
        SizedBox(width: 12),
        Expanded(child: _StatCard.loading()),
        SizedBox(width: 12),
        Expanded(child: _StatCard.loading()),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                  ),
                  Text(
                    'Data laden mislukt',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(BuildContext context, TeamStatistics teamStats) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people,
            iconColor: Colors.blue,
            value: teamStats.totalPlayers.toString(),
            label: 'Spelers',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.assessment,
            iconColor: Colors.green,
            value: teamStats.totalAssessments.toString(),
            label: 'Beoordelingen',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.sports,
            iconColor: Colors.orange,
            value: teamStats.totalTrainingSessions.toString(),
            label: 'Trainingen',
          ),
        ),
      ],
    );
  }
}

/// Individual Stat Card Widget
///
/// Reusable card component for displaying a single statistic with:
/// - Icon with customizable color
/// - Large numeric value
/// - Descriptive label
/// - Loading state support
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  const _StatCard.loading()
      : icon = Icons.hourglass_empty,
        iconColor = Colors.grey,
        value = '...',
        label = 'Laden...';

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
