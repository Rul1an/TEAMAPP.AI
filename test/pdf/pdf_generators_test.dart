// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/pdf/generators/match_report_pdf_generator.dart';
import 'package:jo17_tactical_manager/pdf/generators/player_assessment_pdf_generator.dart';
import 'package:jo17_tactical_manager/pdf/generators/training_session_pdf_generator.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/assessment.dart';
import 'package:jo17_tactical_manager/models/training_session/training_session.dart';

void main() {
  group('PDF Generators', () {
    test('MatchReportPdfGenerator produces valid PDF bytes', () async {
      final match = Match()
        ..date = DateTime.utc(2025, 6)
        ..opponent = 'Ajax U17'
        ..location = Location.home
        ..competition = Competition.league
        ..teamScore = 2
        ..opponentScore = 1;

      final bytes = await const MatchReportPdfGenerator().generate(match);
      expect(bytes, isNotEmpty);
      // PDF files start with '%PDF'.
      expect(String.fromCharCodes(bytes.take(4)), equals('%PDF'));
    });

    test('PlayerAssessmentPdfGenerator produces valid PDF bytes', () async {
      final assessment = PlayerAssessment()
        ..playerId = 'p1'
        ..assessorId = 'coach1'
        ..type = AssessmentType.monthly
        ..ballControl = 4;

      final bytes = await const PlayerAssessmentPdfGenerator().generate(
        assessment,
      );
      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), equals('%PDF'));
    });

    test('TrainingSessionPdfGenerator produces valid PDF bytes', () async {
      final session = TrainingSession.create(
        teamId: 'team1',
        date: DateTime.utc(2025, 4, 20),
        trainingNumber: 12,
      )
        ..id = 'ts1'
        ..durationMinutes = 120
        ..startTime = DateTime.utc(2025, 4, 20, 18)
        ..endTime = DateTime.utc(2025, 4, 20, 20);

      final bytes = await const TrainingSessionPdfGenerator().generate(
        (
          session,
          const [],
        ),
      );
      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), equals('%PDF'));
    });
  });
}
