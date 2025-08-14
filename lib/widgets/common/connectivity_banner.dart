import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkInternetReachability();
    });
    // Initial check
    _checkInternetReachability();
  }

  Future<void> _checkInternetReachability() async {
    try {
      final Uri probe = kIsWeb
          ? Uri.parse(
              '/favicon.png?nocache=${DateTime.now().millisecondsSinceEpoch}')
          : Uri.parse('https://www.gstatic.com/generate_204');
      final response =
          await http.get(probe).timeout(const Duration(seconds: 3));
      final bool online =
          kIsWeb ? response.statusCode == 200 : response.statusCode == 204;
      if (mounted && _isOnline != online) {
        setState(() => _isOnline = online);
      }
    } catch (_) {
      if (mounted && _isOnline != false) {
        setState(() => _isOnline = false);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOnline) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.wifi_off, color: scheme.onErrorContainer),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Offline: wijzigingen worden gesynchroniseerd zodra je weer online bent',
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
