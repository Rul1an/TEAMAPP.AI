// ignore_for_file: flutter_style_todos

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  static final DeepLinkService instance = DeepLinkService();

  StreamSubscription<Uri>? _linkSub;

  /// Sets up deep link handling using the provided [GoRouter] instance.
  ///
  /// On mobile we listen to the [AppLinks] stream for incoming links and
  /// process the initial link. On web we parse [Uri.base] once during
  /// initialisation which covers refreshes and direct navigations.
  Future<void> init(GoRouter router) async {
    if (kIsWeb) {
      _handleUri(router, Uri.base);
      return;
    }

    final appLinks = AppLinks();

    try {
      final initial = await appLinks.getInitialLink();
      _handleUri(router, initial);
    } catch (_) {
      // Ignore errors from the platform link handler.
    }

    _linkSub = appLinks.uriLinkStream.listen(
      (uri) => _handleUri(router, uri),
      onError: (_) {},
    );
  }

  /// Exposed for unit testing.
  @visibleForTesting
  void handleUriForTest(Uri? uri, GoRouter router) => _handleUri(router, uri);

  void _handleUri(GoRouter router, Uri? uri) {
    if (uri == null) return;

    // On web links are provided as hash fragments (e.g. #/matches/123).
    final path = uri.fragment.isNotEmpty ? uri.fragment : uri.path;
    final segments = Uri.parse(path).pathSegments;
    if (segments.length < 2) return;

    final id = segments[1];
    switch (segments.first) {
      case 'matches':
        router.go('/matches/$id');
      case 'training':
        router.go('/training/$id');
    }
  }

  /// Returns a shareable deep link for a match.
  Uri createMatchLink(String matchId) {
    // In production we would generate a Firebase Dynamic Link or similar.
    // For now construct app web baseUrl + hash route.
    const base = 'https://teamappai.netlify.app';
    return Uri.parse('$base/#/matches/$matchId');
  }

  /// Returns a shareable deep link for a training session.
  Uri createTrainingLink(String trainingId) {
    const base = 'https://teamappai.netlify.app';
    return Uri.parse('$base/#/training/$trainingId');
  }
}
