import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Terms of Service', style: theme.textTheme.displayLarge),
          const SizedBox(height: 16),
          Text(
            'Last updated: February 23, 2026',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          Text('Acceptance of Terms', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'By accessing or using the KikiBytes Labs website (the "Service"), you agree to be bound by these Terms of Service. If you do not agree to all the terms, do not use the Service.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Use of the Service', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'You agree to use the Service only for lawful purposes and in a way that does not infringe the rights of others or restrict their use and enjoyment of the Service.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Intellectual Property', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'All content on the Service, including text, graphics, logos, and images, is the property of KikiBytes LLC or its licensors and is protected by intellectual property laws.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Limitation of Liability', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'To the fullest extent permitted by law, KikiBytes LLC will not be liable for any indirect, incidental, special, consequential or punitive damages arising out of use of the Service.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Contact', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'If you have questions about these Terms, contact us at contact@kikibytes.com',
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
