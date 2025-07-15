// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/video.dart';
import 'package:jo17_tactical_manager/widgets/video/video_card.dart';
import 'package:jo17_tactical_manager/widgets/common/main_scaffold.dart';

void main() {
  group('VideoCard', () {
    testWidgets('renders title and fallback icon', (tester) async {
      final video = Video(
        id: '1',
        orgId: 'org',
        title: 'My Match',
        type: VideoType.match,
        uploadedBy: 'user',
        uploadedAt: DateTime.now(),
        videoUrl: 'https://example.com/video.mp4',
        fileSize: 100,
        duration: 60,
        status: ProcessingStatus.ready,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: VideoCard(video: video),
          ),
        ),
      );
      expect(find.text('My Match'), findsOneWidget);
      expect(find.byIcon(Icons.videocam), findsOneWidget);
    });
  });

  group('MainScaffold route mapping', () {
    test('maps /videos to index 6', () {
      expect(MainScaffold.routeToNavIndex('/videos'), 6);
      expect(MainScaffold.routeToNavIndex('/videos/123'), 6);
    });
  });
}