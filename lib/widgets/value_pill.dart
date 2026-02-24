import 'package:flutter/material.dart';
import '../theme.dart';

class ValuePill extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? imageAsset;

  const ValuePill({super.key, required this.title, required this.subtitle, this.icon, this.imageAsset});

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
            // triple the container to accommodate triple-sized images
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: kikiOrange.withAlpha(20),
              borderRadius: BorderRadius.circular(36),
            ),
            child: imageAsset != null
                ? Padding(
                    // center a 66x66 image (22 * 3)
                    padding: const EdgeInsets.all(33),
                    child: Image.asset(imageAsset!, width: 66, height: 66, fit: BoxFit.contain),
                  )
                : Icon(icon ?? Icons.help_outline, color: kikiOrange, size: 66),
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
