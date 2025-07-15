// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/match_schedule_import_service.dart';
import 'matches_provider.dart';
import '../services/player_roster_import_service.dart';
import 'players_provider.dart';
import '../services/training_session_import_service.dart';
import 'training_sessions_repo_provider.dart';

final matchScheduleImportServiceProvider = Provider<MatchScheduleImportService>((ref) {
  final matchRepo = ref.read(matchRepositoryProvider);
  return MatchScheduleImportService(matchRepo);
});

final playerRosterImportServiceProvider = Provider<PlayerRosterImportService>((ref) {
  return PlayerRosterImportService(ref.read(playerRepositoryProvider));
});

final trainingSessionImportServiceProvider = Provider<TrainingSessionImportService>((ref) {
  return TrainingSessionImportService(ref.read(trainingSessionRepositoryProvider));
});