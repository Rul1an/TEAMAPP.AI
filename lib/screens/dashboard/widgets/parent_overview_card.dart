import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentOverviewCard extends StatelessWidget {
  const ParentOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overzicht van uw kind',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Spelersinformatie'),
              subtitle: const Text('Bekijk profiel en prestaties'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/players'),
            ),
          ],
        ),
      ),
    );
  }
}
