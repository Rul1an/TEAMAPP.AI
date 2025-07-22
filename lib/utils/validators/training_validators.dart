// Dart imports:

// Model imports:

/// Validates training duration input (String minutes).
/// Returns error message in Dutch when out of range, otherwise null.
String? validateDuration(String? value) {
  if (value == null || value.isEmpty) {
    return 'Duur is verplicht';
  }
  final minutes = int.tryParse(value);
  if (minutes == null) {
    return 'Voer een getal in';
  }
  if (minutes < 15 || minutes > 240) {
    return 'Duur moet tussen 15 en 240 minuten liggen';
  }
  return null;
}

/// Generic required field validation for enums/objects.
String? validateRequired(dynamic value, String fieldName) {
  if (value == null) {
    return 'Selecteer $fieldName';
  }
  return null;
}

/// Validates selected date.
String? validateDate(DateTime? date) {
  if (date == null) {
    return 'Selecteer datum';
  }
  // Example rule: date not more than 1 year in the future
  final maxFuture = DateTime.now().add(const Duration(days: 365));
  if (date.isAfter(maxFuture)) {
    return 'Datum ligt te ver in de toekomst';
  }
  return null;
}
