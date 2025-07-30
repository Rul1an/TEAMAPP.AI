// Core field diagram models for the tactical manager

class FieldDiagram {
  FieldDiagram({
    required this.id,
    required this.fieldType,
    required this.fieldSize,
    this.players = const [],
    this.equipment = const [],
    this.movements = const [],
    this.areas = const [],
    this.labels = const [],
    this.backgroundColor,
    this.showFieldMarkings = true,
    this.showGoals = true,
  });

  // Named constructors for common field types
  FieldDiagram.fullField({String? id})
      : this(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          fieldType: FieldType.fullField,
          fieldSize: const Dimensions(105, 68), // Official field dimensions
        );

  FieldDiagram.halfField({String? id})
      : this(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          fieldType: FieldType.halfField,
          fieldSize: const Dimensions(52.5, 68),
        );

  FieldDiagram.penaltyArea({String? id})
      : this(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          fieldType: FieldType.penaltyArea,
          fieldSize: const Dimensions(16.5, 40.3),
        );

  FieldDiagram.customGrid({
    required double width,
    required double height,
    String? id,
  }) : this(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          fieldType: FieldType.customGrid,
          fieldSize: Dimensions(width, height),
          showFieldMarkings: false,
          showGoals: false,
        );

  factory FieldDiagram.fromJson(Map<String, dynamic> json) => FieldDiagram(
        id: _parseString(json['id']) ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        fieldType: _parseFieldType(_parseString(json['fieldType'])),
        fieldSize: _parseDimensions(json['fieldSize']),
        players: _parsePlayerMarkerList(json['players']),
        equipment: _parseEquipmentMarkerList(json['equipment']),
        movements: _parseMovementLineList(json['movements']),
        areas: _parseAreaMarkerList(json['areas']),
        labels: _parseTextLabelList(json['labels']),
        backgroundColor: _parseString(json['backgroundColor']),
        showFieldMarkings: _parseBool(json['showFieldMarkings']) ?? true,
        showGoals: _parseBool(json['showGoals']) ?? true,
      );

