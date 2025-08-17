// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/training_session/training_session.dart';
import '../repositories/supabase_training_session_repository.dart';
import '../repositories/training_session_repository.dart';

final trainingSessionRepositoryProvider = Provider<TrainingSessionRepository>((
  ref,
) {
  return SupabaseTrainingSessionRepository();
});

final allTrainingSessionsProvider = FutureProvider<List<TrainingSession>>((
  ref,
) async {
  final repo = ref.read(trainingSessionRepositoryProvider);
  try {
    final res = await repo.getAll().timeout(const Duration(seconds: 4));
    return res.dataOrNull ?? [];
  } catch (_) {
    return [];
  }
});

final upcomingTrainingSessionsProvider = FutureProvider<List<TrainingSession>>((
  ref,
) async {
  final repo = ref.read(trainingSessionRepositoryProvider);
  try {
    final res = await repo.getUpcoming().timeout(const Duration(seconds: 4));
    return res.dataOrNull ?? [];
  } catch (_) {
    return [];
  }
});
