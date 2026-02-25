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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: kikiOrange.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: imageAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(imageAsset!, fit: BoxFit.contain, filterQuality: FilterQuality.high),
                  )
                : Icon(icon ?? Icons.help_outline, color: kikiOrange, size: 40),
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(subtitle, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
