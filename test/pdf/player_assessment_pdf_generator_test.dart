import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/models/assessment.dart';
import 'package:jo17_tactical_manager/pdf/generators/player_assessment_pdf_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlayerAssessmentPdfGenerator', () {
    test('generates a valid PDF', () async {
      final assessment = PlayerAssessment()
        ..id = 'assess1'
        ..playerId = 'player1'
        ..type = AssessmentType.monthly;

      final bytes = await const PlayerAssessmentPdfGenerator().generate(
        assessment,
      );

      expect(bytes, isNotEmpty);
      final header = utf8.decode(bytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });
  });
}
