import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/database_service.dart';
import '../../models/player.dart';
import '../../models/assessment.dart';
import '../../models/training_session/training_session.dart';

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
                      'Analyseer spelerontwikkeling, training effectiviteit en team prestaties.\n'
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
                  subtitle: 'Performance tracking',
                  icon: Icons.trending_up,
                  color: Colors.blue,
                  onTap: () => _showPlayerDevelopment(context, ref),
                ),
                _buildFeatureCard(
                  context: context,
                  title: 'Training Effectiviteit',
                  subtitle: 'Opkomst & resultaten',
                  icon: Icons.fitness_center,
                  color: Colors.green,
                  onTap: () => _showTrainingEffectiveness(context, ref),
                ),
                _buildFeatureCard(
                  context: context,
                  title: 'Team Overzicht',
                  subtitle: 'Statistieken & trends',
                  icon: Icons.analytics,
                  color: Colors.orange,
                  onTap: () => _showTeamOverview(context, ref),
                ),
                _buildFeatureCard(
                  context: context,
                  title: 'AI Inzichten',
                  subtitle: 'Slimme aanbevelingen',
                  icon: Icons.lightbulb,
                  color: Colors.purple,
                  onTap: () => _showInsights(context, ref),
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
                  color: color.withValues(alpha: 0.1),
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
          height: 400,
          child: playersAsync.when(
            data: (players) => assessmentsAsync.when(
              data: (assessments) => ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  final playerAssessments = assessments
                      .where((a) => a.playerId == player.id.toString())
                      .toList();

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          player.firstName[0] + player.lastName[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(player.name),
                      subtitle: Text(
                        '${playerAssessments.length} beoordelingen\n'
                        'Goals: ${player.goals} | Assists: ${player.assists}',
                      ),
                      trailing: Text(
                        '${player.attendancePercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
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
          height: 400,
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

              final avgAttendance = players
                  .map((p) => p.attendancePercentage)
                  .reduce((a, b) => a + b) / players.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.green.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Team Opkomst',
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
                            'Gemiddelde opkomst van ${players.length} spelers',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Top Aanwezigheid:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedPlayers.take(5).length,
                      itemBuilder: (context, index) {
                        final player = sortedPlayers[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getAttendanceColor(player.attendancePercentage),
                            radius: 16,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          title: Text(player.name),
                          subtitle: Text('${player.trainingsAttended}/${player.trainingsTotal} trainingen'),
                          trailing: Text(
                            '${player.attendancePercentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getAttendanceColor(player.attendancePercentage),
                            ),
                          ),
                        );
                      },
                    ),
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
          height: 400,
          child: playersAsync.when(
            data: (players) {
              if (players.isEmpty) {
                return const Center(
                  child: Text('Geen spelers gevonden'),
                );
              }

              // Calculate statistics
              final totalGoals = players.map((p) => p.goals).reduce((a, b) => a + b);
              final totalAssists = players.map((p) => p.assists).reduce((a, b) => a + b);
              final avgAge = players.map((p) => p.age).reduce((a, b) => a + b) / players.length;

              // Group by position
              final positionGroups = <Position, List<Player>>{};
              for (final player in players) {
                positionGroups.putIfAbsent(player.position, () => []).add(player);
              }

              return ListView(
                children: [
                  Card(
                    color: Colors.orange.withValues(alpha: 0.1),
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
                  ...positionGroups.entries.map((entry) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          _getPositionIcon(entry.key),
                          color: _getPositionColor(entry.key),
                        ),
                        title: Text(entry.key.displayName),
                        trailing: Text(
                          '${entry.value.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }),
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

  void _showInsights(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.read(playersProvider);
    final assessmentsAsync = ref.read(assessmentsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.purple),
            SizedBox(width: 8),
            Text('AI Inzichten'),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 300,
          child: playersAsync.when(
            data: (players) => assessmentsAsync.when(
              data: (assessments) {
                final insights = _generateInsights(players, assessments);
                return ListView.builder(
                  itemCount: insights.length,
                  itemBuilder: (context, index) {
                    final insight = insights[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(insight['icon'], color: insight['color']),
                        title: Text(insight['title']),
                        subtitle: Text(insight['description']),
                      ),
                    );
                  },
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
    final avgAge = players.map((p) => p.age).reduce((a, b) => a + b) / players.length;
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
