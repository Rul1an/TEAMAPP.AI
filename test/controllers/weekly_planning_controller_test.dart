import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:jo17_tactical_manager/controllers/weekly_planning_controller.dart';

void main() {
  group('WeeklyPlanningController', () {
    late WeeklyPlanningController controller;

    setUp(() {
      // Initialize controller before each test
      controller = WeeklyPlanningController();
    });

    test('initial scrollController offset is zero', () {
      expect(controller.scrollController.offset, equals(0.0));
    });

    test('scrollToWeek does not throw for valid index', () {
      expect(() => controller.scrollToWeek(3), returnsNormally);
    });

    tearDown(() {
      // Dispose controller after each test
      controller.dispose();
    });
  });
}
