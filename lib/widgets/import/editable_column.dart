// Defines a column for [EditableDataTable] with validation.

typedef CellValidator = String? Function(String value);

enum CellType { text, number, date }

class EditableColumn {
  EditableColumn({
    required this.label,
    this.key,
    this.type = CellType.text,
    this.validator,
  });

  final String label;
  final String? key; // map key, defaults to label lowercased
  final CellType type;
  final CellValidator? validator;

  String get dataKey => key ?? label.toLowerCase();
}