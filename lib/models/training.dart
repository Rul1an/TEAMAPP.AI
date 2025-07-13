// Package imports:
import 'package:isar/isar.dart';

// part 'training.g.dart'; // Temporarily commented out

enum TrainingFocus {
  technical,
  tactical,
  physical,
  mental,
  matchPrep;

  String get displayName {
    switch (this) {
      case TrainingFocus.technical:
        return 'Technisch';
      case TrainingFocus.tactical:
        return 'Tactisch';
      case TrainingFocus.physical:
        return 'Fysiek';
      case TrainingFocus.mental:
        return 'Mentaal';
      case TrainingFocus.matchPrep:
        return 'Wedstrijdvoorbereiding';
    }
  }
}

enum TrainingIntensity {
  low,
  medium,
  high,
  recovery;

  String get displayName {
    switch (this) {
      case TrainingIntensity.low:
        return 'Laag';
      case TrainingIntensity.medium:
        return 'Gemiddeld';
      case TrainingIntensity.high:
        return 'Hoog';
      case TrainingIntensity.recovery:
        return 'Herstel';
    }
  }
}

enum TrainingStatus {
  planned,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case TrainingStatus.planned:
        return 'Gepland';
      case TrainingStatus.completed:
        return 'Afgerond';
      case TrainingStatus.cancelled:
        return 'Geannuleerd';
    }
  }
}

class Training {
  Training() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    status = TrainingStatus.planned;
  }
  String id = '';

  late DateTime date;
  late int duration; // in minutes

  @Enumerated(EnumType.name)
  late TrainingFocus focus;

  @Enumerated(EnumType.name)
  late TrainingIntensity intensity;

  @Enumerated(EnumType.name)
  late TrainingStatus status;

  String? location;
  String? description;
  // Session number within the week/season
  int? trainingNumber;
  String? objectives;

  // Drills/exercises
  List<String> drills = [];

  // Attendance
  List<String> presentPlayerIds = [];
  List<String> absentPlayerIds = [];
  List<String> injuredPlayerIds = [];
  List<String> latePlayerIds = [];

  // Notes
  String? coachNotes;
  String? performanceNotes;

  late DateTime createdAt;
  late DateTime updatedAt;
}
