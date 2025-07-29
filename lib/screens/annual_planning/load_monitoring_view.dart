import 'package:flutter/material.dart';
import '../../providers/annual_planning_provider.dart';
import 'load_monitoring/widgets/load_trends_tab.dart';
import 'load_monitoring/widgets/injury_risk_tab.dart';

class LoadMonitoringView extends StatelessWidget {
  const LoadMonitoringView({
    super.key,
    required this.tabController,
    required this.selectedWeekRange,
    required this.showProjections,
    required this.onWeekRangeChanged,
    required this.onToggleProjections,
    required this.planningState,
  });

  final TabController tabController;
  final int selectedWeekRange;
  final bool showProjections;
  final void Function(int) onWeekRangeChanged;
  final VoidCallback onToggleProjections;
  final AnnualPlanningState planningState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Load Monitoring'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: 'Load Trends'),
            Tab(icon: Icon(Icons.warning), text: 'Injury Risk'),
            Tab(icon: Icon(Icons.fitness_center), text: 'Adaptation'),
            Tab(icon: Icon(Icons.insights), text: 'Analytics'),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.date_range),
            tooltip: 'Week Range',
            onSelected: onWeekRangeChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 4, child: Text('4 Weeks')),
              const PopupMenuItem(value: 8, child: Text('8 Weeks')),
              const PopupMenuItem(value: 12, child: Text('12 Weeks')),
              const PopupMenuItem(value: 24, child: Text('24 Weeks')),
              const PopupMenuItem(value: 52, child: Text('Full Season')),
            ],
          ),
          IconButton(
            icon: Icon(
              showProjections ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onToggleProjections,
            tooltip: 'Toggle Projections',
          ),
        ],
      ),
      body: planningState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: tabController,
              children: [
                LoadTrendsTab(
                  state: planningState,
                  selectedWeekRange: selectedWeekRange,
                ),
                InjuryRiskTab(state: planningState),
                _buildAdaptationTab(),
                _buildAnalyticsTab(),
              ],
            ),
    );
  }

  Widget _buildAdaptationTab() => const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🏃‍♂️ Adaptation Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.timeline, size: 48, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'Geavanceerde Prestatie Monitoring',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Volg training aanpassingen, fitness verbeteringen en prestatie ontwikkeling over tijd. Beschikbaar in toekomstige versie.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildAnalyticsTab() => const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Advanced Analytics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.analytics, size: 48, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'Uitgebreide Data Analyse',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Diepgaande inzichten in training effectiviteit, speler ontwikkeling en voorspellende analyses. Wordt ontwikkeld voor volgende versie.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
