// ignore_for_file: always_put_required_named_parameters_first, require_trailing_commas

import 'package:flutter/material.dart';

import '../../models/annual_planning/morphocycle.dart';
import '../../services/load_monitoring_service.dart';

class RiskSummaryCards extends StatelessWidget {
  const RiskSummaryCards({super.key, required this.morphocycles});

  final List<Morphocycle> morphocycles;

  @override
  Widget build(BuildContext context) {
    if (morphocycles.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No data available for risk analysis'),
        ),
      );
    }

    final current = morphocycles.last;
    final avgAcr =
        morphocycles.fold<double>(0, (sum, m) => sum + m.acuteChronicRatio) /
        morphocycles.length;

    final highRiskWeeks = morphocycles
        .where(
          (m) =>
              m.currentInjuryRisk == InjuryRisk.high ||
              m.currentInjuryRisk == InjuryRisk.extreme,
        )
        .length;
    final overloadWeeks = morphocycles.where((m) => m.weeklyLoad > 1400).length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _RiskCard(
                title: 'Current Risk',
                value: current.currentInjuryRisk.name.toUpperCase(),
                color: LoadMonitoringService.riskColor(
                  current.currentInjuryRisk,
                ),
                icon: LoadMonitoringService.riskIcon(current.currentInjuryRisk),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RiskCard(
                title: 'Avg ACR (4 weeks)',
                value: avgAcr.toStringAsFixed(2),
                color: LoadMonitoringService.acrColor(avgAcr),
                icon: Icons.trending_up,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RiskCard(
                title: 'High Risk Weeks',
                value: '$highRiskWeeks/4',
                color: highRiskWeeks > 1 ? Colors.red : Colors.green,
                icon: Icons.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RiskCard(
                title: 'Overload Weeks',
                value: '$overloadWeeks/4',
                color: overloadWeeks > 2 ? Colors.red : Colors.green,
                icon: Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 25), color.withValues(alpha: 10)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
