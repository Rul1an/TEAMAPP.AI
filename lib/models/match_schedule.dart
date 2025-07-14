// Package imports:
import 'package:isar/isar.dart';

// Project imports:
import 'match.dart';

/// Domain model representing a scheduled match that is not yet persisted
/// as a full [`Match`] object. This is the primary output of the CSV/XLSX
/// import flow and acts as a staging entity for validation & duplicate
/// detection before the fixtures are promoted to real matches.
///
/// NOTE: Only the minimal set of properties required for the Import Phase
/// is included. Down-the-road we can evolve this model (or merge it into
/// [`Match`]) when more scheduling functionality is introduced.
class MatchSchedule {
  MatchSchedule() {
    id = '';
    dateTime = DateTime.now();
    opponent = '';
    location = Location.home;
    competition = Competition.league;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  /// Unique identifier – UUID v4 suggested but left to service layer.
  late String id;

  /// Combined date & time of the fixture.
  late DateTime dateTime;

  /// Opponent club/team name.
  late String opponent;

  /// Home or away.
  @Enumerated(EnumType.name)
  late Location location;

  /// Type of competition / context.
  @Enumerated(EnumType.name)
  late Competition competition;

  /// Meta timestamps.
  late DateTime createdAt;
  late DateTime updatedAt;
}