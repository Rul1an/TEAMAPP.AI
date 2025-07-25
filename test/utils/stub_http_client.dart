// ignore_for_file: sort_constructors_first, require_trailing_commas

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:http/http.dart' as http;

/// Lightweight stub that short-circuits Supabase HTTP calls in tests.
///
/// Usage Example in a test:
/// ```dart
/// final client = SupabaseClient(
///   'http://stub.supabase.co',
///   'anon-key',
///   httpClient: StubHttpClient({
///     '/rest/v1/my_view': (_) => http.Response('[{"id":1}]', 200,
///         headers: {'content-type': 'application/json'}),
///   }),
/// );
/// ```
class StubHttpClient extends http.BaseClient {
  /// Map of path pattern -> factory for the desired HTTP response.
  final Map<Pattern, http.Response Function(http.BaseRequest)> _routes;

  StubHttpClient(this._routes);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    for (final entry in _routes.entries) {
      if (request.url.path.contains(entry.key)) {
        final res = entry.value(request);
        return _toStreamed(res, request);
      }
    }
    // Default 404 when no route matches.
    return _toStreamed(
      http.Response(
        'Stub route not found for ${request.url.path}',
        404,
        headers: {'content-type': 'text/plain'},
      ),
      request,
    );
  }

  http.StreamedResponse _toStreamed(
    http.Response res,
    http.BaseRequest original,
  ) {
    return http.StreamedResponse(
      Stream.fromIterable([res.bodyBytes]),
      res.statusCode,
      headers: res.headers,
      reasonPhrase: res.reasonPhrase,
      request: original,
    );
  }
}
