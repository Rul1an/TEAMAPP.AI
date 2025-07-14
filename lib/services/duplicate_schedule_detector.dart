// Dart imports:
import 'package:intl/intl.dart';

// Project imports:
import '../models/match_schedule.dart';

class DuplicateScheduleResult {
  DuplicateScheduleResult({required this.unique, required this.duplicates});

  /// Schedules that are NOT considered duplicates and can be safely added.
  final List<MatchSchedule> unique;

  /// Imported schedules that collide with an existing one. Each element refers
  /// to the conflicting imported entry (not the existing one).
  final List<MatchSchedule> duplicates;

  bool get hasDuplicates => duplicates.isNotEmpty;
}

/// Utility to detect potential duplicates between an imported fixture list and
/// an existing list in storage.
class DuplicateScheduleDetector {
  DuplicateScheduleDetector({DateFormat? dateFormat})
      : _dateFormat = dateFormat ?? DateFormat('yyyy-MM-dd');

  final DateFormat _dateFormat;

  /// Scans [imported] against [existing] and returns a [DuplicateScheduleResult].
  ///
  /// Criteria (simple, can be expanded later):
  ///   • Same calendar date (`yyyy-MM-dd`)
  ///   • Same opponent (case-insensitive, trimmed)
  ///
  DuplicateScheduleResult detect(
    List<MatchSchedule> imported,
    List<MatchSchedule> existing,
  ) {
    final duplicateKeys = <String>{};

    for (final e in existing) {
      duplicateKeys.add(_keyFor(e));
    }

    final unique = <MatchSchedule>[];
    final duplicates = <MatchSchedule>[];

    for (final i in imported) {
      final key = _keyFor(i);
      if (duplicateKeys.contains(key)) {
        duplicates.add(i);
      } else {
        unique.add(i);
      }
    }

    return DuplicateScheduleResult(unique: unique, duplicates: duplicates);
  }

  // Helper to build a hash key.
  String _keyFor(MatchSchedule s) {
    final dateStr = _dateFormat.format(s.dateTime.toLocal());
    final opp = s.opponent.trim().toLowerCase();
    return '$dateStr#$opp';
  }
}