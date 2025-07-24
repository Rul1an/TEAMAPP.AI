// Model representing result of schedule import
class ImportReport {
  const ImportReport({
    required this.imported,
    required this.errors,
  });

  final int imported;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
}
