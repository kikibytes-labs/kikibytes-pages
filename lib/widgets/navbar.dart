import 'package:flutter/material.dart';
import 'safe_svg.dart';
import '../routes.dart';
import 'site_container.dart';

class Navbar extends StatelessWidget {
  final void Function(String route) onNavigate;

  const Navbar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: Colors.white,
      child: SiteContainer(
        child: Row(
          children: [
            InkWell(
              onTap: () => onNavigate(Routes.home),
              child: Row(
                children: [
                  // Use SafeSvg for robust loading
                  SafeSvg.asset('assets/images/logo.svg', width: 48, height: 48),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Kiki',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                        TextSpan(
                            text: 'Bytes Labs',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _nav('Home', Routes.home),
            _nav('About', Routes.about),
            _nav('Contact', Routes.contact),
          ],
        ),
      ),
    );
  }

  Widget _nav(String label, String route) {
    return TextButton(
      onPressed: () => onNavigate(route),
      child: Text(label, style: const TextStyle(color: Colors.black87)),
    );
  }
}
