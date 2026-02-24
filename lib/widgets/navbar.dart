import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import 'safe_svg.dart';
import 'site_container.dart';

class Navbar extends StatelessWidget {
  final void Function(String route) onNavigate;
  final String currentRoute;

  const Navbar({super.key, required this.onNavigate, required this.currentRoute});

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SiteContainer(
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onNavigate(Routes.home),
                child: Row(
                  children: [
                    SafeSvg.asset('assets/images/logo.svg', width: 34, height: 34),
                    const SizedBox(width: 10),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Kiki',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: kikiOrange,
                              letterSpacing: -0.3,
                            ),
                          ),
                          TextSpan(
                            text: 'Bytes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: kikiDeep,
                              letterSpacing: -0.3,
                            ),
                          ),
                          TextSpan(
                            text: ' Labs',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFADB5BD),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            _NavLink(label: 'Home', route: Routes.home, currentRoute: currentRoute, onNavigate: onNavigate),
            const SizedBox(width: 2),
            _NavLink(label: 'About', route: Routes.about, currentRoute: currentRoute, onNavigate: onNavigate),
            const SizedBox(width: 2),
            _NavLink(label: 'Contact', route: Routes.contact, currentRoute: currentRoute, onNavigate: onNavigate),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String route;
  final String currentRoute;
  final void Function(String) onNavigate;

  const _NavLink({
    required this.label,
    required this.route,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  bool get _isActive => widget.currentRoute == widget.route;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onNavigate(widget.route),
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
