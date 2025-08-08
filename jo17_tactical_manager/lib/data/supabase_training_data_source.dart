// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../utils/error_sanitizer.dart';
import '../models/training_session/training_session.dart';

class SupabaseTrainingDataSource {
  SupabaseTrainingDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Training>> getTrainings(String organizationId) async {
    try {
      final res = await _client
          .from('training_sessions')
          .select()
          .eq('organization_id', organizationId)
          .order('date_time');
      return (res as List<dynamic>)
          .map((e) => Training.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }

  Future<void> createTraining(Training t) async {
    try {
      await _client.from('training_sessions').insert(t.toJson());
    } on PostgrestException catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e.message ?? e, s));
    } catch (e, s) {
      throw Exception(ErrorSanitizer.sanitize(e, s));
    }
  }
}
