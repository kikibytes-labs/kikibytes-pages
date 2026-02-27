import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../strings.dart';

class PrivacyPage extends StatelessWidget {
  final void Function(String route) onNavigate;

  const PrivacyPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: Strings.privacyTitle,
            ctaText: Strings.privacyCta,
            assetPath: 'assets/images/cat_towel.svg',
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
              Strings.privacyLastUpdated,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),

          const _Section(
            title: Strings.privacySectionIntro,
            body: Strings.privacyBodyIntro,
          ),
          const _Section(
            title: Strings.privacySectionInfoCollect,
            body: Strings.privacyBodyInfoCollect,
          ),
          const _Section(
            title: Strings.privacySectionHowUse,
            body: Strings.privacyBodyHowUse,
          ),
          const _Section(
            title: Strings.privacySectionShare,
            body: Strings.privacyBodyShare,
          ),
          const _Section(
            title: Strings.privacySectionCookies,
            body: Strings.privacyBodyCookies,
          ),
          const _Section(
            title: Strings.privacySectionChoices,
            body: Strings.privacyBodyChoices,
          ),
          _Section(
            title: Strings.privacySectionContact,
            body: Strings.privacyBodyContact,
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
