// Flutter imports:
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../providers/import_providers.dart';
import '../../services/player_roster_import_service.dart';
import '../../widgets/import/player_roster_review_table.dart';
import '../../widgets/training/session_wizard_stepper.dart';
import '../../utils/app_logger.dart';

class PlayerRosterImportWizardScreen extends ConsumerStatefulWidget {
  const PlayerRosterImportWizardScreen({super.key});

  @override
  ConsumerState<PlayerRosterImportWizardScreen> createState() => _State();
}

class _State extends ConsumerState<PlayerRosterImportWizardScreen> {
  late final PlayerRosterImportService _service;
  int _step = 0;
  Uint8List? _bytes;
  String? _ext;
  PlayerImportPreview? _preview;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _service = ref.read(playerRosterImportServiceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Bestand', 'Preview', 'Bevestigen'];
    return Scaffold(
      appBar: AppBar(title: const Text('Importeer Spelers')),
      body: Column(
        children: [
          SessionWizardStepper(currentStep: _step, steps: steps),
          const SizedBox(height: 16),
          Expanded(child: _buildContent()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_step > 0)
                  ElevatedButton(onPressed: () => setState(() => _step--), child: const Text('Vorige')),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_step == 2 ? 'Importeer' : 'Volgende'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_step) {
      case 0:
        return Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Selecteer CSV/XLSX'),
            onPressed: _pick,
          ),
        );
      case 1:
        if (_loading) return const Center(child: CircularProgressIndicator());
        if (_preview == null) return const Center(child: Text('Geen preview'));
        return PlayerRosterReviewTable(preview: _preview!);
      case 2:
        return _preview == null
            ? const Center(child: Text('Niets te importeren'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nieuw: ${_preview!.newCount}'),
                    Text('Duplicaten: ${_preview!.dupCount}'),
                    Text('Fouten: ${_preview!.errorCount}'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Import uitvo...'),
                      onPressed: _import,
                    ),
                  ],
                ),
              );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv', 'xlsx', 'xls'], withData: true);
    if (res == null || res.files.isEmpty) return;
    setState(() {
      _bytes = res.files.first.bytes;
      _ext = res.files.first.extension;
      _step = 1;
    });
    await _generatePreview();
  }

  Future<void> _generatePreview() async {
    if (_bytes == null || _ext == null) return;
    setState(() => _loading = true);
    try {
      final prev = await _service.previewFile(_bytes!, _ext!);
      setState(() => _preview = prev);
    } catch (e, st) {
      AppLogger.e('player preview', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fout: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _next() async {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      await _import();
    }
  }

  Future<void> _import() async {
    if (_preview == null) return;
    final res = await _service.persist(_preview!);
    res.when(
      success: (count) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$count spelers geïmporteerd'))),
      failure: (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fout: ${err.message}'))),
    );
  }
}