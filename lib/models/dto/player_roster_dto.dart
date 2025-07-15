// DTO used during player roster import preview.

import 'package:intl/intl.dart';
import '../../models/player.dart';

class PlayerRosterDto {
  PlayerRosterDto({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.jerseyNumber,
    required this.position,
  });

  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final int jerseyNumber;
  final Position position;

  static DateTime parseDate(String value) {
    final formats = ['yyyy-MM-dd', 'dd-MM-yyyy', 'dd/MM/yyyy', 'MM/dd/yyyy'];
    for (final fmt in formats) {
      try {
        return DateFormat(fmt).parse(value);
      } catch (_) {}
    }
    throw FormatException('Invalid date: $value');
  }

  static Position parsePosition(String value) {
    final v = value.toLowerCase();
    if (v.startsWith('keep') || v == 'gk') return Position.goalkeeper;
    if (v.contains('def') || v.startsWith('verded')) return Position.defender;
    if (v.contains('mid')) return Position.midfielder;
    if (v.contains('aanv') || v.contains('for')) return Position.forward;
    return Position.midfielder;
  }
}