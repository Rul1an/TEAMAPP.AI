// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports (refactored):
// No longer need heavy model imports here
import 'lineup_builder/lineup_builder_controller.dart';
import 'lineup_builder/formation_toolbar.dart';
import 'lineup_builder/drawing_toolbar.dart';
import 'lineup_builder/field_canvas.dart';
import 'lineup_builder/field_positions_widget.dart';
import 'lineup_builder/bench_player_list.dart';

class LineupBuilderScreen extends ConsumerStatefulWidget {
  const LineupBuilderScreen({
    super.key,
    this.matchId,
  });
  final String? matchId;

  @override
  ConsumerState<LineupBuilderScreen> createState() =>
      _LineupBuilderScreenState();
}

class _LineupBuilderScreenState extends ConsumerState<LineupBuilderScreen> {
  @override
  void initState() {
    super.initState();
    final ctrl =
        ref.read(lineupBuilderControllerProvider); // create controller early
    ctrl.loadTemplates();
    if (widget.matchId != null) {
      ctrl.loadMatch(widget.matchId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.watch(lineupBuilderControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ctrl.isDrawingMode ? 'Tactical Board' : 'Opstelling'),
        actions: [
          IconButton(
            icon: Icon(ctrl.isDrawingMode ? Icons.sports_soccer : Icons.edit),
            onPressed: () =>
                ref.read(lineupBuilderControllerProvider).toggleDrawingMode(),
          ),
          const DrawingToolbar(),
        ],
      ),
      body: Column(
        children: const [
          FormationToolbar(),
          Expanded(child: FieldCanvas()),
          FieldPositionsWidget(),
          const Expanded(child: BenchPlayerList()),
        ],
      ),
    );
  }
}
