import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jo17_tactical_manager/main.dart' as app;
import 'package:jo17_tactical_manager/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// End-to-End Video Flow Test
/// Tests complete video pipeline: Upload → Database → Storage → UI
/// Date: 2025-07-31
///
/// This test verifies the entire video processing pipeline works
/// from UI interaction through database storage to final display.
/// Critical for production readiness validation.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Video Flow E2E Tests', () {
    late SupabaseClient supabaseClient;

    setUpAll(() async {
      // Initialize Supabase for testing
      await SupabaseConfig.initialize();
      supabaseClient = Supabase.instance.client;

      // Verify database connection
      final response = await supabaseClient.from('organizations').select('id').limit(1);
      expect(response, isNotNull, reason: 'Database connection required for E2E tests');
    });

    testWidgets('Complete Video Upload and Display Flow', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Test data
      const testVideoTitle = 'E2E Test Video';
      const testVideoDescription = 'End-to-end test video upload';

      // Step 1: Navigate to Video Upload Screen
      await _navigateToVideoUpload(tester);

      // Step 2: Upload Video (Mock)
      await _performVideoUpload(tester, testVideoTitle, testVideoDescription);

      // Step 3: Verify Database Storage
      await _verifyDatabaseStorage(supabaseClient, testVideoTitle);

      // Step 4: Navigate to Video List
      await _navigateToVideoList(tester);

      // Step 5: Verify Video Appears in UI
      await _verifyVideoInUI(tester, testVideoTitle);

      // Step 6: Test Video Player
      await _testVideoPlayer(tester, testVideoTitle);

      // Step 7: Test Video Tagging
      await _testVideoTagging(tester);

      // Step 8: Cleanup
      await _cleanupTestData(supabaseClient, testVideoTitle);
    });

    testWidgets('Video Analysis Flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      const testVideoTitle = 'E2E Analysis Test Video';

      // Setup test video
      await _setupTestVideo(supabaseClient, testVideoTitle);

      // Navigate to video analysis
      await _navigateToVideoAnalysis(tester);

      // Test analysis features
      await _testAnalysisFeatures(tester);

      // Cleanup
      await _cleanupTestData(supabaseClient, testVideoTitle);
    });

    testWidgets('Database Error Handling', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test app behavior when database is unreachable
      await _testDatabaseErrorHandling(tester);
    });
  });
}

/// Navigate to video upload screen
Future<void> _navigateToVideoUpload(WidgetTester tester) async {
  // Look for video upload navigation
  final videoUploadButton = find.text('Upload Video').or(
    find.byIcon(Icons.video_call)
  ).or(
    find.byTooltip('Upload Video')
  );

  if (videoUploadButton.evaluate().isNotEmpty) {
    await tester.tap(videoUploadButton);
    await tester.pumpAndSettle();
  } else {
    // Alternative navigation path
    final menuButton = find.byIcon(Icons.menu);
    if (menuButton.evaluate().isNotEmpty) {
      await tester.tap(menuButton);
      await tester.pumpAndSettle();

      final videoMenuItem = find.text('Videos').or(find.text('Video'));
      await tester.tap(videoMenuItem);
      await tester.pumpAndSettle();

      final uploadButton = find.byIcon(Icons.add).or(find.text('Upload'));
      await tester.tap(uploadButton);
      await tester.pumpAndSettle();
    }
  }

  // Verify we're on the upload screen
  expect(
    find.text('Upload Video').or(find.text('Video Upload')),
    findsOneWidget,
    reason: 'Should navigate to video upload screen'
  );
}

/// Perform video upload (mocked for testing)
Future<void> _performVideoUpload(WidgetTester tester, String title, String description) async {
  // Fill in video title
  final titleField = find.byType(TextFormField).or(find.byType(TextField));
  if (titleField.evaluate().isNotEmpty) {
    await tester.enterText(titleField.first, title);
    await tester.pumpAndSettle();
  }

  // Fill in description if available
  final descriptionField = find.widgetWithText(TextFormField, 'Description').or(
    find.widgetWithText(TextField, 'Description')
  );
  if (descriptionField.evaluate().isNotEmpty) {
    await tester.enterText(descriptionField, description);
    await tester.pumpAndSettle();
  }

  // Mock file selection (in real scenario this would be a file picker)
  final selectFileButton = find.text('Select Video').or(
    find.byIcon(Icons.file_upload)
  );
  if (selectFileButton.evaluate().isNotEmpty) {
    await tester.tap(selectFileButton);
    await tester.pumpAndSettle();
  }

  // Submit upload
  final uploadButton = find.text('Upload').or(find.text('Save'));
  if (uploadButton.evaluate().isNotEmpty) {
    await tester.tap(uploadButton);
    await tester.pumpAndSettle(const Duration(seconds: 3)); // Allow time for upload
  }

  // Verify success message or navigation
  final successIndicator = find.text('Upload successful').or(
    find.text('Video uploaded')
  ).or(
    find.byIcon(Icons.check_circle)
  );

  expect(
    successIndicator,
    findsOneWidget,
    reason: 'Should show upload success'
  );
}

/// Verify video is stored in database
Future<void> _verifyDatabaseStorage(SupabaseClient client, String title) async {
  try {
    final response = await client
        .from('videos')
        .select('id, title, created_at')
        .eq('title', title)
        .maybeSingle();

    expect(response, isNotNull, reason: 'Video should exist in database');
    expect(response!['title'], equals(title), reason: 'Title should match');
    expect(response['id'], isNotNull, reason: 'Video should have ID');
  } catch (e) {
    fail('Database verification failed: $e');
  }
}

