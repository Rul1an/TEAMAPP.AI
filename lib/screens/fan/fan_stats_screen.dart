import 'package:flutter/material.dart';

class FanStatsScreen extends StatelessWidget {
  const FanStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Stats')),
      body: const Center(child: Text('Personal statistics will appear here.')),
    );
  }
}
