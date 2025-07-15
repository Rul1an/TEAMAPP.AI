import 'package:flutter/material.dart';

/// Simple data class holding a field label and two candidate values.
class _MergeField {
  const _MergeField({
    required this.label,
    required this.left,
    required this.right,
  });
  final String label;
  final String left;
  final String right;
}

/// Result of merging duplicates – map of field → chosen value.
typedef MergeResult = Map<String, String>;

/// Dialog that lets the user decide – for each field – which value to keep.
class MergeDuplicatesDialog extends StatefulWidget {
  const MergeDuplicatesDialog({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.fields,
  });

  /// Title for left record (e.g. existing row).
  final String leftTitle;

  /// Title for incoming duplicate.
  final String rightTitle;

  /// List of field candidates.
  final List<_MergeField> fields;

  /// Shows the dialog and returns merged values or `null` if cancelled.
  static Future<MergeResult?> show(BuildContext context,
      {required String leftTitle,
      required String rightTitle,
      required Map<String, String> leftValues,
      required Map<String, String> rightValues}) {
    assert(leftValues.keys.toSet().containsAll(rightValues.keys));

    final fields = <_MergeField>[];
    for (final key in leftValues.keys) {
      fields.add(_MergeField(
        label: key,
        left: leftValues[key] ?? '',
        right: rightValues[key] ?? '',
      ));
    }

    return showDialog<MergeResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => MergeDuplicatesDialog(
        leftTitle: leftTitle,
        rightTitle: rightTitle,
        fields: fields,
      ),
    );
  }

  @override
  State<MergeDuplicatesDialog> createState() => _MergeDuplicatesDialogState();
}

class _MergeDuplicatesDialogState extends State<MergeDuplicatesDialog> {
  late final Map<String, String> _chosen = {
    for (final f in widget.fields) f.label: f.left,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Duplicates gevonden – welke waarden behouden?'),
      content: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 12,
          headingRowHeight: 36,
          columns: [
            const DataColumn(label: Text('Veld')),
            DataColumn(label: Text(widget.leftTitle)),
            DataColumn(label: Text(widget.rightTitle)),
          ],
          rows: [
            for (final field in widget.fields)
              DataRow(cells: [
                DataCell(Text(field.label)),
                DataCell(_buildRadio(field, true)),
                DataCell(_buildRadio(field, false)),
              ]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<MergeResult>(null),
          child: const Text('Annuleren'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop<MergeResult>(_chosen),
          child: const Text('Opslaan'),
        ),
      ],
    );
  }

  Widget _buildRadio(_MergeField field, bool isLeft) {
    final value = isLeft ? field.left : field.right;
    final groupValue = _chosen[field.label];
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: (val) {
            setState(() {
              _chosen[field.label] = val!;
            });
          },
        ),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}