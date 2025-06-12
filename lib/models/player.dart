import 'package:isar/isar.dart';

// part 'player.g.dart'; // Temporarily commented out

enum Position {
  goalkeeper,
  defender,
  midfielder,
  forward;

  String get displayName {
    switch (this) {
      case Position.goalkeeper:
        return 'Keeper';
      case Position.defender:
        return 'Verdediger';
      case Position.midfielder:
        return 'Middenvelder';
      case Position.forward:
        return 'Aanvaller';
    }
  }
}

enum PreferredFoot {
  left,
  right,
  both;

  String get displayName {
    switch (this) {
      case PreferredFoot.left:
        return 'Links';
      case PreferredFoot.right:
        return 'Rechts';
      case PreferredFoot.both:
        return 'Beide';
    }
  }
}

@collection
class Player {
  Id id = Isar.autoIncrement;

  late String firstName;
  late String lastName;
  late int jerseyNumber;
  late DateTime birthDate;

  @enumerated
  late Position position;

  @enumerated
  late PreferredFoot preferredFoot;

  late double height; // in cm
  late double weight; // in kg

  String? phoneNumber;
  String? email;
  String? parentContact;

  // Performance metrics
  int matchesPlayed = 0;
  int matchesInSelection = 0; // Aantal keer in selectie (basis + wissel)
  int minutesPlayed = 0; // Totaal aantal gespeelde minuten
  int goals = 0;
  int assists = 0;
  int yellowCards = 0;
  int redCards = 0;

  // Training
  int trainingsAttended = 0;
  int trainingsTotal = 0;

  late DateTime createdAt;
  late DateTime updatedAt;

  // Computed properties
  String get name => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  double get attendancePercentage {
    if (trainingsTotal == 0) return 0;
    return (trainingsAttended / trainingsTotal) * 100;
  }

  double get matchMinutesPercentage {
    if (matchesInSelection == 0) return 0;
    // Wedstrijden zijn 2x40 = 80 minuten
    final totalPossibleMinutes = matchesInSelection * 80;
    return (minutesPlayed / totalPossibleMinutes) * 100;
  }

  double get averageMinutesPerMatch {
    if (matchesPlayed == 0) return 0;
    return minutesPlayed / matchesPlayed;
  }

  Player() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
}
