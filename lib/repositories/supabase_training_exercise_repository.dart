// Project imports:
import '../config/supabase_config.dart';
import '../core/result.dart';
import '../models/training_session/training_exercise.dart';

/// Repository for training exercises with Supabase backend
class SupabaseTrainingExerciseRepository {
  final _supabase = SupabaseConfig.client;

  /// Get all exercises for an organization
  Future<Result<List<TrainingExercise>>> getExercises({
    required String organizationId,
    bool includeTemplates = true,
    bool activeOnly = true,
  }) async {
    try {
      var query = _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId);

      if (activeOnly) {
        query = query.eq('is_active', true);
      }

      if (includeTemplates) {
        query =
            query.or('is_template.eq.true,organization_id.eq.$organizationId');
      }

      final response = await query.order('name');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(NetworkFailure('Failed to fetch exercises: $e'));
    }
  }

  /// Get exercises by intensity range
  Future<Result<List<TrainingExercise>>> getExercisesByIntensity({
    required String organizationId,
    required double minIntensity,
    required double maxIntensity,
  }) async {
    try {
      final response = await _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('is_active', true)
          .gte('intensity_level', minIntensity)
          .lte('intensity_level', maxIntensity)
          .order('intensity_level');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(
          NetworkFailure('Failed to fetch exercises by intensity: $e'));
    }
  }

  /// Get exercises by tactical focus
  Future<Result<List<TrainingExercise>>> getExercisesByTacticalFocus({
    required String organizationId,
    required String tacticalFocus,
  }) async {
    try {
      final response = await _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('tactical_focus', tacticalFocus)
          .eq('is_active', true)
          .order('intensity_level');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(
          NetworkFailure('Failed to fetch exercises by tactical focus: $e'));
    }
  }

  /// Get exercises by category
  Future<Result<List<TrainingExercise>>> getExercisesByCategory({
    required String organizationId,
    required String category,
  }) async {
    try {
      final response = await _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('category', category)
          .eq('is_active', true)
          .order('name');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(
          NetworkFailure('Failed to fetch exercises by category: $e'));
    }
  }

  /// Search exercises by name or description
  Future<Result<List<TrainingExercise>>> searchExercises({
    required String organizationId,
    required String query,
  }) async {
    try {
      final response = await _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('name');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(NetworkFailure('Failed to search exercises: $e'));
    }
  }

  /// Create a new exercise
  Future<Result<TrainingExercise>> createExercise({
    required TrainingExercise exercise,
    required String organizationId,
  }) async {
    try {
      final exerciseData = exercise.toJson()
        ..['organization_id'] = organizationId;

      final response = await _supabase
          .from('training_exercises')
          .insert(exerciseData)
          .select()
          .single();

      final createdExercise = TrainingExercise.fromJson(response);
      return Success(createdExercise);
    } catch (e) {
      return Failure(NetworkFailure('Failed to create exercise: $e'));
    }
  }

  /// Update an existing exercise
  Future<Result<TrainingExercise>> updateExercise({
    required TrainingExercise exercise,
  }) async {
    try {
      final exerciseData = exercise.toJson();
      exerciseData.remove('created_at'); // Don't update created_at

      final response = await _supabase
          .from('training_exercises')
          .update(exerciseData)
          .eq('id', exercise.id)
          .select()
          .single();

      final updatedExercise = TrainingExercise.fromJson(response);
      return Success(updatedExercise);
    } catch (e) {
      return Failure(NetworkFailure('Failed to update exercise: $e'));
    }
  }

  /// Delete an exercise (soft delete by setting is_active = false)
  Future<Result<void>> deleteExercise({
    required String exerciseId,
  }) async {
    try {
      await _supabase
          .from('training_exercises')
          .update({'is_active': false}).eq('id', exerciseId);

      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure('Failed to delete exercise: $e'));
    }
  }

  /// Get popular exercises (by usage_count)
  Future<Result<List<TrainingExercise>>> getPopularExercises({
    required String organizationId,
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('is_active', true)
          .order('usage_count', ascending: false)
          .limit(limit);

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(NetworkFailure('Failed to fetch popular exercises: $e'));
    }
  }

  /// Increment usage count for an exercise
  Future<Result<void>> incrementUsageCount({
    required String exerciseId,
  }) async {
    try {
      await _supabase.rpc<void>('increment_exercise_usage', params: {
        'exercise_id': exerciseId,
      });

      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure('Failed to increment usage count: $e'));
    }
  }

  /// Get exercises for specific training session
  Future<Result<List<TrainingExercise>>> getExercisesForSession({
    required String trainingSessionId,
  }) async {
    try {
      final response = await _supabase
          .from('training_exercises')
          .select('*')
          .eq('training_session_id', trainingSessionId)
          .eq('is_active', true)
          .order('order_index');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(NetworkFailure('Failed to fetch session exercises: $e'));
    }
  }

  /// Filter exercises with complex criteria
  Future<Result<List<TrainingExercise>>> filterExercises({
    required String organizationId,
    String? searchQuery,
    List<String>? types,
    List<String>? categories,
    double? minIntensity,
    double? maxIntensity,
    int? minDuration,
    int? maxDuration,
    int? maxPlayerCount,
    String? tacticalFocus,
  }) async {
    try {
      var query = _supabase
          .from('training_exercises')
          .select('*')
          .eq('organization_id', organizationId)
          .eq('is_active', true);

      // Apply filters
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query
            .or('name.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
      }

      if (types != null && types.isNotEmpty) {
        query = query.inFilter('type', types);
      }

      if (categories != null && categories.isNotEmpty) {
        query = query.inFilter('category', categories);
      }

      if (minIntensity != null) {
        query = query.gte('intensity_level', minIntensity);
      }

      if (maxIntensity != null) {
        query = query.lte('intensity_level', maxIntensity);
      }

      if (minDuration != null) {
        query = query.gte('duration_minutes', minDuration);
      }

      if (maxDuration != null) {
        query = query.lte('duration_minutes', maxDuration);
      }

      if (maxPlayerCount != null) {
        query = query.lte('player_count', maxPlayerCount);
      }

      if (tacticalFocus != null) {
        query = query.eq('tactical_focus', tacticalFocus);
      }

      final response = await query.order('name');

      final exercises = (response as List<dynamic>)
          .map(
              (data) => TrainingExercise.fromJson(data as Map<String, dynamic>))
          .toList();

      return Success(exercises);
    } catch (e) {
      return Failure(NetworkFailure('Failed to filter exercises: $e'));
    }
  }
}
