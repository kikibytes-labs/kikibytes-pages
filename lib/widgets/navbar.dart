import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme.dart';
import '../strings.dart';
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
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      SafeSvg.asset('assets/images/cat_head.svg', height: (28.h * 0.85) * 1.10),
                    SizedBox(width: 6.w),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            // append a word-joiner to avoid line breaking between Kiki and Bytes
                            text: Strings.brandPrefix,
                            style: TextStyle(
                              fontSize: 7.8.sp * 1.18,
                              fontWeight: FontWeight.bold,
                              color: kikiOrange,
                            ),
                          ),
                          TextSpan(
                            text: Strings.brandSuffix,
                            style: TextStyle(
                              fontSize: 7.8.sp * 1.18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
            _NavLink(label: 'Home', route: Routes.home),
            SizedBox(width: 12.w),
            _NavLink(label: 'About', route: Routes.about),
            SizedBox(width: 12.w),
            _NavLink(label: 'Projects', route: Routes.projects),
            SizedBox(width: 12.w),
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