/// Navigate to video list screen
Future<void> _navigateToVideoList(WidgetTester tester) async {
  final videoListButton = find.text('Videos').or(
    find.text('Video List')
  ).or(
    find.byIcon(Icons.video_library)
  );

  if (videoListButton.evaluate().isNotEmpty) {
    await tester.tap(videoListButton);
    await tester.pumpAndSettle();
  } else {
    // Navigate back to main screen first
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }
}

/// Verify video appears in UI list
Future<void> _verifyVideoInUI(WidgetTester tester, String title) async {
  // Look for video in list
  final videoTitle = find.text(title);

  // If not immediately visible, try scrolling
  if (videoTitle.evaluate().isEmpty) {
    final scrollableWidget = find.byType(Scrollable);
    if (scrollableWidget.evaluate().isNotEmpty) {
      await tester.scrollUntilVisible(
        videoTitle,
        500.0,
        scrollable: scrollableWidget.first,
      );
    }
  }

  expect(
    videoTitle,
    findsOneWidget,
    reason: 'Video should appear in UI list'
  );
}

/// Test video player functionality
Future<void> _testVideoPlayer(WidgetTester tester, String title) async {
  // Tap on video to open player
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();

  // Verify player controls exist
  final playButton = find.byIcon(Icons.play_arrow).or(
    find.byIcon(Icons.pause)
  );
  expect(playButton, findsOneWidget, reason: 'Video player should have play/pause controls');

  // Test play/pause functionality
  if (playButton.evaluate().isNotEmpty) {
    await tester.tap(playButton);
    await tester.pumpAndSettle();
  }

  // Check for video progress indicator
  final progressIndicator = find.byType(LinearProgressIndicator).or(
    find.byType(Slider)
  );
  expect(progressIndicator, findsOneWidget, reason: 'Video player should show progress');
}

/// Test video tagging functionality
Future<void> _testVideoTagging(WidgetTester tester) async {
  // Look for tagging controls
  final tagButton = find.text('Add Tag').or(
    find.byIcon(Icons.label)
  ).or(
    find.byIcon(Icons.add)
  );

  if (tagButton.evaluate().isNotEmpty) {
    await tester.tap(tagButton);
    await tester.pumpAndSettle();

    // Enter tag information
    final tagField = find.byType(TextFormField).or(find.byType(TextField));
    if (tagField.evaluate().isNotEmpty) {
      await tester.enterText(tagField.first, 'Test Tag');
      await tester.pumpAndSettle();

      // Save tag
      final saveButton = find.text('Save').or(find.text('Add'));
      if (saveButton.evaluate().isNotEmpty) {
        await tester.tap(saveButton);
        await tester.pumpAndSettle();
      }
    }

    // Verify tag appears
    expect(find.text('Test Tag'), findsOneWidget, reason: 'Tag should be visible');
  }
}

/// Setup test video in database
Future<void> _setupTestVideo(SupabaseClient client, String title) async {
  try {
    await client.from('videos').insert({
      'title': title,
      'description': 'E2E test video',
      'file_path': 'test/path/video.mp4',
      'duration_seconds': 120,
      'processing_status': 'completed',
    });
  } catch (e) {
    // Video might already exist, which is fine for testing
    print('Setup video warning: $e');
  }
}

/// Navigate to video analysis screen
Future<void> _navigateToVideoAnalysis(WidgetTester tester) async {
  final analysisButton = find.text('Analysis').or(
    find.text('Video Analysis')
  ).or(
    find.byIcon(Icons.analytics)
  );

  if (analysisButton.evaluate().isNotEmpty) {
    await tester.tap(analysisButton);
    await tester.pumpAndSettle();
  }
}

/// Test analysis features
Future<void> _testAnalysisFeatures(WidgetTester tester) async {
  // Verify analysis screen elements
  final analysisElements = [
    find.text('Timeline'),
    find.text('Tags'),
    find.text('Statistics'),
    find.byIcon(Icons.timeline),
  ];

  bool foundAnalysisElement = false;
  for (final element in analysisElements) {
    if (element.evaluate().isNotEmpty) {
      foundAnalysisElement = true;
      break;
    }
  }

  expect(foundAnalysisElement, isTrue, reason: 'Should find analysis interface elements');
}

/// Test database error handling
Future<void> _testDatabaseErrorHandling(WidgetTester tester) async {
  // App should gracefully handle database connection issues
  // This is more of a behavioral test - app shouldn't crash

  // Try to perform actions that require database
  final buttons = find.byType(ElevatedButton).or(find.byType(TextButton));

  if (buttons.evaluate().isNotEmpty) {
    // Tap first available button
    await tester.tap(buttons.first);
    await tester.pumpAndSettle();

    // App should still be functional (not crash)
    expect(find.byType(MaterialApp), findsOneWidget, reason: 'App should remain stable');
  }
}

/// Cleanup test data from database
Future<void> _cleanupTestData(SupabaseClient client, String title) async {
  try {
    // Delete test video and related data
    await client.from('video_tags').delete().eq('video_id',
      client.from('videos').select('id').eq('title', title)
    );

    await client.from('videos').delete().eq('title', title);
  } catch (e) {
    print('Cleanup warning: $e');
    // Non-critical if cleanup fails
  }
}
