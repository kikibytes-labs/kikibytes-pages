import 'package:flutter/material.dart';

class SiteContainer extends StatelessWidget {
  final Widget child;
  const SiteContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: child,
        ),
      ),
    );
  }
}
