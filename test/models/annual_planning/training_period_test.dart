import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/annual_planning/training_period.dart';

void main() {
  group('TrainingPeriod templates', () {
    test('Preparation period JSON roundtrip', () {
      final period = TrainingPeriod.preparation(periodizationPlanId: 'plan1');
      final json = period.toJson();
      final copy = TrainingPeriod.fromJson(json);
      expect(copy.name, 'Voorbereiding');
      expect(copy.type, period.type);
      expect(copy.sessionsPerWeek, 3);
    });

    test('Transition period has lower intensity', () {
      final period = TrainingPeriod.transition(periodizationPlanId: 'plan1');
      expect(period.intensityPercentage, lessThan(60));
    });
  });
}
