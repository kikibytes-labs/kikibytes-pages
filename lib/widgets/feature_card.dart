import 'package:flutter/material.dart';
import '../theme.dart';
import 'safe_svg.dart';

class FeatureCard extends StatefulWidget {
  final String title;
  final String body;
  final String assetPath;

  const FeatureCard({super.key, required this.title, required this.body, required this.assetPath});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: _hovered
              ? [BoxShadow(color: kikiOrange.withAlpha(25), blurRadius: 16, offset: const Offset(0, 6))]
              : [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 72, child: SafeSvg.asset(widget.assetPath, width: 72, height: 72)),
              const SizedBox(height: 14),
              Text(widget.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(widget.body, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
