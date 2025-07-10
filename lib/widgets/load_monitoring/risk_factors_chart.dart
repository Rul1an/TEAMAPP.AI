// ignore_for_file: always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/annual_planning/morphocycle.dart';
import '../../services/load_monitoring_service.dart';

class RiskFactorsChart extends StatelessWidget {
  const RiskFactorsChart({super.key, required this.morphocycles});

  final List<Morphocycle> morphocycles;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Injury Risk Factors Over Time',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: morphocycles.isEmpty
                  ? const Center(child: Text('No data available'))
                  : LineChart(_buildData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildData() {
    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < morphocycles.length) {
                return Text(
                  'W${morphocycles[index].weekNumber}',
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < morphocycles.length; i++)
              FlSpot(i.toDouble(), morphocycles[i].acuteChronicRatio),
          ],
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(
            getDotPainter: (spot, _, __, ___) {
              final risk = Morphocycle.assessInjuryRisk(spot.y);
              return FlDotCirclePainter(
                radius: 5,
                color: LoadMonitoringService.riskColor(risk),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 0.8,
            color: Colors.green.withValues(alpha: 128),
            dashArray: [5, 5],
          ),
          HorizontalLine(
            y: 1.3,
            color: Colors.orange.withValues(alpha: 128),
            dashArray: [5, 5],
          ),
          HorizontalLine(
            y: 1.5,
            color: Colors.red.withValues(alpha: 128),
            dashArray: [5, 5],
          ),
        ],
      ),
    );
  }
}
