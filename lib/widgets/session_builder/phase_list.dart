import 'package:flutter/material.dart';

import '../../models/training_session/session_phase.dart';

class PhaseList extends StatelessWidget {
  const PhaseList({required this.phases, super.key});

  final List<SessionPhase> phases;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final p = phases[index];
        return ListTile(
          leading: Text('${index + 1}.'),
          title: Text(p.name),
          subtitle: Text(_formatTimeRange(p.startTime, p.endTime)),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: phases.length,
    );
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    String fmt(DateTime t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return '${fmt(start)} - ${fmt(end)}';
  }
}
