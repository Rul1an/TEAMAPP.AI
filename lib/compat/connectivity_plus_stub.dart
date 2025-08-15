// Wasm-safe stub for connectivity_plus (no-ops with optimistic online default)

class ConnectivityResult {
  final String name;
  const ConnectivityResult._(this.name);

  static const ConnectivityResult none = ConnectivityResult._('none');
  static const ConnectivityResult other = ConnectivityResult._('other');
}

class Connectivity {
  const Connectivity();

  // Stream of connectivity changes: empty on wasm (no events)
  Stream<List<ConnectivityResult>> get onConnectivityChanged async* {}

  // Initial check: assume online on wasm
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return <ConnectivityResult>[ConnectivityResult.other];
  }
}
