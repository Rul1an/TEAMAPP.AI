import 'dart:convert' as convert;

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/utils/heatmap_export.dart';

void main() {
  group('heatmap_export', () {
    test('computeRowsCols derives correct dimensions', () {
      final List<List<int>> entries = <List<int>>[
        <int>[0, 0, 3],
        <int>[2, 5, 1],
        <int>[1, 4, 7],
      ];
      final dims = computeRowsCols(entries);
      expect(dims.rows, 3);
      expect(dims.cols, 6);
    });

    test('buildHeatmapCsv contains metadata and rows', () {
      final List<List<int>> entries = <List<int>>[
        <int>[0, 0, 3],
        <int>[2, 5, 1],
      ];
      final meta = HeatMapExportMeta(
        rows: 3,
        cols: 6,
        palette: 'classic',
        minCount: 4,
        dpEnabled: true,
        epsilon: 1.0,
        category: 'overall',
        predictions: false,
        timestampIso: '2025-08-15T12:00:00Z',
      );
      final csv = buildHeatmapCsv(entries: entries, meta: meta);
      expect(csv.contains('# rows=3'), isTrue);
      expect(csv.contains('# cols=6'), isTrue);
      expect(csv.contains('# palette=classic'), isTrue);
      expect(csv.contains('row,col,count'), isTrue);
      expect(csv.contains('0,0,3'), isTrue);
      expect(csv.contains('2,5,1'), isTrue);
    });

    test('buildHeatmapJson serializes entries and meta', () {
      final List<List<int>> entries = <List<int>>[
        <int>[0, 0, 3],
        <int>[2, 5, 1],
      ];
      final meta = HeatMapExportMeta(
        rows: 3,
        cols: 6,
        palette: 'classic',
        minCount: 4,
        dpEnabled: false,
        epsilon: null,
        category: 'overall',
        predictions: false,
        timestampIso: '2025-08-15T12:00:00Z',
      );
      final jsonStr = buildHeatmapJson(entries: entries, meta: meta);
      final Map<String, dynamic> decoded =
          convert.jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['rows'], 3);
      expect(decoded['cols'], 6);
      expect(decoded['palette'], 'classic');
      expect(decoded['minCount'], 4);
      expect(decoded['dpEnabled'], false);
      expect(decoded['epsilon'], isNull);
      expect(decoded['category'], 'overall');
      expect(decoded['predictions'], false);
      final List<dynamic> entriesDynamicList =
          decoded['entries'] as List<dynamic>;
      final List<List<dynamic>> entriesDecoded = entriesDynamicList
          .map<List<dynamic>>((dynamic e) => e as List<dynamic>)
          .toList();
      expect(entriesDecoded.length, 2);
    });
  });
}
