import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final String assetPath;
  final VoidCallback? onCtaPressed;

  const HeroBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.assetPath,
    this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1B4B), kikiOrange],
        ),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textContent(theme),
                const SizedBox(height: 24),
                Center(child: SafeSvg.asset(assetPath, width: 180, height: 130)),
              ],
            )
          : Row(
              children: [
                Expanded(child: _textContent(theme)),
                const SizedBox(width: 24),
                SafeSvg.asset(assetPath, width: 220, height: 160),
              ],
            ),
    );
  }

  Widget _textContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white.withAlpha(204),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        if (onCtaPressed != null && ctaText.isNotEmpty)
          ElevatedButton(
            onPressed: onCtaPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: kikiOrange,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            child: Text(ctaText),
          ),
      ],
    );
  }
}
