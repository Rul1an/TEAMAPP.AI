// ignore_for_file: public_member_api_docs

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:data_table_2/data_table_2.dart';

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

  final List<String> columns;
  final List<Map<String, dynamic>> rows;
  final void Function(int rowIdx, String column, dynamic newValue) onChanged;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      dataRowHeight: rowHeight,
      minWidth: columns.length * 120,
      columns: [
        for (final col in columns) DataColumn2(label: Text(col), size: ColumnSize.L),
      ],
      rows: [
        for (var i = 0; i < rows.length; i++)
          DataRow2(
            cells: [
              for (final col in columns) _buildCell(context, i, col, rows[i][col]),
            ],
          ),
      ],
    );
  }

  DataCell _buildCell(BuildContext context, int rowIdx, String col, dynamic value) {
    return DataCell(
      GestureDetector(
        onTap: () async {
          final controller = TextEditingController(text: value?.toString() ?? '');
          final result = await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Wijzig $col'),
              content: TextField(controller: controller, autofocus: true),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuleren')),
                ElevatedButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Opslaan')),
              ],
            ),
          );
          if (result != null && result != value) {
            onChanged(rowIdx, col, result);
          }
        },
        child: Text(value?.toString() ?? '-', overflow: TextOverflow.ellipsis),
      ),
    );
  }
}