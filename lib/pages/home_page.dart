import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../strings.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/project_card.dart';

class HomePage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const HomePage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 800;

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroBanner(
            title: Strings.homeTitle,
            subtitle: Strings.homeSubtitle,
            assetPath: 'assets/images/cat_computer.svg',
            titleStyle: TextStyle(
              fontSize: 58,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 40),
          Column(
            children: [
              Text(Strings.homeWelcome, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isNarrow ? 16 : 40),
                child: Text(
                  Strings.homeIntro,
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
              Text(Strings.homeProjectsHeader, style: theme.textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),
          if (!isNarrow)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ProjectCard(
                      title: Strings.projectLuckyHallTitle,
                      tagline: Strings.projectLuckyHallTagline,
                      gradientColors: const [Color(0xFFFF8A00), Color(0xFFFFD700)],
                      previewIcon: Icons.grid_on_rounded,
                      imageAsset: 'assets/images/lhb_title.svg',
                      onTap: () => onNavigate(Routes.luckyHallBingo),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: ProjectCard(
                      title: Strings.projectChatSpreeTitle,
                      tagline: Strings.projectChatSpreeTagline,
                      gradientColors: [Color(0xFF6366F1), Color(0xFF0EA5E9)],
                      previewIcon: Icons.chat_bubble_outline_rounded,
                      badge: Strings.projectBadgeInProgress,
                    ),
                  ),
                  // Placeholder to keep the grid balanced while there are only 2 projects
                  const Expanded(child: SizedBox()),
                ],
              ),
            )
          else
            Column(
              children: [
                ProjectCard(
                  title: Strings.projectLuckyHallTitle,
                  tagline: Strings.projectLuckyHallTagline,
                  gradientColors: const [Color(0xFFFF8A00), Color(0xFFFFD700)],
                  previewIcon: Icons.grid_on_rounded,
                  imageAsset: 'assets/images/lhb_title.svg',
                  onTap: () => onNavigate(Routes.luckyHallBingo),
                ),
                const SizedBox(height: 16),
                ProjectCard(
                  title: Strings.projectChatSpreeTitle,
                  tagline: Strings.projectChatSpreeTagline,
                  gradientColors: const [Color(0xFF6366F1), Color(0xFF0EA5E9)],
                  previewIcon: Icons.chat_bubble_outline_rounded,
                  badge: Strings.projectBadgeInProgress,
                ),
              ],
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
