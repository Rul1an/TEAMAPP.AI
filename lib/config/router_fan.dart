// Fan-family specific GoRouter configuration
//
// Lightweight router reusing shared screens but swaps the dashboard for
// `FanHomeScreen`.

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../screens/auth/login_screen.dart';
import '../screens/fan/fan_home_screen.dart';
import '../widgets/common/main_scaffold.dart';
// import 'config/router.dart' as core; // core routes not yet used in bootstrap
import '../screens/fan/fan_stats_screen.dart';
import '../config/providers.dart';
import '../screens/players/players_screen.dart';
import '../screens/training/training_screen.dart';
import '../screens/matches/matches_screen.dart';
import '../screens/annual_planning/annual_planning_screen.dart';

GoRouter createFanRouter(Ref ref) => GoRouter(
      initialLocation: '/auth',
      redirect: (context, state) {
        final isLoggedIn = ref.read(isLoggedInProvider);
        final isDemoMode = ref.read(demoModeProvider).isActive;

        final isOnAuthPage = state.fullPath?.startsWith('/auth') ?? false;
        if (isOnAuthPage) return null;
        if (!isLoggedIn && !isDemoMode) return '/auth';
        return null;
      },
      observers: [ref.read(analyticsRouteObserverProvider)],
      routes: [
        // Auth (outside shell)
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const LoginScreen(),
        ),

        // Protected routes (inside shell)
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            // Fan-specific dashboard
            GoRoute(
              path: '/dashboard',
              name: 'fan-dashboard',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FanHomeScreen()),
            ),
            // My stats screen (fan-only)
            GoRoute(
              path: '/my-stats',
              name: 'fan-stats',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FanStatsScreen()),
            ),

            // Delegate remaining routes to core router by embedding them as
            // sub-routes: we expose core routes list but skip its own shell.
            ..._cloneCoreRoutesExceptDashboard(ref),
          ],
        ),
      ],
    );

List<RouteBase> _cloneCoreRoutesExceptDashboard(Ref ref) {
  return [
    GoRoute(
      path: '/players',
      name: 'players',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: PlayersScreen()),
    ),
    GoRoute(
      path: '/training',
      name: 'training',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: TrainingScreen()),
    ),
    GoRoute(
      path: '/matches',
      name: 'matches',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MatchesScreen()),
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendar',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AnnualPlanningScreen()),
    ),
  ];
}

final routerFanProvider = Provider.autoDispose<GoRouter>(createFanRouter);
