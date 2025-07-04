// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/assessment.dart';
import '../repositories/assessment_repository.dart';
import '../repositories/local_assessment_repository.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return LocalAssessmentRepository();
});

final assessmentsProvider = FutureProvider<List<PlayerAssessment>>((ref) async {
  final repo = ref.read(assessmentRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});
