import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/common/tactical_drawing_canvas.dart';
import 'lineup_builder_controller.dart';

class FieldCanvas extends ConsumerWidget {
  const FieldCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(lineupBuilderControllerProvider);
    return TacticalDrawingCanvas(
      drawings: ctrl.tacticalDrawings,
      onDrawingsChanged: (d) {
        ref.read(lineupBuilderControllerProvider).tacticalDrawings = d;
      },
      isDrawingMode: ctrl.isDrawingMode,
      selectedTool: ctrl.selectedDrawingTool,
      selectedColor: ctrl.selectedDrawingColor,
      child: Container(),
    );
  }
}
