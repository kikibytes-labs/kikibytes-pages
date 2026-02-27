import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../strings.dart';
import '../widgets/safe_svg.dart';

class LuckyHallBingoPage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const LuckyHallBingoPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroBanner(
            title: Strings.luckyHallTitle,
            subtitle: Strings.luckyHallSubtitle,
            assetPath: 'assets/images/lhb_charm.svg',
            backgroundAsset: 'assets/images/bg_lhb.png',
              ),
              const SizedBox(height: 36),

              // About section
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 22,
                    decoration: BoxDecoration(color: kikiOrange, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 10),
                  Text(Strings.luckyHallAboutSection, style: theme.textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                Strings.luckyHallAboutP1,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              Text(
                Strings.luckyHallAboutP2,
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 36),

          // Features
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(color: kikiOrange, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Text(Strings.luckyHallFeaturesSection, style: theme.textTheme.headlineMedium),
            ],
          ),
                const SizedBox(height: 20),
          const _FeatureList(
            features: [
              // each feature now specifies an SVG asset for the icon
              _Feature(
                icon: SafeSvg.asset('assets/images/bingo.svg', width: 124, height: 124),
                title: Strings.luckyHallFeatureClassic,
                description: Strings.luckyHallFeatureClassicDesc,
              ),
              _Feature(
                icon: SafeSvg.asset('assets/images/charms.svg', width: 124, height: 124),
                title: Strings.luckyHallFeatureThemed,
                description: Strings.luckyHallFeatureThemedDesc,
              ),
              _Feature(
                icon: SafeSvg.asset('assets/images/daub.svg', width: 124, height: 124),
                title: Strings.luckyHallFeatureLeaderboards,
                description: Strings.luckyHallFeatureLeaderboardsDesc,
              ),
              _Feature(
                icon: SafeSvg.asset('assets/images/pulltab.svg', width: 124, height: 124),
                title: Strings.luckyHallFeaturePowerUps,
                description: Strings.luckyHallFeaturePowerUpsDesc,
              ),
            ],
          ),

          const SizedBox(height: 36),

          // Status
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(color: kikiOrange, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Text(Strings.luckyHallStatusHeader, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          _StatusCard(theme: theme, onNavigate: onNavigate),

          const SizedBox(height: 40),

          // CTA — span full width and center contents
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  Strings.luckyHallCtaTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  Strings.luckyHallCtaSubtitle,
                  style: theme.textTheme.bodyLarge,
                ),
                
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bottom CTA — full-width centered orange button linking to Contact
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => onNavigate(Routes.contact),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kikiOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  child: const Text(Strings.luckyHallStatusButton),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  // icon is now an arbitrary widget so we can render SVGs instead of
  // material icons. callers should size/colour the widget as needed.
  final Widget icon;
  final String title;
  final String description;
  const _Feature({required this.icon, required this.title, required this.description});
}

class _FeatureList extends StatelessWidget {
  final List<_Feature> features;
  const _FeatureList({required this.features});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 700;
    // Split into rows of 2 so IntrinsicHeight can enforce uniform height per row.
    if (isNarrow) {
      // Stack features vertically on narrow screens
      return Column(
        children: features
            .map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _FeatureTile(feature: f, theme: theme),
                ))
            .toList(),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < features.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: 16));
      final a = features[i];
      final b = i + 1 < features.length ? features[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _FeatureTile(feature: a, theme: theme)),
              if (b != null) ...[
                const SizedBox(width: 16),
                Expanded(child: _FeatureTile(feature: b, theme: theme)),
              ] else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;
  final ThemeData theme;
  const _FeatureTile({required this.feature, required this.theme});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 600 ? 96.0 : 134.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: kikiOrange.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: feature.icon,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(feature.description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final ThemeData theme;
  final void Function(String route) onNavigate;
  const _StatusCard({required this.theme, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kikiOrange.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kikiOrange.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch_outlined, color: kikiOrange, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.luckyHallStatusTitle, style: theme.textTheme.titleMedium?.copyWith(color: kikiOrange)),
                const SizedBox(height: 4),
                Text(
                  Strings.luckyHallStatusBody,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
