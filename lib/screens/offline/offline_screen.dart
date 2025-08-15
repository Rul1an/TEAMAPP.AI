// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../providers/connectivity_status_provider.dart';

class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConn = ref.watch(connectivityStatusProvider);
    final bool isOnline =
        asyncConn.maybeWhen(data: (v) => v, orElse: () => true);

    return Scaffold(
      appBar: AppBar(title: const Text('Offline')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Geen internetverbinding',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Controleer je verbinding. Je kunt beperkte content offline bekijken.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  // Trigger a refresh of the provider by re-watching; router guards will handle navigation
                  ref.invalidate(connectivityStatusProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Opnieuw proberen'),
              ),
              if (isOnline) ...[
                const SizedBox(height: 12),
                const Text('Verbinding hersteld — ga verder in de app.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
