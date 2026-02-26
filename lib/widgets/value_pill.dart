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
    // Responsive fixed-size box: slightly smaller on narrow screens to avoid overflow.
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 760;
    final double pillWidth = isNarrow ? (screenWidth - 48).clamp(140.0, 420.0) : 210.0;
    final double pillHeight = isNarrow ? 160.0 : 210.0;
    final double innerPadding = isNarrow ? 12.0 : 20.0;

    // Keep a fixed width but allow height to grow so content (text) can wrap
    // without causing bottom overflow. Constrain the image area so it doesn't
    // dominate vertical space.
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: pillWidth, maxWidth: pillWidth),
      child: Container(
        padding: EdgeInsets.all(innerPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // box just big enough to enclose the image/icon
            Builder(builder: (_) {
              // Scale the image/icon down slightly on narrow screens so it fits
              final double scale = isNarrow ? 0.8 : 1.0;
              final double containerSize = (48 * imageSizeMultiplier) * scale;
              final double svgPadding = (8 * imageSizeMultiplier) * scale;

              // Limit the image area height so remaining space is available for
              // title/subtitle text. Use BoxFit.contain to avoid stretching.
              final double maxImageHeight = isNarrow ? pillHeight * 0.38 : 90.0;
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxImageHeight),
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: kikiOrange.withAlpha(20),
                    borderRadius: BorderRadius.circular(12 * imageSizeMultiplier * scale),
                  ),
                  child: imageAsset != null
                      ? Padding(
                          padding: EdgeInsets.all(svgPadding),
                          child: SafeSvg.asset(imageAsset!, width: double.infinity, height: double.infinity, fit: BoxFit.contain),
                        )
                      : Icon(icon ?? Icons.help_outline, color: kikiOrange, size: 24 * imageSizeMultiplier * scale),
                ),
              );
            }),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          // Reduce text size slightly on narrow screens to avoid wrapping overflow
          Builder(builder: (_) {
            final TextStyle textStyle = isNarrow ? theme.textTheme.bodySmall! : theme.textTheme.bodyMedium!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(subtitle, style: textStyle, textAlign: TextAlign.center),
            );
          }),
        ],
      ),
      ),
    );
  }
}
