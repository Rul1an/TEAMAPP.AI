// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/pdf/generators/match_report_pdf_generator.dart';
import 'package:jo17_tactical_manager/pdf/generators/player_assessment_pdf_generator.dart';
import 'package:jo17_tactical_manager/pdf/generators/training_session_pdf_generator.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/assessment.dart';
import 'package:jo17_tactical_manager/models/training_session/training_session.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/models/training_session/session_phase.dart';

void main() {
  group('PDF Generators', () {
    test('MatchReportPdfGenerator produces valid PDF bytes', () async {
      final match = Match()
        ..date = DateTime.utc(2025, 6, 1)
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
      final now = DateTime.utc(2025, 4, 20, 18);
      final phase = SessionPhase.warmup(start: now, durationMinutes: 15);
      final player = Player()
        ..id = 'p1'
        ..firstName = 'Jan'
        ..lastName = 'Jansen'
        ..jerseyNumber = 10
        ..position = Position.midfielder
        ..birthDate = DateTime(2008, 1, 1)
        ..preferredFoot = PreferredFoot.right
        ..height = 170
        ..weight = 60;

      final session = TrainingSession.create(
        teamId: 'team1',
        date: now,
        trainingNumber: 12,
      )..phases = [phase];

      late List<int> bytes;
      try {
        bytes = await const TrainingSessionPdfGenerator().generate((
          session,
          <Player>[player],
        ));
      } catch (e) {
        fail('PDF generation threw an exception: $e');
      }

      // Basic checks
      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(1000));
      expect(String.fromCharCodes(bytes.take(4)), equals('%PDF'));

      // The PDF text should contain the training number
      final textSnippet = String.fromCharCodes(bytes);
      expect(textSnippet.contains('Training 12'), isTrue);
      expect(textSnippet.contains('/Type /Page'), isTrue);
    });
  });
}
