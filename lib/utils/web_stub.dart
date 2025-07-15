// Minimal stubs to allow non-web platforms (e.g., unit tests) to compile
// when `package:web/web.dart` is imported conditionally.
// These no-op implementations should never be executed on web builds.

class Blob {
  Blob(this._parts, [this._type = 'application/octet-stream']);
  final List<dynamic> _parts;
  final String _type;
}

class Url {
  static String createObjectUrlFromBlob(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({this.href});
  String? href;

  void setAttribute(String name, String value) {}
  void click() {}
}
