// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../services/telemetry_service.dart';

final telemetryServiceProvider =
    Provider<TelemetryService>((ref) => TelemetryService()..init());
