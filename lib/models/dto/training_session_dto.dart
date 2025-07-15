// DTO for training session import.

import 'package:intl/intl.dart';

class TrainingSessionDto {
  TrainingSessionDto({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.teamId,
  });

  final DateTime date;
  final String startTime; // HH:mm string for simplicity
  final String endTime;
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