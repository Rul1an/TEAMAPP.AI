import 'package:flutter/material.dart';
import '../../models/statistics.dart';

/// 2025 Best Practice: Type-safe Statistics Card Widget
class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 2025 Best Practice: Statistics Grid Widget with full type safety
class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({
    required this.statistics,
    super.key,
  });

  final Statistics statistics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        final childAspectRatio = constraints.maxWidth > 800 ? 1.5 : 1.2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            StatisticsCard(
              title: 'Spelers',
              value: statistics.totalPlayers.toString(),
              icon: Icons.people,
              color: Colors.blue,
              subtitle:
                  statistics.totalPlayers == 0 ? 'Voeg spelers toe' : null,
            ),
            StatisticsCard(
              title: 'Wedstrijden',
              value: statistics.totalMatches.toString(),
              icon: Icons.sports_soccer,
              color: Colors.green,
              subtitle: statistics.totalMatches == 0
                  ? 'Nog geen wedstrijden'
                  : '${statistics.totalWins}W ${statistics.totalDraws}G ${statistics.totalLosses}V',
            ),
            StatisticsCard(
              title: 'Trainingen',
              value: statistics.totalTrainings.toString(),
              icon: Icons.fitness_center,
              color: Colors.orange,
              subtitle: statistics.attendanceRate > 0
                  ? 'Aanwezigheid: ${statistics.attendanceRateFormatted}'
                  : null,
            ),
            StatisticsCard(
              title: 'Win %',
              value: statistics.winPercentageFormatted,
              icon: Icons.emoji_events,
              color: _getWinPercentageColor(statistics.winPercentage),
              subtitle: statistics.totalMatches > 0
                  ? '${statistics.avgGoalsForFormatted} - ${statistics.avgGoalsAgainstFormatted} gem.'
                  : 'Speel eerste wedstrijd',
            ),
          ],
        );
      },
    );
  }

  /// 2025 Best Practice: Color-coded win percentage indicator
  Color _getWinPercentageColor(double winPercentage) {
    if (winPercentage >= 70) return Colors.green;
    if (winPercentage >= 50) return Colors.amber;
    if (winPercentage >= 30) return Colors.orange;
    return Colors.red;
  }
}

/// 2025 Best Practice: Loading state for statistics
class StatisticsLoadingGrid extends StatelessWidget {
  const StatisticsLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
        final childAspectRatio = constraints.maxWidth > 800 ? 1.5 : 1.2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(
            4,
            (index) => const Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Laden...'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 2025 Best Practice: Error state for statistics
class StatisticsErrorGrid extends StatelessWidget {
  const StatisticsErrorGrid({
    required this.error,
    this.onRetry,
    super.key,
  });

  final String error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Kon statistieken niet laden',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Probeer opnieuw'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
