// ignore_for_file: directives_ordering

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/organization.dart';
import 'package:jo17_tactical_manager/services/organization_service.dart';

void main() {
  group('OrganizationService', () {
    final service = OrganizationService();

    test('createOrganization returns Organization with provided values',
        () async {
      final org = await service.createOrganization(
        name: 'Test Club',
        slug: 'test-club',
      );
      expect(org.name, 'Test Club');
      expect(org.slug, 'test-club');
      expect(org.tier, OrganizationTier.basic);
    });

    test('isSlugAvailable detects unavailable slug', () async {
      final available = await service.isSlugAvailable('admin');
      expect(available, isFalse);
    });

    test('isSlugAvailable allows custom slug', () async {
      final available = await service.isSlugAvailable('unique-slug');
      expect(available, isTrue);
    });

    test('updateOrganization updates updatedAt field', () async {
      final org = await service.createOrganization(
        name: 'Update Me',
        slug: 'update-me',
      );
      final updated = await service.updateOrganization(org);
      expect(updated.updatedAt.isAfter(org.updatedAt), isTrue);
    });
  });
}
