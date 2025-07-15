// ignore_for_file: one_member_abstracts

import 'package:csv/csv.dart';

/// Base utility for converting raw CSV text into strongly-typed DTOs.
///
/// Consumers only need to implement [mapRow] which converts the header-keyed
/// `Map<String, String>` into a typed object. Returning `null` marks the row as
/// invalid and it will be reported to the caller via the [ParseResult].
abstract class BaseCsvParser<T> {
  /// Parses [csv] text and returns a [ParseResult].
  ParseResult<T> parse(String csv) {
    final rows = const CsvToListConverter(eol: '\n').convert(csv);
    if (rows.isEmpty) return ParseResult<T>.empty();

    // Header row – convert to lower-cased keys for leniency.
    final header = rows.first.cast<dynamic>().map((e) => e.toString().toLowerCase()).toList();

    final items = <T>[];
    final errors = <String>[];

    for (var i = 1; i < rows.length; i++) {
      final rowValues = rows[i];
      final rowMap = <String, String>{};
      for (var col = 0; col < header.length && col < rowValues.length; col++) {
        rowMap[header[col]] = rowValues[col].toString();
      }

      try {
        final mapped = mapRow(rowMap);
        if (mapped != null) items.add(mapped);
      } catch (e) {
        errors.add('Row ${i + 1}: $e'); // +1 because header = index 0
      }
    }

    return ParseResult(items: items, errors: errors);
  }

  /// Implement to map a single CSV row (header keys) to a DTO.
  /// Return `null` to skip invalid rows gracefully.
  T? mapRow(Map<String, String> row);
}

class ParseResult<T> {
  const ParseResult({required this.items, required this.errors});

  final List<T> items;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
  int get successCount => items.length;

  factory ParseResult.empty() => const ParseResult(items: [], errors: []);
}