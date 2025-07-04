// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../models/player.dart';
import '../../providers/players_provider.dart';

class AddPlayerScreen extends ConsumerStatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  ConsumerState<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends ConsumerState<AddPlayerScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Speler Toevoegen'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                _buildSectionHeader('Persoonlijke Informatie'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'firstName',
                        decoration: const InputDecoration(
                          labelText: 'Voornaam',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Voornaam is verplicht';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'lastName',
                        decoration: const InputDecoration(
                          labelText: 'Achternaam',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Achternaam is verplicht';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'jerseyNumber',
                        decoration: const InputDecoration(
                          labelText: 'Rugnummer',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Rugnummer is verplicht';
                          }
                          final number = int.tryParse(value);
                          if (number == null || number < 1 || number > 99) {
                            return 'Rugnummer moet tussen 1 en 99 zijn';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderDateTimePicker(
                        name: 'birthDate',
                        decoration: const InputDecoration(
                          labelText: 'Geboortedatum',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        inputType: InputType.date,
                        format: DateFormat('dd-MM-yyyy'),
                        lastDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 20)),
                        validator: (value) {
                          if (value == null) {
                            return 'Geboortedatum is verplicht';
                          }
                          final age =
                              DateTime.now().difference(value).inDays ~/ 365;
                          if (age < 15 || age > 18) {
                            return 'Speler moet tussen 15 en 18 jaar oud zijn';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Football Information Section
                _buildSectionHeader('Voetbal Informatie'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderDropdown<Position>(
                        name: 'position',
                        decoration: const InputDecoration(
                          labelText: 'Positie',
                          prefixIcon: Icon(Icons.sports_soccer),
                        ),
                        items: Position.values
                            .map(
                              (position) => DropdownMenuItem(
                                value: position,
                                child: Text(_getPositionText(position)),
                              ),
                            )
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Positie is verplicht';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderDropdown<PreferredFoot>(
                        name: 'preferredFoot',
                        decoration: const InputDecoration(
                          labelText: 'Voorkeursbeen',
                          prefixIcon: Icon(Icons.directions_walk),
                        ),
                        items: PreferredFoot.values
                            .map(
                              (foot) => DropdownMenuItem(
                                value: foot,
                                child: Text(_getPreferredFootText(foot)),
                              ),
                            )
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Voorkeursbeen is verplicht';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Physical Information Section
                _buildSectionHeader('Fysieke Informatie'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'height',
                        decoration: const InputDecoration(
                          labelText: 'Lengte (cm)',
                          prefixIcon: Icon(Icons.height),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lengte is verplicht';
                          }
                          final height = double.tryParse(value);
                          if (height == null || height < 140 || height > 220) {
                            return 'Lengte moet tussen 140 en 220 cm zijn';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'weight',
                        decoration: const InputDecoration(
                          labelText: 'Gewicht (kg)',
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,1}'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gewicht is verplicht';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight < 40 || weight > 120) {
                            return 'Gewicht moet tussen 40 en 120 kg zijn';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Speler Toevoegen'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSectionHeader(String title) => Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isSubmitting = true);

      try {
        final values = _formKey.currentState!.value;

        final player = Player()
          ..firstName = values['firstName'] as String
          ..lastName = values['lastName'] as String
          ..jerseyNumber = int.parse(values['jerseyNumber'] as String)
          ..birthDate = DateTime.parse(values['birthDate'] as String)
          ..position = Position.values.firstWhere(
            (e) => e.name == values['position'] as String,
            orElse: () => Position.midfielder,
          )
          ..preferredFoot = PreferredFoot.values.firstWhere(
            (e) => e.name == values['preferredFoot'] as String,
            orElse: () => PreferredFoot.right,
          )
          ..height = double.parse(values['height'] as String)
          ..weight = double.parse(values['weight'] as String)
          ..matchesPlayed = 0
          ..goals = 0
          ..assists = 0
          ..yellowCards = 0
          ..redCards = 0
          ..trainingsAttended = 0
          ..trainingsTotal = 0;

        await ref.read(playersNotifierProvider.notifier).addPlayer(player);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${player.firstName} ${player.lastName} is toegevoegd'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fout bij toevoegen speler: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  String _getPositionText(Position position) {
    switch (position) {
      case Position.goalkeeper:
        return 'Keeper';
      case Position.defender:
        return 'Verdediger';
      case Position.midfielder:
        return 'Middenvelder';
      case Position.forward:
        return 'Aanvaller';
    }
  }

  String _getPreferredFootText(PreferredFoot foot) {
    switch (foot) {
      case PreferredFoot.left:
        return 'Links';
      case PreferredFoot.right:
        return 'Rechts';
      case PreferredFoot.both:
        return 'Beide';
    }
  }
}
