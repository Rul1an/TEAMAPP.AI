// DeepLinkService – manages Firebase Dynamic Links and in-app navigation

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import 'analytics_service.dart';

class DeepLinkService {
  DeepLinkService._();
  static final instance = DeepLinkService._();

  final _dynamicLinks = FirebaseDynamicLinks.instance;

  /// Call after Firebase initialization.
  Future<void> init(GoRouter router) async {
    // Handle initial link if app was launched by deep link.
    final initial = await _dynamicLinks.getInitialLink();
    if (initial != null) _handleLink(initial, router);

    // Foreground links
    _dynamicLinks.onLink.listen((event) => _handleLink(event, router));
  }

  void _handleLink(PendingDynamicLinkData data, GoRouter router) {
    final uri = data.link;
    if (uri.pathSegments.isEmpty) return;
    final first = uri.pathSegments.first;
    switch (first) {
      case 'matches':
        final matchId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (matchId != null) {
          router.go('/matches/$matchId');
        }
        break;
      default:
    }
  }

  /// Build a shareable dynamic link to a match.
  Future<Uri> createMatchLink(String matchId) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://tm.page.link',
      link: Uri.parse('https://jo17.app/matches/$matchId'),
      androidParameters: const AndroidParameters(packageName: 'com.voab.jo17_tactical_manager'),
      iosParameters: const IOSParameters(bundleId: 'com.voab.jo17TacticalManager'),
    );

    final short = await _dynamicLinks.buildShortLink(parameters);
    return short.shortUrl;
  }

  Future<void> shareMatchLink(String matchId) async {
    final url = await createMatchLink(matchId);
    await AnalyticsService.instance.logEvent('share_match', params: {'matchId': matchId});
    await Share.share('Bekijk de wedstrijd $url');
  }
}