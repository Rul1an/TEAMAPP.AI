// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/controllers/weekly_planning_controller.dart';

void main() {
  group('WeeklyPlanningController (widget)', () {
    late WeeklyPlanningController controller;

    setUp(() {
      controller = WeeklyPlanningController();
    });

    testWidgets('initial scrollController offset is zero', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListView(
            controller: controller.scrollController,
            children: List.generate(
              5,
              (i) => SizedBox(height: 100),
            ),
          ),
        ),
      );

      expect(controller.scrollController.offset, equals(0.0));
    });

    testWidgets('scrollToWeek does not throw for valid index', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ListView(
            controller: controller.scrollController,
            children: List.generate(
              10,
              (i) => SizedBox(height: 100),
            ),
          ),
        ),
      );

      // Should animate without throwing
      expect(() => controller.scrollToWeek(2), returnsNormally);

      // Allow animation to complete
      await tester.pumpAndSettle();
    });

    tearDown(() {
      controller.dispose();
    });
  });
}
