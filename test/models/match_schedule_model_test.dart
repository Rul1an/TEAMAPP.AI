// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/match_schedule.dart';
import 'package:jo17_tactical_manager/models/match.dart';

void main() {
  group('MatchSchedule model', () {
    late MatchSchedule schedule;

    setUp(() {
      schedule = MatchSchedule()
        ..id = 's1'
        ..dateTime = DateTime.utc(2025, 9, 12, 19, 30)
        ..opponent = 'FC Utrecht U17'
        ..location = Location.home
        ..competition = Competition.league;
    });

    test('toJson / fromJson round-trip', () {
      final json = schedule.toJson();
      final copy = MatchSchedule.fromJson(json);

      expect(copy.id, schedule.id);
      expect(
          copy.dateTime.toIso8601String(), schedule.dateTime.toIso8601String());
      expect(copy.opponent, schedule.opponent);
      expect(copy.location, schedule.location);
      expect(copy.competition, schedule.competition);
    });

    test('default constructor sets sensible defaults', () {
      final fresh = MatchSchedule();
      expect(fresh.id, isA<String>());
      expect(fresh.dateTime, isA<DateTime>());
      expect(fresh.location, Location.home);
      expect(fresh.competition, Competition.league);
    });
  });
}
