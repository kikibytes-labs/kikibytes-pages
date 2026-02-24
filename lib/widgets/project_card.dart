import 'package:flutter/material.dart';
import '../theme.dart';

class ProjectCard extends StatefulWidget {
  /// Display name of the project.
  final String title;

  /// Short tagline shown beneath the title.
  final String tagline;

  /// Gradient used for the placeholder image area.
  final List<Color> gradientColors;

  /// Icon shown in the placeholder image area.
  final IconData previewIcon;

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

    return MouseRegion(
      cursor: _isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
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
                // Placeholder image area
                Stack(
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.gradientColors,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          widget.previewIcon,
                          size: 64,
                          color: Colors.white.withAlpha(200),
                        ),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(widget.tagline, style: theme.textTheme.bodyMedium),
                      if (!_isDisabled) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              'Learn More',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: kikiOrange,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AnimatedSlide(
                              duration: const Duration(milliseconds: 180),
                              offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                              child: Icon(Icons.arrow_forward, size: 14, color: kikiOrange),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
