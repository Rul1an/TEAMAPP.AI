// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Project imports:
import '../../models/training.dart';
import '../../providers/trainings_provider.dart';
import '../../utils/validators/training_validators.dart';

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

    // Ensure Dutch locale date symbols are available during tests.
    initializeDateFormatting('nl_NL').catchError((_) {});
  }

  @override
  void dispose() {
    _durationCtrl.dispose();
    super.dispose();
  }

  void _load(List<Training> list) {
    _training = list.firstWhere(
      (t) => t.id == widget.trainingId,
      orElse: Training.new,
    );
    if (_training != null && _training!.id.isNotEmpty) {
      _selectedDate = _training!.date;
      _durationCtrl.text = _training!.duration.toString();
      _focus = _training!.focus;
      _intensity = _training!.intensity;
      _status = _training!.status;
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
    if (validateDate(_selectedDate) != null ||
        !_formKey.currentState!.validate()) {
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

  String _formatDate(DateTime date) {
    try {
      return DateFormat('d MMM yyyy', 'nl_NL').format(date);
    } catch (_) {
      return DateFormat('d MMM yyyy').format(date);
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
        data: (trainings) {
          _load(trainings);
          if (_training == null || _training!.id.isEmpty) {
            return const Center(child: Text('Training niet gevonden'));
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
                            ? _formatDate(_selectedDate!)
                            : 'Selecteer datum',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Duration
                  TextFormField(
                    controller: _durationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Duur (minuten)',
                      border: OutlineInputBorder(),
                      suffixText: 'min',
                    ),
                    keyboardType: TextInputType.number,
                    validator: validateDuration,
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
                          items: TrainingFocus.values
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(f.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _focus = v),
                          validator: (v) => validateRequired(v, 'Focus'),
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
                          validator: (v) => validateRequired(v, 'Intensiteit'),
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
                    validator: (v) => validateRequired(v, 'Status'),
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
