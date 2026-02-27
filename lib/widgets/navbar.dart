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
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.go(Routes.home),
              child: Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // compute a single logo height used for both the SVG and brand text sizing
                    Builder(builder: (ctx) {
                      final double logoHeight = (28.h * 0.85) * 1.10 * 1.20;
                      return Row(
                        children: [
                          SafeSvg.asset('assets/images/cat_head.svg', height: logoHeight),
                          SizedBox(width: isNarrow ? 0.w : 2.w),
                          // Brand split into two spans: prefix (orange) and suffix (black)
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: Strings.brandPrefix,
                                style: TextStyle(
                                  fontSize: logoHeight * 0.6,
                                  fontWeight: FontWeight.bold,
                                  color: kikiOrange,
                                ),
                              ),
                              TextSpan(
                                text: Strings.brandSuffix,
                                style: TextStyle(
                                  fontSize: logoHeight * 0.6,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const Spacer(),

            if (!isNarrow) ...[
              _NavLink(label: Strings.navHome, route: Routes.home),
              SizedBox(width: 12.w),
              _NavLink(label: Strings.navAbout, route: Routes.about),
              SizedBox(width: 12.w),
              _NavLink(label: Strings.navProjects, route: Routes.projects),
              SizedBox(width: 12.w),
              _NavLink(label: Strings.navContact, route: Routes.contact),
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB), // subtle light background
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 20, offset: const Offset(0, 6))
                                ],
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // small handle to indicate draggable sheet
                                    Center(
                                      child: Container(
                                        width: 48,
                                        height: 4,
                                        decoration: BoxDecoration(color: Colors.grey.withAlpha(60), borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SafeSvg.asset('assets/images/cat_head.svg', height: 38.h),
                                        const SizedBox(width: 6),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: Strings.brandPrefix,
                                              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: kikiOrange),
                                            ),
                                            TextSpan(
                                              text: Strings.brandSuffix,
                                              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: Colors.black),
                                            ),
                                          ]),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Divider(color: Colors.grey.withAlpha(40)),
                                    const SizedBox(height: 12),

                                    // Menu items — styled cards
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

  const _NavLink({required this.label, required this.route});

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
              color: _isActive ? kikiOrange : _hovered ? kikiDeep : const Color(0xFF6B7280),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                // cute accent dot
                Container(width: 10, height: 10, decoration: BoxDecoration(color: kikiOrange, borderRadius: BorderRadius.circular(6))),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: kikiDeep))),
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
