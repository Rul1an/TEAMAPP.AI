import 'package:isar/isar.dart';

// part 'player_attendance.g.dart'; // Disabled for web compatibility

// @Collection() // Disabled for web compatibility
class PlayerAttendance {
  Id id = Isar.autoIncrement;

  late String playerId;
  late String playerName;
  late int playerNumber;

  @Enumerated(EnumType.name)
  late PlayerPosition position; // K, V, M, A

  @Enumerated(EnumType.name)
  late AttendanceStatus status;

  String? notes; // injury details, reason for absence
  DateTime? arrivalTime;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Computed properties
  @ignore
  bool get isPresent => status == AttendanceStatus.present;

  @ignore
  bool get isAbsent => status == AttendanceStatus.absent;

  @ignore
  bool get isLate => status == AttendanceStatus.late;

  @ignore
  bool get isInjured => status == AttendanceStatus.injured;

  @ignore
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

  @ignore
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

  factory PlayerAttendance.fromJson(Map<String, dynamic> json) {
    final attendance = PlayerAttendance();
    attendance.id = json['id'] ?? Isar.autoIncrement;
    attendance.playerId = json['playerId'] ?? '';
    attendance.playerName = json['playerName'] ?? '';
    attendance.playerNumber = json['playerNumber'] ?? 0;
    attendance.position = PlayerPosition.values.firstWhere(
      (e) => e.name == json['position'],
      orElse: () => PlayerPosition.V,
    );
    attendance.status = AttendanceStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => AttendanceStatus.unknown,
    );
    attendance.notes = json['notes'];
    attendance.arrivalTime = json['arrivalTime'] != null
        ? DateTime.parse(json['arrivalTime'])
        : null;
    attendance.createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    attendance.updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    return attendance;
  }

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
  String toString() {
    return 'PlayerAttendance(name: $playerName, number: $playerNumber, '
           'position: $position, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerAttendance &&
        other.playerId == playerId &&
        other.playerNumber == playerNumber;
  }

  @override
  int get hashCode {
    return playerId.hashCode ^ playerNumber.hashCode;
  }
}

enum PlayerPosition {
  K,  // Keeper
  V,  // Verdediger
  M,  // Middenvelder
  A   // Aanvaller
}

enum AttendanceStatus {
  present,   // Aanwezig
  absent,    // Afwezig
  late,      // Te laat
  injured,   // Geblesseerd
  unknown    // Onbekend
}
