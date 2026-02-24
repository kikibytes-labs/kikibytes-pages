import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads and renders SVG assets with a static cache so each asset is only
/// fetched + sanitized once. Call [SafeSvg.preload] for each asset before
/// [runApp] to guarantee zero async lag on first render.
class SafeSvg extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;

  // Stores fully processed SVG strings keyed by asset path.
  static final Map<String, String> _cache = {};

  // Deduplicates concurrent loads for the same asset.
  static final Map<String, Future<String>> _inflight = {};

  const SafeSvg.asset(this.assetName, {super.key, this.width, this.height, this.fit = BoxFit.contain});

  /// Pre-warm the cache for [assetName]. Concurrent calls for the same path
  /// are coalesced into a single load.
  static Future<void> preload(String assetName) async {
    if (_cache.containsKey(assetName)) return;
    await _loadAndCache(assetName);
  }

  static Future<String> _loadAndCache(String assetName) {
    if (_cache.containsKey(assetName)) {
      return Future.value(_cache[assetName]!);
    }
    return _inflight.putIfAbsent(assetName, () async {
      try {
        final raw = await rootBundle.loadString(assetName);
        final result = _sanitize(raw);
        _cache[assetName] = result;
        return result;
      } catch (_) {
        _cache[assetName] = '';
        return '';
      } finally {
        _inflight.remove(assetName);
      }
    });
  }

  static String _sanitize(String svg) {
    // Replace percentage-based width/height with viewBox values when available.
    final viewBoxMatch = RegExp(
      r'viewBox="\s*([0-9.\-]+)\s+([0-9.\-]+)\s+([0-9.\-]+)\s+([0-9.\-]+)\s*"',
    ).firstMatch(svg);
    if (viewBoxMatch != null) {
      final vbW = viewBoxMatch.group(3);
      final vbH = viewBoxMatch.group(4);
      if (vbW != null && vbH != null) {
        svg = svg.replaceAll(RegExp(r'width="100%"'), 'width="$vbW"');
        svg = svg.replaceAll(RegExp(r'height="100%"'), 'height="$vbH"');
      }
    }
    // Convert stop offsets like offset="50%" → offset="0.5".
    svg = svg.replaceAllMapped(RegExp(r'offset="([0-9]+)%"'), (m) {
      final n = int.parse(m.group(1)!);
      return 'offset="${(n / 100).toStringAsFixed(2)}"';
    });
    return svg;
  }

  @override
  Widget build(BuildContext context) {
    // Cache hit → synchronous render, no async flicker.
    final cached = _cache[assetName];
    if (cached != null) {
      return cached.isEmpty ? _fallback() : _render(cached);
    }

    // Cache miss → async load (should only happen if preload wasn't called).
    return FutureBuilder<String>(
      future: _loadAndCache(assetName),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(width: width, height: height);
        }
        final data = snapshot.data;
        if (data == null || data.isEmpty) return _fallback();
        return _render(data);
      },
    );
  }

  Widget _render(String svg) {
    return SvgPicture.string(
      svg,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (context) => SizedBox(width: width, height: height),
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
