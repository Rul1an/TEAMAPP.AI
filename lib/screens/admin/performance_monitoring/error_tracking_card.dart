import 'package:flutter/material.dart';

class ErrorTrackingCard extends StatelessWidget {
  const ErrorTrackingCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Error Tracking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // simple placeholder list
              SizedBox(
                height: 160,
                child: ListView(
                  children: const [
                    ListTile(leading: Icon(Icons.error, color: Colors.red), title: Text('NullPointerException'), subtitle: Text('4 occurrences • last 1h')),
                    ListTile(leading: Icon(Icons.error, color: Colors.orange), title: Text('TimeoutException'), subtitle: Text('2 occurrences • last 2h')),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}