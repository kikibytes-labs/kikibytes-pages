import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/value_pill.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: 'About KikiBytes Labs',
            subtitle: 'Innovative apps and games with a touch of fun and whimsy.',
            ctaText: 'Learn More',
            assetPath: 'assets/images/illustration.svg',
          ),

          const SizedBox(height: 24),
          Text('Who We Are', style: theme.textTheme.headlineMedium),
          const Divider(),
          const SizedBox(height: 8),
          const Text('KikiBytes Labs is a small indie development studio dedicated to crafting playful, thoughtfully engineered apps and games. We\'re a passionate team of creative minds and experienced developers who love to experiment and create delightful digital experiences.'),

          const SizedBox(height: 20),
          Text('Our Mission', style: theme.textTheme.headlineMedium),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Our mission is to bring joy and creativity into the digital world. We strive to develop applications and games that are not only fun but also thoughtfully designed and engineered.'),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: ValuePill(title: 'Creativity', subtitle: 'We thrive on original ideas.', assetPath: 'assets/images/icon1.svg')),
              SizedBox(width: 12),
              Expanded(child: ValuePill(title: 'Quality', subtitle: 'Thoughtful engineering and polish.', assetPath: 'assets/images/icon2.svg')),
              SizedBox(width: 12),
              Expanded(child: ValuePill(title: 'Fun', subtitle: 'Playful spirit and charm.', assetPath: 'assets/images/icon3.svg')),
              SizedBox(width: 12),
              Expanded(child: ValuePill(title: 'Community', subtitle: 'An inclusive player base.', assetPath: 'assets/images/icon1.svg')),
            ],
          )
        ],
      ),
    );
  }

  // ValuePill extracted to widgets/value_pill.dart
}
