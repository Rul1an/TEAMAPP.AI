// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../widgets/common/quick_actions_widget.dart';
import '../../widgets/rbac_demo_widget.dart';
import 'widgets/dashboard_app_bar_actions.dart';
import 'widgets/welcome_section.dart';
import 'widgets/dashboard_stats_cards.dart';
import 'widgets/performance_chart.dart';

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
        actions: [
          DashboardAppBarActions(userRole: userRole),
        ],
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
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
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
        _buildPlayerQuickActions(context),
        const SizedBox(height: 24),
        _buildPlayerStats(context, statistics),
        const SizedBox(height: 24),
        _buildUpcomingEventsForPlayer(
          context,
          upcomingMatchesAsync,
          trainingSessionsAsync,
        ),
      ]);
    } else if (PermissionService.isParent(userRole)) {
      // Parent-specific content
      content.addAll([
        _buildParentOverview(context),
        const SizedBox(height: 24),
        _buildUpcomingEventsForParent(
          context,
          upcomingMatchesAsync,
          trainingSessionsAsync,
        ),
      ]);
    } else {
      // Coach/Admin content (full access)
      content.addAll([
        _buildSmartActions(context),
        const SizedBox(height: 24),
        const QuickActionsWidget(),
        const SizedBox(height: 24),
        // ignore: unnecessary_cast
        DashboardStatsCards(statistics: statistics as Map<String, dynamic>),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
                    error: (error, stack) => Text('Error: $error'),
                    data: (matches) => _buildUpcomingMatches(context, matches),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VOAB Training Sessies',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  trainingSessionsAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => const Text('Geen sessies'),
                    data: (sessions) =>
                        _buildUpcomingTrainingSessions(context, sessions),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // ignore: unnecessary_cast
        PerformanceChart(statistics: statistics as Map<String, dynamic>),
      ]);
    }

    return content;
  }

  Widget _buildPlayerQuickActions(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mijn Acties',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildActionCard(
                    context,
                    'Mijn Profiel',
                    Icons.person,
                    () => context.go('/players'),
                  ),
                  _buildActionCard(
                    context,
                    'Prestaties',
                    Icons.analytics,
                    () => context.go('/analytics'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildPlayerStats(BuildContext context, dynamic statistics) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mijn Statistieken',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Trainingen',
                      '${statistics?.totalTrainingAttendance ?? 0}',
                      Icons.sports,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Wedstrijden',
                      '${statistics?.totalMatches ?? 0}',
                      Icons.stadium,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildParentOverview(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overzicht van uw kind',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Spelersinformatie'),
                subtitle: const Text('Bekijk profiel en prestaties'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.go('/players'),
              ),
            ],
          ),
        ),
      );

  Widget _buildUpcomingEventsForPlayer(
    BuildContext context,
    AsyncValue<List<Match>> upcomingMatchesAsync,
    AsyncValue<List<TrainingSession>> trainingSessionsAsync,
  ) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aankomende Evenementen',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              upcomingMatchesAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => const Text('Geen wedstrijden'),
                data: (matches) => Column(
                  children: matches
                      .take(3)
                      .map(
                        (match) => ListTile(
                          leading: const Icon(Icons.stadium),
                          title: Text(match.opponent),
                          subtitle: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(match.date),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildUpcomingEventsForParent(
    BuildContext context,
    AsyncValue<List<Match>> upcomingMatchesAsync,
    AsyncValue<List<TrainingSession>> trainingSessionsAsync,
  ) =>
      _buildUpcomingEventsForPlayer(
        context,
        upcomingMatchesAsync,
        trainingSessionsAsync,
      );

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) =>
      Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSmartActions(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flash_on, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Snelle Acties',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Nieuwe Training',
                      Icons.add_circle,
                      () => context.push('/session-builder'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Seizoen Planning',
                      Icons.calendar_today,
                      () => context.push('/annual-planning'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Alle Trainingen',
                      Icons.list_alt,
                      () => context.push('/training-sessions'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Opstelling',
                      Icons.sports_soccer,
                      () => context.go('/lineup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildUpcomingTrainingSessions(
    BuildContext context,
    List<TrainingSession> sessions,
  ) {
    if (sessions.isEmpty) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[400]),
              const SizedBox(height: 8),
              const Text('Geen geplande VOAB sessies'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.push('/session-builder'),
                child: const Text('Plan Training'),
              ),
            ],
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
                  backgroundColor: _getSessionTypeColor(session.type),
                  child: Icon(
                    _getSessionTypeIcon(session.type),
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                title: Text('Training ${session.trainingNumber}'),
                subtitle: Text(
                  '${session.date.day}/${session.date.month} | ${session.phases.length} fasen\n'
                  '${session.sessionObjective ?? 'VOAB Standard'}',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, color: Colors.orange, size: 16),
                    Text(
                      '${session.sessionDuration.inMinutes}m',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
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

  Color _getSessionTypeColor(TrainingType type) {
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

  IconData _getSessionTypeIcon(TrainingType type) {
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

  Widget _buildUpcomingMatches(BuildContext context, List<Match> matches) {
    if (matches.isEmpty) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const Text('Geen aankomende wedstrijden'),
        ),
      );
    }

    return Column(
      children: matches
          .take(3)
          .map(
            (match) => Card(
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
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) =>
      Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ],
          ),
        ),
      );
}
