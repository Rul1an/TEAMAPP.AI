import 'package:isar/isar.dart';
import 'periodization_plan.dart';

// part 'season_plan.g.dart'; // Disabled for web compatibility

// @Collection() // Disabled for web compatibility
class SeasonPlan {
  Id id = Isar.autoIncrement;

  // Basic season information
  late String name; // "JO17-1 Seizoen 2024-2025"
  late String description;
  late String season; // "2024-2025"

  @Enumerated(EnumType.name)
  late AgeGroup ageGroup; // U17, U16, etc.

  late String teamName; // "JO17-1", "JO16-2"

  // Season timing
  late DateTime seasonStartDate; // Start of season (e.g., August 15)
  late DateTime seasonEndDate; // End of season (e.g., June 15)

  // Holiday/break periods
  late List<String> holidayPeriods; // JSON string list of holiday periods

  // Linked periodization plan
  late String periodizationPlanId; // Reference to PeriodizationPlan

  // Season structure
  late int totalWeeks; // Total weeks in season
  late int trainingWeeks; // Actual training weeks (excluding holidays)
  late int competitionWeeks; // Weeks with matches

  // Competition information
  late String primaryCompetition; // "Hoofdklasse B", "1e Klasse A"
  late List<String> additionalCompetitions; // Cup tournaments, friendlies

  // Key season dates
  DateTime? firstMatchDate;
  DateTime? lastMatchDate;
  DateTime? midSeasonBreakStart;
  DateTime? midSeasonBreakEnd;

  // Season goals and objectives
  late List<String> seasonObjectives; // ["Top 3 finish", "Youth development", "Style of play"]
  late List<String> keyPerformanceIndicators; // ["Goals scored", "Clean sheets", "Pass accuracy"]

  // Template and tracking
  late bool isTemplate; // true for reusable season templates

  @Enumerated(EnumType.name)
  late SeasonStatus status; // draft, active, completed, archived

  // Progress tracking
  late int currentWeek; // Current week number in season (1-based)
  late double progressPercentage; // 0-100% season completion

  // Metadata
  String? createdBy; // User who created this plan
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Constructor
  SeasonPlan();

  // Named constructor for JO17 Dutch season
  SeasonPlan.jo17DutchSeason({
    required this.teamName,
    required this.season,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    name = "$teamName Seizoen $season";
    description = "Nederlands voetbalseizoen planning voor $teamName volgens KNVB richtlijnen";
    ageGroup = AgeGroup.u17;

    // Default Dutch season dates (August to June)
    seasonStartDate = startDate ?? DateTime(DateTime.now().year, 8, 15);
    seasonEndDate = endDate ?? DateTime(DateTime.now().year + 1, 6, 15);

    // Calculate weeks
    totalWeeks = seasonEndDate.difference(seasonStartDate).inDays ~/ 7;
    trainingWeeks = totalWeeks - 12; // Subtract holiday weeks
    competitionWeeks = 32; // Standard Dutch season

    // Default Dutch holiday periods
    holidayPeriods = [
      "Herfstvakantie (Week 43)",
      "Kerstvakantie (Week 52-2)",
      "Voorjaarsvakantie (Week 8)",
      "Meivakantie (Week 18)",
      "Zomervakantie (Week 27-34)"
    ];

    primaryCompetition = "Jeugdcompetitie";
    additionalCompetitions = ["Beker", "Toernooien", "Oefenwedstrijden"];

    // Season objectives
    seasonObjectives = [
      "Technische ontwikkeling spelers",
      "Tactisch begrip verbeteren",
      "Wedstrijdervaring opdoen",
      "Teamsamenhang versteken"
    ];

    keyPerformanceIndicators = [
      "Individuele spelerontwikkeling",
      "Team prestaties",
      "Blessure preventie",
      "Speeltijd verdeling"
    ];

    isTemplate = false;
    status = SeasonStatus.draft;
    currentWeek = 1;
    progressPercentage = 0.0;
  }

  // Standard template constructor
  SeasonPlan.standardTemplate({
    required this.ageGroup,
    required this.name,
  }) {
    description = "Standard seizoen template voor \\${ageGroup.dutchName}";
    season = "Template";
    teamName = "${ageGroup.dutchName} Template";

    // Template defaults
    seasonStartDate = DateTime(2024, 8, 15);
    seasonEndDate = DateTime(2025, 6, 15);
    totalWeeks = 43;
    trainingWeeks = 36;
    competitionWeeks = 32;

    holidayPeriods = [
      "Herfstvakantie",
      "Kerstvakantie",
      "Voorjaarsvakantie",
      "Meivakantie"
    ];

    primaryCompetition = "Hoofdcompetitie";
    additionalCompetitions = ["Beker", "Toernooien"];

    seasonObjectives = [
      "Spelerontwikkeling",
      "Team prestaties",
      "Positief voetbal"
    ];

    keyPerformanceIndicators = [
      "Technische vooruitgang",
      "Tactisch begrip",
      "Plezier in het spel"
    ];

    isTemplate = true;
    status = SeasonStatus.draft;
    currentWeek = 1;
    progressPercentage = 0.0;
  }

  // Calculated properties
  DateTime get currentDate {
    return seasonStartDate.add(Duration(days: (currentWeek - 1) * 7));
  }

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(seasonStartDate) && now.isBefore(seasonEndDate);
  }

