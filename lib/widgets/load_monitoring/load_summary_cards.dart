// ignore_for_file: always_put_required_named_parameters_first

import 'package:flutter/material.dart';

import '../../models/annual_planning/morphocycle.dart';
import '../../services/load_monitoring_service.dart';

class LoadSummaryCards extends StatelessWidget {
  const LoadSummaryCards({super.key, required this.morphocycles});

  final List<Morphocycle> morphocycles;

  @override
  Widget build(BuildContext context) {
    if (morphocycles.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No morphocycle data available'),
        ),
      );
    }

    final currentLoad = LoadMonitoringService.getCurrentLoad(morphocycles);
    final averageLoad = LoadMonitoringService.getAverageLoad(morphocycles);
    final maxLoad = LoadMonitoringService.getPeakLoad(morphocycles);
    final currentAcr = LoadMonitoringService.getCurrentAcr(morphocycles);

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Current Load',
            value: '${currentLoad.toInt()}',
            unit: 'AU',
            color: LoadMonitoringService.loadColor(currentLoad),
            icon: Icons.fitness_center,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Average Load',
            value: '${averageLoad.toInt()}',
            unit: 'AU',
            color: Colors.blue,
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'Peak Load',
            value: '$maxLoad',
            unit: 'AU',
            color: Colors.red,
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: 'ACR',
            value: currentAcr.toStringAsFixed(2),
            unit: 'Ratio',
            color: LoadMonitoringService.acrColor(currentAcr),
            icon: Icons.warning,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
