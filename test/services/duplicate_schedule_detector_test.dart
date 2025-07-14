// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/duplicate_schedule_detector.dart';
import 'package:jo17_tactical_manager/models/match_schedule.dart';

void main() {
  group('DuplicateScheduleDetector', () {
    late DuplicateScheduleDetector detector;

    setUp(() {
      detector = DuplicateScheduleDetector();
    });

    MatchSchedule fixture({required String date, required String opp}) {
      return MatchSchedule()
        ..dateTime = DateTime.parse('${date}T19:30:00Z')
        ..opponent = opp;
    }

    test('identifies duplicates by date+opponent', () {
      final existing = [
        fixture(date: '2025-09-12', opp: 'FC Utrecht U17'),
      ];

      final imported = [
        fixture(date: '2025-09-12', opp: 'FC Utrecht U17'), // dup
        fixture(date: '2025-09-19', opp: 'Ajax U17'), // new
      ];

      final result = detector.detect(imported, existing);

      expect(result.duplicates.length, 1);
      expect(result.unique.length, 1);
      expect(result.hasDuplicates, isTrue);
    });

    test('opponent comparison is case-insensitive & trimmed', () {
      final existing = [
        fixture(date: '2025-10-01', opp: '  PSV U17  '),
      ];
      final imported = [
        fixture(date: '2025-10-01', opp: 'psv u17'),
      ];
      final result = detector.detect(imported, existing);
      expect(result.hasDuplicates, isTrue);
    });
  });
}