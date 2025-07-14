// Fan & Family router – exposes only view-only, read-only routes for Parents & Players
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../providers/auth_provider.dart';
import '../providers/demo_mode_provider.dart';
import '../widgets/common/main_scaffold.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/players/player_detail_screen.dart';
import '../screens/players/players_screen.dart';
import '../screens/training/training_screen.dart';
import '../screens/matches/match_detail_screen.dart';
import '../screens/matches/matches_screen.dart';

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
  routes: [
    // Auth
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const LoginScreen(),
    ),

    // Shell with navigation
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: '/players',
          name: 'players',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PlayersScreen()),
          routes: [
            GoRoute(
              path: ':playerId',
              name: 'player-detail',
              builder: (context, state) => PlayerDetailScreen(
                playerId: state.pathParameters['playerId'] ?? '',
              ),
            ),
          ],
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
          routes: [
            GoRoute(
              path: ':matchId',
              name: 'match-detail',
              builder: (context, state) => MatchDetailScreen(
                matchId: state.pathParameters['matchId'] ?? '',
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

// Provider for fan router
final routerFanProvider = Provider.autoDispose<GoRouter>(createFanRouter);