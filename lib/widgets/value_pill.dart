import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class ValuePill extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? imageAsset;
  final double imageSizeMultiplier; // scales the image/icon container

  const ValuePill({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.imageAsset,
    this.imageSizeMultiplier = 1.0,
  });

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // box just big enough to enclose the image/icon
          Builder(builder: (_) {
            final double containerSize = 48 * imageSizeMultiplier;
            final double innerPadding = 8 * imageSizeMultiplier;

            return Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: kikiOrange.withAlpha(20),
                borderRadius: BorderRadius.circular(12 * imageSizeMultiplier),
              ),
              child: imageAsset != null
                  ? Padding(
                      padding: EdgeInsets.all(innerPadding),
                      child: SafeSvg.asset(imageAsset!, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
                    )
                  : Icon(icon ?? Icons.help_outline, color: kikiOrange, size: 24 * imageSizeMultiplier),
            );
          }),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(subtitle, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
