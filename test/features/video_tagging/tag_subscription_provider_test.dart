// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

// Project imports:
import 'package:jo17_tactical_manager/features/video_tagging/models/video_tag.dart';
import 'package:jo17_tactical_manager/features/video_tagging/providers/tag_subscription_provider.dart';

class _MockGraphQLClient extends Mock implements GraphQLClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      SubscriptionOptions(document: gql('subscription { __typename }')),
    );
  });

  test('tagSubscriptionProvider maps GraphQL result to VideoTag list',
      () async {
    final mockClient = _MockGraphQLClient();

    final result = QueryResult(
      options: SubscriptionOptions(document: gql('')), // minimal
      data: {
        'video_tags': [
          {
            'id': 't1',
            'video_id': 'v1',
            'timestamp': 3,
            'label': 'Goal',
            'type': 'goal',
            'player_id': 'p1',
            'description': 'Left-foot volley',
          }
        ],
      },
      source: QueryResultSource.network,
    );

    when(() => mockClient.subscribe(any()))
        .thenAnswer((_) => Stream.value(result));

    final container = ProviderContainer(
      overrides: [graphQLClientProvider.overrideWithValue(mockClient)],
    );
    addTearDown(container.dispose);

    final first = await container.read(tagSubscriptionProvider('v1').future);
    expect(first, isA<List<VideoTag>>());
    expect(first.first.id, 't1');
  });
}
