import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../contact_config.dart';

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
            title: 'Terms of Service',
            ctaText: 'Back to Home',
            assetPath: 'assets/images/illustration.svg',
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
              'Last updated: February 23, 2026',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),

          _Section(
            title: 'Acceptance of Terms',
            body: 'By accessing or using the KikiBytes Labs website (the "Service"), you agree to be bound by these Terms of Service. If you do not agree to all the terms, do not use the Service.',
          ),
          _Section(
            title: 'Use of the Service',
            body: 'You agree to use the Service only for lawful purposes and in a way that does not infringe the rights of others or restrict their use and enjoyment of the Service.',
          ),
          _Section(
            title: 'Intellectual Property',
            body: 'All content on the Service, including text, graphics, logos, and images, is the property of KikiBytes LLC or its licensors and is protected by intellectual property laws.',
          ),
          _Section(
            title: 'Limitation of Liability',
            body: 'To the fullest extent permitted by law, KikiBytes LLC will not be liable for any indirect, incidental, special, consequential or punitive damages arising out of use of the Service.',
          ),
          _Section(
            title: 'Contact',
            body: 'If you have questions about these Terms, please contact us at $contactEmail',
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
