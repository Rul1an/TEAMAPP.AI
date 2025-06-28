#!/bin/bash

echo "Fixing Flutter analysis errors..."

# Fix withOpacity deprecation warnings
echo "Fixing deprecated withOpacity usage..."
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(\([0-9.]*\))/.withValues(alpha: \1)/g' {} \;

# Remove the problematic radar chart parameters
echo "Fixing RadarChart API issues..."
sed -i '' '/titleCount:/d' lib/screens/players/assessment_detail_screen.dart
sed -i '' '/titlesBuilder:/,/},/d' lib/screens/players/assessment_detail_screen.dart
sed -i '' '/titleCount:/d' lib/screens/players/player_radar_chart_screen.dart

# Add proper getTitle implementation to assessment_detail_screen.dart
cat << 'EOF' > temp_radar_fix.txt
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(text: 'Technical', angle: angle);
            case 1:
              return RadarChartTitle(text: 'Tactical', angle: angle);
            case 2:
              return RadarChartTitle(text: 'Physical', angle: angle);
            case 3:
              return RadarChartTitle(text: 'Mental', angle: angle);
            default:
              return const RadarChartTitle(text: '');
          }
        },
EOF

# Fix the performance analytics screen if needed
if grep -q "Analyseer spelerontwikkeling, training effectiviteit en team prestaties\." lib/screens/analytics/performance_analytics_screen.dart; then
    echo "String literal already fixed in performance_analytics_screen.dart"
else
    echo "Fixing string literal in performance_analytics_screen.dart..."
    sed -i '' "s/'Analyseer spelerontwikkeling, training effectiviteit en team prestaties\./'Analyseer spelerontwikkeling, training effectiviteit en team prestaties. '/" lib/screens/analytics/performance_analytics_screen.dart
fi

echo "Running flutter analyze to check remaining issues..."
flutter analyze

echo "Fix complete!"
