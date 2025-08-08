// Package imports:
import 'package:jo17_tactical_manager/compat/isar_stub.dart';

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

class Player {
  Player() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  // Named constructor for JSON deserialization
  Player.fromJson(Map<String, dynamic> json) : this._fromJson(json);

  // Private constructor for actual JSON deserialization
  Player._fromJson(Map<String, dynamic> json) {
    id = json['id'] as String? ?? '';
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    jerseyNumber = json['jerseyNumber'] as int;

    // Safe DateTime parsing - handle both String and DateTime types
    final birthDateValue = json['birthDate'];
    birthDate = birthDateValue is DateTime
        ? birthDateValue
        : DateTime.parse(birthDateValue as String);

    position = Position.values.byName(json['position'] as String);
    preferredFoot =
        PreferredFoot.values.byName(json['preferredFoot'] as String);
    height = (json['height'] as num).toDouble();
    weight = (json['weight'] as num).toDouble();
    phoneNumber = json['phoneNumber'] as String?;
    email = json['email'] as String?;
    parentContact = json['parentContact'] as String?;
    matchesPlayed = json['matchesPlayed'] as int? ?? 0;
    matchesInSelection = json['matchesInSelection'] as int? ?? 0;
    minutesPlayed = json['minutesPlayed'] as int? ?? 0;
    goals = json['goals'] as int? ?? 0;
    assists = json['assists'] as int? ?? 0;
    yellowCards = json['yellowCards'] as int? ?? 0;
    redCards = json['redCards'] as int? ?? 0;
    trainingsAttended = json['trainingsAttended'] as int? ?? 0;
    trainingsTotal = json['trainingsTotal'] as int? ?? 0;

    // Safe DateTime parsing for createdAt and updatedAt
    final createdAtValue = json['createdAt'];
    createdAt = createdAtValue is DateTime
        ? createdAtValue
        : DateTime.parse(createdAtValue as String);

    final updatedAtValue = json['updatedAt'];
    updatedAt = updatedAtValue is DateTime
        ? updatedAtValue
        : DateTime.parse(updatedAtValue as String);
  }

  String id = '';

  late String firstName;
  late String lastName;
  late int jerseyNumber;
  late DateTime birthDate;

  @Enumerated(EnumType.name)
  late Position position;

  @Enumerated(EnumType.name)
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
    var age = now.year - birthDate.year;
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

  // JSON serialization
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

// Manual toJson implementation to avoid build_runner issues
Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'jerseyNumber': instance.jerseyNumber,
      'birthDate': instance.birthDate.toIso8601String(),
      'position': instance.position.name,
      'preferredFoot': instance.preferredFoot.name,
      'height': instance.height,
      'weight': instance.weight,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'parentContact': instance.parentContact,
      'matchesPlayed': instance.matchesPlayed,
      'matchesInSelection': instance.matchesInSelection,
      'minutesPlayed': instance.minutesPlayed,
      'goals': instance.goals,
      'assists': instance.assists,
      'yellowCards': instance.yellowCards,
      'redCards': instance.redCards,
      'trainingsAttended': instance.trainingsAttended,
      'trainingsTotal': instance.trainingsTotal,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
