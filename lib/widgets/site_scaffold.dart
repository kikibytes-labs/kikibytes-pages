import 'package:flutter/material.dart';
import 'site_container.dart';

class SiteScaffold extends StatelessWidget {
  final Widget child;

  const SiteScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // No nested Scaffold — the outer router shell provides one.  Wrap the
    // body in a white container so that when the page fades in the underlying
    // content from the previous route isn't visible through transparent areas.
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: SiteContainer(child: child),
      ),
    );
  }
}