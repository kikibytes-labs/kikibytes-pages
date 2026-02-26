import 'package:flutter/material.dart';
import 'app.dart';
import 'widgets/safe_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: PreloadApp(child: KikiBytesApp()),
    ),
  );
}

/// Top-level widget that triggers asset preloads from a safe BuildContext.
class PreloadApp extends StatefulWidget {
  final Widget child;

  const PreloadApp({Key? key, required this.child}) : super(key: key);

  @override
  State<PreloadApp> createState() => _PreloadAppState();
}

class _PreloadAppState extends State<PreloadApp> {
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    // Ensure we have a render context; run preloads after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPreloads());
  }

  Future<void> _startPreloads() async {
    final svgs = [
      'assets/images/logo.png',
      'assets/images/facebook.svg',
      'assets/images/instagram.svg',
      'assets/images/lhb_charm.svg',
      'assets/images/cat_computer.svg',
      'assets/images/cat_head.svg',
      'assets/images/cat_hiking.svg',
      'assets/images/cat_phone.svg',
      'assets/images/cat_sawing.svg',
      'assets/images/cat_scholar.svg',
      'assets/images/cat_towel.svg',
      'assets/images/lightbulb.svg',
      'assets/images/gears.svg',
      'assets/images/joystick.svg',
      'assets/images/handshake.svg',
      'assets/images/bingo.svg',
      'assets/images/charms.svg',
      'assets/images/daub.svg',
      'assets/images/pulltab.svg',
      'assets/images/lhb_title.svg',
    ];

    final bitmapAssets = [
      'assets/images/bg.png',
      'assets/images/bg_lhb.png',
      'assets/images/logo.png',
    ];
    try {
      // Start SVG preloads and bitmap precaches and wait for completion.
      final svgFutures = svgs.map((p) => SafeSvg.preload(p)).toList();
      final bitmapFutures = bitmapAssets.map((p) async {
        try {
          await precacheImage(AssetImage(p), context);
        } catch (_) {}
      });
      final bitmapList = bitmapFutures.toList();
      await Future.wait([...svgFutures, ...bitmapList]);
    } catch (_) {
      // ignore errors but continue to show app
    }

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      // simple splash while assets load
      return Material(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png', height: 58),
              const SizedBox(height: 16),
              SizedBox(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
