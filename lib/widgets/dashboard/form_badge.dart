import 'package:flutter/material.dart';

import '../../repositories/prediction_repository.dart';

class FormBadge extends StatelessWidget {
  const FormBadge({super.key, required this.trend});

  final FormTrend trend;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (trend) {
      FormTrend.improving => (Icons.arrow_upward, Colors.green),
      FormTrend.declining => (Icons.arrow_downward, Colors.red),
      FormTrend.stable => (Icons.horizontal_rule, Colors.grey),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(trend.name, style: TextStyle(color: color)),
      ],
    );
  }
}