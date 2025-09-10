import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

import 'package:csv/csv.dart';

import '../core/result.dart';
import '../models/match.dart';
import '../models/import_report.dart';
import '../repositories/match_repository.dart';

class ScheduleImportService {
  ScheduleImportService(this._repo);

  final MatchRepository _repo;

  /// Imports match fixtures from raw CSV bytes.
  /// Returns [ImportReport] with count & errors.
  Future<Result<ImportReport>> importCsvBytes(Uint8List bytes) async {
    // Heavy CSV-decoding offloaded to background isolate.
    final rows = await compute(_decodeCsvIsolate, bytes);
    if (rows.isEmpty) {
      return const Success(ImportReport(imported: 0, errors: ['Leeg CSV']));
    }
    // Expect header row
    final header =
        rows.first.map((e) => e.toString().trim().toLowerCase()).toList();
    final required = ['date', 'time', 'opponent', 'competition', 'location'];
    if (!required.every(header.contains)) {
      return Success(
        ImportReport(
          imported: 0,
          errors: [
            'CSV mist verplichte kolommen: ${required.where((c) => !header.contains(c)).join(', ')}',
          ],
        ),
      );
    }
    final dateIdx = header.indexOf('date');
    final timeIdx = header.indexOf('time');
    final oppIdx = header.indexOf('opponent');
    final compIdx = header.indexOf('competition');
    final locIdx = header.indexOf('location');

    // Preload existing matches to detect duplicates (date & opponent)
    final existingRes = await _repo.getAll();
    final existing =
        existingRes.isSuccess ? existingRes.dataOrNull! : <Match>[];
    final existingKeys =
        existing.map((m) => _dupKey(m.date, m.opponent)).toSet();

    var imported = 0;
    final errors = <String>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      try {
        if (row.length <= dateIdx ||
            row.length <= timeIdx ||
            row.length <= oppIdx ||
            row.length <= compIdx ||
            row.length <= locIdx) {
          errors.add('Rij $i: onvoldoende kolommen');
          continue;
        }

        final dateStr = row[dateIdx]?.toString();
        final timeStr = row[timeIdx]?.toString();
        final dt = DateTime.tryParse('$dateStr $timeStr');
        if (dt == null) {
          errors.add('Rij $i: ongeldige datum of tijd');
          continue;
        }
        final locStr = row[locIdx].toString().toLowerCase();
        final compStr = row[compIdx].toString().toLowerCase();

        final location = switch (locStr) {
          'uit' || 'away' => Location.away,
          _ => Location.home,
        };

        final competition = switch (compStr) {
          'cup' || 'beker' => Competition.cup,
          'friendly' || 'vriendschappelijk' => Competition.friendly,
          'tournament' || 'toernooi' => Competition.tournament,
          _ => Competition.league,
        };

        final dupKey = _dupKey(dt, row[oppIdx].toString());
        if (existingKeys.contains(dupKey)) {
          errors.add(
              'Rij $i: duplicaat – ${row[oppIdx]} op ${dt.toIso8601String()}');
          continue;
        }

        final match = Match()
          ..id = '${DateTime.now().millisecondsSinceEpoch}-$i'
          ..date = dt
          ..opponent = row[oppIdx].toString()
          ..competition = competition
          ..location = location;
        final res = await _repo.add(match);
        if (res.isSuccess) {
          imported += 1;
          existingKeys.add(dupKey);
        } else {
          errors.add('Rij $i: ${res.errorOrNull?.message ?? 'onbekende fout'}');
        }
      } catch (e) {
        errors.add('Rij $i: $e');
      }
    }
    return Success(ImportReport(imported: imported, errors: errors));
  }

  String _dupKey(DateTime dateTime, String opponent) {
    // Use YYYY-MM-DD + lowercase opponent as uniqueness key
    final d = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return '${d.toIso8601String().substring(0, 10)}|${opponent.toLowerCase()}';
  }
}

// Top-level isolate entry point – must be a global/static function.
List<List<dynamic>> _decodeCsvIsolate(Uint8List bytes) {
  final csvStr = utf8.decode(bytes);
  return const CsvToListConverter(eol: '\n').convert(csvStr);
}
