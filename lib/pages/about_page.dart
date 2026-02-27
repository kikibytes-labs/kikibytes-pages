import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/value_pill.dart';
import '../strings.dart';

class AboutPage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const AboutPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 760;

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: Strings.aboutTitle,
            subtitle: Strings.aboutSubtitle,
            ctaText: Strings.aboutCta,
            assetPath: 'assets/images/cat_hiking.svg',
            onCtaPressed: () => onNavigate(Routes.contact),
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(
                  color: kikiOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(Strings.aboutSectionWho, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            Strings.aboutParagraph1,
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(
                  color: kikiOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(Strings.aboutSectionMission, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            Strings.aboutParagraph2,
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 3,
                height: 22,
                decoration: BoxDecoration(
                  color: kikiOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(Strings.aboutSectionValues, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          if (!isNarrow) ...[
            // Ensure all value pills are the same height on wide screens by
            // wrapping the row in IntrinsicHeight and making each pill Expanded.
            const IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: ValuePill(title: Strings.valueCreativityTitle, subtitle: Strings.valueCreativitySubtitle, imageAsset: 'assets/images/lightbulb.svg', imageSizeMultiplier: 3.375)),
                  SizedBox(width: 16),
                  Expanded(child: ValuePill(title: Strings.valueQualityTitle, subtitle: Strings.valueQualitySubtitle, imageAsset: 'assets/images/gears.svg', imageSizeMultiplier: 3.375)),
                  SizedBox(width: 16),
                  Expanded(child: ValuePill(title: Strings.valueFunTitle, subtitle: Strings.valueFunSubtitle, imageAsset: 'assets/images/joystick.svg', imageSizeMultiplier: 3.375)),
                  SizedBox(width: 16),
                  Expanded(child: ValuePill(title: Strings.valueCommunityTitle, subtitle: Strings.valueCommunitySubtitle, imageAsset: 'assets/images/handshake.svg', imageSizeMultiplier: 3.375)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            // On narrow screens show a 2x2 grid (two per row) using Wrap so items
            // maintain consistent width and wrap naturally.
            Builder(builder: (_) {
              const double gap = 12.0;
              const double horizontalPadding = 48.0; // approximate SiteScaffold padding
              final double twoWidth = ((screenWidth - horizontalPadding) - gap) / 2.0;
              final double pillWidth = twoWidth.clamp(140.0, 420.0);
              return Wrap(
                spacing: gap,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(width: pillWidth, child: const ValuePill(title: Strings.valueCreativityTitle, subtitle: Strings.valueCreativitySubtitle, imageAsset: 'assets/images/lightbulb.svg', imageSizeMultiplier: 2.0)),
                  SizedBox(width: pillWidth, child: const ValuePill(title: Strings.valueQualityTitle, subtitle: Strings.valueQualitySubtitle, imageAsset: 'assets/images/gears.svg', imageSizeMultiplier: 2.0)),
                  SizedBox(width: pillWidth, child: const ValuePill(title: Strings.valueFunTitle, subtitle: Strings.valueFunSubtitle, imageAsset: 'assets/images/joystick.svg', imageSizeMultiplier: 2.0)),
                  SizedBox(width: pillWidth, child: const ValuePill(title: Strings.valueCommunityTitle, subtitle: Strings.valueCommunitySubtitle, imageAsset: 'assets/images/handshake.svg', imageSizeMultiplier: 2.0)),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }
}
