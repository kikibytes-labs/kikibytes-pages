import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/value_pill.dart';

class AboutPage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const AboutPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: 'About KikiBytes Labs',
            subtitle: 'Innovative apps and games\nwith a touch of fun and whimsy.',
            ctaText: 'Get in Touch',
            assetPath: 'assets/images/cat_hiking.png',
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
              Text('Who We Are', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "KikiBytes Labs is a small indie development studio dedicated to crafting playful, thoughtfully engineered apps and games. We're a passionate team of creative minds and experienced developers who love to experiment and create delightful digital experiences.",
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
              Text('Our Mission', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Our mission is to bring joy and creativity into the digital world. We strive to develop applications and games that are not only fun but also thoughtfully designed and engineered.',
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
              Text('Our Values', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(child: ValuePill(title: 'Creativity', subtitle: 'We thrive on original ideas.', imageAsset: 'assets/images/lightbulb.png')),
                SizedBox(width: 16),
                Expanded(child: ValuePill(title: 'Quality', subtitle: 'Thoughtful engineering and polish.', imageAsset: 'assets/images/gears.png')),
                SizedBox(width: 16),
                Expanded(child: ValuePill(title: 'Fun', subtitle: 'Playful spirit and charm.', imageAsset: 'assets/images/joystick.png')),
                SizedBox(width: 16),
                Expanded(child: ValuePill(title: 'Community', subtitle: 'An inclusive player base.', imageAsset: 'assets/images/handshake.png')),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
