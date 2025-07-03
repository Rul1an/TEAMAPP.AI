import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/local_performance_rating_repository.dart';
import '../repositories/performance_rating_repository.dart';

/// Provides an implementation of [PerformanceRatingRepository].
final performanceRatingRepositoryProvider =
    Provider<PerformanceRatingRepository>((ref) {
  return LocalPerformanceRatingRepository();
});
