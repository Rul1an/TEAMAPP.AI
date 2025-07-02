import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/training_session/field_diagram.dart';
import '../../providers/field_diagram_provider.dart';

class FieldDiagramToolbar extends ConsumerStatefulWidget {
  const FieldDiagramToolbar({
    super.key,
    required this.selectedTool,
    required this.onToolSelected,
  });
  final DiagramTool selectedTool;
  final void Function(DiagramTool) onToolSelected;

  @override
  ConsumerState<FieldDiagramToolbar> createState() =>
      _FieldDiagramToolbarState();
}

class _FieldDiagramToolbarState extends ConsumerState<FieldDiagramToolbar> {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          _buildToolButton(
            icon: Icons.pan_tool,
            tool: DiagramTool.select,
            tooltip: 'Selecteren/Verplaatsen',
            context: context,
          ),
          const SizedBox(width: 8),
          _buildToolButton(
            icon: Icons.person,
            tool: DiagramTool.player,
            tooltip: 'Speler Plaatsen',
            context: context,
          ),
          const SizedBox(width: 8),
          _buildToolButton(
            icon: Icons.circle_outlined,
            tool: DiagramTool.equipment,
            tooltip: 'Equipment Plaatsen',
            context: context,
          ),
          const SizedBox(width: 8),
          _buildToolButton(
            icon: Icons.arrow_forward,
            tool: DiagramTool.line,
            tooltip: 'Bewegingslijn Tekenen',
            context: context,
          ),
          if (widget.selectedTool == DiagramTool.line) ...[
            const SizedBox(width: 16),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLineTypeButton(
                      LineType.pass, Colors.green, Icons.arrow_forward,),
                  const SizedBox(width: 4),
                  _buildLineTypeButton(
                      LineType.run, Colors.blue, Icons.directions_run,),
                  const SizedBox(width: 4),
                  _buildLineTypeButton(
                      LineType.dribble, Colors.orange, Icons.sports_soccer,),
                  const SizedBox(width: 4),
                  _buildLineTypeButton(
                      LineType.shot, Colors.red, Icons.sports_hockey,),
                  const SizedBox(width: 4),
                  _buildLineTypeButton(
                      LineType.defensive, Colors.purple, Icons.shield,),
                ],
              ),
            ),
          ],
          const SizedBox(width: 8),
          _buildToolButton(
            icon: Icons.text_fields,
            tool: DiagramTool.text,
            tooltip: 'Tekst Toevoegen',
            context: context,
          ),
          const SizedBox(width: 8),
          _buildToolButton(
            icon: Icons.crop_square,
            tool: DiagramTool.area,
            tooltip: 'Gebied Markeren',
            context: context,
          ),
          const SizedBox(width: 8),
          _buildFormationButton(context),
          const SizedBox(width: 8),
          _buildToolButton(
            icon: Icons.delete,
            tool: DiagramTool.delete,
            tooltip: 'Verwijderen',
            context: context,
            color: Colors.red,
          ),
          const Spacer(),
          _buildPlayerTypeSelector(),
          const SizedBox(width: 8),
          _buildEquipmentTypeSelector(),
        ],
      );

  Widget _buildToolButton({
    required IconData icon,
    required DiagramTool tool,
    required String tooltip,
    required BuildContext context,
    Color? color,
  }) {
    final isSelected = widget.selectedTool == tool;

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: isSelected ? Colors.green[100] : Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => widget.onToolSelected(tool),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border:
                isSelected ? Border.all(color: Colors.green, width: 2) : null,
          ),
          child: Icon(
            icon,
            size: 24,
            color: color ?? (isSelected ? Colors.green[700] : Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  // 🔧 CASCADE OPERATOR DOCUMENTATION: Widget Builder Pattern
  // This PopupMenuButton with nested Container pattern demonstrates where
  // cascade notation could improve readability for complex widget building.
  //
  // **CURRENT PATTERN**: PopupMenuButton(properties) (single constructor)
  // **RECOMMENDED**: PopupMenuButton()..property = value (cascade notation)
  //
  // **CASCADE BENEFITS FOR WIDGET BUILDERS**:
  // ✅ Separates widget creation from property assignment
  // ✅ Easier to conditionally set properties
  // ✅ Better readability for complex widget configurations
  // ✅ Maintains Flutter widget building patterns
  //
  Widget _buildPlayerTypeSelector() {
    final state = ref.watch(fieldDiagramProvider);
    final selectedPlayerType = state.selectedPlayerType;

    // Get color based on selected player type
    Color playerIconColor;
    switch (selectedPlayerType) {
      case PlayerType.attacking:
        playerIconColor = Colors.blue;
        break;
      case PlayerType.defending:
        playerIconColor = Colors.red;
        break;
      case PlayerType.neutral:
        playerIconColor = Colors.yellow[700]!;
        break;
      case PlayerType.goalkeeper:
        playerIconColor = Colors.green;
        break;
    }

    return PopupMenuButton<PlayerType>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.selectedTool == DiagramTool.player
              ? Colors.green[100]
              : Colors.grey[100],
          border: widget.selectedTool == DiagramTool.player
              ? Border.all(color: Colors.green)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: playerIconColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
      tooltip: 'Speler Type: ${_getPlayerTypeText(selectedPlayerType)}',
      onSelected: _selectPlayerType,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: PlayerType.attacking,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Aanvaller'),
            ],
          ),
        ),
        PopupMenuItem(
          value: PlayerType.defending,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Verdediger'),
            ],
          ),
        ),
        PopupMenuItem(
          value: PlayerType.neutral,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Neutraal'),
            ],
          ),
        ),
        PopupMenuItem(
          value: PlayerType.goalkeeper,
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Keeper'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentTypeSelector() {
    final state = ref.watch(fieldDiagramProvider);
    final selectedEquipmentType = state.selectedEquipmentType;

    // Get icon and color based on selected equipment type
    IconData equipmentIcon;
    Color equipmentColor;
    switch (selectedEquipmentType) {
      case EquipmentType.cone:
        equipmentIcon = Icons.change_history;
        equipmentColor = Colors.orange;
        break;
      case EquipmentType.ball:
        equipmentIcon = Icons.sports_soccer;
        equipmentColor = Colors.black;
        break;
      case EquipmentType.smallGoal:
        equipmentIcon = Icons.sports_soccer;
        equipmentColor = Colors.blue;
        break;
      case EquipmentType.largeGoal:
        equipmentIcon = Icons.crop_landscape;
        equipmentColor = Colors.blue;
        break;
      case EquipmentType.ladder:
        equipmentIcon = Icons.grid_3x3;
        equipmentColor = Colors.amber;
        break;
      case EquipmentType.hurdle:
        equipmentIcon = Icons.trending_up;
        equipmentColor = Colors.red;
        break;
      case EquipmentType.pole:
        equipmentIcon = Icons.straight;
        equipmentColor = Colors.grey;
        break;
      case EquipmentType.mannequin:
        equipmentIcon = Icons.person;
        equipmentColor = Colors.brown;
        break;
    }

    return PopupMenuButton<EquipmentType>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.selectedTool == DiagramTool.equipment
              ? Colors.green[100]
              : Colors.grey[100],
          border: widget.selectedTool == DiagramTool.equipment
              ? Border.all(color: Colors.green)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              equipmentIcon,
              size: 16,
              color: equipmentColor,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
      tooltip:
          'Equipment Type: ${_getEquipmentTypeText(selectedEquipmentType)}',
      onSelected: _selectEquipmentType,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: EquipmentType.cone,
          child: Row(
            children: [
              Icon(Icons.change_history, color: Colors.orange),
              SizedBox(width: 8),
              Text('Pion'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.ball,
          child: Row(
            children: [
              Icon(Icons.sports_soccer, color: Colors.black),
              SizedBox(width: 8),
              Text('Bal'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.smallGoal,
          child: Row(
            children: [
              Icon(Icons.sports_soccer, color: Colors.blue),
              SizedBox(width: 8),
              Text('Goal'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.largeGoal,
          child: Row(
            children: [
              Icon(Icons.crop_landscape, color: Colors.blue),
              SizedBox(width: 8),
              Text('Groot Goal'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.ladder,
          child: Row(
            children: [
              Icon(Icons.grid_3x3, color: Colors.amber),
              SizedBox(width: 8),
              Text('Ladder'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.hurdle,
          child: Row(
            children: [
              Icon(Icons.trending_up, color: Colors.red),
              SizedBox(width: 8),
              Text('Horde'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.pole,
          child: Row(
            children: [
              Icon(Icons.straight, color: Colors.grey),
              SizedBox(width: 8),
              Text('Paal'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: EquipmentType.mannequin,
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.brown),
              SizedBox(width: 8),
              Text('Pop'),
            ],
          ),
        ),
      ],
    );
  }

  void _selectPlayerType(PlayerType playerType) {
    ref.read(fieldDiagramProvider.notifier).selectPlayerType(playerType);
  }

  void _selectEquipmentType(EquipmentType equipmentType) {
    ref.read(fieldDiagramProvider.notifier).selectEquipmentType(equipmentType);
  }

  Widget _buildLineTypeButton(LineType lineType, Color color, IconData icon) {
    final state = ref.watch(fieldDiagramProvider);
    final isSelected = state.selectedLineType == lineType;

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _selectLineType(lineType),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: color, width: 2)
                : Border.all(color: Colors.grey[300]!),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
      ),
    );
  }

  void _selectLineType(LineType lineType) {
    ref.read(fieldDiagramProvider.notifier).selectLineType(lineType);
  }

  String _getPlayerTypeText(PlayerType playerType) {
    switch (playerType) {
      case PlayerType.attacking:
        return 'Aanvaller';
      case PlayerType.defending:
        return 'Verdediger';
      case PlayerType.neutral:
        return 'Neutraal';
      case PlayerType.goalkeeper:
        return 'Keeper';
    }
  }

  String _getEquipmentTypeText(EquipmentType equipmentType) {
    switch (equipmentType) {
      case EquipmentType.cone:
        return 'Pion';
      case EquipmentType.ball:
        return 'Bal';
      case EquipmentType.smallGoal:
        return 'Goal';
      case EquipmentType.largeGoal:
        return 'Groot Goal';
      case EquipmentType.ladder:
        return 'Ladder';
      case EquipmentType.hurdle:
        return 'Horde';
      case EquipmentType.pole:
        return 'Paal';
      case EquipmentType.mannequin:
        return 'Pop';
    }
  }

  Widget _buildFormationButton(BuildContext context) {
    // TODO(team): implement proper formation selector. For now this placeholder avoids runtime errors in tests.
    return _buildToolButton(
      icon: Icons.grid_view,
      tool: DiagramTool.select,
      tooltip: 'Formatie (coming soon)',
      context: context,
    );
  }
}

// Custom painters for line type visualization
class DashedLinePainter extends CustomPainter {
  DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedLinePainter extends CustomPainter {
  DottedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    const dotSpacing = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX, size.height / 2),
        1,
        paint,
      );
      startX += dotSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WavyLinePainter extends CustomPainter {
  WavyLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(0, size.height / 2);

    for (double x = 0; x < size.width; x += 5) {
      final y = size.height / 2 + 3 * (x.remainder(10) < 5 ? 1 : -1);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
