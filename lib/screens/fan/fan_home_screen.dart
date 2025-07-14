// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../providers/auth_provider.dart';
import '../../services/permission_service.dart';

class FanHomeScreen extends ConsumerWidget {
  const FanHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final spacing = isTablet ? 24.0 : 16.0;

    final userRole = ref.watch(userRoleProvider);
    final isViewOnly = PermissionService.isViewOnlyUser(userRole);

    final cards = _HomeCard.values;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')), // Minimal top bar
      body: GridView.builder(
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 1,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildCard(context, card, isViewOnly);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, _HomeCard type, bool isViewOnly) {
    IconData icon;
    String label;
    String route;

    switch (type) {
      case _HomeCard.dashboard:
        icon = Icons.dashboard;
        label = 'Overzicht';
        route = '/dashboard';
      case _HomeCard.training:
        icon = Icons.fitness_center;
        label = 'Trainingen';
        route = '/training';
      case _HomeCard.matches:
        icon = Icons.stadium;
        label = 'Wedstrijden';
        route = '/matches';
      case _HomeCard.players:
        icon = Icons.people;
        label = 'Spelers';
        route = '/players';
      case _HomeCard.stats:
        icon = Icons.bar_chart;
        label = 'Mijn Statistieken';
        route = '/my-stats';
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(route),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

enum _HomeCard { dashboard, training, matches, players, stats }