import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/video_tag.dart';

const _subscription = r'''
subscription VideoTagAdded(
  $videoId: uuid!
) {
  video_tags(where: {video_id: {_eq: $videoId}}) {
    id
    video_id
    timestamp
    label
    type
    player_id
    description
  }
}
''';

final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  const wsUrl = String.fromEnvironment(
    'GRAPHQL_WS_URL',
    defaultValue: 'wss://YOURPROJECT.supabase.co/graphql/v1',
  );
  final link = WebSocketLink(wsUrl);
  return GraphQLClient(link: link, cache: GraphQLCache());
});

final tagSubscriptionProvider =
    StreamProvider.family<List<VideoTag>, String>((ref, videoId) {
  final client = ref.watch(graphQLClientProvider);
  final options = SubscriptionOptions(
    document: gql(_subscription),
    variables: {'videoId': videoId},
  );
  return client.subscribe(options).map((result) {
    final list = (result.data?['video_tags'] as List<dynamic>? ?? [])
        .map((e) => VideoTag.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  });
});
