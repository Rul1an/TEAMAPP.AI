import 'package:isar/isar.dart';

// part 'content_distribution.g.dart'; // Disabled for web compatibility

// @Collection() // Disabled for web compatibility
class ContentDistribution {
  Id id = Isar.autoIncrement;

    // Training content percentages (must total 100%)
  late double technicalPercentage; // 0-100% (ball skills, passing, shooting)
  late double tacticalPercentage; // 0-100% (team shape, strategy, positioning)
  late double physicalPercentage; // 0-100% (fitness, strength, speed, endurance)
  late double mentalPercentage; // 0-100% (decision making, pressure, concentration)
  late double gamePlayPercentage; // 0-100% (small-sided games, scrimmages, match simulation)

  // Metadata
  String? description; // Optional description of this distribution
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Computed properties
  bool get isValid =>
    (technicalPercentage + tacticalPercentage + physicalPercentage +
     mentalPercentage + gamePlayPercentage) == 100.0;

  double get totalPercentage =>
    technicalPercentage + tacticalPercentage + physicalPercentage +
    mentalPercentage + gamePlayPercentage;

  // Constructor
  ContentDistribution();

  // Named constructors for common distributions
  ContentDistribution.balanced() {
    technicalPercentage = 25.0;
    tacticalPercentage = 25.0;
    physicalPercentage = 20.0;
    mentalPercentage = 10.0;
    gamePlayPercentage = 20.0;
    description = "Balanced training distribution";
  }

  ContentDistribution.technicalFocus() {
    technicalPercentage = 40.0;
    tacticalPercentage = 20.0;
    physicalPercentage = 15.0;
    mentalPercentage = 10.0;
    gamePlayPercentage = 15.0;
    description = "Technical skill focus";
  }

  ContentDistribution.tacticalFocus() {
    technicalPercentage = 20.0;
    tacticalPercentage = 40.0;
    physicalPercentage = 15.0;
    mentalPercentage = 15.0;
    gamePlayPercentage = 10.0;
    description = "Tactical development focus";
  }

  ContentDistribution.matchPrep() {
    technicalPercentage = 15.0;
    tacticalPercentage = 30.0;
    physicalPercentage = 10.0;
    mentalPercentage = 15.0;
    gamePlayPercentage = 30.0;
    description = "Match preparation focus";
  }

  ContentDistribution.recovery() {
    technicalPercentage = 30.0;
    tacticalPercentage = 10.0;
    physicalPercentage = 20.0;
    mentalPercentage = 20.0;
    gamePlayPercentage = 20.0;
    description = "Recovery and light training";
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'technicalPercentage': technicalPercentage,
    'tacticalPercentage': tacticalPercentage,
    'physicalPercentage': physicalPercentage,
    'mentalPercentage': mentalPercentage,
    'gamePlayPercentage': gamePlayPercentage,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ContentDistribution.fromJson(Map<String, dynamic> json) {
    final distribution = ContentDistribution();
    distribution.id = json['id'] ?? Isar.autoIncrement;
    distribution.technicalPercentage = json['technicalPercentage']?.toDouble() ?? 0.0;
    distribution.tacticalPercentage = json['tacticalPercentage']?.toDouble() ?? 0.0;
    distribution.physicalPercentage = json['physicalPercentage']?.toDouble() ?? 0.0;
    distribution.mentalPercentage = json['mentalPercentage']?.toDouble() ?? 0.0;
    distribution.gamePlayPercentage = json['gamePlayPercentage']?.toDouble() ?? 0.0;
    distribution.description = json['description'];
    distribution.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    distribution.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return distribution;
  }

  // Copy with method for updates
  ContentDistribution copyWith({
    double? technicalPercentage,
    double? tacticalPercentage,
    double? physicalPercentage,
    double? mentalPercentage,
    double? gamePlayPercentage,
    String? description,
  }) {
    final copy = ContentDistribution();
    copy.id = id;
    copy.technicalPercentage = technicalPercentage ?? this.technicalPercentage;
    copy.tacticalPercentage = tacticalPercentage ?? this.tacticalPercentage;
    copy.physicalPercentage = physicalPercentage ?? this.physicalPercentage;
    copy.mentalPercentage = mentalPercentage ?? this.mentalPercentage;
    copy.gamePlayPercentage = gamePlayPercentage ?? this.gamePlayPercentage;
    copy.description = description ?? this.description;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  @override
  String toString() {
    return 'ContentDistribution(id: $id, tech: $technicalPercentage%, '
           'tact: $tacticalPercentage%, phys: $physicalPercentage%, '
           'ment: $mentalPercentage%, game: $gamePlayPercentage%, '
           'valid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentDistribution &&
        other.technicalPercentage == technicalPercentage &&
        other.tacticalPercentage == tacticalPercentage &&
        other.physicalPercentage == physicalPercentage &&
        other.mentalPercentage == mentalPercentage &&
        other.gamePlayPercentage == gamePlayPercentage;
  }

  @override
  int get hashCode {
    return technicalPercentage.hashCode ^
           tacticalPercentage.hashCode ^
           physicalPercentage.hashCode ^
           mentalPercentage.hashCode ^
           gamePlayPercentage.hashCode;
  }
}
