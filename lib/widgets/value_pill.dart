import 'package:flutter/material.dart';
import 'safe_svg.dart';

class ValuePill extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;

  const ValuePill({super.key, required this.title, required this.subtitle, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.white, radius: 34, child: SafeSvg.asset(assetPath, width: 40, height: 40)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(subtitle, textAlign: TextAlign.center),
      ],
    );
  }
}
