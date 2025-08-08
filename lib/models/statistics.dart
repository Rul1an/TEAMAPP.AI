/// 2025 Best Practice: Type-safe Statistics model with safe defaults
/// Simple immutable class without Freezed to avoid conflicts
class Statistics {
  const Statistics({
    this.totalPlayers = 0,
    this.totalMatches = 0,
    this.totalTrainings = 0,
    this.winPercentage = 0.0,
    this.avgGoalsFor = 0.0,
    this.avgGoalsAgainst = 0.0,
    this.totalWins = 0,
    this.totalLosses = 0,
    this.totalDraws = 0,
    this.attendanceRate = 0.0,
  });

  final int totalPlayers;
  final int totalMatches;
  final int totalTrainings;
  final double winPercentage;
  final double avgGoalsFor;
  final double avgGoalsAgainst;
  final int totalWins;
  final int totalLosses;
  final int totalDraws;
  final double attendanceRate;

  /// Create Statistics from legacy Map<String, dynamic>
  /// 2025 Best Practice: Safe parsing with null protection
  factory Statistics.fromLegacyMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return const Statistics(); // Returns defaults
    }

    return Statistics(
      totalPlayers: _safeParseInt(map['totalPlayers']),
      totalMatches: _safeParseInt(map['totalMatches']),
      totalTrainings: _safeParseInt(map['totalTrainings']),
      winPercentage: _safeParseDouble(map['winPercentage']),
      avgGoalsFor: _safeParseDouble(map['avgGoalsFor']),
      avgGoalsAgainst: _safeParseDouble(map['avgGoalsAgainst']),
      totalWins: _safeParseInt(map['totalWins']),
      totalLosses: _safeParseInt(map['totalLosses']),
      totalDraws: _safeParseInt(map['totalDraws']),
      attendanceRate: _safeParseDouble(map['attendanceRate']),
    );
  }

  /// Convert to legacy Map format for backwards compatibility
  Map<String, dynamic> toLegacyMap() => {
        'totalPlayers': totalPlayers,
        'totalMatches': totalMatches,
        'totalTrainings': totalTrainings,
        'winPercentage': winPercentage,
        'avgGoalsFor': avgGoalsFor,
        'avgGoalsAgainst': avgGoalsAgainst,
        'totalWins': totalWins,
        'totalLosses': totalLosses,
        'totalDraws': totalDraws,
        'attendanceRate': attendanceRate,
      };

  /// CopyWith method for immutable updates
  Statistics copyWith({
    int? totalPlayers,
    int? totalMatches,
    int? totalTrainings,
    double? winPercentage,
    double? avgGoalsFor,
    double? avgGoalsAgainst,
    int? totalWins,
    int? totalLosses,
    int? totalDraws,
    double? attendanceRate,
  }) {
    return Statistics(
      totalPlayers: totalPlayers ?? this.totalPlayers,
      totalMatches: totalMatches ?? this.totalMatches,
      totalTrainings: totalTrainings ?? this.totalTrainings,
      winPercentage: winPercentage ?? this.winPercentage,
      avgGoalsFor: avgGoalsFor ?? this.avgGoalsFor,
      avgGoalsAgainst: avgGoalsAgainst ?? this.avgGoalsAgainst,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      totalDraws: totalDraws ?? this.totalDraws,
      attendanceRate: attendanceRate ?? this.attendanceRate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Statistics &&
        other.totalPlayers == totalPlayers &&
        other.totalMatches == totalMatches &&
        other.totalTrainings == totalTrainings &&
        other.winPercentage == winPercentage &&
        other.avgGoalsFor == avgGoalsFor &&
        other.avgGoalsAgainst == avgGoalsAgainst &&
        other.totalWins == totalWins &&
        other.totalLosses == totalLosses &&
        other.totalDraws == totalDraws &&
        other.attendanceRate == attendanceRate;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalPlayers,
      totalMatches,
      totalTrainings,
      winPercentage,
      avgGoalsFor,
      avgGoalsAgainst,
      totalWins,
      totalLosses,
      totalDraws,
      attendanceRate,
    );
  }

  @override
  String toString() {
    return 'Statistics(totalPlayers: $totalPlayers, totalMatches: $totalMatches, '
        'totalTrainings: $totalTrainings, winPercentage: $winPercentage, '
        'avgGoalsFor: $avgGoalsFor, avgGoalsAgainst: $avgGoalsAgainst, '
        'totalWins: $totalWins, totalLosses: $totalLosses, '
        'totalDraws: $totalDraws, attendanceRate: $attendanceRate)';
  }
}

// 2025 Best Practice: Defensive parsing with proper null safety
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

/// 2025 Best Practice: Extension methods for safe formatting
extension StatisticsFormatting on Statistics {
  /// Safely format percentage with specified decimal places
  String formatPercentage(double value, {int decimals = 1}) {
    if (value.isNaN || value.isInfinite) return '0.0';
    return value.clamp(0.0, 100.0).toStringAsFixed(decimals);
  }

  /// Safely format win percentage
  String get winPercentageFormatted => '${formatPercentage(winPercentage)}%';

  /// Safely format attendance rate
  String get attendanceRateFormatted => '${formatPercentage(attendanceRate)}%';

  /// Safely format average goals
  String formatGoals(double goals, {int decimals = 1}) {
    if (goals.isNaN || goals.isInfinite) return '0.0';
    return goals.clamp(0.0, double.maxFinite).toStringAsFixed(decimals);
  }

  /// Get formatted average goals for
  String get avgGoalsForFormatted => formatGoals(avgGoalsFor);

  /// Get formatted average goals against
  String get avgGoalsAgainstFormatted => formatGoals(avgGoalsAgainst);
}
