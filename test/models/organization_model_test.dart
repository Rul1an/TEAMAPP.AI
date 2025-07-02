import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/organization.dart';

void main() {
  group('Organization model', () {
    test('toJson / fromJson round-trip', () {
      final original = Organization(
        id: 'org1',
        name: 'Test Club',
        slug: 'test-club',
        tier: OrganizationTier.pro,
        primaryColor: '#000000',
        secondaryColor: '#FFFFFF',
        settings: {
          'maxPlayers': 50,
        },
        subscriptionStatus: 'active',
        subscriptionEndDate: DateTime.utc(2025, 1, 1),
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 6, 1),
      );

      final json = original.toJson();
      final copy = Organization.fromJson(json);

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.slug, original.slug);
      expect(copy.tier, original.tier);
      expect(copy.primaryColor, original.primaryColor);
      expect(copy.secondaryColor, original.secondaryColor);
      expect(copy.settings['maxPlayers'], 50);
      expect(copy.subscriptionStatus, original.subscriptionStatus);
      expect(copy.subscriptionEndDate, original.subscriptionEndDate);
    });
  });
}
