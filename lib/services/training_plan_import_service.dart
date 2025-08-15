// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

// Package imports:
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

// Project imports:
import '../repositories/training_repository.dart';
import '../models/training.dart';

/// Data Transfer Object for planned training import rows
class PlannedTrainingDto {
  PlannedTrainingDto({
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.focus,
    required this.intensity,
    this.title,
    this.objective,
    this.location,
  });

  final DateTime date;
  final String startTime; // HH:mm
  final int durationMinutes;
  final String focus; // e.g., Techniek/Tactiek/Fysiek
  final String intensity; // Laag/Gemiddeld/Hoog/Herstel
  final String? title;
  final String? objective;
  final String? location;
}

class TrainingPlanImportResult {
  TrainingPlanImportResult({
    required this.success,
    required this.message,
    this.items = const [],
    this.errors = const [],
  });
  final bool success;
  final String message;
  final List<PlannedTrainingDto> items;
  final List<String> errors;
}

/// Service to import planned trainings from CSV/Excel according to a strict template
class TrainingPlanImportService {
  Future<TrainingPlanImportResult> importPlannedTrainings() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return TrainingPlanImportResult(
          success: false,
          message: 'Geen bestand geselecteerd',
        );
      }

      final file = result.files.first;
      final bytes = file.bytes;
      if (bytes == null) {
        return TrainingPlanImportResult(
          success: false,
          message: 'Kon bestand niet lezen',
        );
      }

      if (file.extension == 'csv') {
        return _fromCsv(bytes);
      } else {
        return _fromExcel(bytes);
      }
    } catch (e) {
      return TrainingPlanImportResult(
        success: false,
        message: 'Fout bij importeren: $e',
      );
    }
  }

  Future<TrainingPlanImportResult> _fromCsv(Uint8List bytes) async {
    try {
      final csvString = utf8.decode(bytes);
      final rows = const CsvToListConverter().convert(csvString);
      if (rows.isEmpty) {
        return TrainingPlanImportResult(
          success: false,
          message: 'CSV bestand is leeg',
        );
      }
      final dataRows = rows.skip(1).toList();
      return _parseRows(dataRows);
    } catch (e) {
      return TrainingPlanImportResult(
        success: false,
        message: 'Fout bij verwerken CSV: $e',
      );
    }
  }

  Future<TrainingPlanImportResult> _fromExcel(Uint8List bytes) async {
    try {
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables.values.first;
      final rows = sheet.rows;
      if (rows.isEmpty) {
        return TrainingPlanImportResult(
          success: false,
          message: 'Excel bestand is leeg',
        );
      }
      final dataRows = rows
          .skip(1)
          .map((row) => row.map((cell) => cell?.value).toList())
          .toList();
      return _parseRows(dataRows);
    } catch (e) {
      return TrainingPlanImportResult(
        success: false,
        message: 'Fout bij verwerken Excel: $e',
      );
    }
  }

  TrainingPlanImportResult _parseRows(List<List<dynamic>> rows) {
    final items = <PlannedTrainingDto>[];
    final errors = <String>[];

    for (var i = 0; i < rows.length; i++) {
      try {
        final row = rows[i];
        // Expected columns: Datum, Starttijd (HH:mm), Duur (min), Focus, Intensiteit, Titel, Doel, Locatie
        if (row.length < 5) {
          errors.add('Rij ${i + 2}: Onvoldoende kolommen');
          continue;
        }

        final date = _parseDate(row[0]);
        final start = _parseStartTime(row[1]?.toString() ?? '');
        final duration = int.tryParse(row[2]?.toString() ?? '') ?? 90;
        final focus = (row[3]?.toString() ?? 'Techniek').trim();
        final intensity = (row[4]?.toString() ?? 'Gemiddeld').trim();
        final title = row.length > 5 ? row[5]?.toString() : null;
        final objective = row.length > 6 ? row[6]?.toString() : null;
        final location = row.length > 7 ? row[7]?.toString() : null;

        if (start == null) {
          errors.add('Rij ${i + 2}: Ongeldige starttijd (verwacht HH:mm)');
          continue;
        }

        items.add(
          PlannedTrainingDto(
            date: date,
            startTime: start,
            durationMinutes: duration,
            focus: focus,
            intensity: intensity,
            title: title,
            objective: objective,
            location: location,
          ),
        );
      } catch (e) {
        errors.add('Rij ${i + 2}: $e');
      }
    }

    return TrainingPlanImportResult(
      success: items.isNotEmpty,
      message: items.isNotEmpty
          ? 'Import voltooid: ${items.length} trainingen verwerkt'
          : 'Geen geldige rijen gevonden',
      items: items,
      errors: errors,
    );
  }

  DateTime _parseDate(dynamic value) {
    final s = (value?.toString() ?? '').trim();
    final dash = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    final slash = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    final iso = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (dash.hasMatch(s)) {
      final p = s.split('-');
      return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    }
    if (slash.hasMatch(s)) {
      final p = s.split('/');
      return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    }
    if (iso.hasMatch(s)) {
      return DateTime.parse(s);
    }
    // Fallback: today
    return DateTime.now();
  }

  String? _parseStartTime(String s) {
    final trimmed = s.trim();
    final re = RegExp(r'^\d{2}:\d{2}$');
    if (!re.hasMatch(trimmed)) return null;
    final parts = trimmed.split(':');
    final hh = int.tryParse(parts[0]) ?? -1;
    final mm = int.tryParse(parts[1]) ?? -1;
    if (hh < 0 || hh > 23 || mm < 0 || mm > 59) return null;
    return trimmed;
  }

  /// Generate an Excel template for planned trainings
  Future<void> generateTemplate() async {
    final excel = Excel.createExcel();
    final sheet = excel['Trainingen'];

    final headers = <String>[
      'Datum (dd-mm-jjjj)',
      'Starttijd (HH:mm)',
      'Duur (minuten)',
      'Focus (Techniek/Tactiek/Fysiek/Mentaal/Wedstrijd)',
      'Intensiteit (Laag/Gemiddeld/Hoog/Herstel)',
      'Titel (optioneel)',
      'Doel (optioneel)',
      'Locatie (optioneel)',
    ];

    for (var i = 0; i < headers.length; i++) {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        TextCellValue(headers[i]),
      );
    }

    final example = <String>[
      '21-09-2025',
      '18:30',
      '90',
      'Techniek',
      'Gemiddeld',
      'Passing en balcontrole',
      'Verbeteren van korte passing in kleine ruimtes',
      'Veld 1',
    ];

    for (var i = 0; i < example.length; i++) {
      sheet.updateCell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 1),
        TextCellValue(example[i]),
      );
    }

    final bytes = excel.save();
    if (bytes != null) {
      await FileSaver.instance.saveFile(
        name: 'training_plannen_template.xlsx',
        bytes: Uint8List.fromList(bytes),
        mimeType: MimeType.microsoftExcel,
      );
    }
  }

  /// Persist imported items into the repository
  Future<TrainingPlanImportResult> persistImported(
    List<PlannedTrainingDto> items,
    TrainingRepository repo,
  ) async {
    final errors = <String>[];
    var created = 0;

    for (var i = 0; i < items.length; i++) {
      final dto = items[i];
      try {
        final training = _mapDtoToTraining(dto);
        final res = await repo.add(training);
        if (res.isSuccess) {
          created += 1;
        } else {
          errors.add('Rij ${i + 2}: ${res.errorOrNull}');
        }
      } catch (e) {
        errors.add('Rij ${i + 2}: $e');
      }
    }

    return TrainingPlanImportResult(
      success: created > 0,
      message: created > 0
          ? 'Planning aangemaakt: $created items'
          : 'Geen items aangemaakt',
      items: items,
      errors: errors,
    );
  }

  Training _mapDtoToTraining(PlannedTrainingDto dto) {
    final training = Training();
    final timeParts = dto.startTime.split(':');
    final start = DateTime(
      dto.date.year,
      dto.date.month,
      dto.date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
    training.date = start;
    training.duration = dto.durationMinutes;
    training.focus = _mapFocus(dto.focus);
    training.intensity = _mapIntensity(dto.intensity);
    training.status = TrainingStatus.planned;
    training.description = dto.objective;
    training.location = dto.location;
    training.coachNotes = dto.title;
    return training;
  }

  TrainingFocus _mapFocus(String value) {
    final v = value.trim().toLowerCase();
    switch (v) {
      case 'techniek':
      case 'technical':
        return TrainingFocus.technical;
      case 'tactiek':
      case 'tactical':
        return TrainingFocus.tactical;
      case 'fysiek':
      case 'physical':
        return TrainingFocus.physical;
      case 'mentaal':
      case 'mental':
        return TrainingFocus.mental;
      case 'wedstrijd':
      case 'match':
        return TrainingFocus.matchPrep;
      default:
        return TrainingFocus.technical;
    }
  }

  TrainingIntensity _mapIntensity(String value) {
    final v = value.trim().toLowerCase();
    switch (v) {
      case 'laag':
      case 'low':
        return TrainingIntensity.low;
      case 'gemiddeld':
      case 'medium':
        return TrainingIntensity.medium;
      case 'hoog':
      case 'high':
        return TrainingIntensity.high;
      case 'herstel':
      case 'recovery':
        return TrainingIntensity.recovery;
      default:
        return TrainingIntensity.medium;
    }
  }
}
