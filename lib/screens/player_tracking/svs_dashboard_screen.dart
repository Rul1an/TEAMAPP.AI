import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SVSDashboardScreen extends ConsumerWidget {
  const SVSDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SVS Dashboard"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.track_changes, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text("Speler Volg Systeem", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Advanced player tracking and analytics", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 32),
            Text("Coming Soon...", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
