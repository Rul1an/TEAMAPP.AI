import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/database_service.dart';
import '../../models/player.dart';
import '../../models/assessment.dart';
import '../../models/training_session/training_session.dart';
import '../players/assessment_detail_screen.dart'; // Import the new screen

// Analytics Data Providers
final playersProvider = FutureProvider<List<Player>>((ref) async {
  final db = DatabaseService();
  await db.initialize();
  return await db.getAllPlayers();
});

final assessmentsProvider = FutureProvider<List<PlayerAssessment>>((ref) async {
  final db = DatabaseService();
  await db.initialize();
  return db.getAllAssessments();
});

final trainingSessionsProvider = FutureProvider<List<TrainingSession>>((ref) async {
  final db = DatabaseService();
  await db.initialize();
  return db.getAllTrainingSessions();
});

class PerformanceAnalyticsScreen extends ConsumerWidget {
  const PerformanceAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersProvider);
    final assessmentsAsync = ref.watch(assessmentsProvider);
    final trainingsAsync = ref.watch(trainingSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(playersProvider);
              ref.invalidate(assessmentsProvider);
              ref.invalidate(trainingSessionsProvider);
            },
            tooltip: 'Ververs Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Performance Analytics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Analyseer spelerontwikkeling, training effectiviteit en team prestaties.
