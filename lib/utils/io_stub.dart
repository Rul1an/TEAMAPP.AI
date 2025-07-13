// This stub is used when compiling for web where `dart:io` is unavailable.
// It provides minimal no-op implementations so that source files can
// reference `io.File` without pulling in the actual `dart:io` library.

class File {
  File(String path);
  Future<void> writeAsBytes(List<int> bytes, {bool flush = false}) async {}
  String get path => '';
}