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
    String? id,
    required double width,
    required double height,
  }) : this(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          fieldType: FieldType.customGrid,
          fieldSize: Dimensions(width, height),
          showFieldMarkings: false,
          showGoals: false,
        );

  factory FieldDiagram.fromJson(Map<String, dynamic> json) => FieldDiagram(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fieldType: FieldType.values.firstWhere(
        (e) => e.name == json['fieldType'],
        orElse: () => FieldType.halfField,
      ),
      fieldSize: Dimensions.fromJson(json['fieldSize']),
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => PlayerMarker.fromJson(p))
              .toList() ??
          [],
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => EquipmentMarker.fromJson(e))
              .toList() ??
          [],
      movements: (json['movements'] as List<dynamic>?)
              ?.map((m) => MovementLine.fromJson(m))
              .toList() ??
          [],
      areas: (json['areas'] as List<dynamic>?)
              ?.map((a) => AreaMarker.fromJson(a))
              .toList() ??
          [],
      labels: (json['labels'] as List<dynamic>?)
              ?.map((l) => TextLabel.fromJson(l))
              .toList() ??
          [],
      backgroundColor: json['backgroundColor'],
      showFieldMarkings: json['showFieldMarkings'] ?? true,
      showGoals: json['showGoals'] ?? true,
    );
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
  }) => FieldDiagram(
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
  String toString() => 'FieldDiagram(type: $fieldType, players: ${players.length}, '
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
      id: json['id'] ?? '',
      position: Position.fromJson(json['position']),
      type: PlayerType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PlayerType.neutral,
      ),
      label: json['label'],
      color: json['color'] ?? '#2196F3',
    );
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

  factory EquipmentMarker.fromJson(Map<String, dynamic> json) => EquipmentMarker(
      id: json['id'] ?? '',
      position: Position.fromJson(json['position']),
      type: EquipmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EquipmentType.cone,
      ),
      color: json['color'] ?? '#FF9800',
      size: json['size']?.toDouble(),
    );
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
        id: json['id'] ?? '',
        points: [
          Position.fromJson(json['start']),
          Position.fromJson(json['end']),
        ],
        type: LineType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LineType.pass,
        ),
        color: json['color'] ?? '#4CAF50',
        label: json['label'],
      );
    }

    // New format with points array
    return MovementLine(
      id: json['id'] ?? '',
      points: (json['points'] as List<dynamic>?)
              ?.map((p) => Position.fromJson(p))
              .toList() ??
          [],
      type: LineType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LineType.pass,
      ),
      color: json['color'] ?? '#4CAF50',
      strokeWidth: json['strokeWidth']?.toDouble() ?? 2.0,
      hasArrowHead: json['hasArrowHead'] ?? true,
      label: json['label'],
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
      id: json['id'] ?? '',
      topLeft: Position.fromJson(json['topLeft']),
      bottomRight: Position.fromJson(json['bottomRight']),
      color: json['color'] ?? '#FFC107',
      opacity: json['opacity']?.toDouble() ?? 0.3,
      label: json['label'],
    );
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
      id: json['id'] ?? '',
      position: Position.fromJson(json['position']),
      text: json['text'] ?? '',
      color: json['color'] ?? '#000000',
      fontSize: json['fontSize']?.toDouble() ?? 14.0,
    );
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
      json['x']?.toDouble() ?? 0.0,
      json['y']?.toDouble() ?? 0.0,
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
      json['width']?.toDouble() ?? 0.0,
      json['height']?.toDouble() ?? 0.0,
    );
  final double width;
  final double height;

  Map<String, dynamic> toJson() => {'width': width, 'height': height};

  @override
  String toString() => 'Dimensions($width x $height)';
}

enum FieldType {
  fullField,      // Volledig veld
  halfField,      // Half veld
  penaltyArea,    // Strafschopgebied
  customGrid,     // Custom grid
  thirdField,     // 1/3 veld
  quarterField    // 1/4 veld
}

enum PlayerType {
  attacking,      // Aanvallende speler (blauw)
  defending,      // Verdedigende speler (rood)
  neutral,        // Neutrale speler (geel)
  goalkeeper      // Keeper (groen)
}

enum EquipmentType {
  cone,           // Kegel
  ball,           // Bal
  smallGoal,      // Klein doel
  largeGoal,      // Groot doel
  pole,           // Paal
  mannequin,      // Pop
  ladder,         // Ladder
  hurdle          // Horde
}

enum LineType {
  pass,           // Pass (doorgetrokken lijn met pijl)
  run,            // Looplijn (gestreepte lijn)
  dribble,        // Dribbel (golvende lijn)
  shot,           // Schot (dikke lijn met pijl)
  defensive,      // Verdedigende beweging (gestippelde lijn)
  ballPath        // Bal beweging (dunne lijn)
}