  bool get isCompleted {
    return status == SeasonStatus.completed || DateTime.now().isAfter(seasonEndDate);
  }

  int get remainingWeeks {
    final now = DateTime.now();
    if (now.isAfter(seasonEndDate)) return 0;
    return seasonEndDate.difference(now).inDays ~/ 7;
  }

  double get seasonProgressByDate {
    final now = DateTime.now();
    if (now.isBefore(seasonStartDate)) return 0.0;
    if (now.isAfter(seasonEndDate)) return 100.0;

    final totalDays = seasonEndDate.difference(seasonStartDate).inDays;
    final elapsedDays = now.difference(seasonStartDate).inDays;

    return (elapsedDays / totalDays * 100).clamp(0.0, 100.0);
  }

  // Season phase detection
  SeasonPhase getCurrentPhase() {
    final progress = seasonProgressByDate;

    if (progress < 20) return SeasonPhase.preseason;
    if (progress < 40) return SeasonPhase.earlySeason;
    if (progress < 70) return SeasonPhase.midSeason;
    if (progress < 90) return SeasonPhase.lateSeason;
    return SeasonPhase.postSeason;
  }

  // Holiday checking
  bool isCurrentlyInHoliday() {
    // In a real implementation, this would check against specific holiday dates
    // For now, return false as a placeholder
    return false;
  }

  List<String> getHolidaysInPeriod(DateTime start, DateTime end) {
    // In a real implementation, this would return holidays within the date range
    // For now, return empty list as a placeholder
    return [];
  }

  // Season statistics
  Map<String, dynamic> getSeasonStatistics() {
    return {
      'totalWeeks': totalWeeks,
      'completedWeeks': currentWeek - 1,
      'remainingWeeks': remainingWeeks,
      'progressPercentage': progressPercentage,
      'currentPhase': getCurrentPhase().displayName,
      'isActive': isActive,
      'isCompleted': isCompleted,
    };
  }

  // Update progress
  void updateProgress() {
    progressPercentage = seasonProgressByDate;

    // Update current week based on date
    final now = DateTime.now();
    if (now.isAfter(seasonStartDate) && now.isBefore(seasonEndDate)) {
      currentWeek = (now.difference(seasonStartDate).inDays ~/ 7) + 1;
    }

    // Auto-update status
    if (isCompleted && status != SeasonStatus.completed) {
      status = SeasonStatus.completed;
    } else if (isActive && status == SeasonStatus.draft) {
      status = SeasonStatus.active;
    }

    updatedAt = DateTime.now();
  }

  // Validation
  bool isValid() {
    return name.isNotEmpty &&
           season.isNotEmpty &&
           teamName.isNotEmpty &&
           seasonStartDate.isBefore(seasonEndDate) &&
           totalWeeks > 0 &&
           currentWeek >= 1 &&
           progressPercentage >= 0.0 && progressPercentage <= 100.0;
  }

