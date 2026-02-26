import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class ProjectCard extends StatefulWidget {
  /// Display name of the project.
  final String title;

  /// Short tagline shown beneath the title.
  final String tagline;

  /// Gradient used for the placeholder image area (ignored when [imageAsset] is provided).
  final List<Color> gradientColors;

  /// Icon shown in the placeholder image area (ignored when [imageAsset] is provided).
  final IconData previewIcon;

  /// Optional image asset to render in the top area instead of the gradient/icon.
  final String? imageAsset;

  /// Optional badge label (e.g. "In Progress"). Null means no badge.
  final String? badge;

  /// Called when the card is tapped. Null disables navigation.
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.tagline,
    required this.gradientColors,
    required this.previewIcon,
    this.imageAsset,
    this.badge,
    this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  bool get _isDisabled => widget.onTap == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;
    final imageHeight = isNarrow ? 160.0 : 200.0;

    // Build the card widget first so we can optionally constrain and center it
    Widget cardWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: _hovered && !_isDisabled
            ? [BoxShadow(color: kikiOrange.withAlpha(30), blurRadius: 20, offset: const Offset(0, 8))]
            : [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder image area (or real asset)
            Stack(
              children: [
                Container(
                  height: imageHeight,
                  decoration: widget.imageAsset == null
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: widget.gradientColors,
                          ),
                        )
                      : null,
                  child: widget.imageAsset == null
                      ? Center(
                          child: Icon(
                            widget.previewIcon,
                            size: isNarrow ? 48 : 64,
                            color: Colors.white.withAlpha(200),
                          ),
                        )
                      : SafeSvg.asset(
                          widget.imageAsset!,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
                if (widget.badge != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _Badge(label: widget.badge!),
                  ),
              ],
            ),
            // Card body
            Padding(
              padding: EdgeInsets.all(isNarrow ? 14 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(widget.tagline, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Learn More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isDisabled ? Colors.grey : kikiOrange,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _isDisabled
                          ? const Icon(Icons.arrow_forward, size: 14, color: Colors.grey)
                          : AnimatedSlide(
                              duration: const Duration(milliseconds: 180),
                              offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                              child: const Icon(Icons.arrow_forward, size: 14, color: kikiOrange),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // If this card uses an image asset, constrain its width and center it
    if (widget.imageAsset != null) {
      cardWidget = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: cardWidget,
        ),
      );
    }

    // On narrow screens, add horizontal padding so cards don't feel long & skinny
    if (isNarrow) {
      cardWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: cardWidget,
      );
    }

    return MouseRegion(
      cursor: _isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: cardWidget,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
