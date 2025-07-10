// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';

// Project imports:
import '../../models/assessment.dart';
import '../../models/player.dart';

class PlayerRadarChartScreen extends StatelessWidget {
  const PlayerRadarChartScreen({
    required this.player,
    required this.assessment,
    super.key,
  });
  final Player player;
  final PlayerAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final radarData = _prepareRadarData();

    return Scaffold(
      appBar: AppBar(
        title: Text('${player.name} - Skill Radar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skill Profiel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Visuele weergave van de gemiddelde scores per vaardigheidscategorie.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 300,
                      child: RadarChart(
                        RadarChartData(
                          dataSets: radarData,
                          radarBackgroundColor: Colors.transparent,
                          borderData: FlBorderData(show: false),
                          radarBorderData: const BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          titleTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          getTitle: (index, angle) {
                            switch (index) {
                              case 0:
                                return const RadarChartTitle(text: 'Technisch');
                              case 1:
                                return const RadarChartTitle(text: 'Tactisch');
                              case 2:
                                return const RadarChartTitle(text: 'Fysiek');
                              case 3:
                                return const RadarChartTitle(text: 'Mentaal');
                              default:
                                return const RadarChartTitle(text: '');
                            }
                          },
                          tickCount: 5,
                          ticksTextStyle: const TextStyle(
                            color: Colors.transparent,
                            fontSize: 10,
                          ),
                          tickBorderData: const BorderSide(color: Colors.grey),
                          gridBorderData: const BorderSide(color: Colors.grey),
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

  List<RadarDataSet> _prepareRadarData() {
    final averages = [
      assessment.technicalAverage,
      assessment.tacticalAverage,
      assessment.physicalAverage,
      assessment.mentalAverage,
    ];

    return [
      RadarDataSet(
        fillColor: Colors.blue.withValues(alpha: 0.4),
        borderColor: Colors.blue,
        borderWidth: 2,
        entryRadius: 4,
        dataEntries: averages.map((avg) => RadarEntry(value: avg)).toList(),
      ),
    ];
  }
}
