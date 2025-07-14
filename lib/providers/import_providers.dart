// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/match_schedule_import_service.dart';
import 'matches_provider.dart';

final matchScheduleImportServiceProvider = Provider<MatchScheduleImportService>((ref) {
  final matchRepo = ref.read(matchRepositoryProvider);
  return MatchScheduleImportService(matchRepo);
});