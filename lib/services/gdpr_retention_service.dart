// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

class GdprRetentionService {
  const GdprRetentionService(this._endpoint, {http.Client? client})
      : _client = client;

  final String
      _endpoint; // e.g. https://<project>.functions.supabase.co/schedule_retention
  final http.Client? _client;

  Future<Map<String, dynamic>> run({bool dryRun = true}) async {
    final uri = Uri.parse('$_endpoint?dry_run=${dryRun ? 'true' : 'false'}');
    final client = _client ?? http.Client();
    try {
      final resp = await client.get(uri).timeout(const Duration(seconds: 15));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      throw Exception('Retention function failed: ${resp.statusCode}');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }
}
