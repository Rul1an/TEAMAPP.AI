// ignore_for_file: cascade_invocations, unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/player.dart';

void main() {
  group('Player model', () {
    late Player player;

    setUp(() {
      player = Player()
        ..id = 'p1'
        ..firstName = 'Jan'
        ..lastName = 'Jansen'
        ..jerseyNumber = 10
        ..birthDate = DateTime(2008, 7, 15)
        ..position = Position.midfielder
        ..preferredFoot = PreferredFoot.right
        ..height = 175
        ..weight = 65;
    });

    test('name combines first and last name', () {
      expect(player.name, 'Jan Jansen');
    });

    test('age calculation is correct', () {
      // Approximate age check: assert age between 16 and 17 based on fixed birthDate.
      expect(player.age, inInclusiveRange(16, 17));
    });

    test('attendancePercentage returns 0 if no trainings', () {
      expect(player.attendancePercentage, 0);
    });

    test('attendancePercentage calculates correctly', () {
      player.trainingsAttended = 8;
      player.trainingsTotal = 10;
      expect(player.attendancePercentage, 80);
    });

    test('matchMinutesPercentage returns 0 if no selection', () {
      expect(player.matchMinutesPercentage, 0);
    });

    test('matchMinutesPercentage calculates correctly', () {
      player.matchesInSelection = 2; // possible minutes = 160
      player.minutesPlayed = 80;
      expect(player.matchMinutesPercentage, closeTo(50, 0.001));
    });

    test('averageMinutesPerMatch returns 0 if matchesPlayed is 0', () {
      expect(player.averageMinutesPerMatch, 0);
    });

    test('averageMinutesPerMatch calculates correctly', () {
      player.matchesPlayed = 4;
      player.minutesPlayed = 200;
      expect(player.averageMinutesPerMatch, 50);
    });
  });
}
