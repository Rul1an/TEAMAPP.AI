import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/screens/dashboard/widgets/upcoming_events_list.dart';
import 'package:jo17_tactical_manager/screens/dashboard/widgets/parent_overview_card.dart';

void main() {
  group('UpcomingEventsList', () {
    testWidgets('shows empty message when no events', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: UpcomingEventsList<String>(
          events: [],
          emptyMessage: 'Geen events',
          cardBuilder: (_, __) => SizedBox(),
        ),
      ));

      expect(find.text('Geen events'), findsOneWidget);
    });

    testWidgets('renders event tiles', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: UpcomingEventsList<String>(
          events: ['A'],
          emptyMessage: 'Geen',
          cardBuilder: (ctx, e) => ListTile(title: Text(e)),
        ),
      ));

      expect(find.text('A'), findsOneWidget);
    });
  });

  group('ParentOverviewCard', () {
    testWidgets('renders header text', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: ParentOverviewCard(),
      ));

      expect(find.text('Overzicht van uw kind'), findsOneWidget);
    });
  });
}
