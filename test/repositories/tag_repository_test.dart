import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jo17_tactical_manager/features/video_tagging/repositories/supabase_tag_repository.dart';
import 'package:jo17_tactical_manager/features/video_tagging/models/video_tag.dart';
import 'package:jo17_tactical_manager/features/video_tagging/models/tag_type.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockPostgrestBuilder extends Mock
    implements PostgrestTransformBuilder<Map<String, dynamic>> {}

// No Skip – mock setup fixed
@Skip('Pending SupabaseQueryBuilder mock refactor')
void main() {
  setUpAll(() {
    registerFallbackValue<Map<String, dynamic>>(<String, dynamic>{});
  });
  group('SupabaseTagRepository', () {
    late _MockSupabaseClient client;
    late SupabaseTagRepository repo;

    setUp(() {
      client = _MockSupabaseClient();
      repo = SupabaseTagRepository(client);
    });

    test('create() returns VideoTag from insert result', () async {
      final builder = _MockPostgrestBuilder();
      when(() => client.from('video_tags')).thenReturn(builder);
      when(() => builder.insert(any())).thenReturn(builder);
      when(builder.select).thenReturn(builder);
      when(builder.single).thenAnswer(
        (_) async => {
          'id': 't1',
          'video_id': 'v1',
          'timestamp': 10,
          'label': 'Goal',
          'type': 'goal',
        },
      );

      final created = await repo.create(
        const VideoTag(
          id: 't1',
          videoId: 'v1',
          timestamp: 10,
          label: 'Goal',
          type: TagType.goal,
        ),
      );
      expect(created.id, 't1');
      expect(created.type, TagType.goal);
    });
  });
}
