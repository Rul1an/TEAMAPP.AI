import 'dart:convert' as convert;

/// Metadata for heatmap export files (CSV/JSON).
class HeatMapExportMeta {
  final int rows;
  final int cols;
  final String palette;
  final int minCount;
  final bool dpEnabled;
  final double? epsilon;
  final String category;
  final bool predictions;
  final String timestampIso;

  const HeatMapExportMeta({
    required this.rows,
    required this.cols,
    required this.palette,
    required this.minCount,
    required this.dpEnabled,
    required this.epsilon,
    required this.category,
    required this.predictions,
    required this.timestampIso,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'rows': rows,
      'cols': cols,
      'palette': palette,
      'minCount': minCount,
      'dpEnabled': dpEnabled,
      'epsilon': epsilon,
      'category': category,
      'predictions': predictions,
      'timestamp': timestampIso,
    };
  }
}

/// Compute matrix dimensions from sparse [row, col, count] entries.
({int rows, int cols}) computeRowsCols(List<List<int>> entries) {
  int rows = 0;
  int cols = 0;
  for (final List<int> e in entries) {
    if (e.length >= 2) {
      final int r = e[0];
      final int c = e[1];
      if (r + 1 > rows) rows = r + 1;
      if (c + 1 > cols) cols = c + 1;
    }
  }
  return (rows: rows, cols: cols);
}

/// Build a CSV string for the given sparse entries with metadata header.
String buildHeatmapCsv({
  required List<List<int>> entries,
  required HeatMapExportMeta meta,
}) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('# heatmap csv export');
  buffer.writeln('# rows=${meta.rows}');
  buffer.writeln('# cols=${meta.cols}');
  buffer.writeln('# palette=${meta.palette}');
  buffer.writeln('# minCount=${meta.minCount}');
  buffer.writeln('# dpEnabled=${meta.dpEnabled}');
  buffer.writeln('# epsilon=${meta.epsilon ?? 'n/a'}');
  buffer.writeln('# category=${meta.category}');
  buffer.writeln('# predictions=${meta.predictions}');
  buffer.writeln('# timestamp=${meta.timestampIso}');
  buffer.writeln('row,col,count');
  for (final List<int> e in entries) {
    buffer.writeln('${e[0]},${e[1]},${e[2]}');
  }
  return buffer.toString();
}

/// Build a JSON string for the given sparse entries with metadata object.
String buildHeatmapJson({
  required List<List<int>> entries,
  required HeatMapExportMeta meta,
}) {
  final Map<String, dynamic> obj = meta.toJson();
  obj['entries'] = entries;
  return convert.jsonEncode(obj);
}
