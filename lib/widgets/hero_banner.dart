import 'package:flutter/material.dart';
import 'safe_svg.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final String assetPath;

  const HeroBanner({super.key, required this.title, required this.subtitle, required this.ctaText, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.displayLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8),
                Text(subtitle, style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () {}, child: Text(ctaText)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 220, child: SafeSvg.asset(assetPath, width: 220, height: 160)),
        ],
      ),
    );
  }
}
