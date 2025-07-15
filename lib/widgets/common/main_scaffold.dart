// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../../providers/auth_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../organization/organization_badge.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final compactLabels = screenWidth < 800;
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
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.dashboard_outlined),
                  selectedIcon: const Icon(Icons.dashboard),
                  label: Text(_navLabel('Overzicht', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.sports_soccer_outlined),
                  selectedIcon: const Icon(Icons.sports_soccer),
                  label: Text(_navLabel('Seizoen', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.sports_outlined),
                  selectedIcon: const Icon(Icons.sports),
                  label: Text(_navLabel('Training', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.stadium_outlined),
                  selectedIcon: const Icon(Icons.stadium),
                  label: Text(_navLabel('Wedstr', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.people_outline),
                  selectedIcon: const Icon(Icons.people),
                  label: Text(_navLabel('Spelers', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.insights_outlined),
                  selectedIcon: const Icon(Icons.insights),
                  label: Text(_navLabel('Insights', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.video_library_outlined),
                  selectedIcon: const Icon(Icons.video_library),
                  label: Text(_navLabel('Video', compactLabels)),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
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
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: _navLabel('Overzicht', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.sports_soccer_outlined),
              selectedIcon: const Icon(Icons.sports_soccer),
              label: _navLabel('Seizoen', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.sports_outlined),
              selectedIcon: const Icon(Icons.sports),
              label: _navLabel('Training', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.stadium_outlined),
              selectedIcon: const Icon(Icons.stadium),
              label: _navLabel('Wedstr', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline),
              selectedIcon: const Icon(Icons.people),
              label: _navLabel('Spelers', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.insights_outlined),
              selectedIcon: const Icon(Icons.insights),
              label: _navLabel('Insights', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.video_library_outlined),
              selectedIcon: const Icon(Icons.video_library),
              label: _navLabel('Video', compactLabels),
            ),
          ],
        ),
      );
    }
  }

  int _getSelectedIndex(String currentRoute) {
    return routeToNavIndex(currentRoute);
  }

  /// Public helper for testing: maps a route string to the nav index used
  /// by both NavigationRail and NavigationBar.
  static int routeToNavIndex(String currentRoute) {
    if (currentRoute.startsWith('/dashboard')) return 0;
    if (currentRoute.startsWith('/season') ||
        currentRoute.startsWith('/annual-planning')) {
      return 1;
    }
    if (currentRoute.startsWith('/training') ||
        currentRoute.startsWith('/exercise') ||
        currentRoute.startsWith('/training-sessions') ||
        currentRoute.startsWith('/exercise-library') ||
        currentRoute.startsWith('/field-diagram-editor') ||
        currentRoute.startsWith('/exercise-designer')) {
      return 2;
    }
    if (currentRoute.startsWith('/matches') ||
        currentRoute.startsWith('/lineup')) {
      return 3;
    }
    if (currentRoute.startsWith('/players')) return 4;
    if (currentRoute.startsWith('/insights') ||
        currentRoute.startsWith('/analytics') ||
        currentRoute.startsWith('/svs')) {
      return 5;
    }
    if (currentRoute.startsWith('/videos')) return 6;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/season');
      case 2:
        context.go('/training');
      case 3:
        context.go('/matches');
      case 4:
        context.go('/players');
      case 5:
        context.go('/insights');
      case 6:
        context.go('/videos');
    }
  }

  String _navLabel(String full, bool compact) {
    if (!compact) return full;
    // Truncate to 6 chars for compact mode, add ellipsis if longer
    const maxLen = 6;
    if (full.length <= maxLen) return full;
    return '${full.substring(0, maxLen)}…';
  }
}
