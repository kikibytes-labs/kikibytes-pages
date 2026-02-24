import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';

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
          HeroBanner(
            title: 'Lucky Hall Bingo',
            subtitle: 'The classic game of bingo — reimagined for everyone.',
            assetPath: 'assets/images/illustration.svg',
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
              Text('About the Game', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Lucky Hall Bingo brings the timeless fun of bingo to your fingertips. Whether you\'re a seasoned bingo veteran or brand new to the game, Lucky Hall Bingo offers a welcoming experience packed with charm, vibrant visuals, and satisfying gameplay.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Play solo or challenge friends in a variety of game modes. Unlock themed bingo cards, collect power-ups, and compete on leaderboards to prove you\'ve got the lucky touch.',
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
              Text('Features', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          _FeatureList(
            features: const [
              _Feature(icon: Icons.grid_on_rounded, title: 'Classic Bingo Gameplay', description: 'Multiple card layouts and pattern win conditions to keep every game fresh.'),
              _Feature(icon: Icons.palette_outlined, title: 'Themed Cards & Daubers', description: 'Unlock seasonal and holiday-themed bingo cards and custom daubers.'),
              _Feature(icon: Icons.leaderboard_outlined, title: 'Leaderboards', description: 'Compete globally and climb the ranks to become the Lucky Hall champion.'),
              _Feature(icon: Icons.bolt_outlined, title: 'Power-Ups', description: 'Strategically deploy power-ups to gain the edge when the numbers are called.'),
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
              Text('Development Status', style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 14),
          _StatusCard(theme: theme, onNavigate: onNavigate),

          const SizedBox(height: 40),

          // CTA
          Center(
            child: Column(
              children: [
                Text(
                  'Interested in Lucky Hall Bingo?',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Reach out to us — we\'d love to hear from you.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => onNavigate(Routes.contact),
                  child: const Text('Contact Us'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
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
    // Split into rows of 2 so IntrinsicHeight can enforce uniform height per row.
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kikiOrange.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(feature.icon, color: kikiOrange, size: 22),
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
          Icon(Icons.rocket_launch_outlined, color: kikiOrange, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Now', style: theme.textTheme.titleMedium?.copyWith(color: kikiOrange)),
                const SizedBox(height: 4),
                Text(
                  'Lucky Hall Bingo is live and available to play. Stay tuned for updates, new themes, and seasonal events.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => onNavigate(Routes.contact),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kikiOrange,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Get in Touch'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
