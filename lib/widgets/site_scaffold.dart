import 'package:flutter/material.dart';
import 'site_container.dart';

class SiteScaffold extends StatelessWidget {
  final Widget child;

  const SiteScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // No nested Scaffold — the outer MainShell already provides one.
    return SingleChildScrollView(
      child: SiteContainer(child: child),
    );
  }
}