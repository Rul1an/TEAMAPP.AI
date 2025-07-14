// Fan-family specific GoRouter configuration
//
// Lightweight router reusing shared screens but swaps the dashboard for
// `FanHomeScreen`.

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import '../providers/auth_provider.dart';
import '../providers/demo_mode_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/fan/fan_home_screen.dart';
import '../widgets/common/main_scaffold.dart';
import 'router.dart' as core; // for the rest of the screens

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
            // Delegate remaining routes to core router by embedding them as
            // sub-routes: we expose core routes list but skip its own shell.
            ..._cloneCoreRoutesExceptDashboard(ref),
          ],
        ),
      ],
    );

List<RouteBase> _cloneCoreRoutesExceptDashboard(Ref ref) {
  final original = core.createRouter(ref);
  // The first ShellRoute from original is MainScaffold; we want its children.
  final shell = original.routes.whereType<ShellRoute>().first;
  final List<RouteBase> others = [];
  for (final r in shell.routes) {
    if (r is GoRoute && r.path == '/dashboard') continue;
    others.add(r);
  }
  return others;
}

final routerFanProvider = Provider.autoDispose<GoRouter>(createFanRouter);