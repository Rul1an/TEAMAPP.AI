// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../models/training_session/training_exercise.dart';
import '../providers/auth_provider.dart';
import '../providers/demo_mode_provider.dart';
import '../screens/analytics/performance_analytics_screen.dart';
import '../screens/annual_planning/annual_planning_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/matches/add_match_screen.dart';
import '../screens/matches/edit_match_screen.dart';
import '../screens/matches/lineup_builder_screen.dart';
import '../screens/matches/match_detail_screen.dart';
import '../screens/matches/matches_screen.dart';
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
import '../screens/training_sessions/exercise_designer_screen.dart';
import '../screens/training_sessions/exercise_library_screen.dart';
import '../screens/training_sessions/field_diagram_editor_screen.dart';
import '../screens/training_sessions/session_builder_screen.dart';
import '../screens/training_sessions/training_sessions_screen.dart';
import '../widgets/common/main_scaffold.dart';

// Create router with Riverpod
GoRouter createRouter(Ref ref) => GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final demoMode = ref.read(demoModeProvider);
        final isLoggedIn = ref.read(isLoggedInProvider);

        // Allow demo mode without auth
        if (demoMode.isActive) {
          // If trying to access login while in demo mode, redirect to dashboard
          if (state.matchedLocation == '/login') {
            return '/dashboard';
          }
          return null;
        }

        // Redirect to login if not authenticated
        if (!isLoggedIn && state.matchedLocation != '/login') {
          return '/login';
        }

        // Redirect to dashboard if authenticated and on login page
        if (isLoggedIn && state.matchedLocation == '/login') {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginScreen()),
        ),
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
                  path: 'attendance/:id',
                  builder: (context, state) => TrainingAttendanceScreen(
                    trainingId: state.pathParameters['id']!,
                  ),
                ),
                GoRoute(
                  path: 'edit/:id',
                  builder: (context, state) => EditTrainingScreen(
                      trainingId: state.pathParameters['id']!,),
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
              ],
            ),
            GoRoute(
              path: '/lineup',
              name: 'lineup-builder',
              pageBuilder: (context, state) {
                final matchId = state.uri.queryParameters['matchId'];
                return NoTransitionPage(
                  child: LineupBuilderScreen(matchId: matchId),
                );
              },
            ),
            GoRoute(
              path: '/annual-planning',
              name: 'annual-planning',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SeasonHubScreen()),
            ),
            GoRoute(
              path: '/annual-planning/details',
              name: 'annual-planning-details',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AnnualPlanningScreen()),
            ),
            GoRoute(
              path: '/training-sessions',
              name: 'training-sessions',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: TrainingSessionsScreen()),
            ),
            GoRoute(
              path: '/session-builder',
              name: 'session-builder',
              builder: (context, state) {
                final sessionIdString = state.uri.queryParameters['sessionId'];
                final sessionId = sessionIdString != null
                    ? int.tryParse(sessionIdString)
                    : null;
                return SessionBuilderScreen(sessionId: sessionId);
              },
            ),
            GoRoute(
              path: '/exercise-library',
              name: 'exercise-library',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ExerciseLibraryScreen()),
            ),
            GoRoute(
              path: '/field-diagram-editor',
              name: 'field-diagram-editor',
              builder: (context, state) {
                final exerciseId = state.uri.queryParameters['exerciseId'];
                return FieldDiagramEditorScreen(exerciseId: exerciseId);
              },
            ),
            GoRoute(
              path: '/exercise-designer',
              name: 'exercise-designer',
              builder: (context, state) {
                final sessionId = state.uri.queryParameters['sessionId'];
                final typeString = state.uri.queryParameters['type'];
                ExerciseType? type;

                if (typeString != null) {
                  type = ExerciseType.values.firstWhere(
                    (e) => e.name == typeString,
                    orElse: () => ExerciseType.technical,
                  );
                }

                return ExerciseDesignerScreen(
                  sessionId: sessionId,
                  initialType: type,
                );
              },
            ),
            GoRoute(
              path: '/analytics',
              name: 'performance-analytics',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PerformanceAnalyticsScreen()),
            ),
          ],
        ),
      ],
    );
