// ignore_for_file: always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/annual_planning/morphocycle.dart';

class WeeklyLoadChart extends StatelessWidget {
  const WeeklyLoadChart({super.key, required this.morphocycles});

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
              'Weekly Training Load Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: morphocycles.isEmpty
                  ? const Center(child: Text('No data available'))
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(
                          horizontalInterval: 200,
                          verticalInterval: 2,
                        ),
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
                              reservedSize: 50,
                              interval: 200,
                              getTitlesWidget: (value, meta) => Text(
                                '${value.toInt()}',
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
                        maxY: 2000,
                        lineBarsData: [
                          LineChartBarData(
                            spots: morphocycles.asMap().entries.map((entry) {
                              return FlSpot(
                                entry.key.toDouble(),
                                entry.value.weeklyLoad,
                              );
                            }).toList(),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.blue,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
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
