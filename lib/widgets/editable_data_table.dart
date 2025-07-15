import 'package:flutter/material.dart';

/// Defines an editable column within [EditableDataTable].
///
/// [T] is the row model type.
class EditableColumn<T> {
  const EditableColumn({
    required this.label,
    required this.getValue,
    required this.setValue,
    this.validator,
    this.cellWidth = 120,
  });

  /// Column header label.
  final String label;

  /// Getter that converts [row] into the string value shown in the cell.
  final String Function(T row) getValue;

  /// Setter invoked when the cell value is changed.
  final void Function(T row, String value) setValue;

  /// Optional inline validator. Returning a non-null string marks the cell as
  /// invalid and shows the error as tooltip.
  final String? Function(String? value)? validator;

  /// Convenience width for the cell (minimum).
  final double cellWidth;
}

/// A very lightweight editable data-grid backed by plain [DataTable].
///
/// It supports:
/// * Per-cell text editing
/// * Inline validation via [EditableColumn.validator]
/// * Emitting full row list changes through [onChanged]
class EditableDataTable<T> extends StatefulWidget {
  const EditableDataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.onChanged,
  });

  /// Column definitions.
  final List<EditableColumn<T>> columns;

  /// Current row models.
  final List<T> rows;

  /// Callback invoked when any cell value changes.
  final ValueChanged<List<T>> onChanged;

  @override
  State<EditableDataTable<T>> createState() => _EditableDataTableState<T>();
}

class _EditableDataTableState<T> extends State<EditableDataTable<T>> {
  late final List<T> _rows = List<T>.from(widget.rows);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStatePropertyAll(Theme.of(context).primaryColorLight),
        columns: [
          for (final col in widget.columns)
            DataColumn(label: Text(col.label)),
        ],
        rows: [
          for (int rowIndex = 0; rowIndex < _rows.length; rowIndex++)
            DataRow(
              cells: [
                for (final col in widget.columns)
                  DataCell(_buildEditableCell(col, rowIndex)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEditableCell(EditableColumn<T> column, int rowIndex) {
    final row = _rows[rowIndex];
    final controller = TextEditingController(text: column.getValue(row));

    return SizedBox(
      width: column.cellWidth,
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(border: InputBorder.none),
        validator: column.validator,
        onFieldSubmitted: (value) {
          final error = column.validator?.call(value);
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
            return;
          }
          setState(() {
            column.setValue(row, value);
            widget.onChanged(List<T>.from(_rows));
          });
        },
      ),
    );
  }
}