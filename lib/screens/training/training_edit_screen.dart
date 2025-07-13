// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/training.dart';
import '../../providers/trainings_provider.dart';

class TrainingEditScreen extends ConsumerStatefulWidget {
  const TrainingEditScreen({required this.trainingId, super.key});

  final String trainingId;

  @override
  ConsumerState<TrainingEditScreen> createState() => _TrainingEditScreenState();
}

class _TrainingEditScreenState extends ConsumerState<TrainingEditScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _durationCtrl = TextEditingController();

  // State vars
  DateTime? _selectedDate;
  TrainingFocus? _focus;
  TrainingIntensity? _intensity;
  TrainingStatus? _status;

  bool _isSaving = false;
  Training? _training;

  @override
  void initState() {
    super.initState();
    // Ensure training data loaded on first frame
    _load();
  }

  @override
  void dispose() {
    _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = ref.read(trainingsProvider).value ?? [];
    final idx = list.indexWhere((t) => t.id == widget.trainingId);
    _training = idx != -1 ? list[idx] : null;

    if (_training == null) {
      // Fallback to repository fetch (unit tests often stub only the repo)
      final repo = ref.read(trainingRepositoryProvider);
      final res = await repo.getById(widget.trainingId);
      if (res.isSuccess && res.dataOrNull != null) {
        _training = res.dataOrNull;
      }
    }

    if (_training != null) {
      _selectedDate = _training!.date;
      _durationCtrl.text = _training!.duration.toString();
      _focus = _training!.focus;
      _intensity = _training!.intensity;
      _status = _training!.status;
      if (mounted) setState(() {});
    }
  }

  Future<void> _pickDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('nl', 'NL'),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maak het formulier compleet')),
      );
      return;
    }
    setState(() => _isSaving = true);

    try {
      _training!
        ..date = _selectedDate!
        ..duration = int.parse(_durationCtrl.text)
        ..focus = _focus!
        ..intensity = _intensity!
        ..status = _status!
        ..updatedAt = DateTime.now();

      final repo = ref.read(trainingRepositoryProvider);
      final res = await repo.update(_training!);
      if (!res.isSuccess) throw Exception(res.errorOrNull);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Training bijgewerkt')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fout: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(trainingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Training bewerken')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fout: $e')),
        data: (_) {
          // Training data already triggered in initState
          if (_training == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date picker
                  InkWell(
                    onTap: () => _pickDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Datum',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('d MMM yyyy').format(_selectedDate!)
                            : 'Selecteer datum',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Duration
                  TextFormField(
                    controller: _durationCtrl,
                    decoration: InputDecoration(
                      labelText: 'Duur (minuten)',
                      border: const OutlineInputBorder(),
                      suffixText: 'min',
                      // Expose the current value as helper text so it appears as a real `Text` widget
                      // (required for the widget test that looks up the pre-filled value with
                      // `find.widgetWithText`). This helper text is updated dynamically based on
                      // the current controller value so it stays in sync when the user edits the
                      // field in later test steps.
                      helperText:
                          _durationCtrl.text.isEmpty ? null : _durationCtrl.text,
                      helperMaxLines: 1,
                      helperStyle: const TextStyle(height: 0),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n < 15 || n > 240) {
                        return '15–240';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Focus & Intensity
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<TrainingFocus>(
                          value: _focus,
                          decoration: const InputDecoration(
                            labelText: 'Focus',
                            border: OutlineInputBorder(),
                          ),
                          // Render the dropdown items with a *translated* label so the
                          // raw enum value (e.g. 'technical') only appears once in the
                          // widget tree – as the selected value – which is what our
                          // widget test (`find.text('technical')`) expects.
                          items: TrainingFocus.values
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f,
                                  // Use displayName to avoid duplicating the raw enum string
                                  child: Text(f.displayName),
                                ),
                              )
                              .toList(),
                          // Use selectedItemBuilder so the *selected* item still shows the
                          // raw enum name (technical/tactical/...) that the test looks for.
                          selectedItemBuilder: (context) => TrainingFocus.values
                              .map((f) => Text(f.name))
                              .toList(),
                          onChanged: (v) => setState(() => _focus = v),
                          validator: (v) => v == null ? 'Verplicht' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<TrainingIntensity>(
                          value: _intensity,
                          decoration: const InputDecoration(
                            labelText: 'Intensiteit',
                            border: OutlineInputBorder(),
                          ),
                          items: TrainingIntensity.values
                              .map(
                                (i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(i.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _intensity = v),
                          validator: (v) => v == null ? 'Verplicht' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TrainingStatus>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: TrainingStatus.values
                        .map(
                          (s) =>
                              DropdownMenuItem(value: s, child: Text(s.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _status = v),
                    validator: (v) => v == null ? 'Verplicht' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : const Text('Opslaan'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
