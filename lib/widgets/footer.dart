import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../theme.dart';
import 'site_container.dart';
import 'safe_svg.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SiteContainer(
        child: Row(
          children: [
            Text(
              '© 2026 KikiBytes LLC. All rights reserved.',
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF6B7280)),
                  child: const Text('Privacy Policy'),
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF6B7280)),
                  child: const Text('Terms'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => launchUrlString('https://facebook.com/kikibytes'),
                  icon: SizedBox(width: 20, height: 20, child: SafeSvg.asset('assets/images/facebook.svg')),
                  color: kikiOrange,
                  tooltip: 'Facebook',
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () => launchUrlString('https://instagram.com/kiki.bytes'),
                  icon: SizedBox(width: 20, height: 20, child: SafeSvg.asset('assets/images/instagram.svg')),
                  color: kikiOrange,
                  tooltip: 'Instagram (@kiki.bytes)',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.email_outlined),
                  color: const Color(0xFF6B7280),
                  tooltip: 'Email',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
