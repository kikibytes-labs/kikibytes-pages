import 'package:flutter/material.dart';
import 'app.dart';
import 'widgets/safe_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload all SVG assets in parallel before the first frame so every
  // SafeSvg widget renders synchronously with no async flicker.
  await Future.wait([
    SafeSvg.preload('assets/images/illustration.svg'),
    SafeSvg.preload('assets/images/logo.svg'),
    SafeSvg.preload('assets/images/facebook.svg'),
    SafeSvg.preload('assets/images/instagram.svg'),
  ]);

  runApp(const KikiBytesApp());
}
