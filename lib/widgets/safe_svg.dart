import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads an SVG asset safely. If the SVG fails to parse, shows a fallback widget.
class SafeSvg extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SafeSvg.asset(this.assetName, {super.key, this.width, this.height, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString(assetName),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(width: width, height: height);
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _fallback();
        }
        try {
          // Log asset being loaded to aid debugging when parsing fails.
          // ignore: avoid_print
          print('SafeSvg: loading $assetName');

          String svg = snapshot.data!;

          // First attempt to parse as-is
          try {
            return SvgPicture.string(
              svg,
              width: width,
              height: height,
              fit: fit,
              placeholderBuilder: (context) => SizedBox(width: width, height: height),
            );
          } catch (e) {
            // ignore: avoid_print
            print('SafeSvg: initial parse failed for $assetName: $e');
          }

          // Attempt to sanitize percentage-based attributes when viewBox is available
          try {
            final viewBoxMatch = RegExp(r'viewBox="\s*([0-9.\-]+)\s+([0-9.\-]+)\s+([0-9.\-]+)\s+([0-9.\-]+)\s*"').firstMatch(svg);
            if (viewBoxMatch != null) {
              final vbW = viewBoxMatch.group(3);
              final vbH = viewBoxMatch.group(4);
              if (vbW != null && vbH != null) {
                svg = svg.replaceAllMapped(RegExp(r'width="100%"'), (_) => 'width="$vbW"');
                svg = svg.replaceAllMapped(RegExp(r'height="100%"'), (_) => 'height="$vbH"');
              }
            }

            // Convert stop offsets like "50%" -> "0.5"
            svg = svg.replaceAllMapped(RegExp(r'offset="([0-9]+)%"'), (m) {
              final n = int.parse(m.group(1)!);
              final dec = (n / 100).toString();
              return 'offset="$dec"';
            });

            return SvgPicture.string(
              svg,
              width: width,
              height: height,
              fit: fit,
              placeholderBuilder: (context) => SizedBox(width: width, height: height),
            );
          } catch (e) {
            // ignore: avoid_print
            print('SafeSvg: sanitized parse failed for $assetName: $e');
            return _fallback();
          }
        } catch (_) {
          return _fallback();
        }
      },
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
