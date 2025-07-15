// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../services/player_roster_import_service.dart';

class PlayerRosterReviewTable extends StatelessWidget {
  const PlayerRosterReviewTable({required this.preview, super.key});

  final PlayerImportPreview preview;

  @override
  Widget build(BuildContext context) {
    if (preview.rows.isEmpty) return const Center(child: Text('Geen rijen'));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Voornaam')),
          DataColumn(label: Text('Achternaam')),
          DataColumn(label: Text('Rugnummer')),
          DataColumn(label: Text('Geboortedatum')),
          DataColumn(label: Text('Positie')),
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
          final p = row.player;
          return DataRow(
            color: MaterialStateProperty.resolveWith((_) => bg),
            cells: [
              DataCell(Text(row.rowNumber.toString())),
              DataCell(Text(p?.firstName ?? '-')),
              DataCell(Text(p?.lastName ?? '-')),
              DataCell(Text(p?.jerseyNumber.toString() ?? '-')),
              DataCell(Text(p?.birthDate.toIso8601String().split('T').first ?? '-')),
              DataCell(Text(p?.position.displayName ?? '-')),
              DataCell(Text(row.state.name)),
              DataCell(Text(row.error ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }
}