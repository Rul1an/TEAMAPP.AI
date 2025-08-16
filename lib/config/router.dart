// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/matches/add_match_screen.dart';
import '../screens/matches/edit_match_screen.dart';
import '../screens/matches/lineup_builder_screen.dart';
import '../screens/matches/match_detail_screen.dart';
import '../screens/matches/matches_screen.dart';
import '../screens/insights/insights_screen.dart';
import '../screens/players/add_player_screen.dart';
import '../screens/players/assessment_screen.dart';
import '../screens/players/edit_player_screen.dart';
import '../screens/players/player_detail_screen.dart';
import '../screens/players/players_screen.dart';
import '../screens/season/season_hub_screen.dart';
import '../screens/training/add_training_screen.dart';
import '../screens/training/edit_training_screen.dart';
import '../screens/training/training_attendance_screen.dart';
import '../screens/training/training_screen.dart';
import '../screens/offline/offline_screen.dart';
import '../screens/training_sessions/exercise_designer_screen.dart';
import '../screens/training_sessions/exercise_library_screen.dart';
import '../screens/training_sessions/field_diagram_editor_screen.dart';
import '../screens/training_sessions/session_builder/session_builder_view.dart';
import '../screens/training_sessions/training_sessions_screen.dart';
import '../widgets/common/main_scaffold.dart';
// import schedule import removed – feature postponed
import '../config/providers.dart';
import '../config/environment.dart';
import '../providers/connectivity_status_provider.dart';
import '../services/monitoring_service.dart';

