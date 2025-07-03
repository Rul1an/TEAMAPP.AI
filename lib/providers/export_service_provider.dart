import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/export_service.dart';
import 'matches_provider.dart';
import 'players_provider.dart';
import 'trainings_provider.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(
    playerRepository: ref.read(playerRepositoryProvider),
    matchRepository: ref.read(matchRepositoryProvider),
    trainingRepository: ref.read(trainingRepositoryProvider),
  );
});
