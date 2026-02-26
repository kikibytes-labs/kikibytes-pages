import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import 'site_container.dart';
import 'package:go_router/go_router.dart';
import 'safe_svg.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 24,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      child: SiteContainer(
        // navigation row with logo attached on the left
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => context.go(Routes.home),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SafeSvg.asset('assets/images/cat_head.svg', height: 28),
                  const SizedBox(width: 10),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          // append a word-joiner to avoid line breaking between Kiki and Bytes
                          text: 'Kiki\u2060',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kikiOrange,
                          ),
                        ),
                        TextSpan(
                          text: 'Bytes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' Labs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: kikiDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _NavLink(label: 'Home', route: Routes.home),
            const SizedBox(width: 12),
            _NavLink(label: 'About', route: Routes.about),
            const SizedBox(width: 12),
            _NavLink(label: 'Projects', route: Routes.projects),
            const SizedBox(width: 12),
            _NavLink(label: 'Contact', route: Routes.contact),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String route;

  const _NavLink({
    required this.label,
    required this.route,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  bool get _isActive => GoRouter.of(context).state.uri.path == widget.route;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _isActive
                ? kikiOrange.withAlpha(18)
                : _hovered
                    ? const Color(0xFFF3F4F6)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontSize: 14,
              fontWeight: _isActive ? FontWeight.w600 : FontWeight.w500,
              color: _isActive
                  ? kikiOrange
                  : _hovered
                      ? kikiDeep
                      : const Color(0xFF6B7280),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
