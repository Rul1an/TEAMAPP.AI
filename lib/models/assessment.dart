import 'package:isar/isar.dart';

// part 'assessment.g.dart'; // Temporarily commented out

enum AssessmentType {
  monthly,
  quarterly,
  biannual;

  String get displayName {
    switch (this) {
      case AssessmentType.monthly:
        return 'Maandelijks';
      case AssessmentType.quarterly:
        return 'Kwartaal';
      case AssessmentType.biannual:
        return 'Halfjaarlijks';
    }
  }
}

enum SkillCategory {
  technical,
  tactical,
  physical,
  mental;

  String get displayName {
    switch (this) {
      case SkillCategory.technical:
        return 'Technisch';
      case SkillCategory.tactical:
        return 'Tactisch';
      case SkillCategory.physical:
        return 'Fysiek';
      case SkillCategory.mental:
        return 'Mentaal';
    }
  }
}

@collection
class PlayerAssessment {
  Id id = Isar.autoIncrement;

  late String playerId;
  late DateTime assessmentDate;

  @enumerated
  late AssessmentType type;

  // Technical Skills (1-5 rating)
  late int ballControl = 3;
  late int passing = 3;
  late int shooting = 3;
  late int dribbling = 3;
  late int defending = 3;

  // Tactical Skills (1-5 rating)
  late int positioning = 3;
  late int gameReading = 3;
  late int decisionMaking = 3;
  late int communication = 3;
  late int teamwork = 3;

  // Physical Attributes (1-5 rating)
  late int speed = 3;
  late int stamina = 3;
  late int strength = 3;
  late int agility = 3;
  late int coordination = 3;

  // Mental Attributes (1-5 rating)
  late int confidence = 3;
  late int concentration = 3;
  late int leadership = 3;
  late int coachability = 3;
  late int motivation = 3;

  // Text fields
  String? strengths;
  String? areasForImprovement;
  String? developmentGoals;
  String? coachNotes;

  late String assessorId; // Coach who did the assessment
  late DateTime createdAt;
  late DateTime updatedAt;

  PlayerAssessment() {
    assessmentDate = DateTime.now();
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  // Helper methods
  double get technicalAverage => (ballControl + passing + shooting + dribbling + defending) / 5.0;
  double get tacticalAverage => (positioning + gameReading + decisionMaking + communication + teamwork) / 5.0;
  double get physicalAverage => (speed + stamina + strength + agility + coordination) / 5.0;
  double get mentalAverage => (confidence + concentration + leadership + coachability + motivation) / 5.0;
  double get overallAverage => (technicalAverage + tacticalAverage + physicalAverage + mentalAverage) / 4.0;

  @ignore
  Map<String, int> get technicalSkills => {
    'Balbeheersing': ballControl,
    'Passen': passing,
    'Schieten': shooting,
    'Dribbelen': dribbling,
    'Verdedigen': defending,
  };

  @ignore
  Map<String, int> get tacticalSkills => {
    'Positiespel': positioning,
    'Spellezing': gameReading,
    'Besluitvorming': decisionMaking,
    'Communicatie': communication,
    'Teamwork': teamwork,
  };

  @ignore
  Map<String, int> get physicalAttributes => {
    'Snelheid': speed,
    'Conditie': stamina,
    'Kracht': strength,
    'Beweeglijkheid': agility,
    'Coördinatie': coordination,
  };

  @ignore
  Map<String, int> get mentalAttributes => {
    'Zelfvertrouwen': confidence,
    'Concentratie': concentration,
    'Leiderschap': leadership,
    'Coachbaarheid': coachability,
    'Motivatie': motivation,
  };
}

@collection
class DevelopmentGoal {
  Id id = Isar.autoIncrement;

  late String playerId;
  late String title;
  late String description;

  @enumerated
  late SkillCategory category;

  late int targetRating; // Target score (1-5)
  late int currentRating; // Current score (1-5)

  late DateTime targetDate;
  late bool isCompleted = false;
  late DateTime? completedDate;

  String? progressNotes;
  late String createdBy; // Coach ID

  late DateTime createdAt;
  late DateTime updatedAt;

  DevelopmentGoal() {
    targetDate = DateTime.now().add(const Duration(days: 90)); // 3 months default
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  int get progressPercentage {
    if (targetRating <= currentRating) return 100;
    return ((currentRating / targetRating) * 100).round();
  }

  bool get isOverdue => DateTime.now().isAfter(targetDate) && !isCompleted;
}
