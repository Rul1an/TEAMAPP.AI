// Data Transfer Object used solely during CSV/XLSX import preview.
// Not persisted – converted to [Match] domain objects afterwards.

import 'package:intl/intl.dart';

class MatchScheduleDto {
  MatchScheduleDto({
    required this.date,
    required this.opponent,
    required this.venue,
    required this.teamId,
  });

  final DateTime date;
  final String opponent;
  final String venue;
  final String teamId;

  static DateTime parseDate(String value) {
    final formats = ['yyyy-MM-dd', 'dd-MM-yyyy', 'dd/MM/yyyy', 'MM/dd/yyyy'];
    for (final fmt in formats) {
      try {
        return DateFormat(fmt).parse(value);
      } catch (_) {}
    }
    throw FormatException('Invalid date: $value');
  }
}