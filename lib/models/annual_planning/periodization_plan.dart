// Project imports:
import 'content_distribution.dart';
import 'training_period.dart';

// part 'periodization_plan.g.dart'; // Disabled for web compatibility

class PeriodizationPlan {
  // Constructor
  PeriodizationPlan();

  // Named constructors for system templates
  PeriodizationPlan.knvbYouthU17() {
    name = 'KNVB Youth Development Model U17';
    description =
        'Nederlandse voetbalbond standaard periodisering voor JO17 teams. '
        'Focus op technische ontwikkeling, tactisch begrip en competitieve prestaties.';
    modelType = PeriodizationModel.knvbYouth;
    targetAgeGroup = AgeGroup.u17;
    totalDurationWeeks = 42; // Full season
    numberOfPeriods = 4;
    isTemplate = true;
    isDefault = true;
    createdBy = 'KNVB Standards';
  }

  PeriodizationPlan.traditionalLinear() {
    name = 'Traditional Linear Periodization';
    description =
        'Klassieke 3-fase periodisering: voorbereiding → competitie → overgang. '
        'Geschikt voor teams met duidelijke seizoenstructuur.';
    modelType = PeriodizationModel.linear;
    targetAgeGroup = AgeGroup.u17;
    totalDurationWeeks = 36;
    numberOfPeriods = 3;
    isTemplate = true;
    isDefault = true;
    createdBy = 'System';
  }

  PeriodizationPlan.blockPeriodization() {
    name = 'Block Periodization Model';
    description = 'Moderne blok periodisering met 4-weken cycli. '
        'Intense focus op specifieke vaardigheden per blok.';
    modelType = PeriodizationModel.block;
    targetAgeGroup = AgeGroup.u17;
    totalDurationWeeks = 32;
    numberOfPeriods = 8; // 8 blocks of 4 weeks
    isTemplate = true;
    isDefault = true;
    createdBy = 'System';
  }

  PeriodizationPlan.conjugateMethod() {
    name = 'Conjugate Method';
    description =
        'Gelijktijdige ontwikkeling van alle aspecten met variërende accenten. '
        'Flexibele aanpak voor ervaren teams.';
    modelType = PeriodizationModel.conjugate;
    targetAgeGroup = AgeGroup.u17;
    totalDurationWeeks = 40;
    numberOfPeriods = 6;
    isTemplate = true;
    isDefault = true;
    createdBy = 'System';
  }

