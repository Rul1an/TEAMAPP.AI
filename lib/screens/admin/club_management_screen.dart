import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/providers.dart';
import '../../models/club/club.dart';
import '../../models/club/staff_member.dart';
import '../../models/club/team.dart';
import '../../services/feature_service.dart';
import '../../widgets/common/tier_badge.dart';

class ClubManagementScreen extends ConsumerStatefulWidget {
  const ClubManagementScreen({super.key});

  @override
  ConsumerState<ClubManagementScreen> createState() =>
      _ClubManagementScreenState();
}

class _ClubManagementScreenState extends ConsumerState<ClubManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final clubProviderInstance = ref.watch(clubProvider);
    final featureService = ref.watch(featureServiceProvider);
    final club = clubProviderInstance.currentClub;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Management'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
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
              : club != null
                  ? _buildClubManagementContent(context, club, featureService)
                  : const Center(child: Text('Geen club gevonden')),
    );
  }

  Widget _buildClubManagementContent(
          BuildContext context, Club club, FeatureService featureService,) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Info Card
            _buildClubInfoCard(context, club),
            const SizedBox(height: 24),

            // Subscription & Billing
            Text(
              'Abonnement & Facturering',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildSubscriptionCard(context, club, featureService),

            const SizedBox(height: 24),

            // Team Management
            Text(
              'Team Beheer',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildTeamManagementSection(context, club, featureService),

            const SizedBox(height: 24),

            // Staff Management
            Text(
              'Staff Beheer',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildStaffManagementSection(context, club, featureService),

            const SizedBox(height: 24),

            // Club Settings
            Text(
              'Club Instellingen',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildClubSettingsSection(context, club),
          ],
        ),
      );

  Widget _buildClubInfoCard(BuildContext context, Club club) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      club.name.isNotEmpty ? club.name[0].toUpperCase() : 'C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Opgericht: ${club.foundedYear}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  TierBadge(tier: club.tier.name),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Teams',
                      '${club.teams.length}',
                      Icons.groups,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Spelers',
                      '${club.teams.fold<int>(0, (sum, team) => sum + team.playerIds.length)}',
                      Icons.person,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      'Staff',
                      '${club.staff.length}',
                      Icons.work,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildStatItem(
          BuildContext context, String label, String value, IconData icon,) =>
      Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      );

  Widget _buildSubscriptionCard(
      BuildContext context, Club club, FeatureService featureService,) {
    final tierLimits =
        featureService.getTierLimits(club.tier.name.toLowerCase());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Huidig Abonnement',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      featureService
                          .getTierDisplayName(club.tier.name.toLowerCase()),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                if (club.tier != ClubTier.enterprise)
                  ElevatedButton(
                    onPressed: () => _showUpgradeDialog(context, club),
                    child: const Text('Upgrade'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Limieten & Gebruik',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildLimitItem(
              context,
              'Spelers',
              club.teams
                  .fold<int>(0, (sum, team) => sum + team.playerIds.length),
              tierLimits['max_players'] as int,
            ),
            _buildLimitItem(
              context,
              'Teams',
              club.teams.length,
              tierLimits['max_teams'] as int,
            ),
            _buildLimitItem(
              context,
              'Coaches',
              club.staff
                  .where((s) => s.primaryRole == StaffRole.headCoach)
                  .length,
              tierLimits['max_coaches'] as int,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitItem(
      BuildContext context, String label, int current, int limit,) {
    final isUnlimited = limit == -1;
    final percentage = isUnlimited ? 0.0 : (current / limit).clamp(0.0, 1.0);
    final isNearLimit = percentage > 0.8;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isUnlimited
                          ? '$current / Onbeperkt'
                          : '$current / $limit',
                      style: TextStyle(
                        color: isNearLimit ? Colors.orange : null,
                        fontWeight: isNearLimit ? FontWeight.bold : null,
                      ),
                    ),
                    if (isNearLimit)
                      const Icon(
                        Icons.warning,
                        size: 16,
                        color: Colors.orange,
                      ),
                  ],
                ),
                if (!isUnlimited)
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isNearLimit
                          ? Colors.orange
                          : Theme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamManagementSection(
          BuildContext context, Club club, FeatureService featureService,) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Teams (${club.teams.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _addTeam(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Team Toevoegen'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (club.teams.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Nog geen teams toegevoegd'),
                  ),
                )
              else
                ...club.teams.map(
                  (team) => ListTile(
                    leading: CircleAvatar(
                      child: Text(team.name[0].toUpperCase()),
                    ),
                    title: Text(team.name),
                    subtitle: Text('${team.playerIds.length} spelers'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Bewerken'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Verwijderen',
                                  style: TextStyle(color: Colors.red),),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editTeam(context, team);
                        } else if (value == 'delete') {
                          _deleteTeam(context, team);
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildStaffManagementSection(
          BuildContext context, Club club, FeatureService featureService,) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Staff (${club.staff.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _addStaff(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Staff Toevoegen'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (club.staff.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Nog geen staff toegevoegd'),
                  ),
                )
              else
                ...club.staff.map(
                  (staff) => ListTile(
                    leading: CircleAvatar(
                      child: Text('${staff.firstName[0]}${staff.lastName[0]}'),
                    ),
                    title: Text('${staff.firstName} ${staff.lastName}'),
                    subtitle: Text(_getStaffRoleDisplayName(staff.primaryRole)),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Bewerken'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Verwijderen',
                                  style: TextStyle(color: Colors.red),),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editStaff(context, staff);
                        } else if (value == 'delete') {
                          _deleteStaff(context, staff);
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildClubSettingsSection(BuildContext context, Club club) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instellingen',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Club Gegevens Bewerken'),
                subtitle: const Text('Naam, logo, contactgegevens'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _editClubInfo(context, club),
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Thema & Branding'),
                subtitle: const Text('Kleuren, logo, huisstijl'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _editBranding(context),
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Data Export'),
                subtitle: const Text('Exporteer club data'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _exportData(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Club Verwijderen',
                    style: TextStyle(color: Colors.red),),
                subtitle: const Text('Permanent verwijderen van alle data'),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.red),
                onTap: () => _deleteClub(context, club),
              ),
            ],
          ),
        ),
      );

  String _getStaffRoleDisplayName(StaffRole role) {
    switch (role) {
      case StaffRole.headCoach:
        return 'Hoofdcoach';
      case StaffRole.assistantCoach:
        return 'Assistent Coach';
      case StaffRole.teamManager:
        return 'Manager';
      case StaffRole.physiotherapist:
        return 'Fysiotherapeut';
      case StaffRole.analyst:
        return 'Analist';
      default:
        return 'Overig';
    }
  }

  // Action methods
  void _showSettingsDialog(BuildContext context) {
    // TODO(author): Implement settings dialog
  }

  void _showUpgradeDialog(BuildContext context, Club club) {
    // TODO(author): Implement upgrade dialog
  }

  void _addTeam(BuildContext context) {
    // TODO(author): Implement add team
  }

  void _editTeam(BuildContext context, Team team) {
    // TODO(author): Implement edit team
  }

  void _deleteTeam(BuildContext context, Team team) {
    // TODO(author): Implement delete team
  }

  void _addStaff(BuildContext context) {
    // TODO(author): Implement add staff
  }

  void _editStaff(BuildContext context, StaffMember staff) {
    // TODO(author): Implement edit staff
  }

  void _deleteStaff(BuildContext context, StaffMember staff) {
    // TODO(author): Implement delete staff
  }

  void _editClubInfo(BuildContext context, Club club) {
    // TODO(author): Implement edit club info
  }

  void _editBranding(BuildContext context) {
    // TODO(author): Implement edit branding
  }

  void _exportData(BuildContext context) {
    // TODO(author): Implement data export
  }

  void _deleteClub(BuildContext context, Club club) {
    // TODO(author): Implement delete club
  }
}
