import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/demo_data_service.dart';
import 'package:jo17_tactical_manager/providers/demo_mode_provider.dart';
import 'package:jo17_tactical_manager/services/organization_service.dart';

void main() {
  group('DemoDataService', () {
    test('generateDemoData returns data for club admin', () {
      final data = DemoDataService.generateDemoData(DemoRole.clubAdmin);
      expect(data['club'], isNotNull);
      expect((data['teams'] as List).length, greaterThanOrEqualTo(1));
      expect((data['players'] as List).length, greaterThan(0));
    });

    test('OrganizationService.isSlugAvailable rejects reserved slugs', () async {
      const reserved = ['admin', 'api', 'APP'];
      final service = OrganizationService();
      for (final slug in reserved) {
        final available = await service.isSlugAvailable(slug);
        expect(available, isFalse);
      }
    });
  });
}