  List<String> getValidationErrors() {
    List<String> errors = [];

    if (name.isEmpty) errors.add("Season name is required");
    if (season.isEmpty) errors.add("Season year is required");
    if (teamName.isEmpty) errors.add("Team name is required");
    if (!seasonStartDate.isBefore(seasonEndDate)) {
      errors.add("Start date must be before end date");
    }
    if (totalWeeks <= 0) errors.add("Total weeks must be positive");
    if (currentWeek < 1) errors.add("Current week must be at least 1");
    if (progressPercentage < 0.0 || progressPercentage > 100.0) {
      errors.add("Progress percentage must be between 0 and 100");
    }

    return errors;
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'season': season,
    'ageGroup': ageGroup.name,
    'teamName': teamName,
    'seasonStartDate': seasonStartDate.toIso8601String(),
    'seasonEndDate': seasonEndDate.toIso8601String(),
    'holidayPeriods': holidayPeriods,
    'periodizationPlanId': periodizationPlanId,
    'totalWeeks': totalWeeks,
    'trainingWeeks': trainingWeeks,
    'competitionWeeks': competitionWeeks,
    'primaryCompetition': primaryCompetition,
    'additionalCompetitions': additionalCompetitions,
    'firstMatchDate': firstMatchDate?.toIso8601String(),
    'lastMatchDate': lastMatchDate?.toIso8601String(),
    'midSeasonBreakStart': midSeasonBreakStart?.toIso8601String(),
    'midSeasonBreakEnd': midSeasonBreakEnd?.toIso8601String(),
    'seasonObjectives': seasonObjectives,
    'keyPerformanceIndicators': keyPerformanceIndicators,
    'isTemplate': isTemplate,
    'status': status.name,
    'currentWeek': currentWeek,
    'progressPercentage': progressPercentage,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory SeasonPlan.fromJson(Map<String, dynamic> json) {
    final plan = SeasonPlan();
    plan.id = json['id'] ?? Isar.autoIncrement;
    plan.name = json['name'] ?? '';
    plan.description = json['description'] ?? '';
    plan.season = json['season'] ?? '';
    plan.ageGroup = AgeGroup.values.firstWhere(
      (e) => e.name == json['ageGroup'],
      orElse: () => AgeGroup.u17,
    );
    plan.teamName = json['teamName'] ?? '';
    plan.seasonStartDate = json['seasonStartDate'] != null
        ? DateTime.parse(json['seasonStartDate'])
        : DateTime.now();
    plan.seasonEndDate = json['seasonEndDate'] != null
        ? DateTime.parse(json['seasonEndDate'])
        : DateTime.now().add(const Duration(days: 300));
    plan.holidayPeriods = List<String>.from(json['holidayPeriods'] ?? []);
    plan.periodizationPlanId = json['periodizationPlanId'] ?? '';
    plan.totalWeeks = json['totalWeeks'] ?? 40;
    plan.trainingWeeks = json['trainingWeeks'] ?? 36;
    plan.competitionWeeks = json['competitionWeeks'] ?? 32;
    plan.primaryCompetition = json['primaryCompetition'] ?? '';
    plan.additionalCompetitions = List<String>.from(json['additionalCompetitions'] ?? []);
    plan.firstMatchDate = json['firstMatchDate'] != null
        ? DateTime.parse(json['firstMatchDate'])
        : null;
    plan.lastMatchDate = json['lastMatchDate'] != null
        ? DateTime.parse(json['lastMatchDate'])
        : null;
    plan.midSeasonBreakStart = json['midSeasonBreakStart'] != null
        ? DateTime.parse(json['midSeasonBreakStart'])
        : null;
    plan.midSeasonBreakEnd = json['midSeasonBreakEnd'] != null
        ? DateTime.parse(json['midSeasonBreakEnd'])
        : null;
    plan.seasonObjectives = List<String>.from(json['seasonObjectives'] ?? []);
    plan.keyPerformanceIndicators = List<String>.from(json['keyPerformanceIndicators'] ?? []);
    plan.isTemplate = json['isTemplate'] ?? false;
    plan.status = SeasonStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => SeasonStatus.draft,
    );
    plan.currentWeek = json['currentWeek'] ?? 1;
    plan.progressPercentage = json['progressPercentage']?.toDouble() ?? 0.0;
    plan.createdBy = json['createdBy'];
    plan.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    plan.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return plan;
  }

