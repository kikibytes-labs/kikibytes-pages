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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SiteContainer(
        child: Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onNavigate(Routes.home),
                child: Row(
                  children: [
                    SafeSvg.asset('assets/images/logo.svg', width: 40, height: 40),
                    const SizedBox(width: 10),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Kiki',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kikiOrange,
                            ),
                          ),
                          TextSpan(
                            text: 'Bytes Labs',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kikiDeep,
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
            _NavLink(label: 'About', route: Routes.about, currentRoute: currentRoute, onNavigate: onNavigate),
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
    final color = _isActive
        ? kikiOrange
        : _hovered
            ? kikiDeep
            : const Color(0xFF6B7280);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onNavigate(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isActive ? kikiOrange : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontSize: 14,
              fontWeight: _isActive ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
