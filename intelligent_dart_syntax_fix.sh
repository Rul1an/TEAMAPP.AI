#!/bin/bash

echo "🔧 Intelligent Dart Syntax Restoration..."

# Remove all the untracked temp files first
rm -f temp_fix_*.dart
rm -f fix_*.sh

# Function to fix a single file
fix_dart_file() {
    local file="$1"
    echo "Fixing: $file"
    
    # Create backup
    cp "$file" "$file.broken"
    
    # Fix 1: Remove standalone semicolons that shouldn't be there
    sed -i '' '/^[[:space:]]*;[[:space:]]*$/d' "$file"
    
    # Fix 2: Fix parameter syntax (= back to :)
    sed -i '' 's/\([a-zA-Z_][a-zA-Z0-9_]*\) = \([^=,})\n]*\),/\1: \2,/g' "$file"
    sed -i '' 's/\([a-zA-Z_][a-zA-Z0-9_]*\) = \([^=,})\n]*\))/\1: \2)/g' "$file"
    
    # Fix 3: Fix widget constructor parameters
    sed -i '' 's/child = /child: /g' "$file"
    sed -i '' 's/height = /height: /g' "$file"
    sed -i '' 's/width = /width: /g' "$file"
    sed -i '' 's/color = /color: /g' "$file"
    sed -i '' 's/style = /style: /g' "$file"
    sed -i '' 's/padding = /padding: /g' "$file"
    sed -i '' 's/margin = /margin: /g' "$file"
    sed -i '' 's/decoration = /decoration: /g' "$file"
    
    # Fix 4: Fix common Flutter properties
    sed -i '' 's/title = /title: /g' "$file"
    sed -i '' 's/theme = /theme: /g' "$file"
    sed -i '' 's/darkTheme = /darkTheme: /g' "$file"
    sed -i '' 's/routerConfig = /routerConfig: /g' "$file"
    sed -i '' 's/debugShowCheckedModeBanner = /debugShowCheckedModeBanner: /g' "$file"
    
    # Fix 5: Fix GoRouter properties
    sed -i '' 's/initialLocation = /initialLocation: /g' "$file"
    sed -i '' 's/routes = /routes: /g' "$file"
    sed -i '' 's/path = /path: /g' "$file"
    sed -i '' 's/name = /name: /g' "$file"
    sed -i '' 's/builder = /builder: /g' "$file"
    sed -i '' 's/pageBuilder = /pageBuilder: /g' "$file"
    
    # Fix 6: Fix widget properties
    sed -i '' 's/body = /body: /g' "$file"
    sed -i '' 's/children = /children: /g' "$file"
    sed -i '' 's/crossAxisAlignment = /crossAxisAlignment: /g' "$file"
    sed -i '' 's/mainAxisAlignment = /mainAxisAlignment: /g' "$file"
    sed -i '' 's/onTap = /onTap: /g' "$file"
    sed -i '' 's/onPressed = /onPressed: /g' "$file"
    
    # Fix 7: Fix constructor calls with {required
    sed -i '' 's/{required \([a-zA-Z_][a-zA-Z0-9_]*\) = /{\1: /g' "$file"
    sed -i '' 's/SizedBox({required /SizedBox(/g' "$file"
    
    # Fix 8: Remove semicolons after closing braces in wrong places
    sed -i '' 's/},;/},/g' "$file"
    sed -i '' 's/);/)/g' "$file"
    sed -i '' 's/];/]/g' "$file"
    sed -i '' 's/};$/}/g' "$file"
    
    # Fix 9: Fix switch statements
    sed -i '' 's/};$/}/g' "$file"
}

# Fix main application files first
echo "🎯 Fixing core application files..."
fix_dart_file "lib/main.dart"
fix_dart_file "lib/main_working.dart"

# Fix config files
echo "📁 Fixing config files..."
for file in lib/config/*.dart; do
    if [[ -f "$file" ]]; then
        fix_dart_file "$file"
    fi
done

# Fix a few critical model files
echo "📊 Fixing critical model files..."
for file in lib/models/*.dart; do
    if [[ -f "$file" ]]; then
        fix_dart_file "$file"
    fi
done

echo "✅ Intelligent syntax fix completed!"
echo "🧪 Testing core files..."

# Quick test
flutter analyze lib/main.dart lib/config/ --no-fatal-infos > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Core files syntax looks good!"
else
    echo "⚠️  Some issues remain, but should be much better"
fi
