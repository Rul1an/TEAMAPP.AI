import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
        actions:
            _buildAppBarActions(context, userRole, organization?.tier.name),
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
                    _buildWelcomeSection(context, season, userRole),
                loading: () => _buildLoadingWelcome(context, userRole),
                error: (error, stack) =>
                    _buildNoSeasonWelcome(context, userRole),
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

  List<Widget> _buildAppBarActions(
    BuildContext context,
    String? userRole,
    String? tier,
  ) {
    final List<Widget> actions = [];

    // Only coaches and admins can create training sessions
    if (PermissionService.canManageTraining(userRole)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => context.push('/session-builder'),
          tooltip: 'Nieuwe Training',
        ),
      );
    }

    // Only coaches can create lineups
    if (PermissionService.canManageMatches(userRole)) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.sports_soccer),
          onPressed: () => context.go('/lineup'),
          tooltip: 'Opstelling Maken',
        ),
      );
    }

    return actions;
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
    final List<Widget> content = [];

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
        _buildStatisticsCards(context, statistics as Map<String, dynamic>),
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
        _buildPerformanceChart(context, statistics),
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

  Widget _buildWelcomeSection(
    BuildContext context,
    SeasonPlan? season,
    String? userRole,
  ) {
    if (season == null) {
      return _buildNoSeasonWelcome(context, userRole);
    }

    final currentPhase = season.getCurrentPhase();
    final progress = season.seasonProgressByDate;
    String welcomeMessage = 'Welkom terug!';

    if (PermissionService.isPlayer(userRole)) {
      welcomeMessage = 'Hallo speler!';
    } else if (PermissionService.isParent(userRole)) {
      welcomeMessage = 'Welkom ouder!';
    } else if (PermissionService.canAccessAdmin(userRole)) {
      welcomeMessage = 'Welkom bestuurder!';
    } else {
      welcomeMessage = 'Welkom terug, Coach!';
    }

    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.waving_hand,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        welcomeMessage,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        '${season.teamName} - ${currentPhase.displayName}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('Week ${season.currentWeek}'),
                  backgroundColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timeline, color: Colors.grey[600], size: 16),
                const SizedBox(width: 4),
                Text('Seizoen: ${progress.toStringAsFixed(0)}% voltooid'),
                const Spacer(),
                Text('${season.remainingWeeks} weken te gaan'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWelcome(BuildContext context, String? userRole) => Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );

  Widget _buildNoSeasonWelcome(BuildContext context, String? userRole) => Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.sports_soccer_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'Welkom bij JO17 Tactical Manager',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Start door je seizoenplanning in te stellen',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.push('/annual-planning'),
                child: const Text('Begin Setup'),
              ),
            ],
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

  Widget _buildStatisticsCards(
    BuildContext context,
    Map<String, dynamic> statistics,
  ) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
          final childAspectRatio = constraints.maxWidth > 800 ? 1.5 : 1.2;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(
                context,
                'Spelers',
                statistics['totalPlayers'].toString(),
                Icons.people,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Wedstrijden',
                statistics['totalMatches'].toString(),
                Icons.sports_soccer,
                Colors.green,
              ),
              _buildStatCard(
                context,
                'Trainingen',
                statistics['totalTrainings'].toString(),
                Icons.fitness_center,
                Colors.orange,
              ),
              _buildStatCard(
                context,
                'Win %',
                '${statistics['winPercentage'].toStringAsFixed(1)}%',
                Icons.emoji_events,
                Colors.amber,
              ),
            ],
          );
        },
      );

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

  Widget _buildPerformanceChart(
    BuildContext context,
    Map<String, dynamic> statistics,
  ) {
    final wins = statistics['wins'] as int;
    final draws = statistics['draws'] as int;
    final losses = statistics['losses'] as int;
    final total = wins + draws + losses;

    if (total == 0) {
      return Card(
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: const Center(
            child: Text('Nog geen wedstrijden gespeeld'),
          ),
        ),
      );
    }

    return Card(
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wedstrijd Resultaten',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: wins.toDouble(),
                            title: 'W: $wins',
                            color: Colors.green,
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: draws.toDouble(),
                            title: 'G: $draws',
                            color: Colors.orange,
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: losses.toDouble(),
                            title: 'V: $losses',
                            color: Colors.red,
                            radius: 60,
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem('Gewonnen', Colors.green, wins),
                      const SizedBox(height: 8),
                      _buildLegendItem('Gelijk', Colors.orange, draws),
                      const SizedBox(height: 8),
                      _buildLegendItem('Verloren', Colors.red, losses),
                      const Divider(height: 24),
                      Text(
                        'Doelpunten',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('Voor: ${statistics['goalsFor']}'),
                      Text('Tegen: ${statistics['goalsAgainst']}'),
                      Text('Saldo: ${statistics['goalDifference']}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int value) => Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text('$label: $value'),
        ],
      );

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
}
