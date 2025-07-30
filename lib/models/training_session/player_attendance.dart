// Package imports:
import 'package:jo17_tactical_manager/compat/isar_stub.dart';

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
      ..id = _parseString(json['id']) ?? ''
      ..playerId = _parseString(json['playerId']) ?? ''
      ..playerName = _parseString(json['playerName']) ?? ''
      ..playerNumber = _parseInt(json['playerNumber']) ?? 0
      ..position = _parsePlayerPosition(_parseString(json['position']))
      ..status = _parseAttendanceStatus(_parseString(json['status']))
      ..notes = _parseString(json['notes'])
      ..arrivalTime = _parseDateTime(_parseString(json['arrivalTime']))
      ..createdAt = _parseDateTimeOrNow(_parseString(json['createdAt']))
      ..updatedAt = _parseDateTimeOrNow(_parseString(json['updatedAt']));
  }

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

  static PlayerPosition _parsePlayerPosition(String? positionString) {
    if (positionString == null) return PlayerPosition.V;
    return PlayerPosition.values.firstWhere(
      (e) => e.name == positionString,
      orElse: () => PlayerPosition.V,
    );
  }

  static AttendanceStatus _parseAttendanceStatus(String? statusString) {
    if (statusString == null) return AttendanceStatus.unknown;
    return AttendanceStatus.values.firstWhere(
      (e) => e.name == statusString,
      orElse: () => AttendanceStatus.unknown,
    );
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static DateTime _parseDateTimeOrNow(String? dateString) {
    if (dateString == null || dateString.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
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
    return PlayerAttendance()
      ..id = id
      ..playerId = playerId ?? this.playerId
      ..playerName = playerName ?? this.playerName
      ..playerNumber = playerNumber ?? this.playerNumber
      ..position = position ?? this.position
      ..status = status ?? this.status
      ..notes = notes ?? this.notes
      ..arrivalTime = arrivalTime ?? this.arrivalTime
      ..createdAt = createdAt
      ..updatedAt = DateTime.now();
  }

  // Mark attendance methods
  void markPresent({DateTime? arrival}) {
    this
      ..status = AttendanceStatus.present
      ..arrivalTime = arrival ?? DateTime.now()
      ..updatedAt = DateTime.now();
  }

  void markAbsent({String? reason}) {
    this
      ..status = AttendanceStatus.absent
      ..notes = reason
      ..arrivalTime = null
      ..updatedAt = DateTime.now();
  }

  void markLate({required DateTime arrival, String? reason}) {
    this
      ..status = AttendanceStatus.late
      ..arrivalTime = arrival
      ..notes = reason
      ..updatedAt = DateTime.now();
  }

  void markInjured({String? injuryDetails}) {
    this
      ..status = AttendanceStatus.injured
      ..notes = injuryDetails
      ..arrivalTime = null
      ..updatedAt = DateTime.now();
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
  A, // Aanvaller
}

enum AttendanceStatus {
  present, // Aanwezig
  absent, // Afwezig
  late, // Te laat
  injured, // Geblesseerd
  unknown, // Onbekend
}
