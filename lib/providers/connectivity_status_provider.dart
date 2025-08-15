// Flutter imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';

/// StreamProvider that emits `true` when the device reports any connectivity
/// other than `none`. This is a coarse online/offline signal suitable for
/// simple router redirects. Detailed reachability checks remain in UI widgets.
final connectivityStatusProvider = StreamProvider<bool>((ref) async* {
  try {
    final connectivity = Connectivity();
    // Emit initial state with safety fallback
    try {
      final initial = await connectivity.checkConnectivity();
      yield initial.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      // Assume online at startup to avoid blocking app init
      yield true;
    }

    // Listen to subsequent changes
    await for (final results in connectivity.onConnectivityChanged) {
      try {
        yield results.any((r) => r != ConnectivityResult.none);
      } catch (_) {
        // Maintain optimistic online status on intermittent errors
        yield true;
      }
    }
  } catch (_) {
    // Ultimate fallback: always assume online if service fails
    yield true;
  }
});
