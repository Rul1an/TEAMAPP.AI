import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/statistics.dart';

/// 2025 Best Practice: Comprehensive tests for type-safe Statistics model
void main() {
  group('Statistics Model - 2025 Type Safety Tests', () {
    test('should create Statistics with default values', () {
      const stats = Statistics();

      expect(stats.totalPlayers, equals(0));
      expect(stats.totalMatches, equals(0));
      expect(stats.totalTrainings, equals(0));
      expect(stats.winPercentage, equals(0.0));
      expect(stats.avgGoalsFor, equals(0.0));
      expect(stats.avgGoalsAgainst, equals(0.0));
      expect(stats.totalWins, equals(0));
      expect(stats.totalLosses, equals(0));
      expect(stats.totalDraws, equals(0));
      expect(stats.attendanceRate, equals(0.0));
    });

    test('should create Statistics with specific values', () {
      const stats = Statistics(
        totalPlayers: 22,
        totalMatches: 10,
        totalTrainings: 25,
        winPercentage: 70.5,
        avgGoalsFor: 2.3,
        avgGoalsAgainst: 1.1,
        totalWins: 7,
        totalLosses: 2,
        totalDraws: 1,
        attendanceRate: 85.2,
      );

      expect(stats.totalPlayers, equals(22));
      expect(stats.totalMatches, equals(10));
      expect(stats.totalTrainings, equals(25));
      expect(stats.winPercentage, equals(70.5));
      expect(stats.avgGoalsFor, equals(2.3));
      expect(stats.avgGoalsAgainst, equals(1.1));
      expect(stats.totalWins, equals(7));
      expect(stats.totalLosses, equals(2));
      expect(stats.totalDraws, equals(1));
      expect(stats.attendanceRate, equals(85.2));
    });

    group('Statistics.fromLegacyMap - Null Safety Tests', () {
      test('should handle null map gracefully', () {
        final stats = Statistics.fromLegacyMap(null);

        expect(stats.totalPlayers, equals(0));
        expect(stats.winPercentage, equals(0.0));
      });

      test('should handle empty map gracefully', () {
        final stats = Statistics.fromLegacyMap(<String, dynamic>{});

        expect(stats.totalPlayers, equals(0));
        expect(stats.winPercentage, equals(0.0));
      });

      test('should handle map with null values gracefully', () {
        final stats = Statistics.fromLegacyMap(<String, dynamic>{
          'totalPlayers': null,
          'winPercentage': null,
          'totalMatches': null,
          'totalTrainings': null,
        });

        expect(stats.totalPlayers, equals(0));
        expect(stats.totalMatches, equals(0));
        expect(stats.totalTrainings, equals(0));
        expect(stats.winPercentage, equals(0.0));
      });

      test('should handle mixed null and valid values', () {
        final stats = Statistics.fromLegacyMap(<String, dynamic>{
          'totalPlayers': 15,
          'winPercentage': null,
          'totalMatches': 8,
          'totalTrainings': null,
          'avgGoalsFor': 2.1,
        });

        expect(stats.totalPlayers, equals(15));
        expect(stats.totalMatches, equals(8));
        expect(stats.totalTrainings, equals(0));
        expect(stats.winPercentage, equals(0.0));
        expect(stats.avgGoalsFor, equals(2.1));
      });

      test('should handle string numeric values', () {
        final stats = Statistics.fromLegacyMap(<String, dynamic>{
          'totalPlayers': '20',
          'winPercentage': '65.5',
          'totalMatches': '12',
          'avgGoalsFor': '2.8',
        });

        expect(stats.totalPlayers, equals(20));
        expect(stats.winPercentage, equals(65.5));
        expect(stats.totalMatches, equals(12));
        expect(stats.avgGoalsFor, equals(2.8));
      });

      test('should handle invalid string values gracefully', () {
        final stats = Statistics.fromLegacyMap(<String, dynamic>{
          'totalPlayers': 'invalid',
          'winPercentage': 'not-a-number',
          'totalMatches': 'abc',
        });

        expect(stats.totalPlayers, equals(0));
        expect(stats.winPercentage, equals(0.0));
        expect(stats.totalMatches, equals(0));
      });

      test('should handle double to int conversion', () {
        final stats = Statistics.fromLegacyMap(<String, dynamic>{
          'totalPlayers': 20.7,
          'totalMatches': 12.3,
          'winPercentage': 65,
        });

        expect(stats.totalPlayers, equals(21)); // rounded
        expect(stats.totalMatches, equals(12)); // rounded
        expect(stats.winPercentage, equals(65.0)); // converted to double
      });
    });

    group('Statistics Formatting Extensions', () {
      test('should format win percentage correctly', () {
        const stats = Statistics(winPercentage: 67.89);

        expect(stats.winPercentageFormatted, equals('67.9%'));
      });

      test('should format attendance rate correctly', () {
        const stats = Statistics(attendanceRate: 85.23);

        expect(stats.attendanceRateFormatted, equals('85.2%'));
      });

      test('should format goals correctly', () {
        const stats = Statistics(
          avgGoalsFor: 2.345,
          avgGoalsAgainst: 1.678,
        );

        expect(stats.avgGoalsForFormatted, equals('2.3'));
        expect(stats.avgGoalsAgainstFormatted, equals('1.7'));
      });

      test('should handle NaN and Infinite values gracefully', () {
        const stats = Statistics();

        expect(stats.formatPercentage(double.nan), equals('0.0'));
        expect(stats.formatPercentage(double.infinity), equals('0.0'));
        expect(stats.formatGoals(double.nan), equals('0.0'));
        expect(stats.formatGoals(double.infinity), equals('0.0'));
      });

      test('should clamp percentage values to valid range', () {
        const stats = Statistics();

        expect(stats.formatPercentage(-10.5), equals('0.0'));
        expect(stats.formatPercentage(150.7), equals('100.0'));
        expect(stats.formatPercentage(50.0), equals('50.0'));
      });
    });

    group('Statistics Legacy Compatibility', () {
      test('should convert to and from legacy map consistently', () {
        const original = Statistics(
          totalPlayers: 22,
          totalMatches: 10,
          totalTrainings: 25,
          winPercentage: 70.5,
          avgGoalsFor: 2.3,
          avgGoalsAgainst: 1.1,
          totalWins: 7,
          totalLosses: 2,
          totalDraws: 1,
          attendanceRate: 85.2,
        );

        final legacyMap = original.toLegacyMap();
        final reconstructed = Statistics.fromLegacyMap(legacyMap);

        expect(reconstructed.totalPlayers, equals(original.totalPlayers));
        expect(reconstructed.totalMatches, equals(original.totalMatches));
        expect(reconstructed.totalTrainings, equals(original.totalTrainings));
        expect(reconstructed.winPercentage, equals(original.winPercentage));
        expect(reconstructed.avgGoalsFor, equals(original.avgGoalsFor));
        expect(reconstructed.avgGoalsAgainst, equals(original.avgGoalsAgainst));
        expect(reconstructed.totalWins, equals(original.totalWins));
        expect(reconstructed.totalLosses, equals(original.totalLosses));
        expect(reconstructed.totalDraws, equals(original.totalDraws));
        expect(reconstructed.attendanceRate, equals(original.attendanceRate));
      });
    });

    group('Statistics Edge Cases - Production Scenarios', () {
      test('should handle the exact error scenario that crashed the app', () {
        // This reproduces the exact Map that caused the null pointer exception
        final crashMap = <String, dynamic>{
          'totalPlayers': 0,
          'totalMatches': 0,
          'totalTrainings': 0,
          'winPercentage': null, // This null value caused the crash
        };

        // This should NOT throw an exception anymore
        expect(() => Statistics.fromLegacyMap(crashMap), returnsNormally);

        final stats = Statistics.fromLegacyMap(crashMap);
        expect(stats.winPercentage, equals(0.0));

        // This should NOT crash when calling toStringAsFixed
        expect(() => stats.winPercentageFormatted, returnsNormally);
        expect(stats.winPercentageFormatted, equals('0.0%'));
      });

      test('should handle completely empty statistics gracefully', () {
        const stats = Statistics();

        // All formatted values should work without crashing
        expect(stats.winPercentageFormatted, equals('0.0%'));
        expect(stats.attendanceRateFormatted, equals('0.0%'));
        expect(stats.avgGoalsForFormatted, equals('0.0'));
        expect(stats.avgGoalsAgainstFormatted, equals('0.0'));
      });
    });
  });
}
