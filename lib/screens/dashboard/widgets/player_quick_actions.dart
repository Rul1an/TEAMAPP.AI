import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Card with quick action buttons shown on the player dashboard.
class PlayerQuickActions extends StatelessWidget {
  const PlayerQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mijn Acties',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _actionCard(
                  context,
                  title: 'Mijn Profiel',
                  icon: Icons.person,
                  onTap: () => context.go('/players'),
                ),
                _actionCard(
                  context,
                  title: 'Prestaties',
                  icon: Icons.analytics,
                  onTap: () => context.go('/analytics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) =>
      Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
