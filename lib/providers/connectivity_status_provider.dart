// Flutter imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';

/// StreamProvider that emits `true` when the device reports any connectivity
/// other than `none`. This is a coarse online/offline signal suitable for
/// simple router redirects. Detailed reachability checks remain in UI widgets.
final connectivityStatusProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  // Emit initial state
  final initial = await connectivity.checkConnectivity();
  yield initial.any((r) => r != ConnectivityResult.none);

  // Listen to subsequent changes
  await for (final results in connectivity.onConnectivityChanged) {
    yield results.any((r) => r != ConnectivityResult.none);
  }
});
