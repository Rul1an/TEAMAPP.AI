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

  // ---------------------------------------------------------------------------
  // JSON serialization helpers – keep manual (avoid codegen for now)
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'date_time': dateTime.toIso8601String(),
        'opponent': opponent,
        'location': location.name,
        'competition': competition.name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      }..removeWhere((_, v) => v == null);

  static MatchSchedule fromJson(Map<String, dynamic> json) => MatchSchedule()
    ..id = json['id'] as String? ?? ''
    ..dateTime = DateTime.tryParse(json['date_time'] as String? ?? '') ??
        DateTime.now()
    ..opponent = json['opponent'] as String? ?? ''
    ..location = Location.values.firstWhere(
      (e) => e.name == (json['location'] as String? ?? '').toLowerCase(),
      orElse: () => Location.home,
    )
    ..competition = Competition.values.firstWhere(
      (e) => e.name == (json['competition'] as String? ?? '').toLowerCase(),
      orElse: () => Competition.league,
    )
    ..createdAt = DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now()
    ..updatedAt = DateTime.tryParse(json['updated_at'] as String? ?? '') ??
        DateTime.now();
}