import 'package:flutter/material.dart';
import '../theme.dart';
import 'site_container.dart';

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
                  onPressed: () {},
                  icon: const Icon(Icons.facebook),
                  color: kikiOrange,
                  tooltip: 'Facebook',
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
