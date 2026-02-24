import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String ctaText;
  final String assetPath;
  final VoidCallback? onCtaPressed;
  final TextStyle? titleStyle;

  const HeroBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.ctaText = '',
    required this.assetPath,
    this.onCtaPressed,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;
    final isSvg = assetPath.toLowerCase().endsWith('.svg');
    // Use the same sizes as the original dummy images
    final double baseWidth = isNarrow ? 180.0 : 220.0;
    final double baseHeight = isNarrow ? 130.0 : 160.0;
    final double imageWidth = baseWidth;
    final double imageHeight = baseHeight;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C0A1E),
            Color(0xFF1E1B4B),
            kikiOrange,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textContent(theme),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                Center(
                  child: isSvg
                      ? SafeSvg.asset(assetPath, width: imageWidth, height: imageHeight)
                      : Image.asset(assetPath, width: imageWidth, height: imageHeight, fit: BoxFit.contain),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _textContent(theme)),
                const SizedBox(width: 24),
                isSvg
                  ? SafeSvg.asset(assetPath, width: imageWidth, height: imageHeight)
                  : Image.asset(assetPath, width: imageWidth, height: imageHeight, fit: BoxFit.contain),
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
          style: titleStyle?.copyWith(color: Colors.white) ??
              theme.textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white.withAlpha(204),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
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
