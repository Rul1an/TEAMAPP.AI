// ignore_for_file: undefined_getter, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:jo17_tactical_manager/screens/fan/fan_home_screen.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (c, s) => const FanHomeScreen()),
        GoRoute(
          path: '/training',
          builder: (c, s) => const Placeholder(key: Key('training')),
        ),
        GoRoute(
          path: '/matches',
          builder: (c, s) => const Placeholder(key: Key('matches')),
        ),
        GoRoute(
          path: '/players',
          builder: (c, s) => const Placeholder(key: Key('players')),
        ),
        GoRoute(
          path: '/calendar',
          builder: (c, s) => const Placeholder(key: Key('calendar')),
        ),
        GoRoute(
          path: '/my-stats',
          builder: (c, s) => const Placeholder(key: Key('stats')),
        ),
      ],
    );
  });

  Future<void> _pump(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('tap Training card navigates', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Training'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('training')), findsOneWidget);
  });

  testWidgets('tap Matches card navigates', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Matches'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('matches')), findsOneWidget);
  });
}
