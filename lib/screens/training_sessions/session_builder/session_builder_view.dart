import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/session_builder_controller.dart';
import '../../../widgets/session_builder/phase_list.dart';
import '../../../widgets/session_builder/session_toolbar.dart';

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
          SessionToolbar(
            session: session,
            onDateChanged: (d) {/* TODO hook into controller */},
            onTypeChanged: (t) {/* TODO */},
          ),
          const Divider(),
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
          PhaseList(phases: state.phases),
        ],
      ),
    );
  }
}
