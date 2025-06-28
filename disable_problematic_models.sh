#!/bin/bash

echo "🔧 Temporarily disabling problematic Freezed models..."

# Comment out problematic part statements in morphocycle.dart
sed -i '' 's/^part.*morphocycle\.freezed\.dart.*/\/\/ part "morphocycle.freezed.dart";/' lib/models/annual_planning/morphocycle.dart
sed -i '' 's/^part.*morphocycle\.g\.dart.*/\/\/ part "morphocycle.g.dart";/' lib/models/annual_planning/morphocycle.dart

# Comment out problematic part statements in periodization_plan.dart  
sed -i '' 's/^part.*periodization_plan\.freezed\.dart.*/\/\/ part "periodization_plan.freezed.dart";/' lib/models/annual_planning/periodization_plan.dart
sed -i '' 's/^part.*periodization_plan\.g\.dart.*/\/\/ part "periodization_plan.g.dart";/' lib/models/annual_planning/periodization_plan.dart

# Comment out @freezed annotations temporarily
sed -i '' 's/^@freezed/\/\/ @freezed/' lib/models/annual_planning/morphocycle.dart
sed -i '' 's/^@freezed/\/\/ @freezed/' lib/models/annual_planning/periodization_plan.dart

echo "✅ Problematic models temporarily disabled"