  // Copy with method for updates
  SeasonPlan copyWith({
    String? name,
    String? description,
    String? season,
    AgeGroup? ageGroup,
    String? teamName,
    DateTime? seasonStartDate,
    DateTime? seasonEndDate,
    List<String>? holidayPeriods,
    String? periodizationPlanId,
    int? totalWeeks,
    int? trainingWeeks,
    int? competitionWeeks,
    String? primaryCompetition,
    List<String>? additionalCompetitions,
    DateTime? firstMatchDate,
    DateTime? lastMatchDate,
    DateTime? midSeasonBreakStart,
    DateTime? midSeasonBreakEnd,
    List<String>? seasonObjectives,
    List<String>? keyPerformanceIndicators,
    bool? isTemplate,
    SeasonStatus? status,
    int? currentWeek,
    double? progressPercentage,
    String? createdBy,
  }) {
    final copy = SeasonPlan();
    copy.id = id;
    copy.name = name ?? this.name;
    copy.description = description ?? this.description;
    copy.season = season ?? this.season;
    copy.ageGroup = ageGroup ?? this.ageGroup;
    copy.teamName = teamName ?? this.teamName;
    copy.seasonStartDate = seasonStartDate ?? this.seasonStartDate;
    copy.seasonEndDate = seasonEndDate ?? this.seasonEndDate;
    copy.holidayPeriods = holidayPeriods ?? List.from(this.holidayPeriods);
    copy.periodizationPlanId = periodizationPlanId ?? this.periodizationPlanId;
    copy.totalWeeks = totalWeeks ?? this.totalWeeks;
    copy.trainingWeeks = trainingWeeks ?? this.trainingWeeks;
    copy.competitionWeeks = competitionWeeks ?? this.competitionWeeks;
    copy.primaryCompetition = primaryCompetition ?? this.primaryCompetition;
    copy.additionalCompetitions = additionalCompetitions ?? List.from(this.additionalCompetitions);
    copy.firstMatchDate = firstMatchDate ?? this.firstMatchDate;
    copy.lastMatchDate = lastMatchDate ?? this.lastMatchDate;
    copy.midSeasonBreakStart = midSeasonBreakStart ?? this.midSeasonBreakStart;
    copy.midSeasonBreakEnd = midSeasonBreakEnd ?? this.midSeasonBreakEnd;
    copy.seasonObjectives = seasonObjectives ?? List.from(this.seasonObjectives);
    copy.keyPerformanceIndicators = keyPerformanceIndicators ?? List.from(this.keyPerformanceIndicators);
    copy.isTemplate = isTemplate ?? this.isTemplate;
    copy.status = status ?? this.status;
    copy.currentWeek = currentWeek ?? this.currentWeek;
    copy.progressPercentage = progressPercentage ?? this.progressPercentage;
    copy.createdBy = createdBy ?? this.createdBy;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  @override
  String toString() {
    return 'SeasonPlan(id: $id, name: $name, season: $season, '
           'team: $teamName, weeks: $totalWeeks, status: ${status.name}, '
           'progress: ${progressPercentage.toStringAsFixed(1)}%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SeasonPlan &&
        other.name == name &&
        other.season == season &&
        other.teamName == teamName &&
        other.ageGroup == ageGroup;
  }

  @override
  int get hashCode {
    return name.hashCode ^
           season.hashCode ^
           teamName.hashCode ^
           ageGroup.hashCode;
  }
}

// Enums for season management
enum SeasonStatus {
  draft,
  active,
  completed,
  archived,
}

enum SeasonPhase {
  preseason,
  earlySeason,
  midSeason,
  lateSeason,
  postSeason,
}

// Extensions for better display names
extension SeasonStatusExtension on SeasonStatus {
  String get displayName {
    switch (this) {
      case SeasonStatus.draft:
        return 'Concept';
      case SeasonStatus.active:
        return 'Actief';
      case SeasonStatus.completed:
        return 'Voltooid';
      case SeasonStatus.archived:
        return 'Gearchiveerd';
    }
  }
}

extension SeasonPhaseExtension on SeasonPhase {
  String get displayName {
    switch (this) {
      case SeasonPhase.preseason:
        return 'Voorbereiding';
      case SeasonPhase.earlySeason:
        return 'Vroeg Seizoen';
      case SeasonPhase.midSeason:
        return 'Midden Seizoen';
      case SeasonPhase.lateSeason:
        return 'Laat Seizoen';
      case SeasonPhase.postSeason:
        return 'Na Seizoen';
    }
  }

  String get description {
    switch (this) {
      case SeasonPhase.preseason:
        return 'Voorbereiding en conditie opbouw';
      case SeasonPhase.earlySeason:
        return 'Begin competitie, systemen inslijen';
      case SeasonPhase.midSeason:
        return 'Hoogtepunt seizoen, wedstrijdritme';
      case SeasonPhase.lateSeason:
        return 'Eindspurt, prestaties leveren';
      case SeasonPhase.postSeason:
        return 'Evaluatie en herstel';
    }
  }
}
