// lib/utils/safe_numeric_operations.dart

/// 🛡️ Safe Numeric Operations Utility (2025 Best Practices)
///
/// Prevents NoSuchMethodError: 'toStringAsFixed' and similar numeric errors
/// by providing null-safe alternatives for all numeric operations.
///
/// This directly addresses the UI Error Display Crisis by providing
/// defensive programming techniques for numeric data handling.
class SafeNumericOperations {
  /// Safely format a number to fixed decimal places
  /// Prevents: NoSuchMethodError: 'toStringAsFixed' on null values
  static String toStringAsFixed(dynamic value, int fractionDigits) {
    try {
      if (value == null) return '0.${'0' * fractionDigits}';

      final numValue = value is num ? value : double.tryParse(value.toString());
      if (numValue == null) return '0.${'0' * fractionDigits}';

      return numValue.toStringAsFixed(fractionDigits);
    } catch (e) {
      return '0.${'0' * fractionDigits}';
    }
  }

  /// Safely convert to double with default fallback
  static double toDouble(dynamic value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();

      final parsed = double.tryParse(value.toString());
      return parsed ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safely convert to integer with default fallback
  static int toInt(dynamic value, {int defaultValue = 0}) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.round();

      final parsed = int.tryParse(value.toString());
      return parsed ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe percentage calculation
  static String toPercentage(dynamic value, {int decimalPlaces = 1}) {
    try {
      final numValue = toDouble(value);
      final percentage = numValue * 100;
      return '${toStringAsFixed(percentage, decimalPlaces)}%';
    } catch (e) {
      return '0.${'0' * decimalPlaces}%';
    }
  }

  /// Safe division with zero protection
  static double safeDivide(dynamic numerator, dynamic denominator,
      {double defaultValue = 0.0}) {
    try {
      final num = toDouble(numerator);
      final den = toDouble(denominator);

      if (den == 0.0) return defaultValue;
      return num / den;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe average calculation
  static double safeAverage(List<dynamic> values, {double defaultValue = 0.0}) {
    try {
      if (values.isEmpty) return defaultValue;

      final validNumbers =
          values.map(toDouble).where((v) => v.isFinite).toList();

      if (validNumbers.isEmpty) return defaultValue;

      final sum = validNumbers.reduce((a, b) => a + b);
      return sum / validNumbers.length;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe min/max calculations
  static double safeMin(List<dynamic> values, {double defaultValue = 0.0}) {
    try {
      if (values.isEmpty) return defaultValue;

      final validNumbers =
          values.map(toDouble).where((v) => v.isFinite).toList();

      if (validNumbers.isEmpty) return defaultValue;

      return validNumbers.reduce((a, b) => a < b ? a : b);
    } catch (e) {
      return defaultValue;
    }
  }

  static double safeMax(List<dynamic> values, {double defaultValue = 0.0}) {
    try {
      if (values.isEmpty) return defaultValue;

      final validNumbers =
          values.map(toDouble).where((v) => v.isFinite).toList();

      if (validNumbers.isEmpty) return defaultValue;

      return validNumbers.reduce((a, b) => a > b ? a : b);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Format currency safely
  static String toCurrency(dynamic value,
      {String symbol = '€', int decimalPlaces = 2}) {
    try {
      final numValue = toDouble(value);
      return '$symbol${toStringAsFixed(numValue, decimalPlaces)}';
    } catch (e) {
      return '$symbol.${'0' * decimalPlaces}';
    }
  }

  /// Safe comparison operations
  static bool safeEquals(dynamic a, dynamic b) {
    try {
      return toDouble(a) == toDouble(b);
    } catch (e) {
      return false;
    }
  }

  static bool safeGreaterThan(dynamic a, dynamic b) {
    try {
      return toDouble(a) > toDouble(b);
    } catch (e) {
      return false;
    }
  }

  static bool safeLessThan(dynamic a, dynamic b) {
    try {
      return toDouble(a) < toDouble(b);
    } catch (e) {
      return false;
    }
  }

  /// Validate if a value is a valid number
  static bool isValidNumber(dynamic value) {
    try {
      if (value == null) return false;
      if (value is num) return value.isFinite;

      final parsed = double.tryParse(value.toString());
      return parsed != null && parsed.isFinite;
    } catch (e) {
      return false;
    }
  }

  /// Safe range validation
  static double clamp(dynamic value, dynamic min, dynamic max) {
    try {
      final numValue = toDouble(value);
      final minValue = toDouble(min);
      final maxValue = toDouble(max);

      if (numValue < minValue) return minValue;
      if (numValue > maxValue) return maxValue;
      return numValue;
    } catch (e) {
      return toDouble(min);
    }
  }

  /// Format with thousands separator
  static String toFormattedString(dynamic value,
      {String separator = '.', int decimalPlaces = 0}) {
    try {
      final numValue = toDouble(value);
      final intPart = numValue.floor();
      final decimalPart = decimalPlaces > 0
          ? toStringAsFixed(numValue - intPart, decimalPlaces).substring(1)
          : '';

      // Add thousands separator
      final intString = intPart.toString();
      final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      final formattedInt =
          intString.replaceAllMapped(regex, (match) => '${match[1]}$separator');

      return '$formattedInt$decimalPart';
    } catch (e) {
      return '0';
    }
  }
}

/// Extension methods for easier usage
extension SafeNumericExtensions on dynamic {
  /// Safe toStringAsFixed
  String safeToStringAsFixed(int fractionDigits) =>
      SafeNumericOperations.toStringAsFixed(this, fractionDigits);

  /// Safe toDouble
  double safeToDouble({double defaultValue = 0.0}) =>
      SafeNumericOperations.toDouble(this, defaultValue: defaultValue);

  /// Safe toInt
  int safeToInt({int defaultValue = 0}) =>
      SafeNumericOperations.toInt(this, defaultValue: defaultValue);

  /// Safe percentage
  String safeToPercentage({int decimalPlaces = 1}) =>
      SafeNumericOperations.toPercentage(this, decimalPlaces: decimalPlaces);

  /// Check if valid number
  bool get isSafeNumber => SafeNumericOperations.isValidNumber(this);
}
