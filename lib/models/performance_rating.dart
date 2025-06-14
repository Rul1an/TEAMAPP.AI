import 'package:uuid/uuid.dart';

enum RatingType { match, training }

enum PerformanceTrend { improving, stable, declining }

class PerformanceRating {
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

  PerformanceRating({
    String? id,
    required this.playerId,
    this.matchId,
    this.trainingId,
    required this.date,
    required this.type,
    required this.overallRating,
    this.attackingRating,
    this.defendingRating,
    this.tacticalRating,
    this.workRateRating,
    this.technicalRating,
    this.coachabilityRating,
    this.teamworkRating,
    this.notes,
    required this.coachId,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        assert(overallRating >= 1 && overallRating <= 5),
        assert(type == RatingType.match ? matchId != null : trainingId != null);

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
        .reduce((a, b) => a + b) / midPoint;
    final olderAvg = ratingsToConsider
        .skip(midPoint)
        .map((r) => r.overallRating)
        .reduce((a, b) => a + b) / (ratingsToConsider.length - midPoint);

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

  factory PerformanceRating.fromJson(Map<String, dynamic> json) {
    return PerformanceRating(
      id: json['id'],
      playerId: json['playerId'],
      matchId: json['matchId'],
      trainingId: json['trainingId'],
      date: DateTime.parse(json['date']),
      type: RatingType.values.firstWhere((e) => e.name == json['type']),
      overallRating: json['overallRating'],
      attackingRating: json['attackingRating'],
      defendingRating: json['defendingRating'],
      tacticalRating: json['tacticalRating'],
      workRateRating: json['workRateRating'],
      technicalRating: json['technicalRating'],
      coachabilityRating: json['coachabilityRating'],
      teamworkRating: json['teamworkRating'],
      notes: json['notes'],
      coachId: json['coachId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

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
  }) {
    return PerformanceRating(
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
}
