// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../providers/auth_provider.dart';

class FanStatsScreen extends ConsumerWidget {
  const FanStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mijn Statistieken')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 72, color: Theme.of(context).primaryColor),
            const SizedBox(height: 24),
            Text(
              'Hallo ${user?.email ?? 'speler'}!\n\nDeze pagina toont binnenkort je persoonlijke statistieken.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}