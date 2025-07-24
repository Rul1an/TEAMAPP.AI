import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FanHomeScreen extends StatelessWidget {
  const FanHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: const [
            _DashboardCard(
              label: 'Training',
              icon: Icons.fitness_center,
              route: '/training',
            ),
            _DashboardCard(
              label: 'Matches',
              icon: Icons.sports_soccer,
              route: '/matches',
            ),
            _DashboardCard(
              label: 'Players',
              icon: Icons.group,
              route: '/players',
            ),
            _DashboardCard(
              label: 'Agenda',
              icon: Icons.event,
              route: '/calendar',
            ),
            _DashboardCard(
              label: 'My Stats',
              icon: Icons.bar_chart,
              route: '/my-stats',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.label,
    required this.icon,
    required this.route,
  });
  final String label;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.go(route),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 48, color: Theme.of(context).colorScheme.primary,),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
