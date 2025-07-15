// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../models/organization.dart';
import '../providers/demo_mode_provider.dart';
import '../services/permission_service.dart';

/// 🎭 RBAC Demo Widget for testing role-based access control
/// Allows quick switching between roles and shows available features
class RBACDemoWidget extends ConsumerWidget {
  const RBACDemoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demoState = ref.watch(demoModeProvider);
    final currentRole = ref.read(demoModeProvider.notifier).getDemoRole();

    if (!demoState.isDemo) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'RBAC Demo Mode',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text('Rol: ${_getRoleDisplayName(currentRole)}'),
                  backgroundColor: _getRoleColor(
                    currentRole,
                  ).withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Role Selection
            Text(
              'Kies een rol om te testen:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildRoleButton(
                  context,
                  ref,
                  'bestuurder',
                  'Bestuurder',
                  Icons.admin_panel_settings,
                  Colors.red,
                ),
                _buildRoleButton(
                  context,
                  ref,
                  'hoofdcoach',
                  'Hoofdcoach',
                  Icons.sports,
                  Colors.blue,
                ),
                _buildRoleButton(
                  context,
                  ref,
                  'assistent',
                  'Assistent',
                  Icons.assistant,
                  Colors.green,
                ),
                _buildRoleButton(
                  context,
                  ref,
                  'speler',
                  'Speler',
                  Icons.person,
                  Colors.orange,
                ),
                _buildRoleButton(
                  context,
                  ref,
                  'ouder',
                  'Ouder',
                  Icons.family_restroom,
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Permission Overview
            Text(
              'Toegankelijke functies voor ${_getRoleDisplayName(currentRole)}:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildPermissionOverview(context, currentRole),

            const SizedBox(height: 16),

            // Quick Actions
            Text(
              'Snelle acties:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildQuickActions(context, currentRole),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context,
    WidgetRef ref,
    String roleKey,
    String roleName,
    IconData icon,
    Color color,
  ) {
    final currentRole = ref.read(demoModeProvider.notifier).getDemoRole();
    final isSelected = currentRole == roleKey;

    return ElevatedButton.icon(
      onPressed: () {
        ref.read(demoModeProvider.notifier).setRole(roleKey);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rol gewijzigd naar: $roleName'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      icon: Icon(icon, size: 18),
      label: Text(roleName),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 4 : 1,
      ),
    );
  }

  Widget _buildPermissionOverview(BuildContext context, String? role) {
    final permissions = _getPermissionsForRole(role);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: permissions
            .map(
              (permission) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      permission.hasAccess ? Icons.check_circle : Icons.cancel,
                      color: permission.hasAccess ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        permission.description,
                        style: TextStyle(
                          color: permission.hasAccess
                              ? Colors.black87
                              : Colors.grey,
                          fontWeight: permission.description.startsWith('---')
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, String? role) {
    final actions = _getQuickActionsForRole(context, role);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions
          .map(
            (action) => ElevatedButton.icon(
              onPressed: action.isEnabled ? action.onPressed : null,
              icon: Icon(action.icon, size: 16),
              label: Text(action.label),
              style: ElevatedButton.styleFrom(
                backgroundColor: action.isEnabled
                    ? Colors.blue.shade100
                    : Colors.grey.shade200,
                foregroundColor:
                    action.isEnabled ? Colors.blue.shade800 : Colors.grey,
              ),
            ),
          )
          .toList(),
    );
  }

  List<PermissionInfo> _getPermissionsForRole(String? role) => [
        const PermissionInfo('Dashboard bekijken', hasAccess: true), // Everyone
        const PermissionInfo('Spelers bekijken', hasAccess: true), // Everyone
        const PermissionInfo('Training bekijken', hasAccess: true), // Everyone
        const PermissionInfo('Wedstrijden bekijken',
            hasAccess: true,), // Everyone
        const PermissionInfo('---MANAGEMENT---', hasAccess: false), // Separator
        PermissionInfo(
          'Spelers beheren',
          hasAccess: PermissionService.canManagePlayers(role),
        ),
        PermissionInfo(
          'Spelers bewerken',
          hasAccess: PermissionService.canEditPlayers(role),
        ),
        PermissionInfo(
          'Training beheren',
          hasAccess: PermissionService.canManageTraining(role),
        ),
        PermissionInfo(
          'Training aanmaken',
          hasAccess: PermissionService.canCreateTraining(role),
        ),
        PermissionInfo(
          'Wedstrijden beheren',
          hasAccess: PermissionService.canManageMatches(role),
        ),
        PermissionInfo(
          'Exercise Library',
          hasAccess: PermissionService.canManageExerciseLibrary(role),
        ),
        PermissionInfo(
          'Field Diagram Editor',
          hasAccess: PermissionService.canAccessFieldDiagramEditor(role),
        ),
        PermissionInfo(
          'Exercise Designer',
          hasAccess: PermissionService.canAccessExerciseDesigner(role),
        ),
        const PermissionInfo('---ADVANCED---', hasAccess: false), // Separator
        PermissionInfo(
          'Analytics bekijken',
          hasAccess: PermissionService.canViewAnalytics(role),
        ),
        PermissionInfo(
          'SVS toegang',
          hasAccess: PermissionService.canAccessSVS(role, OrganizationTier.pro),
        ),
        PermissionInfo(
          'Jaarplanning',
          hasAccess: PermissionService.canAccessAnnualPlanning(role),
        ),
        PermissionInfo(
          'Admin functies',
          hasAccess: PermissionService.canAccessAdmin(role),
        ),
        const PermissionInfo('---STATUS---', hasAccess: false), // Separator
        PermissionInfo(
          '🔒 Alleen bekijken',
          hasAccess: PermissionService.isViewOnlyUser(role),
        ),
      ];

  List<QuickActionInfo> _getQuickActionsForRole(
    BuildContext context,
    String? role,
  ) =>
      [
        QuickActionInfo(
          'Dashboard',
          Icons.dashboard,
          isEnabled: true,
          onPressed: () => context.go('/dashboard'),
        ),
        QuickActionInfo(
          'Spelers',
          Icons.people,
          isEnabled: true,
          onPressed: () => context.go('/players'),
        ),
        QuickActionInfo(
          'Training',
          Icons.fitness_center,
          isEnabled: true,
          onPressed: () => context.go('/training'),
        ),
        QuickActionInfo(
          'Wedstrijden',
          Icons.sports_soccer,
          isEnabled: true,
          onPressed: () => context.go('/matches'),
        ),
        QuickActionInfo(
          'Analytics',
          Icons.analytics,
          isEnabled: PermissionService.canViewAnalytics(role),
          onPressed: () => context.go('/analytics'),
        ),
        QuickActionInfo(
          'SVS Dashboard',
          Icons.track_changes,
          isEnabled: PermissionService.canAccessSVS(role, OrganizationTier.pro),
          onPressed: () => context.go('/svs'),
        ),
        QuickActionInfo(
          'Admin Panel',
          Icons.admin_panel_settings,
          isEnabled: PermissionService.canAccessAdmin(role),
          onPressed: () => context.go('/admin'),
        ),
      ];

  String _getRoleDisplayName(String? role) {
    switch (role) {
      case 'bestuurder':
        return 'Bestuurder';
      case 'hoofdcoach':
        return 'Hoofdcoach';
      case 'assistent':
        return 'Assistent';
      case 'speler':
        return 'Speler';
      case 'ouder':
        return 'Ouder';
      case 'admin':
        return 'Admin';
      default:
        return 'Onbekend';
    }
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'bestuurder':
        return Colors.red;
      case 'hoofdcoach':
        return Colors.blue;
      case 'assistent':
        return Colors.green;
      case 'speler':
        return Colors.orange;
      case 'ouder':
        return Colors.purple;
      case 'admin':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class PermissionInfo {
  const PermissionInfo(this.description, {required this.hasAccess});
  final String description;
  final bool hasAccess;
}

class QuickActionInfo {
  const QuickActionInfo(
    this.label,
    this.icon, {
    required this.isEnabled,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onPressed;
}
