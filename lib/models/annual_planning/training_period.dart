import 'dart:convert';
import 'content_distribution.dart';

// part 'training_period.g.dart'; // Disabled for web compatibility

class TrainingPeriod {
  String id = "";

  // Relationship to periodization plan
  late String periodizationPlanId; // Links to PeriodizationPlan

  // Basic information
  late String name; // "Preparation", "Early Competition", "Peak", etc.
  late String description;

  late PeriodType type; // preparation, competition_early, competition_peak, transition

  // Sequence and timing
  late int orderIndex; // sequence in the plan (0, 1, 2, ...)
  late int durationWeeks; // duration of this period in weeks
  DateTime? startDate; // calculated or manually set
  DateTime? endDate; // calculated or manually set

  // Training focus and intensity
  late double intensityPercentage; // 60-95% target intensity

  // Content focus - stored as JSON string
  String? contentFocusJson;

  // Key objectives for this period
  late List<String> keyObjectives; // ["build fitness", "technical skills", "team cohesion"]

  // Load management parameters
  late int sessionsPerWeek; // recommended sessions per week
  late int averageSessionMinutes; // average duration per session
  late int restDaysBetweenSessions; // minimum rest days

  // Status tracking
  late PeriodStatus status; // planned, active, completed, paused

  // Metadata
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Constructor
  TrainingPeriod();

  // Named constructors for common periods
  TrainingPeriod.preparation({
    required this.periodizationPlanId,
    this.orderIndex = 0,
    this.durationWeeks = 8,
  }) {
    name = "Voorbereiding";
    description = "Opbouw van conditie, basis technieken en teamwerk";
    type = PeriodType.preparation;
    intensityPercentage = 65.0;
    keyObjectives = [
      "Conditie opbouwen",
      "Basis technieken verbeteren",
      "Teamwerk ontwikkelen",
      "Blessure preventie"
    ];
    sessionsPerWeek = 3;
    averageSessionMinutes = 90;
    restDaysBetweenSessions = 1;
    status = PeriodStatus.planned;
    contentFocus = ContentDistribution.balanced();
  }

  TrainingPeriod.earlyCompetition({
    required this.periodizationPlanId,
    this.orderIndex = 1,
    this.durationWeeks = 12,
  }) {
    name = "Vroege Competitie";
    description = "Technische verfijning en tactische systemen";
    type = PeriodType.competitionEarly;
    intensityPercentage = 75.0;
    keyObjectives = [
      "Technische skills verfijnen",
      "Tactische systemen inoefenen",
      "Wedstrijdritme opbouwen",
      "Positiespel verbeteren"
    ];
    sessionsPerWeek = 3;
    averageSessionMinutes = 75;
    restDaysBetweenSessions = 1;
    status = PeriodStatus.planned;
    contentFocus = ContentDistribution.tacticalFocus();
  }

  TrainingPeriod.peakCompetition({
    required this.periodizationPlanId,
    this.orderIndex = 2,
    this.durationWeeks = 16,
  }) {
    name = "Piek Competitie";
    description = "Wedstrijdspecifieke training en prestatie optimalisatie";
    type = PeriodType.competitionPeak;
    intensityPercentage = 85.0;
    keyObjectives = [
      "Prestaties optimaliseren",
      "Wedstrijdspecifieke training",
      "Mentale voorbereiding",
      "Tactische flexibiliteit"
    ];
    sessionsPerWeek = 3;
    averageSessionMinutes = 60;
    restDaysBetweenSessions = 2;
    status = PeriodStatus.planned;
    contentFocus = ContentDistribution.matchPrep();
  }

  TrainingPeriod.transition({
    required this.periodizationPlanId,
    this.orderIndex = 3,
    this.durationWeeks = 6,
  }) {
    name = "Overgang";
    description = "Actief herstel en regeneratie";
    type = PeriodType.transition;
    intensityPercentage = 50.0;
    keyObjectives = [
      "Actief herstel",
      "Regeneratie en preventie",
      "Fun-based activiteiten",
      "Individuele ontwikkeling"
    ];
    sessionsPerWeek = 2;
    averageSessionMinutes = 60;
    restDaysBetweenSessions = 2;
    status = PeriodStatus.planned;
    contentFocus = ContentDistribution.recovery();
  }

  // Calculated properties
  DateTime? get calculatedStartDate {
    if (startDate != null) return startDate;
    // If no manual start date, return null for now
    // In a real implementation, this would calculate based on plan start date
    return null;
  }

