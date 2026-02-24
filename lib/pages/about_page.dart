import 'package:flutter/material.dart';
import '../routes.dart';
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
            subtitle: 'Innovative apps and games with a touch of fun and whimsy.',
            ctaText: 'Get in Touch',
            assetPath: 'assets/images/illustration.svg',
            onCtaPressed: () => onNavigate(Routes.contact),
          ),

          const SizedBox(height: 32),
          Text('Who We Are', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            "KikiBytes Labs is a small indie development studio dedicated to crafting playful, thoughtfully engineered apps and games. We're a passionate team of creative minds and experienced developers who love to experiment and create delightful digital experiences.",
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 28),
          Text('Our Mission', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Our mission is to bring joy and creativity into the digital world. We strive to develop applications and games that are not only fun but also thoughtfully designed and engineered.',
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: ValuePill(title: 'Creativity', subtitle: 'We thrive on original ideas.', assetPath: 'assets/images/icon1.svg')),
              SizedBox(width: 16),
              Expanded(child: ValuePill(title: 'Quality', subtitle: 'Thoughtful engineering and polish.', assetPath: 'assets/images/icon2.svg')),
              SizedBox(width: 16),
              Expanded(child: ValuePill(title: 'Fun', subtitle: 'Playful spirit and charm.', assetPath: 'assets/images/icon3.svg')),
              SizedBox(width: 16),
              Expanded(child: ValuePill(title: 'Community', subtitle: 'An inclusive player base.', assetPath: 'assets/images/icon1.svg')),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
