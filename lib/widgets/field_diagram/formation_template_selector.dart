// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/training_session/field_diagram.dart';

class FormationTemplateSelector extends StatefulWidget {
  const FormationTemplateSelector({
    required this.onFormationSelected,
    super.key,
  });
  final void Function(List<PlayerMarker>) onFormationSelected;

  @override
  State<FormationTemplateSelector> createState() =>
      _FormationTemplateSelectorState();
}

class _FormationTemplateSelectorState extends State<FormationTemplateSelector> {
  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.sports_soccer, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Kies Opstelling',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _formations.length,
                  itemBuilder: (context, index) {
                    final formation = _formations[index];
                    return _buildFormationCard(formation);
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildFormationCard(FormationData formation) => Card(
        elevation: 2,
        child: InkWell(
          onTap: () => _selectFormation(formation),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  formation.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: CustomPaint(
                      painter: FormationPreviewPainter(formation.positions),
                      size: Size.infinite,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formation.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );

  void _selectFormation(FormationData formation) {
    final players = [
      for (int i = 0; i < formation.positions.length; i++)
        PlayerMarker(
          id: 'player_${i + 1}',
          position: formation.positions[i],
          type: PlayerType.attacking,
          label: '${i + 1}',
        ),
    ];

    widget.onFormationSelected(players);
    Navigator.pop(context);
  }

  static final List<FormationData> _formations = [
    const FormationData(
      name: '4-3-3',
      description: 'Aanvallende opstelling',
      positions: [
        Position(50, 90), // Keeper
        Position(20, 70), Position(35, 75), Position(65, 75),
        Position(80, 70), // Defense
        Position(30, 50), Position(50, 45), Position(70, 50), // Midfield
        Position(20, 25), Position(50, 20), Position(80, 25), // Attack
      ],
    ),
    const FormationData(
      name: '4-4-2',
      description: 'Gebalanceerde opstelling',
      positions: [
        Position(50, 90), // Keeper
        Position(20, 70), Position(35, 75), Position(65, 75),
        Position(80, 70), // Defense
        Position(20, 50), Position(35, 45), Position(65, 45),
        Position(80, 50), // Midfield
        Position(40, 20), Position(60, 20), // Attack
      ],
    ),
    const FormationData(
      name: '4-2-3-1',
      description: 'Moderne opstelling',
      positions: [
        Position(50, 90), // Keeper
        Position(20, 70), Position(35, 75), Position(65, 75),
        Position(80, 70), // Defense
        Position(35, 55), Position(65, 55), // CDM
        Position(20, 35), Position(50, 30), Position(80, 35), // CAM/Wings
        Position(50, 15), // ST
      ],
    ),
    const FormationData(
      name: 'Training 7v7',
      description: 'Voor training',
      positions: [
        Position(50, 85), // Keeper
        Position(25, 65), Position(50, 70), Position(75, 65), // Defense
        Position(35, 45), Position(65, 45), // Midfield
        Position(50, 25), // Attack
      ],
    ),
  ];
}

class FormationData {
  const FormationData({
    required this.name,
    required this.description,
    required this.positions,
  });
  final String name;
  final String description;
  final List<Position> positions;
}

class FormationPreviewPainter extends CustomPainter {
  FormationPreviewPainter(this.positions);
  final List<Position> positions;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw field background
    final fieldPaint = Paint()
      ..color = Colors.green[100]
      ..style = PaintingStyle.fill;

    final fieldRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(fieldRect, fieldPaint);

    // Draw field lines
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas
      ..drawRect(fieldRect, linePaint)
      ..drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        linePaint,
      );

    // Draw players
    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (final position in positions) {
      final x = (position.x / 100) * size.width;
      final y = (position.y / 100) * size.height;
      canvas.drawCircle(Offset(x, y), 3, playerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