  DateTime? get calculatedEndDate {
    final start = calculatedStartDate;
    if (start == null) return null;
    return start.add(Duration(days: durationWeeks * 7));
  }

  // Check if this period is currently active
  bool get isActive {
    final now = DateTime.now();
    final start = calculatedStartDate;
    final end = calculatedEndDate;

    if (start == null || end == null) return false;
    return now.isAfter(start) && now.isBefore(end);
  }

  // Weekly training load calculation
  int get weeklyTrainingMinutes => sessionsPerWeek * averageSessionMinutes;

  double get weeklyTrainingHours => weeklyTrainingMinutes / 60.0;

  // ContentDistribution helper methods
  ContentDistribution? get contentFocus {
    if (contentFocusJson == null) return null;
    try {
      return ContentDistribution.fromJson(jsonDecode(contentFocusJson!));
    } catch (e) {
      return null;
    }
  }

  set contentFocus(ContentDistribution? distribution) {
    if (distribution == null) {
      contentFocusJson = null;
    } else {
      contentFocusJson = jsonEncode(distribution.toJson());
    }
  }

  // Progress tracking
  double getProgressPercentage() {
    final start = calculatedStartDate;
    final end = calculatedEndDate;

    if (start == null || end == null) return 0.0;

    final now = DateTime.now();
    final totalDuration = end.difference(start).inDays;
    final elapsed = now.difference(start).inDays;

    return (elapsed / totalDuration * 100).clamp(0.0, 100.0);
  }

  // Get recommended content distribution based on period type
  static ContentDistribution getRecommendedContent(PeriodType type) {
    switch (type) {
      case PeriodType.preparation:
        return ContentDistribution.balanced();
      case PeriodType.competitionEarly:
        return ContentDistribution.tacticalFocus();
      case PeriodType.competitionPeak:
        return ContentDistribution.matchPrep();
      case PeriodType.competitionMaintenance:
        return ContentDistribution.balanced();
      case PeriodType.transition:
        return ContentDistribution.recovery();
      case PeriodType.tournamentPrep:
        return ContentDistribution.matchPrep();
    }
  }

  // Get recommended intensity based on period type
  static double getRecommendedIntensity(PeriodType type) {
    switch (type) {
      case PeriodType.preparation:
        return 65.0;
      case PeriodType.competitionEarly:
        return 75.0;
      case PeriodType.competitionPeak:
        return 85.0;
      case PeriodType.competitionMaintenance:
        return 70.0;
      case PeriodType.transition:
        return 50.0;
      case PeriodType.tournamentPrep:
        return 90.0;
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'periodizationPlanId': periodizationPlanId,
    'name': name,
    'description': description,
    'type': type.name,
    'orderIndex': orderIndex,
    'durationWeeks': durationWeeks,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'intensityPercentage': intensityPercentage,
    'contentFocusJson': contentFocusJson,
    'keyObjectives': keyObjectives,
    'sessionsPerWeek': sessionsPerWeek,
    'averageSessionMinutes': averageSessionMinutes,
    'restDaysBetweenSessions': restDaysBetweenSessions,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory TrainingPeriod.fromJson(Map<String, dynamic> json) {
    final period = TrainingPeriod();
    period.id = json['id'] ?? "";
    period.periodizationPlanId = json['periodizationPlanId'] ?? '';
    period.name = json['name'] ?? '';
    period.description = json['description'] ?? '';
    period.type = PeriodType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => PeriodType.preparation,
    );
    period.orderIndex = json['orderIndex'] ?? 0;
    period.durationWeeks = json['durationWeeks'] ?? 4;
    period.startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : null;
    period.endDate = json['endDate'] != null
        ? DateTime.parse(json['endDate'])
        : null;
        period.intensityPercentage = json['intensityPercentage']?.toDouble() ?? 70.0;
    period.contentFocusJson = json['contentFocusJson'];
    period.keyObjectives = List<String>.from(json['keyObjectives'] ?? []);
    period.sessionsPerWeek = json['sessionsPerWeek'] ?? 3;
    period.averageSessionMinutes = json['averageSessionMinutes'] ?? 75;
    period.restDaysBetweenSessions = json['restDaysBetweenSessions'] ?? 1;
    period.status = PeriodStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => PeriodStatus.planned,
    );
    period.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    period.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return period;
  }

