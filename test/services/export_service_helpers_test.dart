// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/export_service.dart';
import 'package:jo17_tactical_manager/models/player.dart';

void main() {
  test('playerExcelHeaders returns stable header set', () {
    final headers = ExportService.playerExcelHeaders();
    expect(headers.first, 'Nr');
    expect(headers.length, greaterThan(5));
  });

  test('playtimePercentageFor returns 0.0 for zero selections', () {
    final p = Player()
      ..matchesInSelection = 0
      ..minutesPlayed = 0;
    expect(ExportService.playtimePercentageFor(p), '0.0');
  });

  test('playtimePercentageFor computes percentage safely', () {
    final p = Player()
      ..matchesInSelection = 2
      ..minutesPlayed = 80; // 80/160 = 0.5 -> 50.0%
    expect(ExportService.playtimePercentageFor(p), '50.0');
  });
}
