import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class ValuePill extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;

  const ValuePill({super.key, required this.title, required this.subtitle, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kikiOrange.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: SafeSvg.asset(assetPath, width: 24, height: 24)),
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(subtitle, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
