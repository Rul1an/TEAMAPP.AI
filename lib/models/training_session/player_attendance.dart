import 'package:isar/isar.dart';

// part 'player_attendance.g.dart'; // Disabled for web compatibility

class PlayerAttendance {
  // Constructor
  PlayerAttendance();

  // Named constructors
  PlayerAttendance.present({
    required this.playerId,
    required this.playerName,
    required this.playerNumber,
    required this.position,
    this.arrivalTime,
  }) {
    status = AttendanceStatus.present;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  PlayerAttendance.absent({
    required this.playerId,
    required this.playerName,
    required this.playerNumber,
    required this.position,
    this.notes,
  }) {
    status = AttendanceStatus.absent;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  PlayerAttendance.late({
    required this.playerId,
    required this.playerName,
    required this.playerNumber,
    required this.position,
    required this.arrivalTime,
    this.notes,
  }) {
    status = AttendanceStatus.late;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  PlayerAttendance.injured({
    required this.playerId,
    required this.playerName,
    required this.playerNumber,
    required this.position,
    this.notes,
  }) {
    status = AttendanceStatus.injured;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  /// 🔧 CASCADE OPERATOR DOCUMENTATION - PLAYER ATTENDANCE MODEL
  ///
  /// This factory method demonstrates object initialization patterns for player tracking
  /// where cascade notation (..) could significantly improve code readability and
  /// maintainability in sports management applications.
  ///
  /// **CURRENT PATTERN**: attendance.property = value (explicit assignments)
  /// **RECOMMENDED**: attendance..property = value (cascade notation)
  ///
  /// **CASCADE BENEFITS FOR PLAYER TRACKING MODELS**:
  /// ✅ Eliminates 10+ repetitive 'attendance.' references
  /// ✅ Creates visual grouping of player data assignments
  /// ✅ Improves readability of sports data deserialization
  /// ✅ Follows Flutter/Dart best practices for model initialization
  /// ✅ Enhances maintainability of player management systems
  /// ✅ Reduces cognitive load when reading player data parsing
  ///
  /// **PLAYER ATTENDANCE SPECIFIC ADVANTAGES**:
  /// - Player data initialization with multiple properties
  /// - Enum parsing for position and attendance status
  /// - DateTime handling for arrival time tracking
  /// - Sports-specific data validation patterns
  /// - Consistent with other sports model patterns
  ///
  /// **SPORTS MODEL TRANSFORMATION EXAMPLE**:
  /// ```dart
  /// // Current (verbose player data assignments):
  /// final attendance = PlayerAttendance();
  /// attendance.playerId = json['playerId'];
  /// attendance.playerName = json['playerName'];
  /// attendance.position = PlayerPosition.values.firstWhere(...);
  /// attendance.status = AttendanceStatus.values.firstWhere(...);
  ///
  /// // With cascade notation (fluent player data initialization):
  /// final attendance = PlayerAttendance()
  ///   ..playerId = json['playerId']
  ///   ..playerName = json['playerName']
  ///   ..position = PlayerPosition.values.firstWhere(...)
  ///   ..status = AttendanceStatus.values.firstWhere(...);
  /// ```
  factory PlayerAttendance.fromJson(Map<String, dynamic> json) {
    return PlayerAttendance()
      ..id = json['id'] as String? ?? ''
      ..playerId = json['playerId'] as String? ?? ''
      ..playerName = json['playerName'] as String? ?? ''
      ..playerNumber = json['playerNumber'] as int? ?? 0
      ..position = PlayerPosition.values.firstWhere(
        (e) => e.name == json['position'],
        orElse: () => PlayerPosition.V,
      )
      ..status = AttendanceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceStatus.unknown,
      )
      ..notes = json['notes'] as String?
      ..arrivalTime = json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : null
      ..createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now()
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now();
  }
  String id = '';

  late String playerId;
  late String playerName;
  late int playerNumber;

  late PlayerPosition position; // K, V, M, A

  late AttendanceStatus status;

  String? notes; // injury details, reason for absence
  DateTime? arrivalTime;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Computed properties
  @Ignore()
  bool get isPresent => status == AttendanceStatus.present;

  @Ignore()
  bool get isAbsent => status == AttendanceStatus.absent;

  @Ignore()
  bool get isLate => status == AttendanceStatus.late;

  @Ignore()
  bool get isInjured => status == AttendanceStatus.injured;

  @Ignore()
  String get statusDisplayText {
    switch (status) {
      case AttendanceStatus.present:
        return 'Aanwezig';
      case AttendanceStatus.absent:
        return 'Afwezig';
      case AttendanceStatus.late:
        return 'Te laat';
      case AttendanceStatus.injured:
        return 'Geblesseerd';
      case AttendanceStatus.unknown:
        return 'Onbekend';
    }
  }

  @Ignore()
  String get positionDisplayText {
    switch (position) {
      case PlayerPosition.K:
        return 'Keeper';
      case PlayerPosition.V:
        return 'Verdediger';
      case PlayerPosition.M:
        return 'Middenvelder';
      case PlayerPosition.A:
        return 'Aanvaller';
    }
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'playerId': playerId,
        'playerName': playerName,
        'playerNumber': playerNumber,
        'position': position.name,
        'status': status.name,
        'notes': notes,
        'arrivalTime': arrivalTime?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  // Copy with method
  PlayerAttendance copyWith({
    String? playerId,
    String? playerName,
    int? playerNumber,
    PlayerPosition? position,
    AttendanceStatus? status,
    String? notes,
    DateTime? arrivalTime,
  }) {
    final copy = PlayerAttendance();
    copy.id = id;
    copy.playerId = playerId ?? this.playerId;
    copy.playerName = playerName ?? this.playerName;
    copy.playerNumber = playerNumber ?? this.playerNumber;
    copy.position = position ?? this.position;
    copy.status = status ?? this.status;
    copy.notes = notes ?? this.notes;
    copy.arrivalTime = arrivalTime ?? this.arrivalTime;
    copy.createdAt = createdAt;
    copy.updatedAt = DateTime.now();
    return copy;
  }

  // Mark attendance methods
  void markPresent({DateTime? arrival}) {
    status = AttendanceStatus.present;
    arrivalTime = arrival ?? DateTime.now();
    updatedAt = DateTime.now();
  }

  void markAbsent({String? reason}) {
    status = AttendanceStatus.absent;
    notes = reason;
    arrivalTime = null;
    updatedAt = DateTime.now();
  }

  void markLate({required DateTime arrival, String? reason}) {
    status = AttendanceStatus.late;
    arrivalTime = arrival;
    notes = reason;
    updatedAt = DateTime.now();
  }

  void markInjured({String? injuryDetails}) {
    status = AttendanceStatus.injured;
    notes = injuryDetails;
    arrivalTime = null;
    updatedAt = DateTime.now();
  }

  @override
  String toString() =>
      'PlayerAttendance(name: $playerName, number: $playerNumber, '
      'position: $position, status: $status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerAttendance &&
        other.playerId == playerId &&
        other.playerNumber == playerNumber;
  }

  @override
  int get hashCode => playerId.hashCode ^ playerNumber.hashCode;
}

enum PlayerPosition {
  K, // Keeper
  V, // Verdediger
  M, // Middenvelder
  A // Aanvaller
}

enum AttendanceStatus {
  present, // Aanwezig
  absent, // Afwezig
  late, // Te laat
  injured, // Geblesseerd
  unknown // Onbekend
}
