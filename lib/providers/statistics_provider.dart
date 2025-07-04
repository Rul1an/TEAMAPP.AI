// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../repositories/local_statistics_repository.dart';
import '../repositories/statistics_repository.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return LocalStatisticsRepository();
});

final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.read(statisticsRepositoryProvider);
  final res = await repo.getStatistics();
  return res.dataOrNull ?? {};
});