'
                      'Realtime data analyse voor betere coaching beslissingen.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats Overview
            _buildQuickStats(context, playersAsync, assessmentsAsync, trainingsAsync),
            const SizedBox(height: 24),

            // Feature Grid
            Text(
              '📊 Analytics Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildFeatureCard(
                  context: context,
                  title: 'Speler Ontwikkeling',
                  subtitle: 'Top performers',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                  onTap: () => _showPlayerDevelopment(context, ref),
                ),
                _buildFeatureCard(
                  context: context,
                  title: 'Training Effectiviteit',
                  subtitle: 'Hoogste opkomst',
                  icon: Icons.fitness_center,
                  color: Colors.green,
                  onTap: () => _showTrainingEffectiveness(context, ref),
                ),
                _buildFeatureCard(
                  context: context,
                  title: 'Team Overzicht',
                  subtitle: 'Positie verdeling',
                  icon: Icons.pie_chart,
                  color: Colors.orange,
                  onTap: () => _showTeamOverview(context, ref),
                ),
                _buildFeatureCard(
                  context: context,
                  title: 'Skill Radar',
                  subtitle: 'Laatste assessment',
                  icon: Icons.radar,
                  color: Colors.red,
                  onTap: () => _showLatestAssessmentRadar(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Activity
            _buildRecentActivity(context, assessmentsAsync, trainingsAsync),
          ],
        ),
      ),
    );
  }

  // New method to navigate to the radar chart screen
  void _showLatestAssessmentRadar(BuildContext context, WidgetRef ref) async {
    final assessments = await ref.read(assessmentsProvider.future);
    final players = await ref.read(playersProvider.future);

    if (assessments.isEmpty || players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geen assessments gevonden.')),
      );
      return;
    }

    // Find the most recent assessment
    assessments.sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));
    final latestAssessment = assessments.first;

    // Find the player for that assessment
    final player = players.firstWhere(
      (p) => p.id.toString() == latestAssessment.playerId,
      orElse: () => players.first, // Fallback, though should not happen
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssessmentDetailScreen(
          assessment: latestAssessment,
          player: player,
        ),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    AsyncValue<List<Player>> playersAsync,
    AsyncValue<List<PlayerAssessment>> assessmentsAsync,
    AsyncValue<List<TrainingSession>> trainingsAsync,
  ) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.people, color: Colors.blue, size: 32),
                  const SizedBox(height: 8),
                  playersAsync.when(
                    data: (players) => Text(
                      '${players.length}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => const Text('...'),
                    error: (_, __) => const Text('0'),
                  ),
                  const Text('Spelers'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.assessment, color: Colors.green, size: 32),
                  const SizedBox(height: 8),
                  assessmentsAsync.when(
                    data: (assessments) => Text(
                      '${assessments.length}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => const Text('...'),
                    error: (_, __) => const Text('0'),
                  ),
                  const Text('Beoordelingen'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.sports, color: Colors.orange, size: 32),
                  const SizedBox(height: 8),
                  trainingsAsync.when(
                    data: (trainings) => Text(
                      '${trainings.length}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => const Text('...'),
                    error: (_, __) => const Text('0'),
                  ),
                  const Text('Trainingen'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    AsyncValue<List<PlayerAssessment>> assessmentsAsync,
    AsyncValue<List<TrainingSession>> trainingsAsync,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recente Activiteit',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: assessmentsAsync.when(
                    data: (assessments) => Text(
                      'Laatste beoordelingen: ${assessments.length}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    loading: () => const Text('Laden...'),
                    error: (_, __) => const Text('Error'),
                  ),
                ),
                Expanded(
                  child: trainingsAsync.when(
                    data: (trainings) => Text(
                      'Trainingen: ${trainings.length}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    loading: () => const Text('Laden...'),
                    error: (_, __) => const Text('Error'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Feature implementations
  void _showPlayerDevelopment(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.read(playersProvider);
    final assessmentsAsync = ref.read(assessmentsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.trending_up, color: Colors.blue),
            SizedBox(width: 8),
            Text('Speler Ontwikkeling'),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 500, // Increased height for the chart
          child: playersAsync.when(
            data: (players) => assessmentsAsync.when(
              data: (assessments) {
                if (assessments.isEmpty) {
                  return const Center(child: Text("Voeg eerst assessments toe."));
                }

                // Create a map of Player ID to their latest assessment
                final latestAssessments = <String, PlayerAssessment>{};
                for (var assessment in assessments) {
                  if (!latestAssessments.containsKey(assessment.playerId) ||
                      assessment.assessmentDate.isAfter(latestAssessments[assessment.playerId]!.assessmentDate)) {
                    latestAssessments[assessment.playerId] = assessment;
                  }
                }

                // Create a list of players with their latest score
                final scoredPlayers = players.map((player) {
                  final assessment = latestAssessments[player.id.toString()];
                  return MapEntry(player, assessment?.overallAverage ?? 0.0);
                }).where((entry) => entry.value > 0).toList();

                // Sort by score and take top 5
                scoredPlayers.sort((a, b) => b.value.compareTo(a.value));
                final topPlayers = scoredPlayers.take(5).toList();

                return Column(
                  children: [
                    const Text(
                      'Top 5 Spelers (Laatste Assessment)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400,
                      child: _buildPlayerPerformanceChart(topPlayers),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error: $error'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerPerformanceChart(List<MapEntry<Player, double>> topPlayers) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5,
        barTouchData: BarTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < topPlayers.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(topPlayers[index].key.name.split(' ').first, style: const TextStyle(fontSize: 10)),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: topPlayers.asMap().entries.map((entry) {
          final index = entry.key;
          final playerData = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: playerData.value,
                color: Colors.blue,
                width: 20,
              )
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
      ),
    );
  }

  void _showTrainingEffectiveness(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.read(playersProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.fitness_center, color: Colors.green),
            SizedBox(width: 8),
            Text('Training Effectiviteit'),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 500, // Increased height for chart
          child: playersAsync.when(
            data: (players) {
              if (players.isEmpty) {
                return const Center(
                  child: Text('Geen spelers gevonden'),
                );
              }

              // Sort players by attendance
              final sortedPlayers = players.toList()
                ..sort((a, b) => b.attendancePercentage.compareTo(a.attendancePercentage));
              
              final topPlayers = sortedPlayers.take(5).toList();

              final avgAttendance = players
                  .map((p) => p.attendancePercentage)
                  .reduce((a, b) => a + b) / players.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      color: Colors.green.withAlpha(30),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Gemiddelde Team Opkomst',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${avgAttendance.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Gebaseerd op ${players.length} spelers',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Top 5 Aanwezigheid:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildAttendanceChart(topPlayers),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart(List<Player> topPlayers) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < topPlayers.length) {
                  return Text(topPlayers[index].name, style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
              reservedSize: 100,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value % 20 == 0) return Text('${value.toInt()}%');
                return const Text('');
              },
              reservedSize: 20,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: topPlayers.asMap().entries.map((entry) {
          final index = entry.key;
          final player = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: player.attendancePercentage,
                color: _getAttendanceColor(player.attendancePercentage),
                width: 15,
                borderRadius: BorderRadius.zero,
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => const FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          ),
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }

  void _showTeamOverview(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.read(playersProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.analytics, color: Colors.orange),
            SizedBox(width: 8),
            Text('Team Overzicht'),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 600, // Increased height for the chart
          child: playersAsync.when(
            data: (players) {
              if (players.isEmpty) {
                return const Center(
                  child: Text('Geen spelers gevonden'),
                );
              }

              // Calculate statistics
              final totalGoals = players.map((p) => p.goals).fold(0, (a, b) => a + b);
              final totalAssists = players.map((p) => p.assists).fold(0, (a, b) => a + b);
              final avgAge = players.map((p) => p.age).fold(0, (a, b) => a + b) / players.length;

              // Group by position
              final positionGroups = <Position, List<Player>>{};
              for (final player in players) {
                positionGroups.putIfAbsent(player.position, () => []).add(player);
              }

              return ListView(
                children: [
                  Card(
                    color: Colors.orange.withAlpha(30),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Team Statistieken',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '$totalGoals',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Goals'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '$totalAssists',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Assists'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    avgAge.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Gem. Leeftijd'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Spelers per Positie:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: _buildPositionChart(positionGroups),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sluiten'),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionChart(Map<Position, List<Player>> positionGroups) {
    int touchedIndex = -1;
    final data = positionGroups.entries.map((entry) {
      final position = entry.key;
      final players = entry.value;
      return PieChartSectionData(
        color: _getPositionColor(position),
        value: players.length.toDouble(),
        title: '${players.length}',
        radius: touchedIndex == position.index ? 60.0 : 50.0,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: data,
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // setState(() { // This needs to be a StatefulWidget to work properly
            //   if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
            //     touchedIndex = -1;
            //     return;
            //   }
            //   touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            // });
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateInsights(List<Player> players, List<PlayerAssessment> assessments) {
    final insights = <Map<String, dynamic>>[];

    if (players.isEmpty) {
      insights.add({
        'icon': Icons.info,
        'color': Colors.blue,
        'title': 'Geen Data',
        'description': 'Voeg spelers toe om inzichten te genereren',
      });
      return insights;
    }

    // Top performer
    final topScorer = players.reduce((a, b) => a.goals > b.goals ? a : b);
    if (topScorer.goals > 0) {
      insights.add({
        'icon': Icons.star,
        'color': Colors.amber,
        'title': 'Top Scorer',
        'description': '${topScorer.name} heeft ${topScorer.goals} goals gemaakt',
      });
    }

    // Best attendance
    final bestAttendance = players.reduce((a, b) =>
        a.attendancePercentage > b.attendancePercentage ? a : b);
    insights.add({
      'icon': Icons.emoji_events,
      'color': Colors.green,
      'title': 'Beste Opkomst',
      'description': '${bestAttendance.name} - ${bestAttendance.attendancePercentage.toStringAsFixed(0)}% aanwezigheid',
    });

    // Team balance
    final avgAge = players.map((p) => p.age).fold(0.0, (a, b) => a + b) / players.length;
    insights.add({
      'icon': Icons.balance,
      'color': Colors.blue,
      'title': 'Team Balans',
      'description': 'Gemiddelde leeftijd ${avgAge.toStringAsFixed(1)} jaar - goede mix',
    });

    // Assessment insights
    if (assessments.isNotEmpty) {
      insights.add({
        'icon': Icons.analytics,
        'color': Colors.purple,
        'title': 'Assessment Data',
        'description': '${assessments.length} beoordelingen beschikbaar voor analyse',
      });
    } else {
      insights.add({
        'icon': Icons.assignment,
        'color': Colors.orange,
        'title': 'Assessment Tip',
        'description': 'Voeg speler beoordelingen toe voor betere inzichten',
      });
    }

    return insights;
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 85) return Colors.green;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  IconData _getPositionIcon(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return Icons.sports_handball;
      case Position.defender:
        return Icons.shield;
      case Position.midfielder:
        return Icons.group_work;
      case Position.forward:
        return Icons.sports_soccer;
    }
  }

  Color _getPositionColor(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return Colors.orange;
      case Position.defender:
        return Colors.blue;
      case Position.midfielder:
        return Colors.green;
      case Position.forward:
        return Colors.red;
    }
  }
}
