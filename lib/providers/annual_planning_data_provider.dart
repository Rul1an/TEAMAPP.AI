// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/annual_planning/periodization_plan.dart';
import '../models/annual_planning/season_plan.dart';
import '../models/annual_planning/training_period.dart';
import '../repositories/local_periodization_plan_repository.dart';
import '../repositories/local_season_repository.dart';
import '../repositories/local_training_period_repository.dart';
import '../repositories/periodization_plan_repository.dart';
import '../repositories/season_repository.dart';
import '../repositories/training_period_repository.dart';

// Repositories
final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return LocalSeasonRepository();
});

final periodizationPlanRepositoryProvider =
    Provider<PeriodizationPlanRepository>((ref) {
  return LocalPeriodizationPlanRepository();
});

final trainingPeriodRepositoryProvider =
    Provider<TrainingPeriodRepository>((ref) {
  return LocalTrainingPeriodRepository();
});

// Data providers
final seasonPlansProvider = FutureProvider<List<SeasonPlan>>((ref) async {
  final repo = ref.read(seasonRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});

final periodizationPlansProvider =
    FutureProvider<List<PeriodizationPlan>>((ref) async {
  final repo = ref.read(periodizationPlanRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});

final trainingPeriodsProvider =
    FutureProvider<List<TrainingPeriod>>((ref) async {
  final repo = ref.read(trainingPeriodRepositoryProvider);
  final res = await repo.getAll();
  return res.dataOrNull ?? [];
});
