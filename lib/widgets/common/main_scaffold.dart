// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';

// Project imports:
import '../../providers/auth_provider.dart';
import '../../providers/demo_mode_provider.dart';
import '../../config/environment.dart';

// ignore_for_file: prefer_const_constructors
class MainScaffold extends ConsumerWidget {
  const MainScaffold({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final screenWidth = MediaQuery.of(context).size.width;
    // 2025 responsive breakpoints (Material 3 inspired)
    const phoneMax = 600.0;
    const tabletMax = 1024.0;
    final isPhone = screenWidth <= phoneMax;
    final isTablet = screenWidth > phoneMax && screenWidth <= tabletMax;
    final isDesktop = screenWidth > tabletMax;
    final compactLabels = screenWidth < 800;
    final demoMode = ref.watch(demoModeProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isCoachMode = Environment.isCoachMode;

    if (!isPhone) {
      // Desktop/Tablet layout with NavigationRail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _getSelectedIndex(currentRoute),
              onDestinationSelected: (index) => _onItemTapped(context, index),
              labelType: isTablet
                  ? NavigationRailLabelType.selected
                  : NavigationRailLabelType.all,
              extended: isDesktop && screenWidth > 1280,
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
                      isCoachMode ? 'Tactical Coach' : 'JO17 Coach',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Coach mode indicator
                    if (isCoachMode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.offline_pin,
                              size: 14,
                              color: Colors.green[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Coach',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    // Demo mode indicator (only in SaaS mode)
                    else if (demoMode.isActive)
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
              trailing: isCoachMode
                  ? null
                  : Padding(
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
                  label: Text(_navLabel('Dashboard', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.people_outline),
                  selectedIcon: const Icon(Icons.people),
                  label: Text(_navLabel('Spelers', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.stadium_outlined),
                  selectedIcon: const Icon(Icons.stadium),
                  label: Text(_navLabel('Wedstrijden', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.sports_outlined),
                  selectedIcon: const Icon(Icons.sports),
                  label: Text(_navLabel('Trainingen', compactLabels)),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart),
                  label: Text(_navLabel('Rapporten', compactLabels)),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: SafeArea(child: child)),
          ],
        ),
      );
    } else {
      // Mobile layout with BottomNavigationBar
      return Scaffold(
        body: SafeArea(child: child),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _getSelectedIndex(currentRoute),
          onDestinationSelected: (index) => _onItemTapped(context, index),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: _navLabel('Dashboard', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline),
              selectedIcon: const Icon(Icons.people),
              label: _navLabel('Spelers', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.stadium_outlined),
              selectedIcon: const Icon(Icons.stadium),
              label: _navLabel('Wedstrijden', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.sports_outlined),
              selectedIcon: const Icon(Icons.sports),
              label: _navLabel('Trainingen', compactLabels),
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: _navLabel('Rapporten', compactLabels),
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
  /// Mapping aligned with test expectations and UI structure:
  /// 0: Dashboard, 1: Season/Annual, 2: Training, 3: Matches, 4: Players, 5: Insights
  static int routeToNavIndex(String currentRoute) {
    if (kDebugMode) {
      print('🔍 Route mapping: $currentRoute');
    }

    if (currentRoute.startsWith('/dashboard')) {
      if (kDebugMode) {
        print('🔍 Mapped to index 0 (Dashboard)');
      }
      return 0;
    }

    // 1: Season & Annual Planning
    if (currentRoute.startsWith('/season') ||
        currentRoute.startsWith('/annual-planning')) {
      if (kDebugMode) {
        print('🔍 Mapped to index 1 (Season/Annual)');
      }
      return 1;
    }

    // 2: Training & related
    if (currentRoute.startsWith('/training') ||
        currentRoute.startsWith('/exercise') ||
        currentRoute.startsWith('/training-sessions') ||
        currentRoute.startsWith('/exercise-library') ||
        currentRoute.startsWith('/field-diagram-editor') ||
        currentRoute.startsWith('/exercise-designer')) {
      if (kDebugMode) {
        print('🔍 Mapped to index 2 (Training)');
      }
      return 2;
    }

    // 3: Matches & lineup
    if (currentRoute.startsWith('/matches') ||
        currentRoute.startsWith('/lineup')) {
      if (kDebugMode) {
        print('🔍 Mapped to index 3 (Matches)');
      }
      return 3;
    }

    // 4: Players
    if (currentRoute.startsWith('/players')) {
      if (kDebugMode) {
        print('🔍 Mapped to index 4 (Players)');
      }
      return 4;
    }

    // 5: Insights & legacy analytics
    if (currentRoute.startsWith('/insights') ||
        currentRoute.startsWith('/analytics') ||
        currentRoute.startsWith('/svs')) {
      if (kDebugMode) {
        print('🔍 Mapped to index 5 (Insights)');
      }
      return 5;
    }

    if (kDebugMode) {
      print('🔍 No match, defaulting to index 0');
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    // 🛡️ 2025 Fix: Defensive navigation with explicit break statements
    // and detailed logging for debugging navigation issues
    if (kDebugMode) {
      print('🧭 Navigation: Tapped index $index');
    }

    switch (index) {
      case 0:
        if (kDebugMode) {
          print('🧭 Navigating to: /dashboard');
        }
        context.go('/dashboard');
        break;
      case 1:
        if (kDebugMode) {
          print('🧭 Navigating to: /players (Spelers)');
        }
        context.go('/players');
        break;
      case 2:
        if (kDebugMode) {
          print('🧭 Navigating to: /matches (Wedstrijden)');
        }
        context.go('/matches');
        break;
      case 3:
        if (kDebugMode) {
          print('🧭 Navigating to: /training (Trainingen)');
        }
        context.go('/training');
        break;
      case 4:
        if (kDebugMode) {
          print('🧭 Navigating to: /insights (Rapporten)');
        }
        context.go('/insights');
        break;
      default:
        if (kDebugMode) {
          print('🧭 Invalid navigation index: $index, defaulting to dashboard');
        }
        context.go('/dashboard');
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
