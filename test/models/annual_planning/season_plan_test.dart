// ignore_for_file: cascade_invocations

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/annual_planning/season_plan.dart';

void main() {
  group('SeasonPlan', () {
    test('JO17 Dutch season JSON roundtrip', () {
      final plan = SeasonPlan.jo17DutchSeason(
        teamName: 'VOAB JO17-1',
        season: '2025-2026',
      );
      plan.periodizationPlanId = 'plan123';
      final json = plan.toJson();
      final copy = SeasonPlan.fromJson(json);
      expect(copy.ageGroup, plan.ageGroup);
      expect(copy.trainingWeeks, greaterThan(30));
    });
  });
}
