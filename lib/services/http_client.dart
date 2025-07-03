import 'package:dio/dio.dart';
import 'package:sentry_dio/sentry_dio.dart';

/// Provides a configured [Dio] HTTP client with Sentry tracing & breadcrumb support.
///
/// Usage:
/// ```dart
/// final dio = HttpClient.instance;
/// final response = await dio.get('/endpoint');
/// ```
class HttpClient {
  HttpClient._internal() {
    _dio = Dio()..addSentry();
  }

  static final HttpClient _singleton = HttpClient._internal();

  late final Dio _dio;

  /// Globally shared Dio instance.
  static Dio get instance => _singleton._dio;
}
