import 'package:flutter/material.dart';
import 'safe_svg.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String body;
  final String assetPath;

  const FeatureCard({super.key, required this.title, required this.body, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 80, child: SafeSvg.asset(assetPath, width: 80, height: 80)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
