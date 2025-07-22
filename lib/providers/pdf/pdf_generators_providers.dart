import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pdf/generators/match_report_pdf_generator.dart';
import '../../pdf/generators/player_assessment_pdf_generator.dart';
import '../../pdf/generators/training_session_pdf_generator.dart';

/// Riverpod providers to access PDF generators throughout the app.
/// Keeping them centrally defined allows dependency injection/testing.

final matchReportPdfGeneratorProvider =
    Provider.autoDispose<MatchReportPdfGenerator>(
  (ref) => const MatchReportPdfGenerator(),
);

final playerAssessmentPdfGeneratorProvider =
    Provider.autoDispose<PlayerAssessmentPdfGenerator>(
  (ref) => const PlayerAssessmentPdfGenerator(),
);

final trainingSessionPdfGeneratorProvider =
    Provider.autoDispose<TrainingSessionPdfGenerator>(
  (ref) => const TrainingSessionPdfGenerator(),
);
