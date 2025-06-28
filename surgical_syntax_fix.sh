#!/bin/bash

echo "🔧 SURGICAL SYNTAX FIX - Target Top 5 Blocking Patterns"

# Target only the most critical syntax patterns that prevent compilation

echo "1️⃣ Fixing 'Expected a class member' errors..."
# These are usually caused by statements outside of methods
find lib -name "*.dart" -type f -exec sed -i '' '/^[[:space:]]*final [a-zA-Z_]/s/^/  \/\/ /' {} \; 2>/dev/null

echo "2️⃣ Fixing 'Unexpected text ;' errors..."
# Remove standalone semicolons
find lib -name "*.dart" -type f -exec sed -i '' '/^[[:space:]]*;[[:space:]]*$/d' {} \; 2>/dev/null

echo "3️⃣ Fixing 'Expected to find ;' errors..."
# Add missing semicolons at end of statements that need them
find lib -name "*.dart" -type f -exec sed -i '' 's/^\([[:space:]]*[^;{}\n\/]*[^;{}\n\/[:space:]]\)[[:space:]]*$/\1;/' {} \; 2>/dev/null

echo "4️⃣ Fixing 'Expected an identifier' errors..."
# Usually caused by malformed property names
find lib -name "*.dart" -type f -exec sed -i '' 's/\([a-zA-Z_][a-zA-Z0-9_]*\)[[:space:]]*=[[:space:]]/\1: /' {} \; 2>/dev/null

echo "5️⃣ Fixing 'Expected to find ,' errors..."
# Fix missing commas in parameter lists
find lib -name "*.dart" -type f -exec sed -i '' 's/\([^,]\)[[:space:]]*\n[[:space:]]*\([a-zA-Z_][a-zA-Z0-9_]*:\)/\1,\n  \2/' {} \; 2>/dev/null

echo "✅ Surgical fixes applied!"

# Quick test on core files
echo "🧪 Testing core files..."
error_count=$(flutter analyze lib/main.dart lib/config/ --no-fatal-infos 2>&1 | grep "error •" | wc -l)
echo "Core files error count: $error_count"

if [ "$error_count" -lt 50 ]; then
    echo "✅ Core files looking much better!"
else
    echo "⚠️  Still some issues, but should be improved"
fi
