import 'package:flutter/material.dart';
import 'app.dart';
import 'widgets/safe_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload all SVG assets in parallel before the first frame so every
  // SafeSvg widget renders synchronously with no async flicker.
  await Future.wait([
    // logo.png is used instead of svg
    SafeSvg.preload('assets/images/logo.png'),
    SafeSvg.preload('assets/images/facebook.svg'),
    SafeSvg.preload('assets/images/instagram.svg'),
    SafeSvg.preload('assets/images/lhb_charm.svg'),
    SafeSvg.preload('assets/images/cat_computer.svg'),
    SafeSvg.preload('assets/images/cat_head.svg'),
    SafeSvg.preload('assets/images/cat_hiking.svg'),
    SafeSvg.preload('assets/images/cat_phone.svg'),
    SafeSvg.preload('assets/images/cat_sawing.svg'),
    SafeSvg.preload('assets/images/cat_scholar.svg'),
    SafeSvg.preload('assets/images/cat_towel.svg'),
    SafeSvg.preload('assets/images/lightbulb.svg'),
    SafeSvg.preload('assets/images/gears.svg'),
    SafeSvg.preload('assets/images/joystick.svg'),
    SafeSvg.preload('assets/images/handshake.svg'),
    // lucky hall feature icons
    SafeSvg.preload('assets/images/bingo.svg'),
    SafeSvg.preload('assets/images/charms.svg'),
    SafeSvg.preload('assets/images/daub.svg'),
    SafeSvg.preload('assets/images/pulltab.svg'),
    // hero & title backgrounds
    SafeSvg.preload('assets/images/lhb_title.svg'),
    SafeSvg.preload('assets/images/bg.png'),
    SafeSvg.preload('assets/images/bg_lhb.png'),
  ]);

  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Precache raster images (PNGs/JPGs) so they are decoded before
        // the first frame. `SafeSvg.preload` is already called in main() to
        // load and sanitize SVG strings; parsing into pictures is handled by
        // the `SafeSvg` widget when it renders.
        final bitmapAssets = [
          'assets/images/bg.png',
          'assets/images/bg_lhb.png',
          'assets/images/logo.png',
        ];

        final preloadFuture = Future.wait(bitmapAssets.map((p) => precacheImage(AssetImage(p), context)));

        return FutureBuilder(
          future: preloadFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              // Keep a blank frame (or spinner) until images are ready to avoid
              // visual pop-in. Using a simple SizedBox keeps layout stable.
              return const SizedBox.shrink();
            }
            return child!;
          },
        );
      },
      child: KikiBytesApp(),
    ),
  );
}
