// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../repositories/supabase_training_exercise_repository.dart';

/// Provider for training exercise repository
final exerciseRepositoryProvider =
    Provider<SupabaseTrainingExerciseRepository>((ref) {
  return SupabaseTrainingExerciseRepository();
});

/// Provider for exercises list (async)
final exercisesProvider =
    FutureProvider.family<List<dynamic>, String>((ref, organizationId) async {
  final repository = ref.read(exerciseRepositoryProvider);
  final result = await repository.getExercises(organizationId: organizationId);

  return result.when(
    success: (exercises) => exercises,
    failure: (error) => throw Exception(error),
  );
});

/// Provider for exercises by intensity
final exercisesByIntensityProvider =
    FutureProvider.family<List<dynamic>, ExerciseIntensityParams>(
        (ref, params) async {
  final repository = ref.read(exerciseRepositoryProvider);
  final result = await repository.getExercisesByIntensity(
    organizationId: params.organizationId,
    minIntensity: params.minIntensity,
    maxIntensity: params.maxIntensity,
  );

  return result.when(
    success: (exercises) => exercises,
    failure: (error) => throw Exception(error),
  );
});

/// Provider for exercises by tactical focus
final exercisesByTacticalFocusProvider =
    FutureProvider.family<List<dynamic>, ExerciseTacticalFocusParams>(
        (ref, params) async {
  final repository = ref.read(exerciseRepositoryProvider);
  final result = await repository.getExercisesByTacticalFocus(
    organizationId: params.organizationId,
    tacticalFocus: params.tacticalFocus,
  );

  return result.when(
    success: (exercises) => exercises,
    failure: (error) => throw Exception(error),
  );
});

/// Parameter classes for providers
class ExerciseIntensityParams {
  const ExerciseIntensityParams({
    required this.organizationId,
    required this.minIntensity,
    required this.maxIntensity,
  });

  final String organizationId;
  final double minIntensity;
  final double maxIntensity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseIntensityParams &&
          runtimeType == other.runtimeType &&
          organizationId == other.organizationId &&
          minIntensity == other.minIntensity &&
          maxIntensity == other.maxIntensity;

  @override
  int get hashCode =>
      organizationId.hashCode ^ minIntensity.hashCode ^ maxIntensity.hashCode;
}

class ExerciseTacticalFocusParams {
  const ExerciseTacticalFocusParams({
    required this.organizationId,
    required this.tacticalFocus,
  });

  final String organizationId;
  final String tacticalFocus;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTacticalFocusParams &&
          runtimeType == other.runtimeType &&
          organizationId == other.organizationId &&
          tacticalFocus == other.tacticalFocus;

  @override
  int get hashCode => organizationId.hashCode ^ tacticalFocus.hashCode;
}
