#!/bin/bash

echo "🔍 COMPREHENSIVE DEPENDENCY HEALTH CHECK"
echo "========================================"
echo "Date: $(date)"
echo "Flutter SDK: $(flutter --version | head -1)"
echo "Dart SDK: $(dart --version)"
echo ""

# Create reports directory
mkdir -p docs/dependency-audit/reports

echo "📊 Phase 1: Dependency Tree Analysis"
echo "-----------------------------------"
dart pub deps --style=compact > docs/dependency-audit/reports/dependency_tree_$(date +%Y%m%d_%H%M%S).txt
dart pub deps --style=list > docs/dependency-audit/reports/dependency_list_$(date +%Y%m%d_%H%M%S).txt
dart pub deps --json > docs/dependency-audit/reports/dependency_graph_$(date +%Y%m%d_%H%M%S).json

echo "✅ Dependency tree analysis complete"

echo ""
echo "🔄 Phase 2: Outdated Package Analysis"
echo "------------------------------------"
dart pub outdated --json > docs/dependency-audit/reports/outdated_$(date +%Y%m%d_%H%M%S).json
dart pub outdated > docs/dependency-audit/reports/outdated_human_$(date +%Y%m%d_%H%M%S).txt

echo "✅ Outdated package analysis complete"

echo ""
echo "🔍 Phase 3: SDK Conflict Detection"
echo "---------------------------------"
echo "Checking for SDK-pinned packages..."

# Check for leak_tracker specifically
if grep -q "leak_tracker" docs/dependency-audit/reports/dependency_tree_*.txt; then
    echo "⚠️  LEAK_TRACKER DETECTED:"
    grep "leak_tracker" docs/dependency-audit/reports/dependency_tree_*.txt | head -5
else
    echo "✅ No leak_tracker conflicts detected"
fi

# Check for other known SDK-pinned packages
echo ""
echo "🔍 Checking other SDK-pinned packages:"
SDK_PACKAGES=("flutter_test" "integration_test" "flutter_driver")

for package in "${SDK_PACKAGES[@]}"; do
    if grep -q "$package" docs/dependency-audit/reports/dependency_tree_*.txt; then
        echo "📦 $package found:"
        grep "$package" docs/dependency-audit/reports/dependency_tree_*.txt | head -2
    fi
done

echo ""
echo "⚡ Phase 4: Version Compatibility Testing"
echo "---------------------------------------"

# Test current state
echo "Testing current dependency resolution..."
if dart pub get > /dev/null 2>&1; then
    echo "✅ Current dependencies resolve successfully"
else
    echo "❌ Current dependencies have resolution conflicts"
fi

# Test analysis
echo "Running static analysis..."
if dart analyze --fatal-infos > docs/dependency-audit/reports/analysis_current_$(date +%Y%m%d_%H%M%S).txt 2>&1; then
    echo "✅ Static analysis passes"
else
    echo "⚠️  Static analysis issues detected - see report"
fi

echo ""
echo "📈 Phase 5: Upgrade Impact Assessment"
echo "------------------------------------"

# Check major version updates available
echo "Major version updates available:"
grep -E '"latest".*version.*[0-9]+\.0\.0' docs/dependency-audit/reports/outdated_*.json | head -10

echo ""
echo "🎯 Phase 6: Strategic Recommendations"
echo "------------------------------------"

OUTDATED_COUNT=$(grep -c '"package":' docs/dependency-audit/reports/outdated_*.json 2>/dev/null || echo "0")
echo "📊 Total outdated packages: $OUTDATED_COUNT"

if [ "$OUTDATED_COUNT" -gt 50 ]; then
    echo "🔴 HIGH PRIORITY: $OUTDATED_COUNT outdated packages require strategic update plan"
elif [ "$OUTDATED_COUNT" -gt 20 ]; then
    echo "🟡 MEDIUM PRIORITY: $OUTDATED_COUNT outdated packages should be updated soon"
elif [ "$OUTDATED_COUNT" -gt 0 ]; then
    echo "🟢 LOW PRIORITY: $OUTDATED_COUNT outdated packages - routine maintenance"
else
    echo "✅ ALL PACKAGES UP TO DATE"
fi

echo ""
echo "📋 SUMMARY REPORT"
echo "================"
echo "Reports generated in: docs/dependency-audit/reports/"
echo "Next steps:"
echo "1. Review outdated_human_*.txt for critical updates"
echo "2. Check analysis_current_*.txt for any issues"
echo "3. Plan strategic updates based on priority level"
echo ""
echo "🚀 DEPENDENCY HEALTH CHECK COMPLETE!"
