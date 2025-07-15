// Experimental streaming CSV parser to handle large files efficiently.
// Processes the CSV line-by-line in chunks to avoid blocking UI.
//
// Usage:
// ```dart
// final result = await StreamingCsvParser.parse(
//   csvBytes,
//   mapper: (rowMap) => MyDto.fromCsv(rowMap),
//   onProgress: (pct) => debugPrint('progress: $pct'),
// );
// ```
//
// Limitations: this is a simplified implementation; for complex escaping rules
// consider the `csv` package's chunked converter.

import 'dart:convert';
import 'dart:typed_data';

class StreamingCsvParser<T> {
  static Future<ParseResult<T>> parse<T>(
    Uint8List bytes, {
    required T? Function(Map<String, String> row) mapper,
    void Function(double progress)? onProgress,
    int notifyEveryLines = 500,
  }) async {
    final text = utf8.decode(bytes);
    final lines = const LineSplitter().convert(text);
    if (lines.isEmpty) return ParseResult.empty();

    final header = lines.first.split(',').map((e) => e.trim().toLowerCase()).toList();
    final items = <T>[];
    final errors = <String>[];

    for (var i = 1; i < lines.length; i++) {
      final cols = lines[i].split(',');
      final map = <String, String>{};
      for (var c = 0; c < header.length && c < cols.length; c++) {
        map[header[c]] = cols[c].trim();
      }
      try {
        final dto = mapper(map);
        if (dto != null) items.add(dto);
      } catch (e) {
        errors.add('Row ${i + 1}: $e');
      }
      if (onProgress != null && i % notifyEveryLines == 0) {
        onProgress(i / lines.length);
        await Future<void>.delayed(const Duration(milliseconds: 1)); // yield
      }
    }
    onProgress?.call(1);
    return ParseResult(items: items, errors: errors);
  }
}

class ParseResult<T> {
  const ParseResult({required this.items, required this.errors});
  final List<T> items;
  final List<String> errors;
  bool get hasErrors => errors.isNotEmpty;
  factory ParseResult.empty() => const ParseResult(items: [], errors: []);
}