  // Helper methods for JSON parsing
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static FieldType _parseFieldType(String? typeString) {
    if (typeString == null) return FieldType.halfField;
    return FieldType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => FieldType.halfField,
    );
  }

  static Dimensions _parseDimensions(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Dimensions.fromJson(value);
    }
    return const Dimensions(52.5, 68); // Default half field
  }

  static List<PlayerMarker> _parsePlayerMarkerList(dynamic value) {
    if (value is! List) return [];
    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => PlayerMarker.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<EquipmentMarker> _parseEquipmentMarkerList(dynamic value) {
    if (value is! List) return [];
    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => EquipmentMarker.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<MovementLine> _parseMovementLineList(dynamic value) {
    if (value is! List) return [];
    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => MovementLine.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<AreaMarker> _parseAreaMarkerList(dynamic value) {
    if (value is! List) return [];
    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => AreaMarker.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<TextLabel> _parseTextLabelList(dynamic value) {
    if (value is! List) return [];
    return value
        .where((item) => item is Map<String, dynamic>)
        .map((item) => TextLabel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  final String id;
  final FieldType fieldType;
  final Dimensions fieldSize;

  final List<PlayerMarker> players;
  final List<EquipmentMarker> equipment;
  final List<MovementLine> movements;
  final List<AreaMarker> areas;
  final List<TextLabel> labels;

  // Visual styling
  final String? backgroundColor;
  final bool showFieldMarkings;
  final bool showGoals;

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'fieldType': fieldType.name,
        'fieldSize': fieldSize.toJson(),
        'players': players.map((p) => p.toJson()).toList(),
        'equipment': equipment.map((e) => e.toJson()).toList(),
        'movements': movements.map((m) => m.toJson()).toList(),
        'areas': areas.map((a) => a.toJson()).toList(),
        'labels': labels.map((l) => l.toJson()).toList(),
        'backgroundColor': backgroundColor,
        'showFieldMarkings': showFieldMarkings,
        'showGoals': showGoals,
      };

  // Copy with method
  FieldDiagram copyWith({
    String? id,
    FieldType? fieldType,
    Dimensions? fieldSize,
    List<PlayerMarker>? players,
    List<EquipmentMarker>? equipment,
    List<MovementLine>? movements,
    List<AreaMarker>? areas,
    List<TextLabel>? labels,
    String? backgroundColor,
    bool? showFieldMarkings,
    bool? showGoals,
  }) =>
      FieldDiagram(
        id: id ?? this.id,
        fieldType: fieldType ?? this.fieldType,
        fieldSize: fieldSize ?? this.fieldSize,
        players: players ?? this.players,
        equipment: equipment ?? this.equipment,
        movements: movements ?? this.movements,
        areas: areas ?? this.areas,
        labels: labels ?? this.labels,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        showFieldMarkings: showFieldMarkings ?? this.showFieldMarkings,
        showGoals: showGoals ?? this.showGoals,
      );

  @override
  String toString() =>
      'FieldDiagram(type: $fieldType, players: ${players.length}, '
      'equipment: ${equipment.length}, movements: ${movements.length})';
}

class PlayerMarker {
  PlayerMarker({
    required this.id,
    required this.position,
    required this.type,
    this.label,
    this.color = '#2196F3', // Default blue
  });

  factory PlayerMarker.fromJson(Map<String, dynamic> json) => PlayerMarker(
        id: _parseString(json['id']) ?? '',
        position: _parsePosition(json['position']),
        type: _parsePlayerType(_parseString(json['type'])),
        label: _parseString(json['label']),
        color: _parseString(json['color']) ?? '#2196F3',
      );

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static Position _parsePosition(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Position.fromJson(value);
    }
    return const Position(0.0, 0.0);
  }

  static PlayerType _parsePlayerType(String? typeString) {
    if (typeString == null) return PlayerType.neutral;
    return PlayerType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => PlayerType.neutral,
    );
  }
  final String id;
  final Position position;
  final PlayerType type;
  final String? label;
  final String color;

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position.toJson(),
        'type': type.name,
        'label': label,
        'color': color,
      };

  @override
  String toString() => 'PlayerMarker(id: $id, type: $type, label: $label)';
}

class EquipmentMarker {
  EquipmentMarker({
    required this.id,
    required this.position,
    required this.type,
    this.color = '#FF9800', // Default orange
    this.size,
  });

  factory EquipmentMarker.fromJson(Map<String, dynamic> json) =>
      EquipmentMarker(
        id: _parseString(json['id']) ?? '',
        position: _parsePosition(json['position']),
        type: _parseEquipmentType(_parseString(json['type'])),
        color: _parseString(json['color']) ?? '#FF9800',
        size: _parseDouble(json['size']),
      );

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static Position _parsePosition(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Position.fromJson(value);
    }
    return const Position(0.0, 0.0);
  }

  static EquipmentType _parseEquipmentType(String? typeString) {
    if (typeString == null) return EquipmentType.cone;
    return EquipmentType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => EquipmentType.cone,
    );
  }
  final String id;
  final Position position;
  final EquipmentType type;
  final String color;
  final double? size;

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position.toJson(),
        'type': type.name,
        'color': color,
        'size': size,
      };
}

class MovementLine {
  MovementLine({
    required this.id,
    required this.points,
    required this.type,
    this.color = '#4CAF50', // Default green
    this.strokeWidth = 2.0,
    this.hasArrowHead = true,
    this.label,
  });

  // Legacy constructor for backward compatibility
  MovementLine.fromStartEnd({
    required String id,
    required Position start,
    required Position end,
    required LineType type,
    String color = '#4CAF50',
    String? label,
  }) : this(
          id: id,
          points: [start, end],
          type: type,
          color: color,
          label: label,
        );

  factory MovementLine.fromJson(Map<String, dynamic> json) {
    // Handle legacy format with start/end
    if (json.containsKey('start') && json.containsKey('end')) {
      return MovementLine(
        id: json['id'] as String? ?? '',
        points: [
          Position.fromJson(json['start'] as Map<String, dynamic>),
          Position.fromJson(json['end'] as Map<String, dynamic>),
        ],
        type: LineType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LineType.pass,
        ),
        color: json['color'] as String? ?? '#4CAF50',
        label: json['label'] as String?,
      );
    }

