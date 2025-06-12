import 'package:isar/isar.dart';
import 'team.dart';

// part 'match.g.dart'; // Temporarily commented out

enum Location {
  home,
  away;

  String get displayName {
    switch (this) {
      case Location.home:
        return 'Thuis';
      case Location.away:
        return 'Uit';
    }
  }
}

enum Competition {
  league,
  cup,
  friendly,
  tournament;

  String get displayName {
    switch (this) {
      case Competition.league:
        return 'Competitie';
      case Competition.cup:
        return 'Beker';
      case Competition.friendly:
        return 'Vriendschappelijk';
      case Competition.tournament:
        return 'Toernooi';
    }
  }
}

enum MatchResult {
  win,
  draw,
  loss;

  String get displayName {
    switch (this) {
      case MatchResult.win:
        return 'Gewonnen';
      case MatchResult.draw:
        return 'Gelijk';
      case MatchResult.loss:
        return 'Verloren';
    }
  }
}

enum MatchStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
  postponed;

  String get displayName {
    switch (this) {
      case MatchStatus.scheduled:
        return 'Gepland';
      case MatchStatus.inProgress:
        return 'Bezig';
      case MatchStatus.completed:
        return 'Afgerond';
      case MatchStatus.cancelled:
        return 'Geannuleerd';
      case MatchStatus.postponed:
        return 'Uitgesteld';
    }
  }
}

@collection
class Match {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late String opponent;

  @enumerated
  late Location location;

  @enumerated
  late Competition competition;

  @enumerated
  late MatchStatus status;

  // Score
  int? teamScore;
  int? opponentScore;

  // Details
  String? venue;
  String? referee;

  // Lineup
  List<String> startingLineupIds = [];
  List<String> substituteIds = [];
  @ignore
  Map<String, String> fieldPositions = {}; // position -> playerId

  @enumerated
  @ignore
  Formation? selectedFormation;

  // Events
  List<String> goalScorers = [];
  List<String> assistProviders = [];
  List<String> yellowCards = [];
  List<String> redCards = [];
  List<String> substitutions = [];

  // Notes
  String? matchReport;
  String? coachNotes;

  late DateTime createdAt;
  late DateTime updatedAt;

  // Computed properties
  @ignore
  MatchResult? get result {
    if (teamScore == null || opponentScore == null) return null;
    if (teamScore! > opponentScore!) return MatchResult.win;
    if (teamScore! < opponentScore!) return MatchResult.loss;
    return MatchResult.draw;
  }

  Match() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    status = MatchStatus.scheduled;
  }
}
