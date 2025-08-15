// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/services/training_plan_import_service.dart';

void main() {
  group('TrainingPlanImportService', () {
    test('parseCsvBytes parses valid CSV and returns items', () async {
      const csv = 'Datum,Starttijd,Duur,Focus,Intensiteit,Titel,Doel,Locatie\n'
          '21-09-2025,18:30,90,Techniek,Gemiddeld,Passing,Balcontrole,Veld 1\n';
      final bytes = Uint8List.fromList(utf8.encode(csv));

      final svc = TrainingPlanImportService();
      final res = await svc.parseCsvBytes(bytes);

      expect(res.items, isNotEmpty);
      expect(res.success, isTrue, reason: res.message);
      final item = res.items.first;
      expect(item.startTime, '18:30');
      expect(item.durationMinutes, 90);
      expect(item.focus.toLowerCase(), contains('techniek'));
      expect(item.intensity.toLowerCase(), contains('gemiddeld'));
      expect(item.location, 'Veld 1');
    });

    test('parseCsvBytes returns error on empty CSV', () async {
      final bytes = Uint8List.fromList(utf8.encode(''));
      final svc = TrainingPlanImportService();
      final res = await svc.parseCsvBytes(bytes);
      expect(res.success, isFalse, reason: 'Empty CSV should not parse');
    });

    test('parseCsvBytes handles bad start time', () async {
      const csv = 'Datum,Starttijd,Duur,Focus,Intensiteit\n'
          '21-09-2025,25:61,60,Techniek,Gemiddeld\n';
      final bytes = Uint8List.fromList(utf8.encode(csv));
      final svc = TrainingPlanImportService();
      final res = await svc.parseCsvBytes(bytes);
      expect(res.success, isFalse, reason: 'Bad start time should fail');
      expect(res.errors, isNotEmpty, reason: 'Should report parsing errors');
    });
  });
}
