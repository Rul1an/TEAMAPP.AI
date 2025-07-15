// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../services/match_schedule_import_service.dart';

/// Table that visualises the ImportPreview returned by MatchScheduleImportService.
///
/// Rows are colour-coded:
///   • Green – new record
///   • Yellow – duplicate
///   • Red – error
class MatchScheduleReviewTable extends StatelessWidget {
  const MatchScheduleReviewTable({required this.preview, super.key});

  final ImportPreview preview;

  @override
  Widget build(BuildContext context) {
    if (preview.rows.isEmpty) {
      return const Center(child: Text('Geen rijen om te tonen'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Datum')),
          DataColumn(label: Text('Tegenstander')),
          DataColumn(label: Text('Speellocatie')),
          DataColumn(label: Text('Team ID')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Fout')),
        ],
        rows: preview.rows.map((row) {
          Color? bg;
          switch (row.state) {
            case ImportRowState.newRecord:
              bg = Colors.green.shade100;
              break;
            case ImportRowState.duplicate:
              bg = Colors.yellow.shade100;
              break;
            case ImportRowState.error:
              bg = Colors.red.shade100;
              break;
          }

          final match = row.match;
          return DataRow(
            color: MaterialStateProperty.resolveWith((_) => bg),
            cells: [
              DataCell(Text(row.rowNumber.toString())),
              DataCell(Text(match?.date.toIso8601String().split('T').first ?? '-')),
              DataCell(Text(match?.opponent ?? '-')),
              DataCell(Text(match?.venue ?? '-')),
              DataCell(Text(match?.id ?? '-')),
              DataCell(Text(row.state.name)),
              DataCell(Text(row.error ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }
}