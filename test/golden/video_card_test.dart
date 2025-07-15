// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Package imports:
import 'package:golden_toolkit/golden_toolkit.dart';

// Project imports:
import 'package:jo17_tactical_manager/models/video.dart';
import 'package:jo17_tactical_manager/widgets/video/video_card.dart';

void main() {
  testGoldens('VideoCard light & dark', (tester) async {
    final video = Video(
      id: '1',
      orgId: 'org',
      title: 'Demo',
      type: VideoType.match,
      uploadedBy: 'u',
      uploadedAt: DateTime.now(),
      videoUrl: 'https://example.com/v.mp4',
      fileSize: 123,
      duration: 10,
      status: ProcessingStatus.ready,
    );

    await tester.pumpWidgetBuilder(
      VideoCard(video: video),
      surfaceSize: const Size(200, 140),
      wrapper: materialAppWrapper(theme: ThemeData.light()),
    );
    await screenMatchesGolden(tester, 'video_card_light');

    await tester.pumpWidgetBuilder(
      VideoCard(video: video),
      surfaceSize: const Size(200, 140),
      wrapper: materialAppWrapper(theme: ThemeData.dark()),
    );
    await screenMatchesGolden(tester, 'video_card_dark');
  });
}