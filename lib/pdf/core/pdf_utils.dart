import 'package:intl/intl.dart';

/// Common utilities for PDF generators.
class PdfUtils {
  PdfUtils._();

  static final _dateFormatter = DateFormat('dd-MM-yyyy');

  static String formatDate(DateTime date) => _dateFormatter.format(date);
}
