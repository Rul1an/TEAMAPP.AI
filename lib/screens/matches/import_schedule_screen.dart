// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../providers/schedule_import_provider.dart';
import '../../services/schedule_import_service.dart';
import '../../models/match_schedule.dart';
import '../../models/match.dart';

class ImportScheduleScreen extends ConsumerWidget {
  const ImportScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleImportNotifierProvider);
    final notifier = ref.read(scheduleImportNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Importeer wedstrijdschema')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(context, state, notifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ScheduleImportState state,
    ScheduleImportNotifier notifier,
  ) {
    switch (state.status) {
      case ImportStatus.idle:
      case ImportStatus.error:
      case ImportStatus.picking:
      case ImportStatus.parsing:
        return Center(
          child: ElevatedButton.icon(
            onPressed: notifier.pickFileAndParse,
            icon: const Icon(Icons.upload_file),
            label: const Text('Selecteer CSV-bestand'),
          ),
        );
      case ImportStatus.ready:
        return _PreviewStep(state: state, notifier: notifier);
      case ImportStatus.importing:
        return const Center(child: CircularProgressIndicator());
      case ImportStatus.done:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              const Text('Import voltooid!'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Terug'),
              ),
            ],
          ),
        );
    }
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({required this.state, required this.notifier});

  final ScheduleImportState state;
  final ScheduleImportNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final unique = state.duplicateResult?.unique ?? [];
    final dupes = state.duplicateResult?.duplicates ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voorbeeld (${unique.length + dupes.length} records)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: [
              ...unique.map((s) => _ScheduleTile(schedule: s)),
              ...dupes
                  .map((s) => _ScheduleTile(schedule: s, isDuplicate: true)),
            ],
          ),
        ),
        if (dupes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${dupes.length} mogelijke duplicaten worden overgeslagen',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.orange),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(
              onPressed: notifier.importUnique,
              child: const Text('Importeer'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleer'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.schedule, this.isDuplicate = false});

  final MatchSchedule schedule;
  final bool isDuplicate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isDuplicate ? Icons.warning : Icons.check,
        color: isDuplicate ? Colors.orange : Colors.green,
      ),
      title: Text(schedule.opponent),
      subtitle: Text(
        '${schedule.dateTime.toLocal().toString().substring(0, 16)} • ${schedule.location == Location.home ? 'Thuis' : 'Uit'}',
      ),
      trailing: isDuplicate
          ? const Text('Dubbel', style: TextStyle(color: Colors.orange))
          : null,
    );
  }
}
