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

    return Column(
      children: [
        CircleAvatar(
          backgroundColor: kikiOrange.withAlpha(20),
          radius: 36,
          child: SafeSvg.asset(assetPath, width: 40, height: 40),
        ),
        const SizedBox(height: 10),
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(subtitle, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
