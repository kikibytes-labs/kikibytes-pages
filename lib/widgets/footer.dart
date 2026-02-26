import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../theme.dart';
import 'site_container.dart';
import 'safe_svg.dart';
import '../routes.dart';
import '../contact_config.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SiteContainer(
        child: Row(
          children: [
            const Text(
              '© 2026 KikiBytes LLC',
              style: TextStyle(fontSize: 12, color: Color(0xFFADB5BD)),
            ),
            const Spacer(),
            _FooterLink(label: 'Privacy', onTap: () => context.go(Routes.privacy)),
            const _Separator(),
            _FooterLink(label: 'Terms', onTap: () => context.go(Routes.terms)),
            const SizedBox(width: 20),
            _SocialButton(
              tooltip: 'Facebook',
              onTap: () => launchUrlString('https://www.facebook.com/profile.php?id=61588637222576'),
              child: SafeSvg.asset('assets/images/facebook.svg', width: 15, height: 15),
            ),
            const SizedBox(width: 14),
            _SocialButton(
              tooltip: 'Instagram',
              onTap: () => launchUrlString('https://instagram.com/kikibytes'),
              child: SafeSvg.asset('assets/images/instagram.svg', width: 15, height: 15),
            ),
            const SizedBox(width: 14),
            _SocialButton(
              tooltip: 'Email us',
              onTap: () => launchUrlString('mailto:$contactEmail'),
              child: const Icon(Icons.alternate_email_rounded, size: 15, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 120),
            style: TextStyle(
              fontSize: 12,
              color: _hovered ? kikiOrange : const Color(0xFF6B7280),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '·',
      style: TextStyle(fontSize: 12, color: Color(0xFFD1D5DB)),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final Widget child;
  final String tooltip;
  final VoidCallback onTap;
  const _SocialButton({required this.child, required this.tooltip, required this.onTap});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 120),
            opacity: _hovered ? 1.0 : 0.45,
            child: SizedBox(width: 18, height: 18, child: Center(child: widget.child)),
          ),
        ),
      ),
    );
  }
}
