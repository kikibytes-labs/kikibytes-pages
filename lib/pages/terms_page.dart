import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../contact_config.dart';
import '../strings.dart';

class TermsPage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const TermsPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: Strings.termsTitle,
            ctaText: Strings.termsCta,
            assetPath: 'assets/images/cat_scholar.svg',
            onCtaPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                onNavigate(Routes.home);
              }
            },
          ),

          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              Strings.termsLastUpdated,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          _Section(
            title: Strings.termsSectionAcceptance,
            body: Strings.termsBodyAcceptance,
          ),
          _Section(
            title: Strings.termsSectionUse,
            body: Strings.termsBodyUse,
          ),
          _Section(
            title: Strings.termsSectionIP,
            body: Strings.termsBodyIP,
          ),
          _Section(
            title: Strings.termsSectionLiability,
            body: Strings.termsBodyLiability,
          ),
          _Section(
            title: Strings.termsSectionContact,
            body: Strings.termsBodyContact,
            isLast: true,
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  final bool isLast;

  const _Section({required this.title, required this.body, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(body, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 20),
        if (!isLast) const Divider(),
      ],
    );
  }
}
