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
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 760;
    // Use a simple fixed brand font size (narrow vs wide).
    // Increase mobile brand size per request (4x on narrow screens).
    final double displayBrandSize = isNarrow ? (3.78.sp * 4) : 5.25.sp;

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
          children: [
            GestureDetector(
              onTap: () => context.go(Routes.home),
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  children: [
                    SafeSvg.asset('assets/images/cat_head.svg', height: (28.h * 0.85) * 1.10 * 1.20),
                    SizedBox(width: isNarrow ? 4.w : 2.w),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            // append a word-joiner to avoid line breaking between Kiki and Bytes
                            text: Strings.brandPrefix,
                            style: TextStyle(
                              fontSize: displayBrandSize,
                              fontWeight: FontWeight.bold,
                              color: kikiOrange,
                            ),
                          ),
                          TextSpan(
                            text: Strings.brandSuffix,
                            style: TextStyle(
                              fontSize: displayBrandSize,
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
            if (!isNarrow) ...[
              _NavLink(label: 'Home', route: Routes.home),
              SizedBox(width: 12.w),
              _NavLink(label: 'About', route: Routes.about),
              SizedBox(width: 12.w),
              _NavLink(label: 'Projects', route: Routes.projects),
              SizedBox(width: 12.w),
              _NavLink(label: 'Contact', route: Routes.contact),
            ] else ...[
              IconButton(
                onPressed: () {
                  showGeneralDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Navigation',
                    barrierColor: Colors.black26,
                    transitionDuration: const Duration(milliseconds: 220),
                    pageBuilder: (ctx, anim1, anim2) {
                      final topPadding = MediaQuery.of(context).padding.top + 8.0;
                      return SafeArea(
                        bottom: false,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: topPadding, left: 12, right: 12),
                            child: Material(
                              color: const Color(0xFFF9FAFB), // subtle light background
                              elevation: 8,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            Strings.brandPrefix + Strings.brandSuffix,
                                            style: TextStyle(fontSize: (22.sp * 4), fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Divider(color: Colors.grey.withAlpha(40)),
                                    const SizedBox(height: 8),

                                    // Menu items
                                    _MobileMenuItem(label: Strings.navHome, onTap: () {
                                      Navigator.of(ctx).pop();
                                      ctx.go(Routes.home);
                                    }),
                                    _MobileMenuItem(label: Strings.navAbout, onTap: () {
                                      Navigator.of(ctx).pop();
                                      ctx.go(Routes.about);
                                    }),
                                    _MobileMenuItem(label: Strings.navProjects, onTap: () {
                                      Navigator.of(ctx).pop();
                                      ctx.go(Routes.projects);
                                    }),
                                    _MobileMenuItem(label: Strings.navContact, onTap: () {
                                      Navigator.of(ctx).pop();
                                      ctx.go(Routes.contact);
                                    }),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    transitionBuilder: (ctx, anim, secAnim, child) {
                      final offset = Tween(begin: const Offset(0, -0.08), end: Offset.zero).animate(anim);
                      return SlideTransition(position: offset, child: child);
                    },
                  );
                },
                icon: const Icon(Icons.menu),
              ),
            ],
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

class _MobileMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MobileMenuItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: kikiDeep),
            ),
          ),
        ),
      ),
    );
  }
}
