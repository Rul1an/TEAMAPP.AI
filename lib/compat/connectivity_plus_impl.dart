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
    // Normalize to list; connectivity_plus emits single values on stable versions
    return cp_real.Connectivity().onConnectivityChanged.map(
      (dynamic event) {
        final cp_real.ConnectivityResult result =
            event as cp_real.ConnectivityResult;
        final bool isNone = result == cp_real.ConnectivityResult.none;
        return <ConnectivityResult>[
          isNone ? ConnectivityResult.none : ConnectivityResult.other,
        ];
      },
    );
  }

  Future<List<ConnectivityResult>> checkConnectivity() async {
    final result = await cp_real.Connectivity().checkConnectivity();
    if (result == cp_real.ConnectivityResult.none) {
      return <ConnectivityResult>[ConnectivityResult.none];
    }
    return <ConnectivityResult>[ConnectivityResult.other];
  }
}
