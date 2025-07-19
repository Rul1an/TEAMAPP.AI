import 'dart:convert';
import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// AlertService is responsible for cross-cutting operational alerts like
/// SLA breaches. It sends notifications to Slack and PagerDuty using
/// webhook integrations configured via environment variables.
class AlertService {
  factory AlertService() => _instance;
  AlertService._internal();
  static final AlertService _instance = AlertService._internal();

  static const _defaultTimeout = Duration(seconds: 5);

  String? get _slackWebhookUrl => dotenv.env['SLACK_WEBHOOK_URL'];
  String? get _pagerDutyRoutingKey => dotenv.env['PAGERDUTY_INTEGRATION_KEY'];

  /// Sends a formatted Slack message using the incoming-webhook URL.
  Future<void> _sendSlack({required String text}) async {
    final url = _slackWebhookUrl;
    if (url == null || url.isEmpty) return; // Slack not configured.

    final payload = jsonEncode({'text': text});
    try {
      await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(_defaultTimeout);
    } catch (_) {
      // Swallow – we never want alert failures to crash the app.
    }
  }

  /// Triggers a PagerDuty event via Events API v2.
  Future<void> _triggerPagerDuty({
    required String summary,
    String severity = 'error',
    Map<String, dynamic>? details,
  }) async {
    final routingKey = _pagerDutyRoutingKey;
    if (routingKey == null || routingKey.isEmpty) return; // PagerDuty not configured.

    final payload = jsonEncode({
      'routing_key': routingKey,
      'event_action': 'trigger',
      'payload': {
        'summary': summary,
        'severity': severity,
        'source': 'jo17-tactical-manager',
        'custom_details': details ?? <String, dynamic>{},
      },
    });

    try {
      await http
          .post(
            Uri.parse('https://events.pagerduty.com/v2/enqueue'),
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(_defaultTimeout);
    } catch (_) {
      // Ignore – alerting should be best-effort.
    }
  }

  /// High-level helper for SLA-breach notifications.
  Future<void> notifySlaBreach({
    required String metric,
    required double value,
    required double threshold,
    Map<String, dynamic>? context,
  }) async {
    final title = '🚨 SLA Breach – $metric';
    final message =
        '$metric breached SLA. value=${value.toStringAsFixed(1)}ms, threshold=${threshold.toStringAsFixed(1)}ms';

    // Fire & forget – do not await both so delays do not block caller.
    unawaited(_sendSlack(text: '*$title*\n$message'));
    unawaited(_triggerPagerDuty(
      summary: message,
      details: {
        'metric': metric,
        'value_ms': value,
        'threshold_ms': threshold,
        ...?context,
      },
    ));
  }
}