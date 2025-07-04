import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/common/tactical_drawing_canvas.dart';
import 'lineup_builder_controller.dart';

class DrawingToolbar extends ConsumerWidget {
  const DrawingToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(lineupBuilderControllerProvider);
    if (!ctrl.isDrawingMode) return const SizedBox.shrink();
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: ctrl.selectedDrawingTool == DrawingTool.arrow
                ? Colors.blue
                : null,
          ),
          onPressed: () =>
              ref.read(lineupBuilderControllerProvider).selectDrawingTool(
                    DrawingTool.arrow,
                  ),
        ),
        IconButton(
          icon: Icon(
            Icons.linear_scale,
            color: ctrl.selectedDrawingTool == DrawingTool.line
                ? Colors.blue
                : null,
          ),
          onPressed: () =>
              ref.read(lineupBuilderControllerProvider).selectDrawingTool(
                    DrawingTool.line,
                  ),
        ),
      ],
    );
  }
}
