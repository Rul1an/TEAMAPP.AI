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
// import '../config/environment.dart';
// import '../providers/connectivity_status_provider.dart';
import '../services/monitoring_service.dart';

GoRouter createRouter(Ref ref) => GoRouter(
      // Restore normal initial route
      initialLocation: '/dashboard',
      redirect: (context, state) {
        try {
          // Basic guards restored (lightweight): allow auth and offline
          final isOnAuth = state.fullPath?.startsWith('/auth') ?? false;
          if (isOnAuth) return null;

          // Avoid heavy provider access during early boot; soft-allow
          MonitoringService.breadcrumb('router.redirect.ok',
              data: {'path': state.fullPath}, category: 'router');
          return null;
        } catch (e) {
          MonitoringService.breadcrumb('router.redirect.fallback',
              data: {'error': e.toString()}, category: 'router');
          return null;
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
