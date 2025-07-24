// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:test_utils/surface_utils.dart';
import 'package:jo17_tactical_manager/screens/fan/fan_home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testSize = Size(375, 812); // iPhone 11 Pro portrait
  final isCi = Platform.environment['CI'] == 'true';
  const skipGolden = false;

  group('FanHomeScreen golden', () {
    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      setScreenSizeBinding(binding, testSize);
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      resetScreenSizeBinding(binding);
    });

    testWidgets(
      'default grid layout',
      (tester) async {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const FanHomeScreen(),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          routerConfig: router,
          theme: ThemeData.light(),
        ));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(FanHomeScreen),
          matchesGoldenFile('goldens/fan_home_screen_default.png'),
        );
      },
      skip: skipGolden || isCi,
    );
  });
}
