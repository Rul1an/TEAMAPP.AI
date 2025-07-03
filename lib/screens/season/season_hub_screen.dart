import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/annual_planning/season_plan.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/training_sessions_repo_provider.dart' as ts_repo;
import '../../repositories/local_season_repository.dart';
import '../../repositories/season_repository.dart';
import '../../widgets/common/weekly_calendar_widget.dart';

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return LocalSeasonRepository();
});

final currentSeasonProvider = FutureProvider<SeasonPlan?>((ref) async {
  final repo = ref.read(seasonRepositoryProvider);
  final res = await repo.getActive();
  final season = res.dataOrNull;
  if (season == null) {
    final listRes = await repo.getAll();
    final seasons = listRes.dataOrNull ?? [];
    if (seasons.isEmpty) return null;

    try {
      return seasons.firstWhere((s) => s.status == SeasonStatus.active);
    } catch (_) {
      return seasons.first;
    }
  }
  return season;
});

final recentTrainingSessionsProvider = ts_repo.allTrainingSessionsProvider;

final upcomingTrainingSessionsProvider =
    ts_repo.upcomingTrainingSessionsProvider;

class SeasonHubScreen extends ConsumerWidget {
  const SeasonHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSeasonAsync = ref.watch(currentSeasonProvider);
    final recentSessionsAsync = ref.watch(recentTrainingSessionsProvider);
    final upcomingSessionsAsync = ref.watch(upcomingTrainingSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seizoen Planning'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/annual-planning/details'),
            tooltip: 'Jaarplanning Details',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Season Overview
            currentSeasonAsync.when(
              data: (season) => _buildSeasonOverview(context, season),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, stack) => _buildNoSeasonCard(context),
            ),

            const SizedBox(height: 16),

            // Quick Actions
            _buildQuickActions(context),

            const SizedBox(height: 24),

            // Weekly Calendar
            const WeeklyCalendarWidget(),

            const SizedBox(height: 24),

            // Training Sessions Overview
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        context,
                        'Recente Trainingen',
                        Icons.history,
                        onViewAll: () => context.push('/training-sessions'),
                      ),
                      const SizedBox(height: 8),
                      recentSessionsAsync.when(
                        data: (sessions) => _buildTrainingSessionsList(
                          context,
                          sessions,
                          false,
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) =>
                            const Text('Geen recente trainingen'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        context,
                        'Komende Trainingen',
                        Icons.schedule,
                        onViewAll: () => context.push('/training-sessions'),
                      ),
                      const SizedBox(height: 8),
                      upcomingSessionsAsync.when(
                        data: (sessions) =>
                            _buildTrainingSessionsList(context, sessions, true),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) =>
                            const Text('Geen geplande trainingen'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Periodization Status
            _buildPeriodizationStatus(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/session-builder'),
        icon: const Icon(Icons.add),
        label: const Text('Nieuwe Training'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSeasonOverview(BuildContext context, SeasonPlan? season) {
    if (season == null) {
      return _buildNoSeasonCard(context);
    }

    final currentPhase = season.getCurrentPhase();
    final progress = season.seasonProgressByDate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sports_soccer,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        season.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '${season.teamName} | ${season.season}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(currentPhase.displayName),
                  backgroundColor: _getPhaseColor(currentPhase),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar
            Row(
              children: [
                Icon(Icons.timeline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text('Seizoen Voortgang: ${progress.toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),

            const SizedBox(height: 16),

            // Key stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Totale Weken',
                    '${season.totalWeeks}',
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Training Weken',
                    '${season.trainingWeeks}',
                    Icons.sports,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Competitie Weken',
                    '${season.competitionWeeks}',
                    Icons.emoji_events,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Huidige Week',
                    '${season.currentWeek}',
                    Icons.today,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSeasonCard(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.sports_soccer_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Geen Actief Seizoen',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Start door een seizoenplanning aan te maken',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/annual-planning/details'),
                icon: const Icon(Icons.add),
                label: const Text('Maak Seizoenplan'),
              ),
            ],
          ),
        ),
      );

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) =>
      Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _buildQuickActions(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Snelle Acties',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Nieuwe Training',
                      Icons.add_circle,
                      Colors.green,
                      () => context.push('/session-builder'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Alle Trainingen',
                      Icons.list,
                      Colors.blue,
                      () => context.push('/training-sessions'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Jaarplanning',
                      Icons.calendar_today,
                      Colors.orange,
                      () => context.push('/annual-planning/details'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      'Wedstrijd Prep',
                      Icons.stadium,
                      Colors.purple,
                      () => context.push('/matches'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) =>
      Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onViewAll,
  }) =>
      Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('Alles bekijken'),
            ),
        ],
      );

  Widget _buildTrainingSessionsList(
    BuildContext context,
    List<TrainingSession> sessions,
    bool isUpcoming,
  ) {
    if (sessions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            isUpcoming ? 'Geen geplande trainingen' : 'Geen recente trainingen',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Column(
      children: sessions
          .take(3)
          .map(
            (session) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getTrainingTypeColor(session.type),
                  child: Icon(
                    _getTrainingTypeIcon(session.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text('Training ${session.trainingNumber}'),
                subtitle: Text(
                  '${session.date.day}/${session.date.month} | ${session.type.name}\n'
                  '${session.sessionObjective ?? 'Geen doelstelling'}',
                ),
                trailing: Icon(
                  isUpcoming ? Icons.schedule : Icons.check_circle,
                  color: isUpcoming ? Colors.orange : Colors.green,
                ),
                onTap: () {
                  // TODO(author): Navigate to session detail
                },
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPeriodizationStatus(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timeline, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Periodisering Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.push('/annual-planning/details'),
                    child: const Text('Details'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPeriodCard(
                      context,
                      'Huidige Periode',
                      'Voorbereiding',
                      'Week 3 van 6',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPeriodCard(
                      context,
                      'Volgende Periode',
                      'Vroeg Seizoen',
                      'Over 3 weken',
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildPeriodCard(
    BuildContext context,
    String label,
    String period,
    String detail,
    Color color,
  ) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );

  Color _getPhaseColor(SeasonPhase phase) {
    switch (phase) {
      case SeasonPhase.preseason:
        return Colors.blue.shade100;
      case SeasonPhase.earlySeason:
        return Colors.green.shade100;
      case SeasonPhase.midSeason:
        return Colors.orange.shade100;
      case SeasonPhase.lateSeason:
        return Colors.red.shade100;
      case SeasonPhase.postSeason:
        return Colors.grey.shade100;
    }
  }

  Color _getTrainingTypeColor(TrainingType type) {
    switch (type) {
      case TrainingType.regularTraining:
        return Colors.blue;
      case TrainingType.matchPreparation:
        return Colors.red;
      case TrainingType.tacticalSession:
        return Colors.purple;
      case TrainingType.technicalSession:
        return Colors.orange;
      case TrainingType.fitnessSession:
        return Colors.green;
      case TrainingType.recoverySession:
        return Colors.teal;
      case TrainingType.teamBuilding:
        return Colors.pink;
    }
  }

  IconData _getTrainingTypeIcon(TrainingType type) {
    switch (type) {
      case TrainingType.regularTraining:
        return Icons.sports_soccer;
      case TrainingType.matchPreparation:
        return Icons.stadium;
      case TrainingType.tacticalSession:
        return Icons.psychology;
      case TrainingType.technicalSession:
        return Icons.precision_manufacturing;
      case TrainingType.fitnessSession:
        return Icons.fitness_center;
      case TrainingType.recoverySession:
        return Icons.self_improvement;
      case TrainingType.teamBuilding:
        return Icons.group;
    }
  }
}
