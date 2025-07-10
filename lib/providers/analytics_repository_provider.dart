import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/analytics_repository.dart';
import '../repositories/analytics_repository_impl.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl();
});
