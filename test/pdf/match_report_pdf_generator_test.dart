import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/pdf/generators/match_report_pdf_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MatchReportPdfGenerator', () {
    test('generates a valid PDF', () async {
      final match = Match()
        ..id = 'test'
        ..date = DateTime(2025, 3, 5, 14, 30)
        ..opponent = 'VV Testia'
        ..location = Location.home
        ..teamScore = 3
        ..opponentScore = 1;

      final bytes = await const MatchReportPdfGenerator().generate(match);

      // Basic assertions – not full golden due to binary variance
      expect(bytes, isNotEmpty);
      // PDF files start with "%PDF-" (25 50 44 46 2D)
      final header = utf8.decode(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });
  });
}
