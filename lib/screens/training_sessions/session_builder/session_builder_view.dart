import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/session_builder_controller.dart';

class SessionBuilderView extends ConsumerWidget {
  const SessionBuilderView({super.key, this.sessionId});

  final int? sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBuilderControllerProvider(sessionId));

    if (state.isLoading || state.session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final session = state.session!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Training ${session.trainingNumber}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Datum: ${session.date}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Type: ${session.type.name}'),
          const SizedBox(height: 16),
          Text(
            'Fases (${state.phases.length}):',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...state.phases.map(
            (p) => ListTile(
              title: Text(p.name ?? '—'),
              subtitle: Text(
                _formatTimeRange(p.startTime, p.endTime),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '--';
    final h1 = start.hour.toString().padLeft(2, '0');
    final m1 = start.minute.toString().padLeft(2, '0');
    final h2 = end.hour.toString().padLeft(2, '0');
    final m2 = end.minute.toString().padLeft(2, '0');
    return '$h1:$m1 - $h2:$m2';
  }
}
