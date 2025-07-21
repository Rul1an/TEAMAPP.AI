import 'dart:async';
import 'package:dio/dio.dart';
import '../config/environment.dart';

/// 🔄 Feature Flag Service (Best-Practice 2025)
///
/// Fetches feature-flag configuration from a remote JSON endpoint so that
/// flags can be toggled *as data* without requiring a redeploy.
///
/// * Caches values in memory for 5 minutes.
/// * Falls back to defaults based on subscription tier.
/// * Exposed via [FeatureFlagService.instance].
class FeatureFlagService {
  FeatureFlagService._();
  static final FeatureFlagService instance = FeatureFlagService._();

  // Cache structure: <flag, enabled>
  Map<String, bool> _cache = {};
  DateTime _cacheExpiry = DateTime.fromMillisecondsSinceEpoch(0);

  /// Returns whether [flag] is enabled.
  /// Automatically refreshes from remote when cache expired.
  Future<bool> isEnabled(String flag) async {
    if (DateTime.now().isAfter(_cacheExpiry)) {
      await _refreshFlags();
    }
    // Fallback to environment defaults
    return _cache[flag] ?? Environment.availableFeatures[flag] ?? false;
  }

  Future<void> _refreshFlags() async {
    final url = '${Environment.apiBaseUrl}/config/feature_flags.json';
    try {
      final Response res = await Dio()
          .get(url, options: Options(responseType: ResponseType.json));
      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        _cache = (res.data as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v == true));
        _cacheExpiry = DateTime.now().add(const Duration(minutes: 5));
        return;
      }
    } catch (e) {
      // Swallow network errors – will use fallback defaults
    }
    // Set short expiry so we retry soon, but avoid hammering endpoint
    _cacheExpiry = DateTime.now().add(const Duration(minutes: 1));
  }
}