  // Copy with method for updates
  TrainingPeriod copyWith({
    String? periodizationPlanId,
    String? name,
    String? description,
    PeriodType? type,
    int? orderIndex,
    int? durationWeeks,
    DateTime? startDate,
    DateTime? endDate,
    double? intensityPercentage,
    ContentDistribution? contentFocus,
    List<String>? keyObjectives,
    int? sessionsPerWeek,
    int? averageSessionMinutes,
    int? restDaysBetweenSessions,
    PeriodStatus? status,
  }) {
    final copy = TrainingPeriod();
    copy.id = id;
    copy.periodizationPlanId = periodizationPlanId ?? this.periodizationPlanId;
    copy.name = name ?? this.name;
    copy.description = description ?? this.description;
    copy.type = type ?? this.type;
    copy.orderIndex = orderIndex ?? this.orderIndex;
    copy.durationWeeks = durationWeeks ?? this.durationWeeks;
    copy.startDate = startDate ?? this.startDate;
    copy.endDate = endDate ?? this.endDate;
    copy.intensityPercentage = intensityPercentage ?? this.intensityPercentage;
    copy.contentFocusJson = contentFocusJson;
    if (contentFocus != null) copy.contentFocus = contentFocus;
    copy.keyObjectives = keyObjectives ?? List.from(this.keyObjectives);
    copy.sessionsPerWeek = sessionsPerWeek ?? this.sessionsPerWeek;
    copy.averageSessionMinutes = averageSessionMinutes ?? this.averageSessionMinutes;
    copy.restDaysBetweenSessions = restDaysBetweenSessions ?? this.restDaysBetweenSessions;
    copy.status = status ?? this.status;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  @override
  String toString() {
    return 'TrainingPeriod(id: $id, name: $name, type: ${type.name}, '
           'order: $orderIndex, weeks: $durationWeeks, intensity: $intensityPercentage%, '
           'status: ${status.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrainingPeriod &&
        other.periodizationPlanId == periodizationPlanId &&
        other.name == name &&
        other.type == type &&
        other.orderIndex == orderIndex &&
        other.durationWeeks == durationWeeks;
  }

  @override
  int get hashCode {
    return periodizationPlanId.hashCode ^
           name.hashCode ^
           type.hashCode ^
           orderIndex.hashCode ^
           durationWeeks.hashCode;
  }
}

// Enums for training periods
enum PeriodType {
  preparation,
  competitionEarly,
  competitionPeak,
  competitionMaintenance,
  transition,
  tournamentPrep,
}

enum PeriodStatus {
  planned,
  active,
  completed,
  paused,
}

// Extensions for better display names
extension PeriodTypeExtension on PeriodType {
  String get displayName {
    switch (this) {
      case PeriodType.preparation:
        return 'Voorbereiding';
      case PeriodType.competitionEarly:
        return 'Vroege Competitie';
      case PeriodType.competitionPeak:
        return 'Piek Competitie';
      case PeriodType.competitionMaintenance:
        return 'Competitie Onderhoud';
      case PeriodType.transition:
        return 'Overgang';
      case PeriodType.tournamentPrep:
        return 'Toernooi Voorbereiding';
    }
  }

  String get description {
    switch (this) {
      case PeriodType.preparation:
        return 'Conditie opbouw, basis technieken en teamwerk';
      case PeriodType.competitionEarly:
        return 'Technische verfijning en tactische systemen';
      case PeriodType.competitionPeak:
        return 'Wedstrijdspecifieke training en prestatie optimalisatie';
      case PeriodType.competitionMaintenance:
        return 'Prestatie niveau behouden tijdens competitie';
      case PeriodType.transition:
        return 'Actief herstel en regeneratie';
      case PeriodType.tournamentPrep:
        return 'Specifieke voorbereiding op toernooien';
    }
  }

  String get shortName {
    switch (this) {
      case PeriodType.preparation:
        return 'Prep';
      case PeriodType.competitionEarly:
        return 'Early';
      case PeriodType.competitionPeak:
        return 'Peak';
      case PeriodType.competitionMaintenance:
        return 'Maint';
      case PeriodType.transition:
        return 'Trans';
      case PeriodType.tournamentPrep:
        return 'Tourn';
    }
  }
}

extension PeriodStatusExtension on PeriodStatus {
  String get displayName {
    switch (this) {
      case PeriodStatus.planned:
        return 'Gepland';
      case PeriodStatus.active:
        return 'Actief';
      case PeriodStatus.completed:
        return 'Voltooid';
      case PeriodStatus.paused:
        return 'Gepauzeerd';
    }
  }
}
