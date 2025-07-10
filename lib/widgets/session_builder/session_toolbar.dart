import 'package:flutter/material.dart';

import '../../models/training_session/training_session.dart';

class SessionToolbar extends StatelessWidget {
  const SessionToolbar({
    required this.session,
    required this.onDateChanged,
    required this.onTypeChanged,
    super.key,
  });

  final TrainingSession session;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TrainingType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date picker
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: session.date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) onDateChanged(picked);
            },
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${session.date.day}/${session.date.month}/${session.date.year}',
                ),
              ],
            ),
          ),
        ),
        // Type dropdown
        DropdownButton<TrainingType>(
          value: session.type,
          onChanged: (t) {
            if (t != null) onTypeChanged(t);
          },
          items: TrainingType.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
              .toList(),
        ),
      ],
    );
  }
}
