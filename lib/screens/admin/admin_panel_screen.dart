// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/video_provider.dart';

/// 🎛️ Admin Panel Screen
/// Simplified admin panel for demo purposes
class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  String selectedTier = 'basic';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('🎛️ Admin Panel'),
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const _AdminStatusCard(),
              const SizedBox(height: 16),
              const _AdminInfoCard(),
              const SizedBox(height: 16),
              _VideoStorageCard(),
            ],
          ),
        ),
      );
}

class _AdminStatusCard extends StatelessWidget {
  const _AdminStatusCard();
  @override
  Widget build(BuildContext context) => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Admin Mode Actief',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text('Admin panel is beschikbaar voor configuratie.'),
            ],
          ),
        ),
      );
}

class _AdminInfoCard extends StatelessWidget {
  const _AdminInfoCard();
  @override
  Widget build(BuildContext context) => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎯 Admin Functies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• Feature management'),
              Text('• Tier configuratie'),
              Text('• System monitoring'),
              Text('• User management'),
            ],
          ),
        ),
      );
}

class _VideoStorageCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageAsync = ref.watch(videoStorageUsageProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: usageAsync.when(
          data: (bytes) {
            final gb = bytes / (1024 * 1024 * 1024);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.video_library, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Video Storage',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Totaal gebruikt: ${gb.toStringAsFixed(2)} GB'),
              ],
            );
          },
          loading: () => const SizedBox(
                height: 40,
                child: Center(child: CircularProgressIndicator()),
              ),
          error: (err, st) => Text('Fout bij ophalen: $err'),
        ),
      ),
    );
  }
}
