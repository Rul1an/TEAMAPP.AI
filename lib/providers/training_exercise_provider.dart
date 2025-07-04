// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/training_session/training_exercise.dart';
import '../repositories/local_training_exercise_repository.dart';
import '../repositories/training_exercise_repository.dart';

final trainingExerciseRepositoryProvider =
    Provider<TrainingExerciseRepository>((ref) {
  return LocalTrainingExerciseRepository();
});

final allExercisesProvider =
    FutureProvider<List<TrainingExercise>>((ref) async {
  final repo = ref.read(trainingExerciseRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});

final exercisesBySessionProvider =
    FutureProvider.family<List<TrainingExercise>, String>(
        (ref, sessionId) async {
  final repo = ref.read(trainingExerciseRepositoryProvider);
  final res = await repo.getBySession(sessionId);
  return res.dataOrNull ?? [];
});
