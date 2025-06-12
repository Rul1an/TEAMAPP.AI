import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/assessment.dart';
import '../../models/player.dart';

class AssessmentDetailScreen extends StatelessWidget {
  final PlayerAssessment assessment;
  final Player player;

  const AssessmentDetailScreen({
    super.key,
    required this.assessment,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment for ${player.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Overall Average: ${assessment.overallAverage.toStringAsFixed(1)}'),
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
  }

  Widget _buildRadarChart(PlayerAssessment assessment) {
    final ticks = [1, 2, 3, 4, 5];
    final dataSets = [
      RadarDataSet(
        fillColor: Colors.blue.withOpacity(0.2),
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
        titleCount: 4,
        titlesBuilder: (index, meta) {
          const style = TextStyle(color: Colors.black, fontSize: 14);
          switch (index) {
            case 0:
              return const Text('Technical', style: style);
            case 1:
              return const Text('Tactical', style: style);
            case 2:
              return const Text('Physical', style: style);
            case 3:
              return const Text('Mental', style: style);
            default:
              return Container();
          }
        },
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
        tickCount: ticks.length,
        ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
        tickBorderData: const BorderSide(color: Colors.grey, width: 2),
        gridBorderData: const BorderSide(color: Colors.grey, width: 1),
      ),
    );
  }
}
