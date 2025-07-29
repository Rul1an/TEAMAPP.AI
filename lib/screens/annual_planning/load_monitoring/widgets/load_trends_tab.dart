// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../models/annual_planning/morphocycle.dart';
import '../../../../providers/annual_planning_provider.dart';
import '../../../../services/load_monitoring_service.dart';
import '../../../../widgets/load_monitoring/load_summary_cards.dart';
import '../../../../widgets/load_monitoring/weekly_load_chart.dart';
import '../../../../widgets/load_monitoring/acute_chronic_chart.dart';
import '../../../../widgets/load_monitoring/intensity_distribution_chart.dart';

class LoadTrendsTab extends StatelessWidget {
  const LoadTrendsTab({
    super.key,
    required this.state,
    required this.selectedWeekRange,
  });

  final AnnualPlanningState state;
  final int selectedWeekRange;

  @override
  Widget build(BuildContext context) {
    final currentWeek = state.currentWeekNumber;
    final startWeek = (currentWeek - selectedWeekRange).clamp(
      1,
      state.totalWeeks,
    );
    final endWeek = currentWeek.clamp(1, state.totalWeeks);

    final morphocycles = <Morphocycle>[];
    for (var week = startWeek; week <= endWeek; week++) {
      final morphocycle = state.getMorphocycleForWeek(week);
      if (morphocycle != null) morphocycles.add(morphocycle);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadSummaryCards(morphocycles: morphocycles),
          const SizedBox(height: 24),
          WeeklyLoadChart(morphocycles: morphocycles),
          const SizedBox(height: 24),
          AcuteChronicChart(morphocycles: morphocycles),
          const SizedBox(height: 24),
          IntensityDistributionChart(morphocycles: morphocycles),
          const SizedBox(height: 24),
          _buildCurrentMorphocycleCard(context, state),
        ],
      ),
    );
  }

  Widget _buildCurrentMorphocycleCard(
    BuildContext context,
    AnnualPlanningState state,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Huidige Morfocycle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (state.currentMorphocycle != null) ...[
              _buildMorphocycleInfo(state.currentMorphocycle!),
            ] else ...[
              const Text(
                'Geen morfocycle data beschikbaar',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMorphocycleInfo(Morphocycle morphocycle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Week ${morphocycle.weekNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      LoadMonitoringService.loadColor(morphocycle.weeklyLoad),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${morphocycle.weeklyLoad.toInt()} AU',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.sports_soccer, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Focus: ${morphocycle.primaryGameModelFocus}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.trending_up, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Verwachte Adaptatie: ${morphocycle.expectedAdaptation.toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                LoadMonitoringService.acwRIcon(morphocycle.acuteChronicRatio),
                size: 16,
                color: LoadMonitoringService.acwrColor(
                  morphocycle.acuteChronicRatio,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Belasting Ratio: ${morphocycle.acuteChronicRatio.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: LoadMonitoringService.acwrColor(
                    morphocycle.acuteChronicRatio,
                  ),
                ),
              ),
            ],
          ),
          if (morphocycle.tacticalFocusAreas.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Tactische Focus Areas:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: morphocycle.tacticalFocusAreas
                  .map(
                    (area) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        area,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
