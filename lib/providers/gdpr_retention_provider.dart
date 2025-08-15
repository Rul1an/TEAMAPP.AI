// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/gdpr_retention_service.dart';

final gdprRetentionServiceProvider = Provider<GdprRetentionService>((ref) {
  // Endpoint should be provided via env or remote config; placeholder here
  const endpoint = String.fromEnvironment('RETENTION_FN_URL', defaultValue: '');
  return GdprRetentionService(endpoint);
});
