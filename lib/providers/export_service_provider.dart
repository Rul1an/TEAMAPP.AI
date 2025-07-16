// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/export_service.dart';
import 'player_repository_provider.dart';
import 'match_repository_provider.dart';
import 'training_repository_provider.dart';

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(
    playerRepository: ref.read(playerRepositoryProvider),
    matchRepository: ref.read(matchRepositoryProvider),
    trainingRepository: ref.read(trainingRepositoryProvider),
  );
});
