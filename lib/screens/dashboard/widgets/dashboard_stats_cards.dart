import 'package:flutter/material.dart';

class DashboardStatsCards extends StatelessWidget {
  const DashboardStatsCards({required this.statistics, super.key});

  final Map<String, dynamic> statistics;

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
            _StatCard(
              title: 'Spelers',
              value: statistics['totalPlayers'].toString(),
              icon: Icons.people,
              color: Colors.blue,
            ),
            _StatCard(
              title: 'Wedstrijden',
              value: statistics['totalMatches'].toString(),
              icon: Icons.sports_soccer,
              color: Colors.green,
            ),
            _StatCard(
              title: 'Trainingen',
              value: statistics['totalTrainings'].toString(),
              icon: Icons.fitness_center,
              color: Colors.orange,
            ),
            _StatCard(
              title: 'Win %',
              value: '${statistics['winPercentage'].toStringAsFixed(1)}%',
              icon: Icons.emoji_events,
              color: Colors.amber,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
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
                style: Theme.of(
                  context,
                )
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ],
          ),
        ),
      );
}
