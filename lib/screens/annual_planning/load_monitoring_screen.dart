import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/annual_planning/morphocycle.dart';
import '../../providers/annual_planning_provider.dart';

class LoadMonitoringScreen extends ConsumerStatefulWidget {
  const LoadMonitoringScreen({super.key});

  @override
  ConsumerState<LoadMonitoringScreen> createState() =>
      _LoadMonitoringScreenState();
}

class _LoadMonitoringScreenState extends ConsumerState<LoadMonitoringScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedWeekRange = 12; // Default to 12 weeks view
  bool _showProjections = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planningState = ref.watch(annualPlanningProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Load Monitoring'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
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
            onSelected: (value) => setState(() => _selectedWeekRange = value),
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
                _showProjections ? Icons.visibility : Icons.visibility_off),
            onPressed: () =>
                setState(() => _showProjections = !_showProjections),
            tooltip: 'Toggle Projections',
          ),
        ],
      ),
      body: planningState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLoadTrendsTab(planningState),
                _buildInjuryRiskTab(planningState),
                _buildAdaptationTab(planningState),
                _buildAnalyticsTab(planningState),
              ],
            ),
    );
  }

  Widget _buildLoadTrendsTab(AnnualPlanningState state) {
    final currentWeek = state.currentWeekNumber;
    final startWeek =
        (currentWeek - _selectedWeekRange).clamp(1, state.totalWeeks);
    final endWeek = currentWeek.clamp(1, state.totalWeeks);

    final morphocycles = <Morphocycle>[];
    for (int week = startWeek; week <= endWeek; week++) {
      final morphocycle = state.getMorphocycleForWeek(week);
      if (morphocycle != null) morphocycles.add(morphocycle);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLoadSummaryCards(morphocycles),
          const SizedBox(height: 24),
          _buildWeeklyLoadChart(morphocycles),
          const SizedBox(height: 24),
          _buildAcuteChronicChart(morphocycles),
          const SizedBox(height: 24),
          _buildIntensityDistributionChart(morphocycles),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '�� Huidige Morfocycle',
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
          ),
        ],
      ),
    );
  }

  Widget _buildLoadSummaryCards(List<Morphocycle> morphocycles) {
    if (morphocycles.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No morphocycle data available'),
        ),
      );
    }

    final currentLoad =
        morphocycles.isNotEmpty ? morphocycles.last.weeklyLoad : 0.0;
    final averageLoad = morphocycles.fold(0, (sum, m) => sum + m.weeklyLoad) /
        morphocycles.length;
    final maxLoad = morphocycles.fold(
        0, (max, m) => m.weeklyLoad > max ? m.weeklyLoad : max);
    final currentAcr =
        morphocycles.isNotEmpty ? morphocycles.last.acuteChronicRatio : 1.0;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Current Load',
            '${currentLoad.toInt()}',
            'AU',
            _getLoadColor(currentLoad),
            Icons.fitness_center,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Average Load',
            '${averageLoad.toInt()}',
            'AU',
            Colors.blue,
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Peak Load',
            '${maxLoad.toInt()}',
            'AU',
            Colors.red,
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'ACR',
            currentAcr.toStringAsFixed(2),
            'Ratio',
            _getAcrColor(currentAcr),
            Icons.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, String unit, Color color,
          IconData icon) =>
      Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildWeeklyLoadChart(List<Morphocycle> morphocycles) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Training Load Trend',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: morphocycles.isEmpty
                    ? const Center(child: Text('No data available'))
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(
                            horizontalInterval: 200,
                            verticalInterval: 2,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 2,
                                getTitlesWidget: (value, meta) {
                                  final weekIndex = value.toInt();
                                  if (weekIndex >= 0 &&
                                      weekIndex < morphocycles.length) {
                                    return Text(
                                      'W${morphocycles[weekIndex].weekNumber}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                interval: 200,
                                getTitlesWidget: (value, meta) => Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          minX: 0,
                          maxX: (morphocycles.length - 1).toDouble(),
                          minY: 0,
                          maxY: 2000,
                          lineBarsData: [
                            LineChartBarData(
                              spots: morphocycles
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => FlSpot(
                                      entry.key.toDouble(),
                                      entry.value.weeklyLoad,
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  final load = spot.y;
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: _getLoadColor(load),
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withValues(alpha: 0.1),
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

  Widget _buildAcuteChronicChart(List<Morphocycle> morphocycles) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Acute:Chronic Workload Ratio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sweet spot: 0.8 - 1.3 (Optimal adaptation zone)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: morphocycles.isEmpty
                    ? const Center(child: Text('No data available'))
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(
                            horizontalInterval: 0.2,
                            verticalInterval: 2,
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 2,
                                getTitlesWidget: (value, meta) {
                                  final weekIndex = value.toInt();
                                  if (weekIndex >= 0 &&
                                      weekIndex < morphocycles.length) {
                                    return Text(
                                      'W${morphocycles[weekIndex].weekNumber}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 0.2,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          minX: 0,
                          maxX: (morphocycles.length - 1).toDouble(),
                          minY: 0,
                          maxY: 2,
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 0.8,
                                color: Colors.green.withValues(alpha: 0.5),
                                dashArray: [5, 5],
                              ),
                              HorizontalLine(
                                y: 1.3,
                                color: Colors.green.withValues(alpha: 0.5),
                                dashArray: [5, 5],
                              ),
                            ],
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: morphocycles
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => FlSpot(
                                      entry.key.toDouble(),
                                      entry.value.acuteChronicRatio,
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  final acr = spot.y;
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: _getAcrColor(acr),
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
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

  Widget _buildIntensityDistributionChart(List<Morphocycle> morphocycles) {
    if (morphocycles.isEmpty) return const SizedBox.shrink();

    final latestMorphocycle = morphocycles.last;
    final distribution = latestMorphocycle.intensityDistribution;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Intensity Distribution (Current Week)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: distribution.entries.map((entry) {
                    final intensity = entry.key;
                    final percentage = entry.value;
                    return PieChartSectionData(
                      color: _getIntensityColor(intensity),
                      value: percentage,
                      title: '${percentage.toInt()}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: distribution.entries
                  .map(
                    (entry) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getIntensityColor(entry.key),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${entry.key.toUpperCase()}: ${entry.value.toInt()}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInjuryRiskTab(AnnualPlanningState state) {
    final currentWeek = state.currentWeekNumber;
    final startWeek = (currentWeek - 4).clamp(1, state.totalWeeks);
    final endWeek = currentWeek.clamp(1, state.totalWeeks);

    final recentMorphocycles = <Morphocycle>[];
    for (int week = startWeek; week <= endWeek; week++) {
      final morphocycle = state.getMorphocycleForWeek(week);
      if (morphocycle != null) recentMorphocycles.add(morphocycle);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRiskSummaryCards(recentMorphocycles),
          const SizedBox(height: 24),
          _buildRiskFactorsChart(recentMorphocycles),
          const SizedBox(height: 24),
          _buildRiskRecommendations(recentMorphocycles),
          const SizedBox(height: 24),
          _buildLoadZoneAnalysis(recentMorphocycles),
        ],
      ),
    );
  }

  Widget _buildRiskSummaryCards(List<Morphocycle> morphocycles) {
    if (morphocycles.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No data available for risk analysis'),
        ),
      );
    }

    final currentMorphocycle = morphocycles.last;
    final avgAcr = morphocycles.fold(0, (sum, m) => sum + m.acuteChronicRatio) /
        morphocycles.length;
    final highRiskWeeks = morphocycles
        .where((m) =>
            m.currentInjuryRisk == InjuryRisk.high ||
            m.currentInjuryRisk == InjuryRisk.extreme)
        .length;
    final overloadWeeks = morphocycles.where((m) => m.weeklyLoad > 1400).length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildRiskCard(
                'Current Risk',
                currentMorphocycle.currentInjuryRisk.name.toUpperCase(),
                _getRiskColor(currentMorphocycle.currentInjuryRisk),
                _getRiskIcon(currentMorphocycle.currentInjuryRisk),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRiskCard(
                'Avg ACR (4 weeks)',
                avgAcr.toStringAsFixed(2),
                _getAcrColor(avgAcr),
                Icons.trending_up,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRiskCard(
                'High Risk Weeks',
                '$highRiskWeeks/4',
                highRiskWeeks > 1 ? Colors.red : Colors.green,
                Icons.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRiskCard(
                'Overload Weeks',
                '$overloadWeeks/4',
                overloadWeeks > 2 ? Colors.red : Colors.green,
                Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskCard(
          String title, String value, Color color, IconData icon) =>
      Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05)
              ],
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

  Widget _buildRiskFactorsChart(List<Morphocycle> morphocycles) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Injury Risk Factors Over Time',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: morphocycles.isEmpty
                    ? const Center(child: Text('No data available'))
                    : LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  final weekIndex = value.toInt();
                                  if (weekIndex >= 0 &&
                                      weekIndex < morphocycles.length) {
                                    return Text(
                                      'W${morphocycles[weekIndex].weekNumber}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                            topTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: morphocycles
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => FlSpot(
                                      entry.key.toDouble(),
                                      entry.value.acuteChronicRatio,
                                    ),
                                  )
                                  .toList(),
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 3,
                              dotData: FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  final acr = spot.y;
                                  final risk =
                                      Morphocycle.assessInjuryRisk(acr);
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: _getRiskColor(risk),
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                            ),
                          ],
                          extraLinesData: ExtraLinesData(
                            horizontalLines: [
                              HorizontalLine(
                                y: 0.8,
                                color: Colors.green.withValues(alpha: 0.5),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                              HorizontalLine(
                                y: 1.3,
                                color: Colors.orange.withValues(alpha: 0.5),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                              HorizontalLine(
                                y: 1.5,
                                color: Colors.red.withValues(alpha: 0.5),
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRiskRecommendations(List<Morphocycle> morphocycles) {
    if (morphocycles.isEmpty) return const SizedBox.shrink();

    final currentMorphocycle = morphocycles.last;
    final recommendations =
        _generateRiskRecommendations(currentMorphocycle, morphocycles);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Injury Prevention Recommendations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildLoadZoneAnalysis(List<Morphocycle> morphocycles) {
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...loadZones.entries.map((entry) {
              final percentage = morphocycles.isNotEmpty
                  ? (entry.value / morphocycles.length * 100)
                  : 0.0;
              final color = _getLoadZoneColor(entry.key);

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
                              fontSize: 12, fontWeight: FontWeight.w500),
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
      Morphocycle current, List<Morphocycle> recent) {
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

  Color _getRiskColor(InjuryRisk risk) {
    switch (risk) {
      case InjuryRisk.underloaded:
        return Colors.blue;
      case InjuryRisk.optimal:
        return Colors.green;
      case InjuryRisk.high:
        return Colors.red;
      case InjuryRisk.extreme:
        return Colors.purple;
    }
  }

  IconData _getRiskIcon(InjuryRisk risk) {
    switch (risk) {
      case InjuryRisk.underloaded:
        return Icons.trending_down;
      case InjuryRisk.optimal:
        return Icons.check_circle;
      case InjuryRisk.high:
        return Icons.warning;
      case InjuryRisk.extreme:
        return Icons.dangerous;
    }
  }

  Color _getLoadZoneColor(String zone) {
    if (zone.contains('Recovery')) return Colors.green;
    if (zone.contains('Optimal')) return Colors.blue;
    if (zone.contains('High Load')) return Colors.orange;
    if (zone.contains('Danger')) return Colors.red;
    return Colors.grey;
  }

  Color _getLoadColor(double load) {
    if (load < 1000) return Colors.green;
    if (load < 1500) return Colors.orange;
    if (load < 2000) return Colors.red;
    return Colors.purple;
  }

  Color _getAcrColor(double acr) {
    if (acr >= 0.8 && acr <= 1.3) return Colors.green;
    if (acr < 0.8 || acr <= 1.5) return Colors.orange;
    return Colors.red;
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'recovery':
        return Colors.green;
      case 'activation':
        return Colors.blue;
      case 'development':
        return Colors.orange;
      case 'acquisition':
        return Colors.red;
      case 'competition':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAdaptationTab(AnnualPlanningState state) => const Padding(
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

  Widget _buildAnalyticsTab(AnnualPlanningState state) => const Padding(
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

  Widget _buildMorphocycleInfo(Morphocycle morphocycle) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.green[50]!],
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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getLoadColor(morphocycle.weeklyLoad),
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

            // Game Model Focus
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

            // Adaptation Expectation
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

            // ACWR Risk Indicator
            Row(
              children: [
                Icon(
                  _getACWRIcon(morphocycle.acuteChronicRatio),
                  size: 16,
                  color: _getACWRColor(morphocycle.acuteChronicRatio),
                ),
                const SizedBox(width: 8),
                Text(
                  'Belasting Ratio: ${morphocycle.acuteChronicRatio.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _getACWRColor(morphocycle.acuteChronicRatio),
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
                            horizontal: 8, vertical: 4),
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

  IconData _getACWRIcon(double acwr) {
    if (acwr > 1.3) return Icons.warning;
    if (acwr < 0.8) return Icons.trending_down;
    return Icons.check_circle;
  }

  Color _getACWRColor(double acwr) {
    if (acwr > 1.3) return Colors.red;
    if (acwr < 0.8) return Colors.orange;
    return Colors.green;
  }
}
