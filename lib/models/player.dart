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
    firstName = (json['firstName'] as String?)?.trim() ?? '';
    lastName = (json['lastName'] as String?)?.trim() ?? '';
    jerseyNumber = _safeParseInt(json['jerseyNumber']);

    // Safe DateTime parsing - handle both String and DateTime types
    final birthDateValue = json['birthDate'];
    birthDate = _safeParseDate(birthDateValue) ?? DateTime.now();

    // Safe enum parsing with fallback
    position = _safeParseEnum<Position>(
          source: json['position'],
          values: Position.values,
          nameSelector: (e) => e.name,
          fallback: Position.midfielder,
        ) ??
        Position.midfielder;
    preferredFoot = _safeParseEnum<PreferredFoot>(
          source: json['preferredFoot'],
          values: PreferredFoot.values,
          nameSelector: (e) => e.name,
          fallback: PreferredFoot.right,
        ) ??
        PreferredFoot.right;

    height = _safeParseDouble(json['height']);
    weight = _safeParseDouble(json['weight']);
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
    createdAt = _safeParseDate(createdAtValue) ?? DateTime.now();

    final updatedAtValue = json['updatedAt'];
    updatedAt = _safeParseDate(updatedAtValue) ?? createdAt;
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

int _safeParseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _safeParseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

DateTime? _safeParseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

TEnum? _safeParseEnum<TEnum>({
  required dynamic source,
  required List<TEnum> values,
  required String Function(TEnum e) nameSelector,
  required TEnum fallback,
}) {
  if (source is String) {
    final normalized = source.trim().toLowerCase();
    for (final v in values) {
      if (nameSelector(v).toLowerCase() == normalized) return v;
    }
  }
  return fallback;
}