  factory PeriodizationPlan.fromJson(Map<String, dynamic> json) {
    return PeriodizationPlan()
      ..id = json['id'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..description = json['description'] as String? ?? ''
      ..modelType = PeriodizationModel.values.firstWhere(
        (e) => e.name == (json['modelType'] as String?),
        orElse: () => PeriodizationModel.custom,
      )
      ..targetAgeGroup = AgeGroup.values.firstWhere(
        (e) => e.name == (json['targetAgeGroup'] as String?),
        orElse: () => AgeGroup.u17,
      )
      ..totalDurationWeeks = json['totalDurationWeeks'] as int? ?? 36
      ..numberOfPeriods = json['numberOfPeriods'] as int? ?? 4
      ..defaultIntensityTargets = json['defaultIntensityTargets'] as String?
      ..defaultContentDistribution =
          json['defaultContentDistribution'] as String?
      ..isTemplate = json['isTemplate'] as bool? ?? false
      ..isDefault = json['isDefault'] as bool? ?? false
      ..createdBy = json['createdBy'] as String?
      ..createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now()
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now();
  }
  String id = '';

  // Basic information
  late String name; // "KNVB Youth Development Model", "Traditional Linear"
  late String description;

  late PeriodizationModel
      modelType; // linear, block, conjugate, knvb_youth, custom

  late AgeGroup targetAgeGroup; // u10, u12, u14, u16, u17, u19, senior

  // Plan structure
  late int totalDurationWeeks; // Total duration of the periodization plan
  late int numberOfPeriods; // How many training periods in this plan

  // Default intensity and content targets
  String? defaultIntensityTargets; // JSON string of Map<String, double>
  String?
      defaultContentDistribution; // JSON string of Map<String, ContentDistribution>

  // Template settings
  late bool isTemplate; // true for system templates, false for custom
  late bool isDefault; // true for default KNVB/system templates
  String? createdBy; // user who created custom plans

  // Metadata
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Helper methods for intensity targets
  Map<String, double> getIntensityTargets() {
    if (defaultIntensityTargets == null) return {};
    // Parse JSON string to Map<String, double>
    // For now, return empty map - will implement JSON parsing
    return {};
  }

  void setIntensityTargets(Map<String, double> targets) {
    // Convert Map to JSON string for storage
    // For now, leave empty - will implement JSON serialization
    defaultIntensityTargets = targets.toString();
    updatedAt = DateTime.now();
  }

  // Helper methods for content distribution
  Map<String, ContentDistribution> getContentDistribution() {
    if (defaultContentDistribution == null) return {};
    // Parse JSON string to Map<String, ContentDistribution>
    // For now, return empty map - will implement JSON parsing
    return {};
  }

  void setContentDistribution(Map<String, ContentDistribution> distribution) {
    // Convert Map to JSON string for storage
    // For now, leave empty - will implement JSON serialization
    defaultContentDistribution = distribution.toString();
    updatedAt = DateTime.now();
  }

  // Get recommended parameters based on model type
  static Map<String, dynamic> getRecommendedParameters(
    PeriodizationModel model,
    AgeGroup ageGroup,
  ) {
    switch (model) {
      case PeriodizationModel.knvbYouth:
        return {
          'totalWeeks': 42,
          'periods': 4,
          'focusAreas': [
            'Technical Development',
            'Tactical Understanding',
            'Game Intelligence',
            'Competition',
          ],
          'intensityProgression': [65, 75, 85, 70], // percentage per period
        };
      case PeriodizationModel.linear:
        return {
          'totalWeeks': 36,
          'periods': 3,
          'focusAreas': ['Preparation', 'Competition', 'Transition'],
          'intensityProgression': [60, 90, 40],
        };
      case PeriodizationModel.block:
        return {
          'totalWeeks': 32,
          'periods': 8,
          'focusAreas': ['Technical', 'Tactical', 'Physical', 'Mental'],
          'intensityProgression': [70, 80, 85, 75, 80, 85, 70, 60],
        };
      case PeriodizationModel.conjugate:
        return {
          'totalWeeks': 40,
          'periods': 6,
          'focusAreas': ['Mixed Development', 'Varied Emphasis'],
          'intensityProgression': [70, 75, 80, 85, 80, 70],
        };
      case PeriodizationModel.custom:
        return {
          'totalWeeks': 36,
          'periods': 4,
          'focusAreas': ['Custom'],
          'intensityProgression': [70, 80, 85, 75],
        };
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'modelType': modelType.name,
        'targetAgeGroup': targetAgeGroup.name,
        'totalDurationWeeks': totalDurationWeeks,
        'numberOfPeriods': numberOfPeriods,
        'defaultIntensityTargets': defaultIntensityTargets,
        'defaultContentDistribution': defaultContentDistribution,
        'isTemplate': isTemplate,
        'isDefault': isDefault,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// 🔧 CASCADE OPERATOR DOCUMENTATION - PERIODIZATION PLAN COPYWITH
  ///
  /// This copyWith method demonstrates complex model copying patterns where cascade
  /// notation (..) could significantly improve readability and maintainability of
  /// annual planning model operations in sports management systems.
  ///
  /// **CURRENT PATTERN**: copy.property = value (explicit assignments)
  /// **RECOMMENDED**: copy..property = value (cascade notation)
  ///
  /// **CASCADE BENEFITS FOR PERIODIZATION MODEL COPYWITH**:
  /// ✅ Eliminates 15+ repetitive "copy." references
  /// ✅ Creates visual grouping of property assignments
  /// ✅ Improves readability of complex model copying
  /// ✅ Follows Flutter/Dart best practices for model patterns
  /// ✅ Enhances maintainability of annual planning systems
  /// ✅ Reduces cognitive load when reviewing model operations
  ///
  /// **PERIODIZATION SPECIFIC ADVANTAGES**:
  /// - Complex annual planning model with many properties
  /// - Sports-specific configuration copying
  /// - Null coalescing patterns with property assignments
  /// - Consistent with other model copyWith patterns
  /// - Professional sports management system standards

  // Copy with method for updates
  PeriodizationPlan copyWith({
    String? name,
    String? description,
    PeriodizationModel? modelType,
    AgeGroup? targetAgeGroup,
    int? totalDurationWeeks,
    int? numberOfPeriods,
    String? defaultIntensityTargets,
    String? defaultContentDistribution,
    bool? isTemplate,
    bool? isDefault,
    String? createdBy,
  }) {
    return PeriodizationPlan()
      ..id = id
      ..name = name ?? this.name
      ..description = description ?? this.description
      ..modelType = modelType ?? this.modelType
      ..targetAgeGroup = targetAgeGroup ?? this.targetAgeGroup
      ..totalDurationWeeks = totalDurationWeeks ?? this.totalDurationWeeks
      ..numberOfPeriods = numberOfPeriods ?? this.numberOfPeriods
      ..defaultIntensityTargets =
          defaultIntensityTargets ?? this.defaultIntensityTargets
      ..defaultContentDistribution =
          defaultContentDistribution ?? this.defaultContentDistribution
      ..isTemplate = isTemplate ?? this.isTemplate
      ..isDefault = isDefault ?? this.isDefault
      ..createdBy = createdBy ?? this.createdBy
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }

  @override
  String toString() =>
      'PeriodizationPlan(id: $id, name: $name, model: ${modelType.name}, '
      'ageGroup: ${targetAgeGroup.name}, weeks: $totalDurationWeeks, '
      'periods: $numberOfPeriods, template: $isTemplate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PeriodizationPlan &&
        other.name == name &&
        other.modelType == modelType &&
        other.targetAgeGroup == targetAgeGroup &&
        other.totalDurationWeeks == totalDurationWeeks &&
        other.numberOfPeriods == numberOfPeriods;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      modelType.hashCode ^
      targetAgeGroup.hashCode ^
      totalDurationWeeks.hashCode ^
      numberOfPeriods.hashCode;
}

// Enums for periodization
enum PeriodizationModel { linear, block, conjugate, knvbYouth, custom }

enum AgeGroup { u10, u12, u14, u16, u17, u19, senior }

// Extensions for better display names
extension PeriodizationModelExtension on PeriodizationModel {
  String get displayName {
    switch (this) {
      case PeriodizationModel.linear:
        return 'Linear Periodization';
      case PeriodizationModel.block:
        return 'Block Periodization';
      case PeriodizationModel.conjugate:
        return 'Conjugate Method';
      case PeriodizationModel.knvbYouth:
        return 'KNVB Youth Model';
      case PeriodizationModel.custom:
        return 'Custom Model';
    }
  }

  String get description {
    switch (this) {
      case PeriodizationModel.linear:
        return 'Traditional 3-phase approach: preparation → competition → transition';
      case PeriodizationModel.block:
        return 'Focused training blocks with specific objectives';
      case PeriodizationModel.conjugate:
        return 'Simultaneous development of all aspects with varying emphasis';
      case PeriodizationModel.knvbYouth:
        return 'Dutch football association youth development standard';
      case PeriodizationModel.custom:
        return 'User-defined periodization structure';
    }
  }
}

extension AgeGroupExtension on AgeGroup {
  String get displayName {
    switch (this) {
      case AgeGroup.u10:
        return 'U10';
      case AgeGroup.u12:
        return 'U12';
      case AgeGroup.u14:
        return 'U14';
      case AgeGroup.u16:
        return 'U16';
      case AgeGroup.u17:
        return 'U17';
      case AgeGroup.u19:
        return 'U19';
      case AgeGroup.senior:
        return 'Senior';
    }
  }

  String get dutchName {
    switch (this) {
      case AgeGroup.u10:
        return 'JO10';
      case AgeGroup.u12:
        return 'JO12';
      case AgeGroup.u14:
        return 'JO14';
      case AgeGroup.u16:
        return 'JO16';
      case AgeGroup.u17:
        return 'JO17';
      case AgeGroup.u19:
        return 'JO19';
      case AgeGroup.senior:
        return 'Senioren';
    }
  }
}
