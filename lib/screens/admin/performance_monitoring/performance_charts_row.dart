import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Row with Memory Usage bar chart and Request Distribution pie chart.
/// Extracted from PerformanceMonitoringScreen to reduce file size.
class PerformanceChartsRow extends StatelessWidget {
  const PerformanceChartsRow({super.key});

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Expanded(child: _MemoryUsageCard()),
          SizedBox(width: 16),
          Expanded(child: _RequestDistributionCard()),
        ],
      );
}

class _MemoryUsageCard extends StatelessWidget {
  const _MemoryUsageCard();

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Memory Usage',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [BarChartRodData(toY: 65, color: Colors.blue)],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [BarChartRodData(toY: 72, color: Colors.blue)],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [BarChartRodData(toY: 58, color: Colors.blue)],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(toY: 81, color: Colors.orange),
                        ],
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

class _RequestDistributionCard extends StatelessWidget {
  const _RequestDistributionCard();

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 45,
                        title: 'API',
                        color: Colors.blue,
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 30,
                        title: 'WEB',
                        color: Colors.orange,
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: 25,
                        title: 'DB',
                        color: Colors.green,
                        radius: 40,
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
