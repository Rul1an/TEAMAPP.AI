// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../services/telemetry_service.dart';

class PerformanceTelemetryStatusCard extends StatelessWidget {
  const PerformanceTelemetryStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final telemetry = TelemetryService();
    final enabled = telemetry.isEnabled;
    final attrs = telemetry.resourceAttributes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(enabled ? Icons.cloud_done : Icons.cloud_off,
                    color: enabled ? Colors.green : Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'OpenTelemetry Status',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: enabled
                      ? () async {
                          await telemetry.ping();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Ping span verzonden')),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.wifi_tethering),
                  label: const Text('Ping'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: attrs.entries
                  .map((e) => Chip(
                        label: Text('${e.key}: ${e.value}'),
                      ))
                  .toList(),
            ),
            if (!enabled) ...[
              const SizedBox(height: 12),
              const Text(
                'OTLP niet geconfigureerd. Stel OTLP_ENDPOINT in om te activeren.',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
