/// Content Distribution Model for Training Periodization
/// Defines the percentage allocation of different training content types
class ContentDistribution {
  const ContentDistribution({
    required this.technical,
    required this.tactical,
    required this.physical,
    required this.mental,
    required this.gameSpecific,
  });

  /// Percentage of training time dedicated to technical skills (0-100)
  final double technical;
  
  /// Percentage of training time dedicated to tactical understanding (0-100)
  final double tactical;
  
  /// Percentage of training time dedicated to physical conditioning (0-100)
  final double physical;
  
  /// Percentage of training time dedicated to mental development (0-100)
  final double mental;
  
  /// Percentage of training time dedicated to game-specific situations (0-100)
  final double gameSpecific;

  /// Create a balanced distribution for youth development
  factory ContentDistribution.balanced() => const ContentDistribution(
    technical: 30.0,
    tactical: 25.0,
    physical: 20.0,
    mental: 10.0,
    gameSpecific: 15.0,
  );

  /// Create a technical-focused distribution
  factory ContentDistribution.technicalFocus() => const ContentDistribution(
    technical: 40.0,
    tactical: 20.0,
    physical: 15.0,
    mental: 10.0,
    gameSpecific: 15.0,
  );

  /// Create a tactical-focused distribution
  factory ContentDistribution.tacticalFocus() => const ContentDistribution(
    technical: 20.0,
    tactical: 35.0,
    physical: 15.0,
    mental: 15.0,
    gameSpecific: 15.0,
  );

  /// Validate that percentages sum to 100%
  bool get isValid {
    const tolerance = 0.1;
    final total = technical + tactical + physical + mental + gameSpecific;
    return (total - 100.0).abs() <= tolerance;
  }

  /// Get total percentage
  double get total => technical + tactical + physical + mental + gameSpecific;

  /// Create from JSON
  factory ContentDistribution.fromJson(Map<String, dynamic> json) {
    return ContentDistribution(
      technical: (json['technical'] as num?)?.toDouble() ?? 0.0,
      tactical: (json['tactical'] as num?)?.toDouble() ?? 0.0,
      physical: (json['physical'] as num?)?.toDouble() ?? 0.0,
      mental: (json['mental'] as num?)?.toDouble() ?? 0.0,
      gameSpecific: (json['gameSpecific'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
    'technical': technical,
    'tactical': tactical,
    'physical': physical,
    'mental': mental,
    'gameSpecific': gameSpecific,
  };

  /// Copy with new values
  ContentDistribution copyWith({
    double? technical,
    double? tactical,
    double? physical,
    double? mental,
    double? gameSpecific,
  }) {
    return ContentDistribution(
      technical: technical ?? this.technical,
      tactical: tactical ?? this.tactical,
      physical: physical ?? this.physical,
      mental: mental ?? this.mental,
      gameSpecific: gameSpecific ?? this.gameSpecific,
    );
  }

  @override
  String toString() => 
    'ContentDistribution(technical: $technical%, tactical: $tactical%, '
    'physical: $physical%, mental: $mental%, gameSpecific: $gameSpecific%)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentDistribution &&
      other.technical == technical &&
      other.tactical == tactical &&
      other.physical == physical &&
      other.mental == mental &&
      other.gameSpecific == gameSpecific;
  }

  @override
  int get hashCode => Object.hash(
    technical,
    tactical,
    physical,
    mental,
    gameSpecific,
  );
}