    // New format with points array
    return MovementLine(
      id: json['id'] as String? ?? '',
      points: (json['points'] as List<dynamic>?)
              ?.map((p) => Position.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      type: LineType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LineType.pass,
      ),
      color: json['color'] as String? ?? '#4CAF50',
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 2.0,
      hasArrowHead: json['hasArrowHead'] as bool? ?? true,
      label: json['label'] as String?,
    );
  }
  final String id;
  final List<Position> points;
  final LineType type;
  final String color;
  final double strokeWidth;
  final bool hasArrowHead;
  final String? label;

  Map<String, dynamic> toJson() => {
        'id': id,
        'points': points.map((p) => p.toJson()).toList(),
        'type': type.name,
        'color': color,
        'strokeWidth': strokeWidth,
        'hasArrowHead': hasArrowHead,
        'label': label,
      };
}

class AreaMarker {
  AreaMarker({
    required this.id,
    required this.topLeft,
    required this.bottomRight,
    this.color = '#FFC107', // Default amber
    this.opacity = 0.3,
    this.label,
  });

  factory AreaMarker.fromJson(Map<String, dynamic> json) => AreaMarker(
        id: _parseString(json['id']) ?? '',
        topLeft: _parsePosition(json['topLeft']),
        bottomRight: _parsePosition(json['bottomRight']),
        color: _parseString(json['color']) ?? '#FFC107',
        opacity: _parseDouble(json['opacity']) ?? 0.3,
        label: _parseString(json['label']),
      );

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static Position _parsePosition(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Position.fromJson(value);
    }
    return const Position(0.0, 0.0);
  }
  final String id;
  final Position topLeft;
  final Position bottomRight;
  final String color;
  final double opacity;
  final String? label;

  Map<String, dynamic> toJson() => {
        'id': id,
        'topLeft': topLeft.toJson(),
        'bottomRight': bottomRight.toJson(),
        'color': color,
        'opacity': opacity,
        'label': label,
      };
}

class TextLabel {
  TextLabel({
    required this.id,
    required this.position,
    required this.text,
    this.color = '#000000',
    this.fontSize = 14.0,
  });

  factory TextLabel.fromJson(Map<String, dynamic> json) => TextLabel(
        id: _parseString(json['id']) ?? '',
        position: _parsePosition(json['position']),
        text: _parseString(json['text']) ?? '',
        color: _parseString(json['color']) ?? '#000000',
        fontSize: _parseDouble(json['fontSize']) ?? 14.0,
      );

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static Position _parsePosition(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Position.fromJson(value);
    }
    return const Position(0.0, 0.0);
  }
  final String id;
  final Position position;
  final String text;
  final String color;
  final double fontSize;

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position.toJson(),
        'text': text,
        'color': color,
        'fontSize': fontSize,
      };
}

class Position {
  const Position(this.x, this.y);

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        (json['x'] as num?)?.toDouble() ?? 0.0,
        (json['y'] as num?)?.toDouble() ?? 0.0,
      );
  final double x;
  final double y;

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  @override
  String toString() => 'Position($x, $y)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class Dimensions {
  const Dimensions(this.width, this.height);

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        (json['width'] as num?)?.toDouble() ?? 0.0,
        (json['height'] as num?)?.toDouble() ?? 0.0,
      );
  final double width;
  final double height;

  Map<String, dynamic> toJson() => {'width': width, 'height': height};

  @override
  String toString() => 'Dimensions($width x $height)';
}

enum FieldType {
  fullField, // Volledig veld
  halfField, // Half veld
  penaltyArea, // Strafschopgebied
  customGrid, // Custom grid
  thirdField, // 1/3 veld
  quarterField, // 1/4 veld
}

enum PlayerType {
  attacking, // Aanvallende speler (blauw)
  defending, // Verdedigende speler (rood)
  neutral, // Neutrale speler (geel)
  goalkeeper, // Keeper (groen)
}

enum EquipmentType {
  cone, // Kegel
  ball, // Bal
  smallGoal, // Klein doel
  largeGoal, // Groot doel
  pole, // Paal
  mannequin, // Pop
  ladder, // Ladder
  hurdle, // Horde
}

enum LineType {
  pass, // Pass (doorgetrokken lijn met pijl)
  run, // Looplijn (gestreepte lijn)
  dribble, // Dribbel (golvende lijn)
  shot, // Schot (dikke lijn met pijl)
  defensive, // Verdedigende beweging (gestippelde lijn)
  ballPath, // Bal beweging (dunne lijn)
}
