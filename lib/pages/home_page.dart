import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/project_card.dart';

class HomePage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const HomePage({super.key, required this.onNavigate});

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
            onCtaPressed: () => onNavigate(Routes.luckyHallBingo),
          ),

          const SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome to KikiBytes Labs!', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "We're a small indie development studio passionate about creating playful and thoughtfully crafted digital experiences. At KikiBytes Labs, we blend creativity, quality, and a touch of whimsy to build games and apps that delight players of all ages.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),
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
              Text('Our Projects', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProjectCard(
                  title: 'Lucky Hall Bingo',
                  tagline: 'The classic game of bingo — reimagined for everyone.',
                  gradientColors: const [Color(0xFFFF8A00), Color(0xFFFFD700)],
                  previewIcon: Icons.grid_on_rounded,
                  onTap: () => onNavigate(Routes.luckyHallBingo),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ProjectCard(
                  title: 'Chat Spree',
                  tagline: 'A fun, fast-paced social chat game for groups.',
                  gradientColors: const [Color(0xFF6366F1), Color(0xFF0EA5E9)],
                  previewIcon: Icons.chat_bubble_outline_rounded,
                  badge: 'In Progress',
                ),
              ),
              // Placeholder to keep the grid balanced while there are only 2 projects
              const Expanded(child: SizedBox()),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
