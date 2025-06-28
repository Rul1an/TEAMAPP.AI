#!/bin/bash

echo "Fixing critical compilation errors..."

# Fix training sessions provider - replace saveMatch with saveTrainingSession
sed -i '' 's/await db\.saveMatch(session)/await db.saveTrainingSession(session)/g' lib/providers/training_sessions_provider.dart

echo "Critical errors fixed!"
echo "Running quick compile check..."

flutter analyze --no-fatal-warnings | grep -E "^  error" | head -5
