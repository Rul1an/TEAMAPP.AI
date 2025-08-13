// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/services/export_service.dart';

void main() {
  test('trainingAttendanceHeaders builds headers with players', () {
    final players = [
      Player()
        ..id = 'p1'
        ..jerseyNumber = 7
        ..lastName = 'De Jong',
      Player()
        ..id = 'p2'
        ..jerseyNumber = 10
        ..lastName = 'De Boer',
    ];
    final headers = ExportService.trainingAttendanceHeaders(players);
    expect(headers.first, 'Datum');
    expect(headers.length, 6);
    expect(headers.last, '10. De Boer');
  });

  test('attendanceSymbolFor maps sets to symbols', () {
    final symbolA = ExportService.attendanceSymbolFor(
      present: {'p1'},
      absent: {},
      injured: {},
      late: {},
      playerId: 'p1',
    );
    expect(symbolA, 'A');

    final symbolX = ExportService.attendanceSymbolFor(
      present: {},
      absent: {'p2'},
      injured: {},
      late: {},
      playerId: 'p2',
    );
    expect(symbolX, 'X');

    final symbolG = ExportService.attendanceSymbolFor(
      present: {},
      absent: {},
      injured: {'p3'},
      late: {},
      playerId: 'p3',
    );
    expect(symbolG, 'G');

    final symbolL = ExportService.attendanceSymbolFor(
      present: {},
      absent: {},
      injured: {},
      late: {'p4'},
      playerId: 'p4',
    );
    expect(symbolL, 'L');

    final symbolDash = ExportService.attendanceSymbolFor(
      present: {},
      absent: {},
      injured: {},
      late: {},
      playerId: 'p5',
    );
    expect(symbolDash, '-');
  });
}
