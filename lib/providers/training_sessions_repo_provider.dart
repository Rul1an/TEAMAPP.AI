import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/training_session/training_session.dart';
import '../repositories/supabase_training_session_repository.dart';
import '../repositories/training_session_repository.dart';

final trainingSessionRepositoryProvider =
    Provider<TrainingSessionRepository>((ref) {
  return SupabaseTrainingSessionRepository();
});

final allTrainingSessionsProvider =
    FutureProvider<List<TrainingSession>>((ref) async {
  final repo = ref.read(trainingSessionRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});

final upcomingTrainingSessionsProvider =
    FutureProvider<List<TrainingSession>>((ref) async {
  final repo = ref.read(trainingSessionRepositoryProvider);
  final res = await repo.getUpcoming();
  return res.dataOrNull ?? [];
});
