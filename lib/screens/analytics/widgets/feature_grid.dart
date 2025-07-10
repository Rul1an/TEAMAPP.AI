import 'package:flutter/material.dart';

import 'feature_card.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({
    super.key,
    required this.cards,
  });

  final List<FeatureCard> cards;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: cards,
    );
  }
}