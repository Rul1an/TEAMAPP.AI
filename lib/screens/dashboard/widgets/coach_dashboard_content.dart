import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/match.dart';
import '../../../models/training_session/training_session.dart';
import 'upcoming_events_list.dart';
import 'dashboard_stats_cards.dart';
import 'performance_chart.dart';
import 'quick_actions_section.dart';

class CoachDashboardContent extends StatelessWidget {
  const CoachDashboardContent({
    super.key,
    required this.statistics,
    required this.upcomingMatchesAsync,
    required this.trainingSessionsAsync,
  });

  final Map<String, dynamic> statistics;
  final AsyncValue<List<Match>> upcomingMatchesAsync;
  final AsyncValue<List<TrainingSession>> trainingSessionsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuickActionsSection(),
        const SizedBox(height: 24),
        DashboardStatsCards(statistics: statistics),
        const SizedBox(height: 24),
        _buildRows(context),
        const SizedBox(height: 24),
        PerformanceChart(statistics: statistics),
      ],
    );
  }

  Widget _buildRows(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMatchesColumn(context)),
        const SizedBox(width: 16),
        Expanded(child: _buildTrainingColumn(context)),
      ],
    );
  }

  Widget _buildMatchesColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aankomende Wedstrijden',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        upcomingMatchesAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, s) => Text('Error: $e'),
          data: (matches) => UpcomingEventsList<Match>(
            events: matches,
            emptyMessage: 'Geen aankomende wedstrijden',
            cardBuilder: (ctx, match) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: match.location == Location.home
                      ? Colors.green
                      : Colors.blue,
                  child: Text(
                    match.location == Location.home ? 'T' : 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(match.opponent),
                subtitle: Text(
                  '${DateFormat('dd MMM').format(match.date)} - ${match.venue}',
                ),
                trailing: Text(
                  DateFormat('HH:mm').format(match.date),
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VOAB Training Sessies',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        trainingSessionsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, s) => const Text('Geen sessies'),
          data: (sessions) => UpcomingEventsList<TrainingSession>(
            events: sessions,
            emptyMessage: 'Geen sessies',
            cardBuilder: (ctx, session) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _trainingTypeColor(session.type),
                  child: Icon(
                    _trainingTypeIcon(session.type),
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                title: Text('Training ${session.trainingNumber}'),
                subtitle: Text(
                  '${session.date.day}/${session.date.month} | ${session.phases.length} fasen\n${session.sessionObjective ?? 'VOAB Standard'}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, color: Colors.orange, size: 16),
                    Text(
                      '${session.sessionDuration.inMinutes}m',
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _trainingTypeColor(TrainingType type) {
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

  IconData _trainingTypeIcon(TrainingType type) {
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
