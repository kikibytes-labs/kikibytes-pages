import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroBanner(
            title: 'Innovative & Fun',
            subtitle: 'Indie Games and Apps',
            ctaText: 'Explore Our Games',
            assetPath: 'assets/images/hero.svg',
          ),

          const SizedBox(height: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome to KikiBytes Labs!', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "We're a small indie development studio passionate about creating playful and thoughtfully crafted digital experiences. At KikiBytes Labs, we blend creativity, quality, and a touch of whimsy to build games and apps that delight players of all ages.",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),
          Row(
            children: const [
              Expanded(child: FeatureCard(title: 'Creative & Engaging', body: 'We develop inventive and fun games that spark joy and wonder.', assetPath: 'assets/images/icon1.svg')),
              SizedBox(width: 12),
              Expanded(child: FeatureCard(title: 'Thoughtfully Crafted', body: 'Our apps are engineered for quality, polish, and an enjoyable user experience.', assetPath: 'assets/images/icon2.svg')),
              SizedBox(width: 12),
              Expanded(child: FeatureCard(title: 'A Touch of Whimsy', body: 'We add a sprinkle of charm and playfulness to everything we create.', assetPath: 'assets/images/icon3.svg')),
            ],
          ),

          const SizedBox(height: 28),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Learn More About Us'),
            ),
          ),
        ],
      ),
    );
  }

  // Feature cards are now provided by FeatureCard widget
}
