import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/consent_service.dart';

final consentServiceProvider = Provider<ConsentService>((ref) {
  return ConsentService();
});

final analyticsConsentProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(consentServiceProvider);
  final flags = await service.getConsent();
  return flags['analytics'] ?? false;
});
