// ignore_for_file: deprecated_member_use, require_trailing_commas, dead_code

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:test_utils/surface_utils.dart';

import 'package:jo17_tactical_manager/screens/fan/fan_home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testSize = Size(375, 812); // iPhone 11 Pro
  final isCi = Platform.environment['CI'] == 'true';
  const skipGolden = true; // baseline png not yet committed

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
          routes: [
            GoRoute(path: '/', builder: (c, s) => const FanHomeScreen()),
          ],
        );
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
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
