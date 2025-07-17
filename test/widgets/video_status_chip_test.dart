import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/services/video_upload_service.dart';
import 'package:jo17_tactical_manager/widgets/video_status_chip.dart';

void main() {
  group('VideoStatusChip label mapping', () {
    final labelExpectations = <UploadStage, String>{
      UploadStage.queued: 'Queued',
      UploadStage.precompressing: 'Compressing',
      UploadStage.uploading: 'Uploading',
      UploadStage.processing: 'Processing',
      UploadStage.complete: 'Ready',
      UploadStage.failed: 'Failed',
      UploadStage.retrying: 'Retrying',
    };

    labelExpectations.forEach((stage, label) {
      testWidgets('shows "$label" for $stage', (tester) async {
        final status = UploadStatus(stage: stage);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VideoStatusChip(status: status),
            ),
          ),
        );

        expect(find.text(label), findsOneWidget);
      });
    });
  });

  group('VideoStatusChip color mapping sanity', () {
    testWidgets('Queued uses disabled color', (tester) async {
      final status = UploadStatus(stage: UploadStage.queued);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(body: VideoStatusChip(status: status)),
        ),
      );
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.backgroundColor, ThemeData.light().disabledColor);
    });

    testWidgets('Complete uses green color', (tester) async {
      final status = UploadStatus(stage: UploadStage.complete);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VideoStatusChip(status: UploadStatus(stage: UploadStage.complete))),
        ),
      );
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect((chip.backgroundColor as Color).green, greaterThan(150));
    });

    testWidgets('Failed uses red color', (tester) async {
      final status = UploadStatus(stage: UploadStage.failed);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VideoStatusChip(status: UploadStatus(stage: UploadStage.failed))),
        ),
      );
      final chip = tester.widget<Chip>(find.byType(Chip));
      expect((chip.backgroundColor as Color).red, greaterThan(150));
    });
  });
}