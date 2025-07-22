import 'package:flutter/material.dart';

class UserActivityMetricsCard extends StatelessWidget {
  const UserActivityMetricsCard({super.key});

  @override
  Widget build(BuildContext context) => const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Metric(label: 'Daily Active', value: '1,247'),
                  _Metric(label: 'New Sign-ups', value: '52'),
                  _Metric(label: 'Churn', value: '1.2%'),
                ],
              ),
            ],
          ),
        ),
      );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      );
}
