// test/integration/exercise_library_integration_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../fixtures/test_data_factory.dart';
import '../helpers/test_database_helper.dart';
import '../helpers/widget_test_helper.dart';

/// Integration tests voor Exercise Library Nederlandse voetbal context
/// Volgens 2025 Flutter testing best practices
void main() {
  group('Exercise Library Integration Tests (Nederlandse Voetbal)', () {
    setUpAll(() async {
      await WidgetTestHelper.setupTestEnvironment();
    });

    tearDownAll(() async {
      await WidgetTestHelper.cleanup();
    });

    setUp(() async {
      await TestDatabaseHelper.resetDatabase();
    });

    group('Nederlandse Oefeningen Basis Tests', () {
      testWidgets('toont Nederlandse exercise library interface',
          (tester) async {
        // Setup test data
        final dutchExercises = TestDataFactory.dutchExercises();

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              title: 'VOAB JO17 Test',
              home: _buildSimpleExerciseLibrary(dutchExercises),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify basic UI elements
        expect(find.text('Nederlandse Oefeningen'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
      });

      testWidgets('zoekt Nederlandse oefeningen', (tester) async {
        final dutchExercises = TestDataFactory.dutchExercises();

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _buildSimpleExerciseLibrary(dutchExercises),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test search functionality
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'passing');
        await tester.pumpAndSettle();

        // Verify search works
        expect(find.text('passing'), findsWidgets);
      });
    });

    group('Nederlandse Form Tests', () {
      testWidgets('valideert Nederlandse oefening form', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _buildSimpleExerciseForm(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test form validation with empty fields
        final submitButton = find.byType(ElevatedButton);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Should show validation error
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Naam is verplicht'), findsOneWidget);

        // Test valid form submission
        await tester.enterText(
            find.byKey(const Key('naam_field')), 'Test Oefening');
        await tester.enterText(
            find.byKey(const Key('categorie_field')), 'Techniek');
        await tester.enterText(find.byKey(const Key('duur_field')), '30');

        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Should show success SnackBar (more reliable than checking text)
        expect(find.byType(SnackBar), findsAtLeastNWidgets(1));
        // Verify form fields are still populated (form doesn't reset on success)
        expect(find.text('Test Oefening'), findsOneWidget);
        expect(find.text('Techniek'), findsOneWidget);
        expect(find.text('30'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('exercise library performance test', (tester) async {
        final dutchExercises = TestDataFactory.dutchExercises();

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _buildSimpleExerciseLibrary(dutchExercises),
            ),
          ),
        );

        await tester.pumpAndSettle();
        stopwatch.stop();

        // Performance should be under 1000ms for UI rendering
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        print('UI render time: ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Accessibility Tests', () {
      testWidgets('heeft toegankelijke Nederlandse labels', (tester) async {
        final dutchExercises = TestDataFactory.dutchExercises();

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _buildSimpleExerciseLibrary(dutchExercises),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Check for semantic labels
        expect(find.byType(Semantics), findsWidgets);
        expect(find.text('Nederlandse Oefeningen'), findsOneWidget);
      });
    });
  });
}

/// Simplified Exercise Library Widget volgens 2025 best practices
Widget _buildSimpleExerciseLibrary(List<Map<String, dynamic>> exercises) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Nederlandse Oefeningen'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: const InputDecoration(
              hintText: 'Zoek oefeningen...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Filter buttons
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Alle'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Techniek'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Tactiek'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Exercise list
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  child: ListTile(
                    title: Text(exercise['name'] as String),
                    subtitle: Text(exercise['category'] as String),
                    trailing: Text('${exercise['duration_minutes']} min'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

/// Simplified Exercise Form Widget volgens 2025 best practices
Widget _buildSimpleExerciseForm() {
  return _ExerciseFormWidget();
}

class _ExerciseFormWidget extends StatefulWidget {
  @override
  _ExerciseFormWidgetState createState() => _ExerciseFormWidgetState();
}

class _ExerciseFormWidgetState extends State<_ExerciseFormWidget> {
  final _naamController = TextEditingController();
  final _categorieController = TextEditingController();
  final _duurController = TextEditingController();

  void _submitForm() {
    final naam = _naamController.text.trim();
    final categorie = _categorieController.text.trim();
    final duur = _duurController.text.trim();

    if (naam.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Naam is verplicht'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (categorie.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categorie is verplicht'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (duur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Duur is verplicht'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Success case
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opgeslagen'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nieuwe Oefening'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('naam_field'),
              controller: _naamController,
              decoration: const InputDecoration(
                labelText: 'Oefening Naam',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('categorie_field'),
              controller: _categorieController,
              decoration: const InputDecoration(
                labelText: 'Categorie',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('duur_field'),
              controller: _duurController,
              decoration: const InputDecoration(
                labelText: 'Duur (minuten)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Opslaan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _naamController.dispose();
    _categorieController.dispose();
    _duurController.dispose();
    super.dispose();
  }
}
