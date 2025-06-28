import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/assessment.dart';
import '../../models/player.dart';

class AssessmentDetailScreen extends StatelessWidget {
  const AssessmentDetailScreen({
    super.key,
    required this.assessment,
    required this.player,
  });
  final PlayerAssessment assessment;
  final Player player;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Assessment for ${player.name}'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assessment Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                          'Overall Average: ${assessment.overallAverage.toStringAsFixed(1)}'),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: _buildRadarChart(assessment),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRadarChart(PlayerAssessment assessment) {
    final dataSets = [
      RadarDataSet(
        fillColor: Colors.blue.withValues(alpha: 0.2),
        borderColor: Colors.blue,
        entryRadius: 3,
        dataEntries: [
          RadarEntry(value: assessment.technicalAverage),
          RadarEntry(value: assessment.tacticalAverage),
          RadarEntry(value: assessment.physicalAverage),
          RadarEntry(value: assessment.mentalAverage),
        ],
        borderWidth: 2,
      ),
    ];

    return RadarChart(
      RadarChartData(
        dataSets: dataSets,
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.grey, width: 2),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(text: 'Technical', angle: angle);
            case 1:
              return RadarChartTitle(text: 'Tactical', angle: angle);
            case 2:
              return RadarChartTitle(text: 'Physical', angle: angle);
            case 3:
              return RadarChartTitle(text: 'Mental', angle: angle);
            default:
              return const RadarChartTitle(text: '');
          }
        },
        tickCount: 5,
        ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
        tickBorderData: const BorderSide(color: Colors.grey, width: 2),
        gridBorderData: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
