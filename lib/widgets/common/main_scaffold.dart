import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isDesktop = MediaQuery.of(context).size.width > 600;

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
                padding: const EdgeInsets.all(8.0),
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

  int _getSelectedIndex(String route) {
    if (route.startsWith('/dashboard')) return 0;
    if (route.startsWith('/annual-planning') || route.startsWith('/season')) return 1;
    if (route.startsWith('/training-sessions') || route.startsWith('/session-builder') ||
        route.startsWith('/exercise-library') || route.startsWith('/exercise-designer') ||
        route.startsWith('/field-diagram-editor')) return 2;
    if (route.startsWith('/matches')) return 3;
    if (route.startsWith('/players')) return 4;
    if (route.startsWith('/analytics')) return 5;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/annual-planning');
        break;
      case 2:
        context.go('/training-sessions');
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
