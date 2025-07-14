// Fan-family specific GoRouter wrapper
//
// At kick-off we simply delegate to the existing router from `router.dart`.
// Over the next sprints we will slim this down to hide staff-only routes and
// tune the navigation for O (Parent) & P (Player) roles.

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'router.dart' as core_router;

GoRouter createFanRouter(Ref ref) => core_router.createRouter(ref);

/// Provider so widgets can `ref.watch(routerFanProvider)` independent from the
/// coach_suite router.
final routerFanProvider = Provider.autoDispose<GoRouter>(createFanRouter);