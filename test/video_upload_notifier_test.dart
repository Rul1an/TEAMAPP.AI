import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jo17_tactical_manager/providers/video_upload_provider.dart';
import 'package:jo17_tactical_manager/services/video_upload_manager.dart';

class _MockVideoUploadManager extends Mock implements VideoUploadManager {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VideoUploadNotifier', () {
    late _MockVideoUploadManager mockManager;
    late VideoUploadNotifier notifier;

    setUp(() {
      mockManager = _MockVideoUploadManager();
      notifier = VideoUploadNotifier(mockManager);
    });

    test('emits success state on successful upload', () async {
      const fakeUrl = 'https://example.com/video.mp4';
      when(() => mockManager.compressAndUpload(any(), onProgress: any(named: 'onProgress')))
          .thenAnswer((invocation) async {
        final onProgress = invocation.namedArguments[#onProgress] as void Function(double)?;
        onProgress?.call(0.5);
        onProgress?.call(1.0);
        return fakeUrl;
      });

      final file = File('dummy.mp4');
      await notifier.upload(file);

      expect(notifier.state.status, VideoUploadStatus.success);
      expect(notifier.state.message, fakeUrl);
      expect(notifier.state.progress, 1.0);
    });

    test('emits error state on exception', () async {
      when(() => mockManager.compressAndUpload(any(), onProgress: any(named: 'onProgress')))
          .thenThrow(Exception('failure'));

      final file = File('dummy.mp4');
      await notifier.upload(file);

      expect(notifier.state.status, VideoUploadStatus.error);
      expect(notifier.state.message, contains('failure'));
    });
  });
}