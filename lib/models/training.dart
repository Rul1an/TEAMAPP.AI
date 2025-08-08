// Package imports:
import 'package:jo17_tactical_manager/compat/isar_stub.dart';

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

  // Named constructor for JSON deserialization
  Training.fromJson(Map<String, dynamic> json) : this._fromJson(json);

  // Private constructor for actual JSON deserialization
  Training._fromJson(Map<String, dynamic> json) {
    id = json['id'] as String? ?? '';
    date = DateTime.parse(json['date'] as String);
    duration = json['duration'] as int;
    trainingNumber = json['trainingNumber'] as int? ?? 1;
    focus = TrainingFocus.values.byName(json['focus'] as String);
    intensity = TrainingIntensity.values.byName(json['intensity'] as String);
    status = TrainingStatus.values.byName(json['status'] as String);
    location = json['location'] as String?;
    description = json['description'] as String?;
    objectives = json['objectives'] as String?;
    drills = List<String>.from(json['drills'] as List? ?? []);
    presentPlayerIds =
        List<String>.from(json['presentPlayerIds'] as List? ?? []);
    absentPlayerIds = List<String>.from(json['absentPlayerIds'] as List? ?? []);
    injuredPlayerIds =
        List<String>.from(json['injuredPlayerIds'] as List? ?? []);
    latePlayerIds = List<String>.from(json['latePlayerIds'] as List? ?? []);
    coachNotes = json['coachNotes'] as String?;
    performanceNotes = json['performanceNotes'] as String?;
    createdAt = DateTime.parse(json['createdAt'] as String);
    updatedAt = DateTime.parse(json['updatedAt'] as String);
  }

  String id = '';

  late DateTime date;
  late int duration; // in minutes
  int trainingNumber = 1; // Sequential number within the season or cycle

  @Enumerated(EnumType.name)
  late TrainingFocus focus;

  @Enumerated(EnumType.name)
  late TrainingIntensity intensity;

  @Enumerated(EnumType.name)
  late TrainingStatus status;

  String? location;
  String? description;
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

  // JSON serialization
  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}

// Manual toJson implementation to avoid build_runner issues
Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'duration': instance.duration,
      'trainingNumber': instance.trainingNumber,
      'focus': instance.focus.name,
      'intensity': instance.intensity.name,
      'status': instance.status.name,
      'location': instance.location,
      'description': instance.description,
      'objectives': instance.objectives,
      'drills': instance.drills,
      'presentPlayerIds': instance.presentPlayerIds,
      'absentPlayerIds': instance.absentPlayerIds,
      'injuredPlayerIds': instance.injuredPlayerIds,
      'latePlayerIds': instance.latePlayerIds,
      'coachNotes': instance.coachNotes,
      'performanceNotes': instance.performanceNotes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
