// Parser tests enabled after EOL auto-detection fix
// ignore_for_file: library_annotations, invalid_annotation_target

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/schedule_csv_parser.dart';
import 'package:jo17_tactical_manager/models/match.dart';

void main() {
  group('ScheduleCsvParser', () {
    late ScheduleCsvParser parser;

    setUp(() {
      parser = ScheduleCsvParser();
    });

    test('parses valid CSV into schedules', () async {
      const csv = 'date,time,opponent,competition,location\n'
          '2025-09-12,19:30,FC Utrecht U17,league,Thuis\n'
          '2025-09-19,20:00,Ajax U17,cup,Uit';

      final res = await parser.parse(csv);

      expect(res.isSuccess, true);
      final data = res.dataOrNull;
      expect(data, isNotNull);
      expect(data!.schedules.length, 2);
      expect(data.errors, isEmpty);
      expect(data.schedules.first.location, Location.home);
      expect(data.schedules.last.location, Location.away);
    });

    test('reports header error when missing required columns', () async {
      const csv = 'date,time,opponent\n2025-09-12,19:30,FC Utrecht U17';
      final res = await parser.parse(csv);
      expect(res.isSuccess, true);
      final data = res.dataOrNull;
      expect(data!.schedules, isEmpty);
      expect(data.errors, isNotEmpty);
    });

    test('skips invalid rows and returns errors', () async {
      const csv = 'date,time,opponent,competition\n'
          '2025-09-12,19:30,FC Utrecht U17,league\n'
          'INVALID-DATE,19:30,PSV U17,league';
      final res = await parser.parse(csv);
      expect(res.isSuccess, true);
      final data = res.dataOrNull;
      expect(data!.schedules.length, 1);
      expect(data.errors.length, 1);
    });
  });
}
