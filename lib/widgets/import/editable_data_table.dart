// ignore_for_file: public_member_api_docs

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:data_table_2/data_table_2.dart';
import 'editable_column.dart';

/// Generic editable table with virtual scrolling & cell editing.
/// Accepts [columns] definitions and [rows] data (List of maps).
/// Best-practice 2025: keeps table stateless, emits cell changes via callback.
class EditableDataTable extends StatelessWidget {
  const EditableDataTable({
    required this.columns,
    required this.rows,
    required this.onChanged,
    this.rowHeight = 48,
    super.key,
  });

  final List<EditableColumn> columns;
  final List<Map<String, dynamic>> rows;
  final void Function(int rowIdx, EditableColumn column, dynamic newValue) onChanged;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      dataRowHeight: rowHeight,
      minWidth: columns.length * 140,
      columns: [
        for (final col in columns) DataColumn2(label: Text(col.label), size: ColumnSize.L),
      ],
      rows: [
        for (var i = 0; i < rows.length; i++)
          DataRow2(
            cells: [
              for (final col in columns) _buildCell(context, i, col, rows[i][col.dataKey]),
            ],
          ),
      ],
    );
  }

  DataCell _buildCell(BuildContext context, int rowIdx, EditableColumn col, dynamic value) {
    return DataCell(
      GestureDetector(
        onTap: () async {
          final controller = TextEditingController(text: value?.toString() ?? '');
          final result = await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Wijzig ${col.label}'),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: col.type==CellType.number?TextInputType.number:null,
                decoration: const InputDecoration(errorText: null),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuleren')),
                ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Opslaan')),
              ],
            ),
          );
          if (result != null && result != value) {
            if (col.validator != null) {
              final err = col.validator!(result);
              if (err != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                return;
              }
            }
            onChanged(rowIdx, col, result);
          }
        },
        child: Text(value?.toString() ?? '-', overflow: TextOverflow.ellipsis),
      ),
    );
  }
}