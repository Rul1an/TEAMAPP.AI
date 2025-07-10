import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PerformanceChart extends StatelessWidget {
  const PerformanceChart({required this.statistics, super.key});

  final Map<String, dynamic> statistics;

  @override
  Widget build(BuildContext context) {
    final wins = statistics['wins'] as int;
    final draws = statistics['draws'] as int;
    final losses = statistics['losses'] as int;
    final total = wins + draws + losses;

    if (total == 0) {
      return Card(
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: const Center(child: Text('Nog geen wedstrijden gespeeld')),
        ),
      );
    }

    return Card(
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wedstrijd Resultaten',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: wins.toDouble(),
                            title: 'W: $wins',
                            color: Colors.green,
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: draws.toDouble(),
                            title: 'G: $draws',
                            color: Colors.orange,
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: losses.toDouble(),
                            title: 'V: $losses',
                            color: Colors.red,
                            radius: 60,
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem('Gewonnen', Colors.green, wins),
                      const SizedBox(height: 8),
                      _legendItem('Gelijk', Colors.orange, draws),
                      const SizedBox(height: 8),
                      _legendItem('Verloren', Colors.red, losses),
                      const Divider(height: 24),
                      Text(
                        'Doelpunten',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('Voor: ${statistics['goalsFor']}'),
                      Text('Tegen: ${statistics['goalsAgainst']}'),
                      Text('Saldo: ${statistics['goalDifference']}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color, int value) => Row(
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 4),
      Text('$label: $value'),
    ],
  );
}
