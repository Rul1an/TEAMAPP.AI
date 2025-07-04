import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/team.dart';
import 'lineup_builder_controller.dart';

class FormationToolbar extends ConsumerWidget {
  const FormationToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(lineupBuilderControllerProvider);
    return DropdownButton<Formation>(
      value: controller.selectedFormation,
      onChanged: (f) => ref
          .read(lineupBuilderControllerProvider)
          .selectFormation(f ?? controller.selectedFormation),
      items: Formation.values
          .map(
            (f) => DropdownMenuItem<Formation>(
              value: f,
              child: Text(_label(f)),
            ),
          )
          .toList(),
    );
  }

  String _label(Formation f) {
    switch (f) {
      case Formation.fourThreeThree:
        return '4-3-3';
      case Formation.fourFourTwo:
        return '4-4-2';
      case Formation.threeForThree:
        return '3-4-3';
      case Formation.fourTwoThreeOne:
        return '4-2-3-1';
      case Formation.fourFourTwoDiamond:
        return '4-4-2 (Ruit)';
      case Formation.fourThreeThreeDefensive:
        return '4-3-3 (Def)';
    }
  }
}
