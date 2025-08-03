/// Safe numeric operations to prevent null pointer exceptions
/// 2025 Best Practice: Always handle null values gracefully
class SafeNumeric {
  /// Safely convert a nullable num to double with default fallback
  static double toDoubleSafe(num? value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    return value.toDouble();
  }

  /// Safely convert a nullable num to int with default fallback
  static int toIntSafe(num? value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    return value.toInt();
  }

  /// Safely format a nullable num to string with fixed decimal places
  static String toStringAsFixedSafe(
    num? value,
    int fractionDigits, {
    String defaultValue = '0.0',
  }) {
    if (value == null) return defaultValue;
    return value.toStringAsFixed(fractionDigits);
  }

  /// Safely format a percentage from nullable double
  static String toPercentageSafe(
    double? value, {
    int decimalPlaces = 1,
    String defaultValue = '0.0%',
  }) {
    if (value == null) return defaultValue;
    return '${value.toStringAsFixed(decimalPlaces)}%';
  }

  /// Safely clamp a nullable double between min and max values
  static double clampSafe(
    double? value,
    double min,
    double max, {
    double defaultValue = 0.0,
  }) {
    if (value == null) return defaultValue.clamp(min, max);
    return value.clamp(min, max);
  }

  /// Safely parse a dynamic value to double
  static double parseDoubleSafe(
    dynamic value, {
    double defaultValue = 0.0,
  }) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely parse a dynamic value to int
  static int parseIntSafe(
    dynamic value, {
    int defaultValue = 0,
  }) {
    if (value == null) return defaultValue;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Check if a numeric value is safe for mathematical operations
  static bool isValidNumber(num? value) {
    if (value == null) return false;
    if (value.isNaN || value.isInfinite) return false;
    return true;
  }

  /// Safely divide two numbers with null safety
  static double divideSafe(
    num? numerator,
    num? denominator, {
    double defaultValue = 0.0,
  }) {
    if (numerator == null || denominator == null) return defaultValue;
    if (denominator == 0) return defaultValue;
    return numerator / denominator;
  }

  /// Format file size safely
  static String formatFileSizeSafe(int? bytes) {
    if (bytes == null || bytes < 0) return '0 B';

    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format duration safely from seconds
  static String formatDurationSafe(double? seconds) {
    if (seconds == null || seconds < 0) return '0:00';

    final int totalSeconds = seconds.toInt();
    final int minutes = totalSeconds ~/ 60;
    final int remainingSeconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

/// Extension methods for null-safe numeric operations
extension SafeNumericExtensions on num? {
  /// Safe conversion to double
  double get safeDouble => SafeNumeric.toDoubleSafe(this);

  /// Safe conversion to int
  int get safeInt => SafeNumeric.toIntSafe(this);

  /// Safe string formatting with fixed decimals
  String safeFixed(int fractionDigits) =>
      SafeNumeric.toStringAsFixedSafe(this, fractionDigits);

  /// Check if this number is valid for operations
  bool get isValidNumber => SafeNumeric.isValidNumber(this);
}
