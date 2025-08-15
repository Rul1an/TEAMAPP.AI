// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/training_plan_import_service.dart';

void main() {
  group('TrainingPlanImportService (Excel)', () {
    test('parseExcelBytes supports Excel serial date and returns items',
        () async {
      // Create an in-memory Excel workbook
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Header row (Dutch aliases)
      final headers = <String>[
        'Datum',
        'Starttijd',
        'Duur',
        'Focus',
        'Intensiteit',
        'Titel',
        'Doel',
        'Locatie',
      ];
      for (var i = 0; i < headers.length; i++) {
        sheet.updateCell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
          TextCellValue(headers[i]),
        );
      }

      // Excel serial date for 2025-09-21 relative to 1899-12-30
      final targetDate = DateTime(2025, 9, 21);
      final base = DateTime(1899, 12, 30);
      final serial = targetDate.difference(base).inDays.toDouble();

      // Data row values
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
          DoubleCellValue(serial));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1),
          TextCellValue('18:30'));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1),
          TextCellValue('90'));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1),
          TextCellValue('Techniek'));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1),
          TextCellValue('Gemiddeld'));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1),
          TextCellValue('Test titel'));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 1),
          TextCellValue('Test doel'));
      sheet.updateCell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 1),
          TextCellValue('Veld 1'));

      final bytes = excel.save()!;
      final service = TrainingPlanImportService();
      final res = await service.parseExcelBytes(Uint8List.fromList(bytes));

      expect(res.success, isTrue);
      expect(res.items.length, 1);
      final dto = res.items.first;
      expect(dto.date.year, targetDate.year);
      expect(dto.date.month, targetDate.month);
      expect(dto.date.day, targetDate.day);
      expect(dto.startTime, '18:30');
      expect(dto.durationMinutes, 90);
      expect(res.message, contains('Dry-run'));
    });
  });
}
