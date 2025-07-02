import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lightweight MaterialApp for widget/integration tests.
class TestApp extends StatelessWidget {
  const TestApp({super.key, required this.child, this.overrides = const []});

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        title: 'TestApp',
        theme: ThemeData.light(),
        home: child,
      ),
    );
  }
}
