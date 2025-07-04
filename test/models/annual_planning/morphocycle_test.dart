// ignore_for_file: avoid_single_cascade_in_expression_statements, cascade_invocations

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/annual_planning/morphocycle.dart';
import 'package:jo17_tactical_manager/models/annual_planning/training_period.dart';

void main() {
  group('Morphocycle', () {
    test('KNVB standard morphocycle JSON roundtrip', () {
      final period = TrainingPeriod.preparation(periodizationPlanId: 'plan1');
      final m = Morphocycle.knvbStandard(
        weekNumber: 5,
        periodId: 'period1',
        seasonPlanId: 'season1',
        period: period,
      );
      final json = m.toJson();
      final copy = Morphocycle.fromJson(json);
      expect(copy.weekNumber, 5);
      expect(copy.periodId, 'period1');
      expect(copy.intensityDistribution.keys.length, 4);
      expect(copy.weeklyLoad, greaterThan(0));
    });

    test('Helpers classify load correctly', () {
      final m = Morphocycle.knvbStandard(
        weekNumber: 1,
        periodId: 'p',
        seasonPlanId: 's',
      );
      // Force weeklyLoad extreme for test
      m..weeklyLoad = 1500;
      expect(m.isHighLoadWeek, isTrue);
      m..weeklyLoad = 700;
      expect(m.isRecoveryWeek, isTrue);
      m..weeklyLoad = 1000;
      expect(m.isOptimalLoad, isTrue);
    });
  });
}
