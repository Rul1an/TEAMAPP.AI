import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/annual_planning/periodization_plan.dart';

void main() {
  group('PeriodizationPlan templates', () {
    test('KNVB Youth U17 round-trip JSON', () {
      final plan = PeriodizationPlan.knvbYouthU17();
      final json = plan.toJson();
      final copy = PeriodizationPlan.fromJson(json);
      expect(copy.name, plan.name);
      expect(copy.modelType, plan.modelType);
      expect(copy.totalDurationWeeks, plan.totalDurationWeeks);
    });

    test('Block periodization template parameters', () {
      final plan = PeriodizationPlan.blockPeriodization();
      final params = PeriodizationPlan.getRecommendedParameters(
        plan.modelType,
        plan.targetAgeGroup,
      );
      expect(params['periods'], 8);
      expect((params['focusAreas'] as List).length, greaterThanOrEqualTo(3));
    });
  });
}
