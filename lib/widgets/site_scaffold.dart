import 'package:flutter/material.dart';
import 'navbar.dart';
import 'footer.dart';
import 'site_container.dart';

class SiteScaffold extends StatelessWidget {
  final Widget child;

  const SiteScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(onNavigate: (route) => Navigator.of(context).pushNamed(route)),
          Expanded(
            child: SingleChildScrollView(
              child: SiteContainer(child: child),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}