GoRouter createRouter(Ref ref) => GoRouter(
      // 🎯 2025 Best Practice: Direct routing based on app mode
      initialLocation: Environment.isStandaloneMode ? '/dashboard' : '/auth',
      redirect: (context, state) {
        MonitoringService.breadcrumb('router.redirect.enter',
            data: {
              'path': state.fullPath,
              'mode': Environment.appMode.name,
            },
            category: 'router');
        // Helper to map mutation paths to safe view routes
        String? mapMutationPath(String path) {
          // Basic patterns for add/edit/build routes
          if (path.startsWith('/players/') && path.contains('/edit')) {
            return '/players';
          }
          if (path == '/players/add') return '/players';

          if (path.startsWith('/matches/') && path.contains('/edit')) {
            return '/matches';
          }
          if (path == '/matches/add') return '/matches';

          if (path == '/training/add') return '/training';
          if (path.startsWith('/training/') && path.contains('/edit')) {
            return '/training';
          }

          if (path.startsWith('/training-sessions/builder')) {
            return '/training-sessions';
          }

          return null;
        }

        // In standalone mode, skip auth and block mutation deep-links
        if (Environment.isStandaloneMode) {
          final path = state.fullPath ?? '';
          if (path.startsWith('/auth')) return '/dashboard';
          final mapped = mapMutationPath(path);
          return mapped; // null when not a mutation path
        }

        // Demo and SaaS mode authentication flows (null-safe)
        try {
          // Basic offline guard: when offline, keep user on current route (avoid loops)
          bool isOnline = true; // safe default during startup
          try {
            final asyncConn = ref.read(connectivityStatusProvider);
            isOnline = asyncConn.when(
              data: (bool v) => v,
              loading: () => true,
              error: (_, __) => true,
            );
          } catch (_) {
            isOnline = true;
          }
          MonitoringService.breadcrumb('router.guard.net',
              data: {
                'online': isOnline,
              },
              category: 'router');

          bool isLoggedIn = false;
          try {
            isLoggedIn = ref.read(isLoggedInProvider);
          } catch (_) {
            isLoggedIn = false;
          }
          MonitoringService.breadcrumb('router.guard.auth',
              data: {
                'logged_in': isLoggedIn,
              },
              category: 'router');

          bool isDemoMode = false;
          try {
            isDemoMode = ref.read(demoModeProvider).isActive;
          } catch (_) {
            isDemoMode = false;
          }
          MonitoringService.breadcrumb('router.guard.demo',
              data: {
                'demo_active': isDemoMode,
              },
              category: 'router');

          final isOnAuthPage = state.fullPath?.startsWith('/auth') ?? false;

          // Always allow access to auth page
          if (isOnAuthPage) {
            MonitoringService.breadcrumb('router.allow.auth',
                category: 'router');
            return null;
          }

          if (!isOnline) {
            // Keep user on current route; if still at /auth or unknown, show offline page
            final path = state.fullPath ?? '';
            if (path.isEmpty || path == '/' || path.startsWith('/auth')) {
              MonitoringService.breadcrumb('router.redirect.offline',
                  category: 'router');
              return '/offline';
            }
            return null;
          }

          // If not logged in and not in demo mode, redirect to auth
          if (!isLoggedIn && !isDemoMode) {
            MonitoringService.breadcrumb('router.redirect.auth',
                category: 'router');
            return '/auth';
          }

          // In demo mode, block mutation deep-links
          if (isDemoMode) {
            final path = state.fullPath ?? '';
            final mapped = mapMutationPath(path);
            if (mapped != null) return mapped;
          }

          MonitoringService.breadcrumb('router.redirect.ok',
              data: {
                'path': state.fullPath,
              },
              category: 'router');
          return null;
        } catch (e) {
          // Providers may not be ready during early router boot; allow auth as fallback
          final isOnAuthPage = state.fullPath?.startsWith('/auth') ?? false;
          MonitoringService.breadcrumb('router.redirect.fallback',
              data: {
                'error': e.toString(),
              },
              category: 'router',
              level: SentryLevel.warning);
          return isOnAuthPage ? null : '/auth';
        }
      },
      observers: [
        ref.read(analyticsRouteObserverProvider),
        // 2025: Add Sentry observer to capture navigation breadcrumbs
        SentryNavigatorObserver(),
      ],
      routes: [
        // Auth route (outside of shell)
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/offline',
          name: 'offline',
          builder: (context, state) => const OfflineScreen(),
        ),

        // Protected routes (inside shell with auth guard)
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
                  path: 'add',
                  name: 'add-player',
                  builder: (context, state) => const AddPlayerScreen(),
                ),
                GoRoute(
                  path: ':playerId',
                  name: 'player-detail',
                  builder: (context, state) => PlayerDetailScreen(
                    playerId: state.pathParameters['playerId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: ':playerId/edit',
                  builder: (context, state) => EditPlayerScreen(
                    playerId: state.pathParameters['playerId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: ':playerId/assessment',
                  name: 'new-assessment',
                  builder: (context, state) => AssessmentScreen(
                    playerId: state.pathParameters['playerId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: ':playerId/assessment/:assessmentId',
                  name: 'edit-assessment',
                  builder: (context, state) => AssessmentScreen(
                    playerId: state.pathParameters['playerId'] ?? '',
                    assessmentId: state.pathParameters['assessmentId'],
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/training',
              name: 'training',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: TrainingScreen()),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'add-training',
                  builder: (context, state) => const AddTrainingScreen(),
                ),
                GoRoute(
                  path: ':trainingId/edit',
                  builder: (context, state) => EditTrainingScreen(
                    trainingId: state.pathParameters['trainingId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: ':trainingId/attendance',
                  name: 'training-attendance',
                  builder: (context, state) => TrainingAttendanceScreen(
                    trainingId: state.pathParameters['trainingId'] ?? '',
                  ),
                ),
              ],
            ),
            GoRoute(
              path: '/matches',
              name: 'matches',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MatchesScreen()),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'add-match',
                  builder: (context, state) => const AddMatchScreen(),
                ),
                GoRoute(
                  path: ':matchId',
                  name: 'match-detail',
                  builder: (context, state) => MatchDetailScreen(
                    matchId: state.pathParameters['matchId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: ':matchId/edit',
                  builder: (context, state) => EditMatchScreen(
                    matchId: state.pathParameters['matchId'] ?? '',
                  ),
                ),
                GoRoute(
                  path: 'lineup',
                  name: 'lineup-builder',
                  builder: (context, state) => const LineupBuilderScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/insights',
              name: 'insights',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: InsightsScreen()),
            ),
            GoRoute(
              path: '/season',
              name: 'season',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SeasonHubScreen()),
            ),
            GoRoute(
              path: '/exercise-library',
              name: 'exercise-library',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ExerciseLibraryScreen(),
              ),
            ),
            GoRoute(
              path: '/field-diagram-editor',
              name: 'field-diagram-editor',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: FieldDiagramEditorScreen(),
              ),
            ),
            GoRoute(
              path: '/exercise-designer',
              name: 'exercise-designer',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ExerciseDesignerScreen(),
              ),
            ),
            GoRoute(
              path: '/training-sessions',
              name: 'training-sessions',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: TrainingSessionsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'builder',
                  name: 'session-builder',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: SessionBuilderView(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

// Router provider - Remove autoDispose to prevent navigation state loss
final routerProvider = Provider<GoRouter>(createRouter);
