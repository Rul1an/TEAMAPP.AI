import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/match.dart';
import '../../providers/matches_provider.dart';

class AddMatchScreen extends ConsumerStatefulWidget {
  const AddMatchScreen({super.key});

  @override
  ConsumerState<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends ConsumerState<AddMatchScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Wedstrijd Toevoegen'),
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
              // Match Information Section
              _buildSectionHeader('Wedstrijd Informatie'),
              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'opponent',
                decoration: const InputDecoration(
                  labelText: 'Tegenstander',
                  prefixIcon: Icon(Icons.sports_soccer),
                  hintText: 'bijv. Ajax JO17',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tegenstander is verplicht';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'date',
                      decoration: const InputDecoration(
                        labelText: 'Datum',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      inputType: InputType.date,
                      format: DateFormat('dd-MM-yyyy'),
                      initialValue: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      validator: (value) {
                        if (value == null) {
                          return 'Datum is verplicht';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'time',
                      decoration: const InputDecoration(
                        labelText: 'Tijd',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      inputType: InputType.time,
                      format: DateFormat('HH:mm'),
                      initialValue: DateTime.now(),
                      validator: (value) {
                        if (value == null) {
                          return 'Tijd is verplicht';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Location and Competition Section
              _buildSectionHeader('Locatie & Competitie'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown<Location>(
                      name: 'location',
                      decoration: const InputDecoration(
                        labelText: 'Thuis/Uit',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      items: Location.values.map((location) => DropdownMenuItem(
                          value: location,
                          child: Text(_getLocationText(location)),
                        ),).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Locatie is verplicht';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderDropdown<Competition>(
                      name: 'competition',
                      decoration: const InputDecoration(
                        labelText: 'Competitie',
                        prefixIcon: Icon(Icons.emoji_events),
                      ),
                      items: Competition.values.map((competition) => DropdownMenuItem(
                          value: competition,
                          child: Text(_getCompetitionText(competition)),
                        ),).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Competitie is verplicht';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'venue',
                decoration: const InputDecoration(
                  labelText: 'Stadion/Veld',
                  prefixIcon: Icon(Icons.stadium),
                  hintText: 'bijv. Sportpark De Toekomst',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stadion/Veld is verplicht';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'referee',
                decoration: const InputDecoration(
                  labelText: 'Scheidsrechter (optioneel)',
                  prefixIcon: Icon(Icons.sports),
                ),
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
                      : const Text('Wedstrijd Toevoegen'),
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

        // Combine date and time
        final date = values['date'] as DateTime;
        final time = values['time'] as DateTime;
        final matchDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        final match = Match()
          ..opponent = values['opponent']
          ..date = matchDateTime
          ..location = values['location']
          ..competition = values['competition']
          ..venue = values['venue']
          ..referee = values['referee']
          ..status = MatchStatus.scheduled;

        await ref.read(matchesNotifierProvider.notifier).addMatch(match);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wedstrijd tegen ${match.opponent} is toegevoegd'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fout bij toevoegen wedstrijd: $e'),
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

  String _getLocationText(Location location) {
    switch (location) {
      case Location.home:
        return 'Thuis';
      case Location.away:
        return 'Uit';
    }
  }

  String _getCompetitionText(Competition competition) {
    switch (competition) {
      case Competition.league:
        return 'Competitie';
      case Competition.cup:
        return 'Beker';
      case Competition.friendly:
        return 'Vriendschappelijk';
      case Competition.tournament:
        return 'Toernooi';
    }
  }
}
