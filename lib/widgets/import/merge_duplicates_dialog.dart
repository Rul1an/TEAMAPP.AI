// Flutter imports:
import 'package:flutter/material.dart';

typedef FieldMergeSelectionCallback = void Function(String field, dynamic chosenValue);

/// Simple two-column merge dialog where user picks per-field which value to keep.
class MergeDuplicatesDialog extends StatefulWidget {
  const MergeDuplicatesDialog({
    required this.existing,
    required this.incoming,
    required this.onConfirm,
    super.key,
  });

  final Map<String, dynamic> existing;
  final Map<String, dynamic> incoming;
  final void Function(Map<String, dynamic> merged) onConfirm;

  @override
  State<MergeDuplicatesDialog> createState() => _MergeDuplicatesDialogState();
}

class _MergeDuplicatesDialogState extends State<MergeDuplicatesDialog> {
  late Map<String, dynamic> _merged;
  @override
  void initState() {
    super.initState();
    _merged = {...widget.existing};
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.existing.keys.toSet()..addAll(widget.incoming.keys);
    return AlertDialog(
      title: const Text('Merge duplicaten'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Veld')),
              DataColumn(label: Text('Bestaand')),
              DataColumn(label: Text('Nieuw')),
            ],
            rows: [
              for (final field in fields)
                DataRow(cells: [
                  DataCell(Text(field)),
                  DataCell(_buildOption(field, widget.existing[field], true)),
                  DataCell(_buildOption(field, widget.incoming[field], false)),
                ]),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuleren')),
        ElevatedButton(onPressed: _confirm, child: const Text('Opslaan')),
      ],
    );
  }

  Widget _buildOption(String field, dynamic value, bool isExisting) {
    final selected = _merged[field] == value;
    return InkWell(
      onTap: () => setState(() => _merged[field] = value),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: selected,
            onChanged: (_) => setState(() => _merged[field] = value),
          ),
          Flexible(child: Text(value?.toString() ?? '-', overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  void _confirm() {
    widget.onConfirm(_merged);
    Navigator.pop(context);
  }
}