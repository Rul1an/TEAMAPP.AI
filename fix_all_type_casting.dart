import 'dart:io';

void main() {
  // Get all dart files in lib directory
  final libDir = Directory('lib');
  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  int totalFixed = 0;

  for (final file in dartFiles) {
    try {
      String content = file.readAsStringSync();
      String originalContent = content;

      // Common JSON access patterns that need type casting
      content = content.replaceAllMapped(
        RegExp(r"json\['([^']+)'\](?!\s+as)"),
        (match) => "json['${match.group(1)}'] as dynamic",
      );

      // Fix specific patterns
      content = content.replaceAll(
        " as dynamic ?? ''",
        " as String? ?? ''"
      );
      
      content = content.replaceAll(
        " as dynamic ?? 0",
        " as int? ?? 0"
      );
      
      content = content.replaceAll(
        " as dynamic ?? 0.0",
        " as double? ?? 0.0"
      );
      
      content = content.replaceAll(
        " as dynamic ?? false",
        " as bool? ?? false"
      );

      // More specific fixes for common patterns
      content = content.replaceAll(
        "DateTime.parse(json[",
        "DateTime.parse(json["
      );

      if (content != originalContent) {
        file.writeAsStringSync(content);
        totalFixed++;
        print('Fixed: ${file.path}');
      }
    } catch (e) {
      print('Error processing ${file.path}: $e');
    }
  }

  print('Total files fixed: $totalFixed');
}
