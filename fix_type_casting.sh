#!/bin/bash

echo "Fixing type casting issues in Flutter app..."

# Fix lineup_builder_screen.dart - remove int.parse for matchId
sed -i '' 's/int\.parse(widget\.matchId!)/widget.matchId!/g' lib/screens/matches/lineup_builder_screen.dart

# Fix assessment_screen.dart - remove int.parse for playerId and assessmentId  
sed -i '' 's/int\.parse(widget\.playerId)/widget.playerId/g' lib/screens/players/assessment_screen.dart
sed -i '' 's/int\.parse(widget\.assessmentId!)/widget.assessmentId!/g' lib/screens/players/assessment_screen.dart

# Fix session_builder_screen.dart - remove int.parse for sessionId
sed -i '' 's/widget\.sessionId!/widget.sessionId!/g' lib/screens/training_sessions/session_builder_screen.dart

# Fix database_service.dart - TrainingExercise ID type issue
sed -i '' 's/exercise\.id\.isEmpty/exercise.id == 0/g' lib/services/database_service.dart
sed -i '' 's/exercise\.id = (_trainingExercises\.length + 1)\.toString()/exercise.id = _trainingExercises.length + 1/g' lib/services/database_service.dart

echo "Type casting fixes completed!"
echo "Running flutter analyze to check for remaining issues..."

flutter analyze --fatal-infos | head -20
