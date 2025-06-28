import 'dart:io';

void main() {
  final file = File('lib/models/annual_planning/morphocycle.dart');
  String content = file.readAsStringSync();
  
  // Find the fromJson method and convert consecutive assignments to cascade notation
  final lines = content.split('\n');
  final newLines = <String>[];
  
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    
    // Look for the pattern: morphocycle.property = value;
    if (line.trim().startsWith('morphocycle.') && line.trim().endsWith(';')) {
      // Check if this is the first assignment after the variable declaration
      bool isFirst = i > 0 && lines[i-1].contains('final morphocycle = Morphocycle()');
      
      if (isFirst) {
        // Convert first assignment to cascade
        newLines.add(line.replaceFirst('morphocycle.', '    ..'));
      } else {
        // Check if previous line was also an assignment
        bool prevIsAssignment = i > 0 && lines[i-1].trim().startsWith('morphocycle.');
        if (prevIsAssignment || (i > 0 && lines[i-1].trim().startsWith('..'))) {
          // Convert to cascade
          newLines.add(line.replaceFirst('morphocycle.', '    ..'));
        } else {
          newLines.add(line);
        }
      }
    } else {
      newLines.add(line);
    }
  }
  
  file.writeAsStringSync(newLines.join('\n'));
  print('Fixed cascades in morphocycle.dart');
}
