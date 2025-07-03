import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/telemetry_service.dart';

final telemetryServiceProvider = Provider<TelemetryService>((ref) {
  final service = TelemetryService();
  service.init();
  return service;
});
