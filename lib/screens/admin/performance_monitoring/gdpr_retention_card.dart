// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../providers/gdpr_retention_provider.dart';

class GdprRetentionCard extends ConsumerStatefulWidget {
  const GdprRetentionCard({super.key});

  @override
  ConsumerState<GdprRetentionCard> createState() => _GdprRetentionCardState();
}

class _GdprRetentionCardState extends ConsumerState<GdprRetentionCard> {
  bool _isRunning = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _run({required bool dryRun}) async {
    setState(() {
      _isRunning = true;
      _error = null;
    });
    try {
      final svc = ref.read(gdprRetentionServiceProvider);
      final res = await svc.run(dryRun: dryRun);
      setState(() => _result = res);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = (_result?['items'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final ok = _result?['ok'] == true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.policy),
                const SizedBox(width: 8),
                Text(
                  'GDPR/Dataretentie – Purge',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _isRunning ? null : () => _run(dryRun: true),
                  icon: const Icon(Icons.visibility),
                  label: const Text('Dry-run'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isRunning ? null : () => _run(dryRun: false),
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Purge'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isRunning) const LinearProgressIndicator(),
            if (_error != null) ...[
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            ] else if (_result != null) ...[
              Text(ok ? 'OK' : 'Failed',
                  style: TextStyle(color: ok ? Colors.green : Colors.red)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map((e) => Chip(
                          label: Text(
                              '${e['entity'] ?? e['table']}: ${e['affected']} (ttl=${e['ttl_days']}, dry=${e['dry_run']})'),
                        ))
                    .toList(),
              ),
            ] else ...[
              const Text(
                  'Run een dry-run om te zien wat er opgeschoond wordt.'),
            ],
          ],
        ),
      ),
    );
  }
}
