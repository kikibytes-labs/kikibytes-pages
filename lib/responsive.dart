import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Navbar / about page / value-pill layout switch (< 760)
  bool get isNarrow => screenWidth < 760;

  /// Lucky Hall Bingo layout switch (< 700)
  bool get isMobile => screenWidth < 700;

  /// Footer / hero-banner / project-card / feature-tile layout switch (< 600)
  bool get isCompact => screenWidth < 600;
}
