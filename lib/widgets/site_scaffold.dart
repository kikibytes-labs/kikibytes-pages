import 'package:flutter/material.dart';
import 'site_container.dart';

class SiteScaffold extends StatelessWidget {
  final Widget child;

  const SiteScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SiteContainer(child: child),
      ),
    );
  }
}