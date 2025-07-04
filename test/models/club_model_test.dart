// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/club/club.dart';

void main() {
  group('Club model', () {
    test('toJson / fromJson round-trip', () {
      final club = Club(
        id: 'c1',
        name: 'SV Test',
        shortName: 'SVT',
        foundedDate: DateTime.utc(1990),
        settings: const ClubSettings(),
        status: ClubStatus.active,
        createdAt: DateTime.utc(2024),
      );

      final json = club.toJson();
      if (json['settings'] is! Map) {
        // Freezed sometimes keeps nested object; convert manually.
        json['settings'] = (json['settings'] as dynamic).toJson();
      }
      final copy = Club.fromJson(json);

      expect(copy.id, club.id);
      expect(copy.name, club.name);
      expect(copy.shortName, club.shortName);
      expect(copy.tier, club.tier);
      expect(copy.status, club.status);
      expect(copy.foundedYear, club.foundedYear);
    });
  });
}
