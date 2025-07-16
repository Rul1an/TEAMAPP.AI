// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';

class DistanceBarChart extends StatelessWidget {
  const DistanceBarChart({
    required this.distanceMeters,
    super.key,
  });

  final double distanceMeters;

  @override
  Widget build(BuildContext context) {
    final km = (distanceMeters / 1000).toStringAsFixed(2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
          child: BarChart(
            BarChartData(
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(
                    toY: distanceMeters,
                    width: 30,
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ]),
              ],
              titlesData: FlTitlesData(show: false),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(enabled: false),
              maxY: distanceMeters * 1.1, // little headroom
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('$km km', style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}