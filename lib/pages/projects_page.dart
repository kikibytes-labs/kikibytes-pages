import 'package:flutter/material.dart';
import '../routes.dart';
import '../theme.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../widgets/project_card.dart';

enum _ProjectFilter { all, games, apps }

class ProjectsPage extends StatefulWidget {
  final void Function(String route) onNavigate;

  const ProjectsPage({super.key, required this.onNavigate});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  _ProjectFilter _filter = _ProjectFilter.all;

  static const _projects = [
    _ProjectData(
      title: 'Lucky Hall Bingo',
      tagline: 'The classic game of bingo — reimagined for everyone.',
      gradientColors: [Color(0xFFFF8A00), Color(0xFFFFD700)],
      previewIcon: Icons.grid_on_rounded,
      imageAsset: 'assets/images/lhb_title.svg',
      category: _ProjectFilter.games,
      route: Routes.luckyHallBingo,
    ),
    _ProjectData(
      title: 'Chat Spree',
      tagline: 'A fun, fast-paced social chat game for groups.',
      gradientColors: [Color(0xFF6366F1), Color(0xFF0EA5E9)],
      previewIcon: Icons.chat_bubble_outline_rounded,
      category: _ProjectFilter.games,
      badge: 'In Progress',
    ),
  ];

  List<_ProjectData> get _filtered {
    if (_filter == _ProjectFilter.all) return _projects;
    return _projects.where((p) => p.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: 'Our Projects',
            subtitle: 'Indie games and apps made\nwith creativity, fun, and heart.',
            assetPath: 'assets/images/cat_sawing.jpg',
          ),

          const SizedBox(height: 40),

          // Section header
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
              Text('Browse Projects', style: theme.textTheme.headlineMedium),
            ],
          ),

          const SizedBox(height: 20),

          // Filter tabs
          _FilterTabs(
            selected: _filter,
            onSelected: (f) => setState(() => _filter = f),
          ),

          const SizedBox(height: 24),

          // Project grid
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  'No projects in this category yet — check back soon!',
                  style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF9CA3AF)),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < 3; i++)
                    i < filtered.length
                        ? Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i < 2 ? 20 : 0),
                              child: ProjectCard(
                                title: filtered[i].title,
                                tagline: filtered[i].tagline,
                                gradientColors: filtered[i].gradientColors,
                                previewIcon: filtered[i].previewIcon,
                                imageAsset: filtered[i].imageAsset,
                                badge: filtered[i].badge,
                                onTap: filtered[i].route != null
                                    ? () => widget.onNavigate(filtered[i].route!)
                                    : null,
                              ),
                            ),
                          )
                        : const Expanded(child: SizedBox()),
                ],
              ),
            ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final _ProjectFilter selected;
  final void Function(_ProjectFilter) onSelected;

  const _FilterTabs({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterTab(label: 'All Projects', value: _ProjectFilter.all, selected: selected, onSelected: onSelected),
        const SizedBox(width: 8),
        _FilterTab(label: 'Games', value: _ProjectFilter.games, selected: selected, onSelected: onSelected),
        const SizedBox(width: 8),
        _FilterTab(label: 'Apps', value: _ProjectFilter.apps, selected: selected, onSelected: onSelected),
      ],
    );
  }
}

class _FilterTab extends StatefulWidget {
  final String label;
  final _ProjectFilter value;
  final _ProjectFilter selected;
  final void Function(_ProjectFilter) onSelected;

  const _FilterTab({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_FilterTab> createState() => _FilterTabState();
}

class _FilterTabState extends State<_FilterTab> {
  bool _hovered = false;

  bool get _isActive => widget.selected == widget.value;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onSelected(widget.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _isActive
                ? kikiOrange
                : _hovered
                    ? const Color(0xFFF3F4F6)
                    : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isActive ? kikiOrange : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
            boxShadow: _isActive
                ? [BoxShadow(color: kikiOrange.withAlpha(50), blurRadius: 8, offset: const Offset(0, 3))]
                : [],
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isActive ? Colors.white : const Color(0xFF6B7280),
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String tagline;
  final List<Color> gradientColors;
  final IconData previewIcon;
  final String? imageAsset;
  final _ProjectFilter category;
  final String? badge;
  final String? route;

  const _ProjectData({
    required this.title,
    required this.tagline,
    required this.gradientColors,
    required this.previewIcon,
    this.imageAsset,
    required this.category,
    this.badge,
    this.route,
  });
}
