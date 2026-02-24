import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';

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
          // Hero
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF8A00), Color(0xFFFFD700)],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb
                      GestureDetector(
                        onTap: () => onNavigate(Routes.home),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.white70, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Back to Home',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Lucky Hall Bingo',
                        style: theme.textTheme.displayLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'The classic game of bingo — reimagined for everyone.',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white.withAlpha(220),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => onNavigate(Routes.download),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kikiOrange,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Download the App'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(30),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(Icons.grid_on_rounded, size: 80, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // About section
          Text('About the Game', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 16),
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
          Text('Features', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Divider(),
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
          Text('Development Status', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 16),
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
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: features.map((f) => _FeatureTile(feature: f, theme: theme)).toList(),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final _Feature feature;
  final ThemeData theme;
  const _FeatureTile({required this.feature, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
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
                  children: [
                    ElevatedButton(
                      onPressed: () => onNavigate(Routes.download),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kikiOrange,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Download the App'),
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
