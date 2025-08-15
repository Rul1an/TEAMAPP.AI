// Native implementation wrapper for connectivity_plus but exposing a stable API.

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart' as cp_real;

class ConnectivityResult {
  final String name;
  const ConnectivityResult._(this.name);

  static const ConnectivityResult none = ConnectivityResult._('none');
  static const ConnectivityResult other = ConnectivityResult._('other');
}

class Connectivity {
  const Connectivity();

  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    // Normalize to list; connectivity_plus may emit a single value or a list depending on platform/version
    return cp_real.Connectivity().onConnectivityChanged.map((dynamic event) {
      final List<cp_real.ConnectivityResult> results = event
              is List<cp_real.ConnectivityResult>
          ? event
          : <cp_real.ConnectivityResult>[event as cp_real.ConnectivityResult];
      final bool hasNone = results.contains(cp_real.ConnectivityResult.none);
      return <ConnectivityResult>[
        if (hasNone) ConnectivityResult.none else ConnectivityResult.other,
      ];
    });
  }

  Future<List<ConnectivityResult>> checkConnectivity() async {
    final dynamic result = await cp_real.Connectivity().checkConnectivity();
    // Normalize both legacy (single) and newer (list) return shapes
    final bool isNone = result is List<cp_real.ConnectivityResult>
        ? result.contains(cp_real.ConnectivityResult.none)
        : (result as cp_real.ConnectivityResult) ==
            cp_real.ConnectivityResult.none;
    if (isNone) {
      return <ConnectivityResult>[ConnectivityResult.none];
    }
    return <ConnectivityResult>[ConnectivityResult.other];
  }
}
