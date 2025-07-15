// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jo17_tactical_manager/services/video_upload_service.dart';

// Mocks --------------------------------------------------------------------
class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockStorageClient extends Mock implements StorageClient {}

class _MockStorageBucketApi extends Mock implements StorageFileApi {}

class _MockRealtimeChannel extends Mock implements RealtimeChannel {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail to avoid null parameter issues
    registerFallbackValue<dynamic>('');
    registerFallbackValue<Map<String, dynamic>>({});
  });

  group('VideoUploadService – queueUpload', () {
    late _MockSupabaseClient supabase;
    late _MockStorageClient storageClient;
    late _MockStorageBucketApi bucketApi;
    late _MockRealtimeChannel channel;
    late VideoUploadService service;
    late Function(dynamic payload) fireProcessingDone;

    const bucketName = 'videos';
    const filePath = 'u1/vid.mp4';

    setUp(() {
      supabase = _MockSupabaseClient();
      storageClient = _MockStorageClient();
      bucketApi = _MockStorageBucketApi();
      channel = _MockRealtimeChannel();
      service = VideoUploadService(supabase);

      // storage mocking
      when(() => supabase.storage).thenReturn(storageClient);
      when(() => storageClient.from(bucketName)).thenReturn(bucketApi);
      when(() => bucketApi.upload(any(), any())).thenAnswer((_) async {
        // succeed by default
        return;
      });

      // realtime channel mocking
      when(() => supabase.channel(any())).thenReturn(channel);
      when(() => channel.subscribe()).thenAnswer((_) async => channel);
      when(() => channel.unsubscribe()).thenReturn(null);
      when(() => channel.on(any(), any(), any()))
          .thenAnswer((invocation) {
        final cb = invocation.positionalArguments[2] as Function;
        // expose for tests
        fireProcessingDone = (payload) => cb(payload);
        return channel;
      });
    });

    test('emits queued → uploading → processing → complete on success', () {
      fakeAsync((async) {
        // Prepare dummy file
        final tmpDir = Directory.systemTemp.createTempSync();
        final file = File('${tmpDir.path}/vid.mp4')..writeAsStringSync('x');

        final stages = <UploadStage>[];
        service
            .queueUpload(file, bucket: bucketName, path: filePath)
            .listen((s) => stages.add(s.stage));

        // flush compress / upload microtasks
        async.flushMicrotasks();

        // Simulate processing-done broadcast
        fireProcessingDone({'path': filePath});
        async.flushMicrotasks();

        // Fast-forward 11 minutes to let internal timeout finish
        async.elapse(const Duration(minutes: 11));

        expect(stages, containsAllInOrder([
          UploadStage.queued,
          UploadStage.uploading,
          UploadStage.processing,
          UploadStage.complete,
        ]));
      });
    });

    test('emits retrying when first upload fails', () {
      fakeAsync((async) {
        var uploadCount = 0;
        when(() => bucketApi.upload(any(), any())).thenAnswer((_) async {
          uploadCount += 1;
          if (uploadCount == 1) {
            throw Exception('boom');
          }
          // succeed second try
        });

        // dummy file
        final file = File('${Directory.systemTemp.path}/v2.mp4')
          ..writeAsStringSync('x');
        final emitted = <UploadStage>[];
        service
            .queueUpload(file, bucket: bucketName, path: filePath)
            .listen((s) => emitted.add(s.stage));

        async.flushMicrotasks();
        // deliver broadcast after retry succeeds
        fireProcessingDone({'path': filePath});
        async.flushMicrotasks();
        async.elapse(const Duration(minutes: 11));

        expect(emitted, contains(UploadStage.retrying));
        expect(emitted.last, UploadStage.complete);
      });
    });

    test('fails after 3 unsuccessful upload attempts', () {
      fakeAsync((async) {
        // upload always throws
        when(() => bucketApi.upload(any(), any()))
            .thenThrow(Exception('fail'));

        final file = File('${Directory.systemTemp.path}/v3.mp4')
          ..writeAsStringSync('x');

        final stages = <UploadStage>[];
        service
            .queueUpload(file, bucket: bucketName, path: filePath)
            .listen((s) => stages.add(s.stage));

        async.flushMicrotasks();
        // advance time for retries (0.5s + 1s + 2s) + margin
        async.elapse(const Duration(seconds: 5));

        expect(stages.last, UploadStage.failed);
      });
    });
  });
}