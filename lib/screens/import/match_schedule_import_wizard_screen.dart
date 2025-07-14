// Flutter imports:
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../services/match_schedule_import_service.dart';
import '../../widgets/import/match_schedule_review_table.dart';
import '../../widgets/training/session_wizard_stepper.dart';
import '../../utils/app_logger.dart';
import '../../providers/import_providers.dart';

class MatchScheduleImportWizardScreen extends ConsumerStatefulWidget {
  const MatchScheduleImportWizardScreen({super.key});

  @override
  ConsumerState<MatchScheduleImportWizardScreen> createState() => _State();
}

class _State extends ConsumerState<MatchScheduleImportWizardScreen> {
  int _currentStep = 0;
  Uint8List? _fileBytes;
  String? _fileExt;
  ImportPreview? _preview;
  bool _isLoading = false;

  late final MatchScheduleImportService _importService;

  @override
  void initState() {
    super.initState();
    _importService = ref.read(matchScheduleImportServiceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Bestand', 'Preview', 'Bevestigen'];

    return Scaffold(
      appBar: AppBar(title: const Text('Importeer Wedstrijdoverzicht')),
      body: Column(
        children: [
          SessionWizardStepper(currentStep: _currentStep, steps: steps),
          const SizedBox(height: 16),
          Expanded(child: _buildStepContent()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text('Vorige'),
                  ),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_currentStep == steps.length - 1 ? 'Importeer' : 'Volgende'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Selecteer CSV of XLSX'),
            onPressed: _pickFile,
          ),
        );
      case 1:
        if (_isLoading) return const Center(child: CircularProgressIndicator());
        if (_preview == null) return const Center(child: Text('Geen preview beschikbaar'));
        return MatchScheduleReviewTable(preview: _preview!);
      case 2:
        if (_preview == null) return const Center(child: Text('Niets om te importeren'));
        return _buildConfirmation();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildConfirmation() => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nieuw: ${_preview!.newCount}'),
        Text('Duplicaten: ${_preview!.duplicateCount}'),
        Text('Fouten: ${_preview!.errorCount}'),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Import uitvoeren'),
          onPressed: _import,
        ),
      ],
    ),
  );

  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withData: true,
    );
    if (res == null || res.files.isEmpty) return;
    final file = res.files.first;
    setState(() {
      _fileBytes = file.bytes;
      _fileExt = file.extension;
      _currentStep = 1;
    });
    await _generatePreview();
  }

  Future<void> _generatePreview() async {
    if (_fileBytes == null || _fileExt == null) return;
    setState(() => _isLoading = true);
    try {
      final preview = await _importService.previewFile(_fileBytes!, _fileExt!);
      setState(() => _preview = preview);
    } catch (e, st) {
      AppLogger.e('Preview error', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij genereren preview: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _next() async {
    if (_currentStep == 1 && _preview == null) return; // cannot continue
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      await _import();
    }
  }

  Future<void> _import() async {
    if (_preview == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Importeren...')),
    );
    final result = await _importService.persist(_preview!);
    result.when(
      success: (count) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count wedstrijden geïmporteerd')),
        );
        Navigator.of(context).pop();
      },
      failure: (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij importeren: ${err.message}')),
        );
      },
    );
  }
}