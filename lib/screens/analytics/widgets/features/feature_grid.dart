// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../performance_analytics_controller.dart';
import '../dialogs/player_development_dialog.dart';
import '../dialogs/team_overview_dialog.dart';
import '../dialogs/training_effectiveness_dialog.dart';
import '../shared/analytics_loading_state.dart';

/// Feature Grid Widget - Main Analytics Navigation
///
/// Displays a 2x2 grid of feature cards that provide access to different analytics views:
/// - Speler Ontwikkeling (Player Development)
/// - Training Effectiviteit (Training Effectiveness)
/// - Team Overzicht (Team Overview)
/// - Skill Radar (Latest Assessment Radar)
///
/// Features:
/// - Responsive grid layout
/// - Loading state handling
/// - Dialog navigation
/// - Consistent Material Design theming
/// - Accessibility support
///
/// Part of the Clean Architecture refactor from 892 LOC performance_analytics_screen.dart
class FeatureGrid extends ConsumerWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(performanceAnalyticsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 Analytics Dashboard',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        switch (analyticsState) {
          AnalyticsLoading() => const AnalyticsLoadingState(),
          AnalyticsError(:final message) => _buildErrorState(context, message),
          AnalyticsLoaded() => _buildFeatureGrid(context, ref),
        },
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Fout bij laden van features',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _FeatureCard(
          title: 'Speler Ontwikkeling',
          subtitle: 'Top performers',
          icon: Icons.trending_up,
          color: Colors.blue,
          onTap: () => _showPlayerDevelopmentDialog(context, ref),
        ),
        _FeatureCard(
          title: 'Training Effectiviteit',
          subtitle: 'Hoogste opkomst',
          icon: Icons.fitness_center,
          color: Colors.green,
          onTap: () => _showTrainingEffectivenessDialog(context, ref),
        ),
        _FeatureCard(
          title: 'Team Overzicht',
          subtitle: 'Positie verdeling',
          icon: Icons.pie_chart,
          color: Colors.orange,
          onTap: () => _showTeamOverviewDialog(context, ref),
        ),
        _FeatureCard(
          title: 'Skill Radar',
          subtitle: 'Laatste assessment',
          icon: Icons.radar,
          color: Colors.red,
          onTap: () => _showSkillRadar(context, ref),
        ),
      ],
    );
  }

  void _showPlayerDevelopmentDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => const PlayerDevelopmentDialog(),
    );
  }

  void _showTrainingEffectivenessDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => const TrainingEffectivenessDialog(),
    );
  }

  void _showTeamOverviewDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => const TeamOverviewDialog(),
    );
  }

  void _showSkillRadar(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.read(performanceAnalyticsControllerProvider);

    if (analyticsState is AnalyticsLoaded) {
      final latestAssessment = analyticsState.latestAssessment;

      if (latestAssessment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Geen assessments gevonden.')),
        );
        return;
      }

      // Navigate to assessment detail screen
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => AssessmentDetailScreen(
            assessment: latestAssessment.assessment,
            player: latestAssessment.player,
          ),
        ),
      );
    }
  }
}

/// Individual Feature Card Widget
///
/// Reusable card component for feature navigation with:
/// - Icon with customizable color
/// - Title and subtitle text
/// - Tap handling
/// - Material Design elevation and theming
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Import for AssessmentDetailScreen - this will be resolved when dialogs are created
class AssessmentDetailScreen extends StatelessWidget {
  const AssessmentDetailScreen({
    super.key,
    required this.assessment,
    required this.player,
  });

  final dynamic assessment;
  final dynamic player;

  @override
  Widget build(BuildContext context) {
    // Placeholder - this should be replaced with actual assessment detail screen
    return Scaffold(
      appBar: AppBar(title: const Text('Assessment Detail')),
      body: const Center(
        child: Text('Assessment Detail Screen - To be implemented'),
      ),
    );
  }
}
