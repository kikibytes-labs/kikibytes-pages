import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class HeroBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String ctaText;
  final String assetPath;
  /// optional background image to use instead of the shared `bg.png`.
  /// if null the default `assets/images/bg.png` is used.
  final String? backgroundAsset;
  final VoidCallback? onCtaPressed;
  final TextStyle? titleStyle;

  const HeroBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.ctaText = '',
    required this.assetPath,
    this.backgroundAsset,
    this.onCtaPressed,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;

    // base sizes (original dummy sizes)
    final double baseWidth = isNarrow ? 180.0 : 220.0;
    final double baseHeight = isNarrow ? 130.0 : 160.0;
    final double imageWidth = baseWidth;
    final double imageHeight = baseHeight;

    // When rendering for wide layouts we want the image visually larger but
    // without affecting surrounding layout. We render a scaled image and
    // position it absolutely using a Positioned widget inside a Stack.
    // enlarge title banner assets again
    const double imageScale = 2.0;

    // Banner container (keeps its size and layout); the image is part of
    // the banner and does not float outside it. This attaches the graphic
    // rather than letting it overlap.
    final banner = Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: isNarrow ? 16 : 36, vertical: isNarrow ? 20 : 36),
      // the banner now uses a fixed background image (customizable per
      // instance) but we keep the previous gradient underneath as a
      // fallback in case the image fails to load or is transparent. the
      // gradient is still visible through any semi‑transparent portions
      // of the PNG.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8E2DE2), // purple
            Color(0xFF4A00E0), // deep blue
            Color(0xFFFF416C), // pink
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        image: DecorationImage(
          image: AssetImage(backgroundAsset ?? 'assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textContent(theme),
                const SizedBox(height: 24),
                SizedBox(
                  width: imageWidth * imageScale,
                  height: imageHeight * imageScale,
                  child: SafeSvg.asset(assetPath),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _textContent(theme)),
                const SizedBox(width: 24),
                SizedBox(
                  width: imageWidth * imageScale,
                  height: imageHeight * imageScale,
                  child: SafeSvg.asset(assetPath),
                ),
              ],
            ),
    );

    return banner;
  }

  Widget _textContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle?.copyWith(color: Colors.black) ??
              theme.textTheme.displayLarge?.copyWith(color: Colors.black),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.black.withAlpha(204),
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
