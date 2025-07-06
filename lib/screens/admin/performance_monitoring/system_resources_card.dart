import 'package:flutter/material.dart';

class SystemResourcesCard extends StatelessWidget {
  const SystemResourcesCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('System Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _Gauge(label: 'CPU', percent: 0.65, color: Colors.blue),
                  _Gauge(label: 'Memory', percent: 0.43, color: Colors.green),
                  _Gauge(label: 'Disk', percent: 0.78, color: Colors.orange),
                ],
              ),
            ],
          ),
        ),
      );
}

class _Gauge extends StatelessWidget {
  const _Gauge({required this.label, required this.percent, required this.color});
  final String label;
  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 8,
                  color: color,
                  backgroundColor: color.withOpacity(0.2),
                ),
              ),
              Text('${(percent * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      );
}