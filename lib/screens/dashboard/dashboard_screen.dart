// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/annual_planning/season_plan.dart';
import '../../models/match.dart';
import '../../models/training_session/training_session.dart';
import '../../providers/auth_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../../providers/matches_provider.dart';
import '../../providers/organization_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../providers/training_sessions_repo_provider.dart' as ts_repo;
import '../../repositories/local_season_repository.dart';
import '../../repositories/season_repository.dart';
import '../../services/permission_service.dart';
import '../../widgets/rbac_demo_widget.dart';
import 'widgets/dashboard_app_bar_actions.dart';
import 'widgets/welcome_section.dart';
import 'widgets/player_quick_actions.dart';
import 'widgets/player_stats_section.dart';
import 'widgets/upcoming_events_list.dart';
import 'widgets/parent_overview_card.dart';
import 'widgets/coach_dashboard_content.dart';

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return LocalSeasonRepository();
});

final dashboardSeasonProvider = FutureProvider<SeasonPlan?>((ref) async {
  final repo = ref.read(seasonRepositoryProvider);
  final res = await repo.getActive();
  return res.dataOrNull;
});

// trainingRepositoryProvider removed – replaced by direct Service call until repository migration completed

final dashboardTrainingSessionsProvider =
    ts_repo.upcomingTrainingSessionsProvider;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(statisticsProvider);
    final upcomingMatchesAsync = ref.watch(upcomingMatchesProvider);
    final seasonAsync = ref.watch(dashboardSeasonProvider);
    final trainingSessionsAsync = ref.watch(dashboardTrainingSessionsProvider);

    // Get user role and permissions
    final isDemoMode = ref.watch(demoModeProvider);
    final currentUser = ref.watch(currentUserProvider);
    final organization = ref.watch(currentOrganizationProvider);

    String? userRole;
    if (isDemoMode.isActive) {
      userRole = ref.read(demoModeProvider.notifier).getDemoRole();
    } else {
      userRole = currentUser?.userMetadata?['role'] as String?;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getDashboardTitle(userRole)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [DashboardAppBarActions(userRole: userRole)],
      ),
      body: statisticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (statistics) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RBAC Demo Widget (only in demo mode)
              const RBACDemoWidget(),

              // Role-specific welcome section
              seasonAsync.when(
                data: (season) =>
                    WelcomeSection(season: season, userRole: userRole),
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) =>
                    WelcomeSection(season: null, userRole: userRole),
              ),
              const SizedBox(height: 24),

              // Role-specific content
              ..._buildRoleSpecificContent(
                context,
                ref,
                userRole,
                organization?.tier.name,
                statistics,
                upcomingMatchesAsync,
                trainingSessionsAsync,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDashboardTitle(String? userRole) {
    if (PermissionService.isPlayer(userRole)) {
      return 'Mijn Dashboard';
    } else if (PermissionService.isParent(userRole)) {
      return 'Ouder Dashboard';
    } else if (PermissionService.canAccessAdmin(userRole)) {
      return 'Bestuurder Dashboard';
    } else {
      return 'Coach Dashboard';
    }
  }

  List<Widget> _buildRoleSpecificContent(
    BuildContext context,
    WidgetRef ref,
    String? userRole,
    String? tier,
    dynamic statistics,
    AsyncValue<List<Match>> upcomingMatchesAsync,
    AsyncValue<List<TrainingSession>> trainingSessionsAsync,
  ) {
    final content = <Widget>[];

    if (PermissionService.isPlayer(userRole)) {
      // Player-specific content
      content.addAll([
        const PlayerQuickActions(),
        const SizedBox(height: 24),
        PlayerStatsSection(
          trainingCount: (statistics?.totalTrainingAttendance ?? 0) as int,
          matchCount: (statistics?.totalMatches ?? 0) as int,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aankomende Wedstrijden',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            upcomingMatchesAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => const Text('Geen wedstrijden'),
              data: (matches) => UpcomingEventsList<Match>(
                events: matches,
                emptyMessage: 'Geen wedstrijden',
                cardBuilder: (ctx, match) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.stadium),
                    title: Text(
                      match.opponent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(match.date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]);
    } else if (PermissionService.isParent(userRole)) {
      // Parent-specific content
      content.addAll([
        const ParentOverviewCard(),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aankomende Wedstrijden',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              upcomingMatchesAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => const Text('Geen wedstrijden'),
                data: (matches) => UpcomingEventsList<Match>(
                  events: matches,
                  emptyMessage: 'Geen wedstrijden',
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
                      title: Text(
                        match.opponent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${DateFormat('dd MMM').format(match.date)} - ${match.venue}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        DateFormat('HH:mm').format(match.date),
                        style: Theme.of(ctx).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'VOAB Training Sessies',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
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
                          const Icon(Icons.schedule,
                              color: Colors.orange, size: 16),
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
          ),
        ),
      ]);
    } else {
      // Coach/Admin content (moved to dedicated widget)
      content.add(
        CoachDashboardContent(
          statistics: statistics as Map<String, dynamic>,
          upcomingMatchesAsync: upcomingMatchesAsync,
          trainingSessionsAsync: trainingSessionsAsync,
        ),
      );
    }

    return content;
  }

  // _buildActionCard & _buildSmartActions removed – replaced by QuickActionsSection widget

  // _buildPlayerQuickActions removed – replaced by PlayerQuickActions widget

  // Removed old _buildParentOverview and _buildUpcoming... helpers – replaced by widgets

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

  // Removed _buildUpcomingTrainingSessions and _buildUpcomingMatches – functionality now provided via UpcomingEventsList widget
}
