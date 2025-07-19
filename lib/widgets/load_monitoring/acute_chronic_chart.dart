// ignore_for_file: always_put_required_named_parameters_first, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/annual_planning/morphocycle.dart';
import '../../services/load_monitoring_service.dart';

class AcuteChronicChart extends StatelessWidget {
  const AcuteChronicChart({super.key, required this.morphocycles});

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
              'Acute:Chronic Workload Ratio',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sweet spot: 0.8 - 1.3 (Optimal adaptation zone)',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: morphocycles.isEmpty
                  ? const Center(child: Text('No data available'))
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(horizontalInterval: 0.2),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 2,
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
                              interval: 0.2,
                              getTitlesWidget: (value, meta) => Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        minX: 0,
                        maxX: (morphocycles.length - 1).toDouble(),
                        minY: 0,
                        maxY: 2,
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: 0.8,
                              dashArray: [5, 5],
                              color: Colors.green.withValues(alpha: 128),
                            ),
                            HorizontalLine(
                              y: 1.3,
                              dashArray: [5, 5],
                              color: Colors.green.withValues(alpha: 128),
                            ),
                          ],
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              for (int i = 0; i < morphocycles.length; i++)
                                FlSpot(
                                  i.toDouble(),
                                  morphocycles[i].acuteChronicRatio,
                                ),
                            ],
                            isCurved: true,
                            color: Colors.orange,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              getDotPainter: (spot, _, __, ___) =>
                                  FlDotCirclePainter(
                                radius: 4,
                                color: LoadMonitoringService.acrColor(
                                  spot.y,
                                ),
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
