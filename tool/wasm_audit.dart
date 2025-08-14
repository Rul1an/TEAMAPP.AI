import 'dart:convert';
import 'dart:io';

/// WASM-compatibility audit script (2025 best practices)
/// - Captures `flutter pub deps --json` output
/// - Scans source files for restricted imports: dart:html, dart:js, dart:ffi
/// - Writes a machine-readable report to wasm_audit.json
Future<void> main() async {
  final report = <String, dynamic>{
    'generated_at': DateTime.now().toIso8601String(),
    'repo': await _gitTopLevel(),
    'pub_deps': await _pubDepsJson(),
  };

  final restricted = await _scanRestrictedImports(
    Directory('lib'),
    patterns: [RegExp(r'dart:(html|js|ffi)')],
  );

  report['restricted_imports'] = restricted
      .map((e) => {
            'file': e.file,
            'line': e.line,
            'import': e.importLine.trim(),
          })
      .toList();

  final file = File('wasm_audit.json');
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(report));
  stdout
      .writeln('✅ wasm_audit.json created with ${restricted.length} findings');
}

Future<String?> _gitTopLevel() async {
  try {
    final res = await Process.run('git', ['rev-parse', '--show-toplevel']);
    if (res.exitCode == 0) return (res.stdout as String).trim();
  } catch (_) {}
  return null;
}

Future<dynamic> _pubDepsJson() async {
  try {
    final res = await Process.run('flutter', ['pub', 'deps', '--json']);
    if (res.exitCode == 0) {
      return jsonDecode(res.stdout as String);
    }
  } catch (_) {}
  return {'error': 'failed_to_capture'};
}

class _Finding {
  _Finding(this.file, this.line, this.importLine);
  final String file;
  final int line;
  final String importLine;
}

Future<List<_Finding>> _scanRestrictedImports(
  Directory root, {
  required List<RegExp> patterns,
}) async {
  final findings = <_Finding>[];
  if (!root.existsSync()) return findings;
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    final lines = await entity.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (patterns.any((p) => p.hasMatch(line))) {
        findings.add(_Finding(entity.path, i + 1, line));
      }
    }
  }
  return findings;
}
