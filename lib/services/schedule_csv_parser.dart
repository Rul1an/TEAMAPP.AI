// Dart imports:
// Package imports:
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import '../core/result.dart';
import '../models/match.dart';
import '../models/match_schedule.dart';

/// Lightweight CSV parser that converts a comma-separated list of fixtures
/// into a list of [`MatchSchedule`] objects.
///
/// The expected header row is (order-insensitive):
///   date,time,opponent,competition,location
///
/// • `date` – ISO `yyyy-MM-dd`
/// • `time` – `HH:mm`
/// • `location` – `Thuis` / `Uit` (optional, defaults to Thuis)
///
/// Any row that fails validation is skipped and reported in [errors].
class ScheduleCsvParseResult {
  ScheduleCsvParseResult(this.schedules, this.errors);
  final List<MatchSchedule> schedules;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
}

class ScheduleCsvParser {
  ScheduleCsvParser({CsvToListConverter? converter})
      : _converter = converter ?? const CsvToListConverter();

  final CsvToListConverter _converter;
  final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');
  final DateFormat _timeFmt = DateFormat('HH:mm');
  final _uuid = const Uuid();

  Future<Result<ScheduleCsvParseResult>> parse(String csvContent) async {
    try {
      final rows = _converter.convert(csvContent.trim());
      if (rows.isEmpty) {
        return Success(ScheduleCsvParseResult([], ['CSV is empty']));
      }

      final header =
          rows.first.map((e) => e.toString().trim().toLowerCase()).toList();
      final idxDate = header.indexOf('date');
      final idxTime = header.indexOf('time');
      final idxOpp = header.indexOf('opponent');
      final idxComp = header.indexOf('competition');
      final idxLoc = header.indexOf('location');

      // Basic header validation.
      if ([idxDate, idxTime, idxOpp, idxComp].any((i) => i == -1)) {
        return Success(
          ScheduleCsvParseResult(
            [],
            [
              'Missing one or more required headers: date,time,opponent,competition'
            ],
          ),
        );
      }

      final schedules = <MatchSchedule>[];
      final errors = <String>[];

      for (var row = 1; row < rows.length; row++) {
        final r = rows[row];
        try {
          final dynamic dateCell = r[idxDate];
          final dynamic timeCell = r[idxTime];

          // Converter may coerce cells to DateTime or numbers; handle gracefully.
          final DateTime date = dateCell is DateTime
              ? dateCell
              : _dateFmt.parseStrict(dateCell.toString().trim());

          final DateTime time = timeCell is DateTime
              ? timeCell
              : _timeFmt.parseStrict(timeCell.toString().trim());
          final dateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);

          final opp = r[idxOpp].toString().trim();
          final compStr = r[idxComp].toString().trim();
          final locStr = idxLoc != -1 ? r[idxLoc].toString().trim() : 'Thuis';

          // Competition mapping.
          final competition = _competitionFrom(compStr);
          // Location mapping.
          final location = _locationFrom(locStr);

          final schedule = MatchSchedule()
            ..id = _uuid.v4()
            ..dateTime = dateTime
            ..opponent = opp
            ..competition = competition
            ..location = location;

          schedules.add(schedule);
        } catch (e) {
          errors.add('Row ${row + 1}: ${e.toString()}');
        }
      }

      return Success(ScheduleCsvParseResult(schedules, errors));
    } catch (e) {
      return Failure(CacheFailure(e.toString()));
    }
  }

  // helpers
  Competition _competitionFrom(String input) {
    final normalized = input.toLowerCase();
    switch (normalized) {
      case 'beker':
      case 'cup':
        return Competition.cup;
      case 'vriendschappelijk':
      case 'friendly':
        return Competition.friendly;
      case 'toernooi':
      case 'tournament':
        return Competition.tournament;
      default:
        return Competition.league;
    }
  }

  Location _locationFrom(String input) {
    final normalized = input.toLowerCase();
    if (normalized.startsWith('u')) return Location.away;
    return Location.home; // default
  }
}
