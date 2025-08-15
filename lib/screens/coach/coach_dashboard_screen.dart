// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../config/providers.dart';
import '../../constants/roles.dart';
import '../../services/feature_service.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubProviderInstance = ref.watch(clubProvider);
    final featureService = ref.watch(featureServiceProvider);
    final club = clubProviderInstance.currentClub;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Meldingen',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () {
              // TODO(author): Implement notifications
            },
          ),
        ],
      ),
      body: clubProviderInstance.isLoading
          ? const Center(child: CircularProgressIndicator())
          : clubProviderInstance.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${clubProviderInstance.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            clubProviderInstance.loadClub('default-club'),
                        child: const Text('Probeer Opnieuw'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Card
                      _buildWelcomeCard(context),
                      const SizedBox(height: 24),

                      // Quick Actions
                      Text(
                        'Snelle Acties',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickActions(context, club, featureService),

                      const SizedBox(height: 24),

                      // Team Management
                      Text(
                        'Team Management',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildTeamManagement(context, club, featureService),

                      const SizedBox(height: 24),

                      // Planning & Analysis
                      Text(
                        'Planning & Analyse',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildPlanningAnalysis(context, club, featureService),

                      const SizedBox(height: 24),

                      // Upcoming Events
                      Text(
                        'Aankomende Activiteiten',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildUpcomingEvents(context),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickPlanDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Snel Plannen'),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) => Card(
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welkom terug, Coach!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Klaar om je team naar het volgende niveau te brengen?',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatChip('Volgende Training', 'Morgen 19:00'),
                  const SizedBox(width: 12),
                  _buildStatChip('Volgende Wedstrijd', 'Zaterdag 14:30'),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildStatChip(String label, String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildQuickActions(
    BuildContext context,
    dynamic club,
    FeatureService featureService,
  ) =>
      Row(
        children: [
          Expanded(
            child: _buildActionCard(
              context,
              'Training Plannen',
              Icons.calendar_today,
              Colors.blue,
              () => context.push('/training/quick'),
              isAvailable: featureService.hasPermission(
                Roles.hoofdcoach,
                'manage_training',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              context,
              'Opstelling Maken',
              Icons.sports_soccer,
              Colors.green,
              () => context.push('/matches/lineup'),
              isAvailable: featureService.hasPermission(
                Roles.hoofdcoach,
                'manage_tactics',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionCard(
              context,
              'Speler Beoordelen',
              Icons.assessment,
              Colors.orange,
              () => context.push('/players/assessment'),
              isAvailable: featureService.hasPermission(
                Roles.hoofdcoach,
                'view_player_data',
              ),
            ),
          ),
        ],
      );

  Widget _buildTeamManagement(
    BuildContext context,
    dynamic club,
    FeatureService featureService,
  ) =>
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildManagementCard(
            context,
            'Spelers Overzicht',
            'Bekijk en beheer je spelersgroep',
            Icons.people,
            Colors.blue,
            () => context.push('/players'),
          ),
          _buildManagementCard(
            context,
            'Training Sessies',
            'Plan en organiseer trainingen',
            Icons.fitness_center,
            Colors.green,
            () => context.push('/training'),
          ),
          _buildManagementCard(
            context,
            'Wedstrijden',
            'Beheer wedstrijden en resultaten',
            Icons.stadium,
            Colors.red,
            () => context.push('/matches'),
          ),
          _buildManagementCard(
            context,
            'Aanwezigheid',
            'Bijhouden van training aanwezigheid',
            Icons.check_circle,
            Colors.orange,
            () => context.push('/training/attendance'),
          ),
        ],
      );

  Widget _buildPlanningAnalysis(
    BuildContext context,
    dynamic club,
    FeatureService featureService,
  ) =>
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildManagementCard(
            context,
            'Weekplanning',
            'Plan je trainingsweek',
            Icons.view_week,
            Colors.purple,
            () => context.push('/planning/week'),
            isAvailable: featureService.isFeatureAvailable(
              'advanced_training_planning',
              club.tier as String,
            ),
          ),
          _buildManagementCard(
            context,
            'Jaarplanning',
            'Seizoen en periodisering',
            Icons.calendar_today,
            Colors.indigo,
            () => context.push('/planning/annual'),
            isAvailable: featureService.isFeatureAvailable(
              'annual_planning',
              club.tier as String,
            ),
          ),
          _buildManagementCard(
            context,
            'Prestatie Analyse',
            'Speler en team statistieken',
            Icons.analytics,
            Colors.teal,
            () => context.push('/analytics'),
            isAvailable: featureService.isFeatureAvailable(
              'performance_analytics',
              club.tier as String,
            ),
          ),
          _buildManagementCard(
            context,
            'SVS Dashboard',
            'Speler Volg Systeem',
            Icons.monitor_heart,
            Colors.pink,
            () => context.push('/player-tracking'),
            isAvailable: featureService.isFeatureAvailable(
              'player_tracking_svs',
              club.tier as String,
            ),
          ),
        ],
      );

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isAvailable = true,
  }) =>
      Card(
        elevation: isAvailable ? 2 : 1,
        child: InkWell(
          onTap: isAvailable ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isAvailable
                  ? color.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: isAvailable ? color : Colors.grey),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? color : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildManagementCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isAvailable = true,
  }) =>
      Card(
        elevation: isAvailable ? 2 : 1,
        child: InkWell(
          onTap: isAvailable ? onTap : () => _showUpgradeDialog(context, title),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Icon(
                      icon,
                      size: 28,
                      color: isAvailable ? color : Colors.grey,
                    ),
                    if (!isAvailable)
                      const Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(Icons.lock, size: 14, color: Colors.grey),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isAvailable ? null : Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildUpcomingEvents(BuildContext context) {
    final events = [
      {'title': 'Training JO17-1', 'time': 'Morgen 19:00', 'type': 'training'},
      {
        'title': 'Wedstrijd vs Ajax JO17',
        'time': 'Zaterdag 14:30',
        'type': 'match',
      },
      {'title': 'Teambespreking', 'time': 'Vrijdag 18:00', 'type': 'meeting'},
    ];

    return Card(
      child: Column(
        children: events
            .map(
              (event) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getEventColor(event['type']!),
                  child: Icon(
                    _getEventIcon(event['type']!),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(event['title']!),
                subtitle: Text(event['time']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to event details
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'training':
        return Colors.blue;
      case 'match':
        return Colors.red;
      case 'meeting':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'training':
        return Icons.sports_soccer;
      case 'match':
        return Icons.stadium;
      case 'meeting':
        return Icons.meeting_room;
      default:
        return Icons.event;
    }
  }

  void _showUpgradeDialog(BuildContext context, String feature) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade Vereist'),
        content: Text('$feature is alleen beschikbaar in hogere abonnementen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sluiten'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/admin/billing');
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _showQuickPlanDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Snel Plannen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sports_soccer, color: Colors.blue),
              title: const Text('Training Plannen'),
              onTap: () {
                Navigator.pop(context);
                context.push('/training/quick');
              },
            ),
            ListTile(
              leading: const Icon(Icons.stadium, color: Colors.red),
              title: const Text('Wedstrijd Toevoegen'),
              onTap: () {
                Navigator.pop(context);
                context.push('/matches/add');
              },
            ),
            ListTile(
              leading: const Icon(Icons.meeting_room, color: Colors.orange),
              title: const Text('Vergadering Plannen'),
              onTap: () {
                Navigator.pop(context);
                // TODO(author): Implement meeting planning
              },
            ),
          ],
        ),
      ),
    );
  }
}
