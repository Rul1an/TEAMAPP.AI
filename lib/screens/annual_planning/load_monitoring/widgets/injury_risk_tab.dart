// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../models/annual_planning/morphocycle.dart';
import '../../../../providers/annual_planning_provider.dart';
import '../../../../services/load_monitoring_service.dart';
import '../../../../widgets/load_monitoring/risk_summary_cards.dart';
import '../../../../widgets/load_monitoring/risk_factors_chart.dart';

class InjuryRiskTab extends StatelessWidget {
  const InjuryRiskTab({
    super.key,
    required this.state,
  });

  final AnnualPlanningState state;

  @override
  Widget build(BuildContext context) {
    final currentWeek = state.currentWeekNumber;
    final startWeek = (currentWeek - 4).clamp(1, state.totalWeeks);
    final endWeek = currentWeek.clamp(1, state.totalWeeks);

    final recentMorphocycles = <Morphocycle>[];
    for (var week = startWeek; week <= endWeek; week++) {
      final morphocycle = state.getMorphocycleForWeek(week);
      if (morphocycle != null) recentMorphocycles.add(morphocycle);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RiskSummaryCards(morphocycles: recentMorphocycles),
          const SizedBox(height: 24),
          RiskFactorsChart(morphocycles: recentMorphocycles),
          const SizedBox(height: 24),
          _buildRiskRecommendations(context, recentMorphocycles),
          const SizedBox(height: 24),
          _buildLoadZoneAnalysis(context, recentMorphocycles),
        ],
      ),
    );
  }

  Widget _buildRiskRecommendations(
    BuildContext context,
    List<Morphocycle> morphocycles,
  ) {
    if (morphocycles.isEmpty) return const SizedBox.shrink();

    final currentMorphocycle = morphocycles.last;
    final recommendations = _generateRiskRecommendations(
      currentMorphocycle,
      morphocycles,
    );

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Injury Prevention Recommendations',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: rec['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rec['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rec['description'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
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

  Widget _buildLoadZoneAnalysis(
    BuildContext context,
    List<Morphocycle> morphocycles,
  ) {
    if (morphocycles.isEmpty) return const SizedBox.shrink();

    final loadZones = {
      'Recovery Zone (<800 AU)':
          morphocycles.where((m) => m.weeklyLoad < 800).length,
      'Optimal Zone (800-1200 AU)': morphocycles
          .where((m) => m.weeklyLoad >= 800 && m.weeklyLoad <= 1200)
          .length,
      'High Load Zone (1200-1600 AU)': morphocycles
          .where((m) => m.weeklyLoad > 1200 && m.weeklyLoad <= 1600)
          .length,
      'Danger Zone (>1600 AU)':
          morphocycles.where((m) => m.weeklyLoad > 1600).length,
    };

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Load Zone Distribution (Last 4 Weeks)',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...loadZones.entries.map((entry) {
              final percentage = morphocycles.isNotEmpty
                  ? (entry.value / morphocycles.length * 100)
                  : 0.0;
              final color = LoadMonitoringService.loadZoneColor(entry.key);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${entry.value} weeks (${percentage.toInt()}%)',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateRiskRecommendations(
    Morphocycle current,
    List<Morphocycle> recent,
  ) {
    final recommendations = <Map<String, dynamic>>[];

    // High ACR recommendation
    if (current.acuteChronicRatio > 1.3) {
      recommendations.add({
        'title': 'Reduce Training Intensity',
        'description':
            'ACR is ${current.acuteChronicRatio.toStringAsFixed(2)}, above optimal range. Consider reducing volume by 20-30% next week.',
        'color': Colors.red,
      });
    }

    // Low ACR recommendation
    if (current.acuteChronicRatio < 0.8) {
      recommendations.add({
        'title': 'Gradual Load Increase',
        'description':
            'ACR is ${current.acuteChronicRatio.toStringAsFixed(2)}, below optimal range. Gradually increase training load.',
        'color': Colors.orange,
      });
    }

    // High load recommendation
    if (current.weeklyLoad > 1400) {
      recommendations.add({
        'title': 'Monitor Recovery',
        'description':
            'Weekly load is ${current.weeklyLoad.toInt()} AU. Ensure adequate recovery between sessions.',
        'color': Colors.red,
      });
    }

    // Consecutive high load weeks
    final highLoadWeeks = recent.where((m) => m.weeklyLoad > 1200).length;
    if (highLoadWeeks >= 3) {
      recommendations.add({
        'title': 'Schedule Recovery Week',
        'description':
            '$highLoadWeeks consecutive high-load weeks detected. Plan a recovery week to prevent overreaching.',
        'color': Colors.orange,
      });
    }

    // Optimal range recommendation
    if (current.acuteChronicRatio >= 0.8 &&
        current.acuteChronicRatio <= 1.3 &&
        current.weeklyLoad <= 1400) {
      recommendations.add({
        'title': 'Maintain Current Load',
        'description':
            'Training load and ACR are in optimal ranges. Continue current training approach.',
        'color': Colors.green,
      });
    }

    return recommendations;
  }
}
