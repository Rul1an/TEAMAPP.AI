// Package imports:
import 'package:uuid/uuid.dart';

enum RatingType { match, training }

enum PerformanceTrend { improving, stable, declining }

class PerformanceRating {
  PerformanceRating({
    required this.playerId,
    required this.date,
    required this.type,
    required this.overallRating,
    required this.coachId,
    String? id,
    this.matchId,
    this.trainingId,
    this.attackingRating,
    this.defendingRating,
    this.tacticalRating,
    this.workRateRating,
    this.technicalRating,
    this.coachabilityRating,
    this.teamworkRating,
    this.notes,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        assert(
          overallRating >= 1 && overallRating <= 5,
          'Overall rating must be between 1 and 5',
        ),
        assert(
          type == RatingType.match ? matchId != null : trainingId != null,
          'Match ratings require matchId, training ratings require trainingId',
        );

  factory PerformanceRating.fromJson(Map<String, dynamic> json) =>
      PerformanceRating(
        id: _parseString(json['id']),
        playerId: _parseString(json['playerId']) ?? '',
        matchId: _parseString(json['matchId']),
        trainingId: _parseString(json['trainingId']),
        date: _parseDateTimeOrNow(_parseString(json['date'])),
        type: _parseRatingType(_parseString(json['type'])),
        overallRating: _parseInt(json['overallRating']) ?? 1,
        attackingRating: _parseInt(json['attackingRating']),
        defendingRating: _parseInt(json['defendingRating']),
        tacticalRating: _parseInt(json['tacticalRating']),
        workRateRating: _parseInt(json['workRateRating']),
        technicalRating: _parseInt(json['technicalRating']),
        coachabilityRating: _parseInt(json['coachabilityRating']),
        teamworkRating: _parseInt(json['teamworkRating']),
        notes: _parseString(json['notes']),
        coachId: _parseString(json['coachId']) ?? '',
        createdAt: _parseDateTimeOrNow(_parseString(json['createdAt'])),
      );

  // Helper methods for JSON parsing
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static RatingType _parseRatingType(String? typeString) {
    if (typeString == null) return RatingType.training;
    return RatingType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => RatingType.training,
    );
  }

  static DateTime _parseDateTimeOrNow(String? dateString) {
    if (dateString == null || dateString.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  final String id;
  final String playerId;
  final String? matchId;
  final String? trainingId;
  final DateTime date;
  final RatingType type;

  // Ratings (1-5)
  final int overallRating;
  final int? attackingRating;
  final int? defendingRating;
  final int? tacticalRating;
  final int? workRateRating;

  // Training specific ratings
  final int? technicalRating;
  final int? coachabilityRating;
  final int? teamworkRating;

  final String? notes;
  final String coachId;
  final DateTime createdAt;

  // Calculate performance trend based on recent ratings
  static String calculateTrend(List<PerformanceRating> recentRatings) {
    if (recentRatings.length < 2) return '→'; // Not enough data

    // Sort by date descending
    recentRatings.sort((a, b) => b.date.compareTo(a.date));

    // Take last 5 ratings
    final ratingsToConsider = recentRatings.take(5).toList();

    if (ratingsToConsider.length < 2) return '→';

    // Calculate average of first half vs second half
    final midPoint = ratingsToConsider.length ~/ 2;
    final recentAvg = ratingsToConsider
            .take(midPoint)
            .map((r) => r.overallRating)
            .reduce((a, b) => a + b) /
        midPoint;
    final olderAvg = ratingsToConsider
            .skip(midPoint)
            .map((r) => r.overallRating)
            .reduce((a, b) => a + b) /
        (ratingsToConsider.length - midPoint);

    if (recentAvg > olderAvg + 0.3) return '↗️';
    if (recentAvg < olderAvg - 0.3) return '↘️';
    return '→';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerId': playerId,
        'matchId': matchId,
        'trainingId': trainingId,
        'date': date.toIso8601String(),
        'type': type.name,
        'overallRating': overallRating,
        'attackingRating': attackingRating,
        'defendingRating': defendingRating,
        'tacticalRating': tacticalRating,
        'workRateRating': workRateRating,
        'technicalRating': technicalRating,
        'coachabilityRating': coachabilityRating,
        'teamworkRating': teamworkRating,
        'notes': notes,
        'coachId': coachId,
        'createdAt': createdAt.toIso8601String(),
      };

  PerformanceRating copyWith({
    String? id,
    String? playerId,
    String? matchId,
    String? trainingId,
    DateTime? date,
    RatingType? type,
    int? overallRating,
    int? attackingRating,
    int? defendingRating,
    int? tacticalRating,
    int? workRateRating,
    int? technicalRating,
    int? coachabilityRating,
    int? teamworkRating,
    String? notes,
    String? coachId,
    DateTime? createdAt,
  }) =>
      PerformanceRating(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        matchId: matchId ?? this.matchId,
        trainingId: trainingId ?? this.trainingId,
        date: date ?? this.date,
        type: type ?? this.type,
        overallRating: overallRating ?? this.overallRating,
        attackingRating: attackingRating ?? this.attackingRating,
        defendingRating: defendingRating ?? this.defendingRating,
        tacticalRating: tacticalRating ?? this.tacticalRating,
        workRateRating: workRateRating ?? this.workRateRating,
        technicalRating: technicalRating ?? this.technicalRating,
        coachabilityRating: coachabilityRating ?? this.coachabilityRating,
        teamworkRating: teamworkRating ?? this.teamworkRating,
        notes: notes ?? this.notes,
        coachId: coachId ?? this.coachId,
        createdAt: createdAt ?? this.createdAt,
      );
}
