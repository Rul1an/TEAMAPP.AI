import 'package:flutter/material.dart';

typedef EventCardBuilder<T> = Widget Function(BuildContext context, T event);

class UpcomingEventsList<T> extends StatelessWidget {
  const UpcomingEventsList({
    super.key,
    required this.events,
    required this.cardBuilder,
    this.maxItems = 3,
    required this.emptyMessage,
  });

  final List<T> events;
  final EventCardBuilder<T> cardBuilder;
  final int maxItems;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text(emptyMessage)),
        ),
      );
    }

    return Column(
      children:
          events.take(maxItems).map((e) => cardBuilder(context, e)).toList(),
    );
  }
}
