// ignore_for_file: always_put_required_named_parameters_first, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/annual_planning/morphocycle.dart';
import '../../services/load_monitoring_service.dart';

class IntensityDistributionChart extends StatelessWidget {
  const IntensityDistributionChart({super.key, required this.morphocycles});

  final List<Morphocycle> morphocycles;

  @override
  Widget build(BuildContext context) {
    if (morphocycles.isEmpty) return const SizedBox.shrink();

    final distribution = morphocycles.last.intensityDistribution;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Intensity Distribution (Current Week)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: distribution.entries.map((e) {
                    return PieChartSectionData(
                      color: LoadMonitoringService.intensityColor(e.key),
                      value: e.value,
                      title: '${e.value.toInt()}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: distribution.entries.map((e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: LoadMonitoringService.intensityColor(e.key),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${e.key.toUpperCase()}: ${e.value.toInt()}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
