import 'dart:io';

import 'package:http/http.dart' as http;

/// 🔐 Zero-trust mTLS HTTP client to call Edge Storage APIs.
///
/// Loads client certificate & key from secure storage (env vars / secrets) and
/// pins server CA certificate. Works on mobile/Desktop targets (not web).
class SecureStorageClient {
  SecureStorageClient._internal() {
    final certPem = Platform.environment['STORAGE_CLIENT_CERT'];
    final keyPem = Platform.environment['STORAGE_CLIENT_KEY'];
    final caPem = Platform.environment['STORAGE_CA_CERT'];

    if (certPem == null || keyPem == null || caPem == null) {
      throw StateError('Missing mTLS environment variables');
    }

    final context = SecurityContext()
      ..useCertificateChainBytes(certPem.codeUnits)
      ..usePrivateKeyBytes(keyPem.codeUnits)
      ..setTrustedCertificatesBytes(caPem.codeUnits);

    _ioClient = HttpClient(context: context)
      ..badCertificateCallback =
          (cert, host, port) => false; // rely on CA pinning
  }

  static final SecureStorageClient instance = SecureStorageClient._internal();

  late final HttpClient _ioClient;

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final ioRequest = await _ioClient.getUrl(url);
    headers?.forEach(ioRequest.headers.set);
    final ioResponse = await ioRequest.close();
    final bytes = await ioResponse
        .fold<List<int>>([], (prev, elem) => prev..addAll(elem));
    return http.Response.bytes(bytes, ioResponse.statusCode,
        headers: ioResponse.headers);
  }

  // Similarly, POST/PUT can be implemented.
}
