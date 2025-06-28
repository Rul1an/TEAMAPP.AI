import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../organization/organization_badge.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final demoMode = ref.watch(demoModeProvider);
    final currentUser = ref.watch(currentUserProvider);

    if (isDesktop) {
      // Desktop/Tablet layout with NavigationRail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _getSelectedIndex(currentRoute),
              onDestinationSelected: (index) => _onItemTapped(context, index),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'JO17',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Organization badge
                    const OrganizationBadge(),
                    const SizedBox(height: 8),
                    // Demo mode indicator
                    if (demoMode.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              size: 14,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Demo',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // User info
                    if (currentUser != null || demoMode.isActive)
                      Text(
                        demoMode.isActive
                            ? demoMode.userName ?? 'Demo User'
                            : currentUser?.email ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    // Logout button
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        if (demoMode.isActive) {
                          ref.read(demoModeProvider.notifier).endDemo();
                        } else {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .signOut();
                        }
                        if (context.mounted) {
                          context.go('/auth');
                        }
                      },
                      tooltip: 'Uitloggen',
                    ),
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Overzicht'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sports_soccer_outlined),
                  selectedIcon: Icon(Icons.sports_soccer),
                  label: Text('Seizoen'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.sports_outlined),
                  selectedIcon: Icon(Icons.sports),
                  label: Text('Trainingen'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.stadium_outlined),
                  selectedIcon: Icon(Icons.stadium),
                  label: Text('Wedstrijden'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Spelers'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: Text('Analytics'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: child,
            ),
          ],
        ),
      );
    } else {
      // Mobile layout with BottomNavigationBar
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _getSelectedIndex(currentRoute),
          onDestinationSelected: (index) => _onItemTapped(context, index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Overzicht',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_soccer_outlined),
              selectedIcon: Icon(Icons.sports_soccer),
              label: 'Seizoen',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_outlined),
              selectedIcon: Icon(Icons.sports),
              label: 'Trainingen',
            ),
            NavigationDestination(
              icon: Icon(Icons.stadium_outlined),
              selectedIcon: Icon(Icons.stadium),
              label: 'Wedstrijden',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Spelers',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
          ],
        ),
      );
    }
  }

  int _getSelectedIndex(String currentRoute) {
    if (currentRoute.startsWith('/dashboard')) return 0;
    if (currentRoute.startsWith('/season') ||
        currentRoute.startsWith('/annual-planning')) return 1;
    if (currentRoute.startsWith('/training') ||
        currentRoute.startsWith('/exercise')) return 2;
    if (currentRoute.startsWith('/matches') ||
        currentRoute.startsWith('/lineup')) return 3;
    if (currentRoute.startsWith('/players')) return 4;
    if (currentRoute.startsWith('/analytics') ||
        currentRoute.startsWith('/svs')) return 5;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/season');
        break;
      case 2:
        context.go('/training');
        break;
      case 3:
        context.go('/matches');
        break;
      case 4:
        context.go('/players');
        break;
      case 5:
        context.go('/analytics');
        break;
    }
  }
}
