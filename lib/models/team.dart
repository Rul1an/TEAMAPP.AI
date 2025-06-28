import 'package:isar/isar.dart';

// part 'team.g.dart'; // Temporarily commented out

enum Formation {
  fourThreeThree,
  fourFourTwo,
  threeForThree,
  fourTwoThreeOne,
  fourFourTwoDiamond,
  fourThreeThreeDefensive;

  String get displayName {
    switch (this) {
      case Formation.fourThreeThree:
        return '4-3-3';
      case Formation.fourFourTwo:
        return '4-4-2';
      case Formation.threeForThree:
        return '3-4-3';
      case Formation.fourTwoThreeOne:
        return '4-2-3-1';
      case Formation.fourFourTwoDiamond:
        return '4-4-2 (Ruit)';
      case Formation.fourThreeThreeDefensive:
        return '4-3-3 (Verdedigend)';
    }
  }
}

class Team {
  Team() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }
  String id = '';

  late String name;
  late String ageGroup;
  late String season;

  @Enumerated(EnumType.name)
  late Formation preferredFormation;

  String? coachName;
  String? assistantCoachName;

  // Team colors
  String? primaryColor;
  String? secondaryColor;

  // Statistics
  late int matchesPlayed = 0;
  late int wins = 0;
  late int draws = 0;
  late int losses = 0;
  late int goalsFor = 0;
  late int goalsAgainst = 0;

  late DateTime createdAt;
  late DateTime updatedAt;

  // Computed properties
  int get points => (wins * 3) + draws;

  int get goalDifference => goalsFor - goalsAgainst;

  double get winPercentage {
    if (matchesPlayed == 0) return 0;
    return (wins / matchesPlayed) * 100;
  }
}
