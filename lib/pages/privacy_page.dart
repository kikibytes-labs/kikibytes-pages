import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../contact_config.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Privacy Policy', style: theme.textTheme.displayLarge),
          const SizedBox(height: 16),
          Text(
            'Last updated: February 23, 2026',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          Text(
            'Introduction',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'KikiBytes LLC ("we", "us" or "our") operates the KikiBytes Labs website. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website or contact us.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Information We Collect', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '- Contact information you provide when you email us or use the contact form (name, email address, message contents).\n- Usage data that is automatically collected (IP address, pages visited, browser and device information).',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('How We Use Information', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'We use the information we collect to respond to inquiries, provide and improve our services, analyze site performance, and communicate updates and marketing messages where you have opted in.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Sharing & Disclosure', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'We do not sell your personal information. We may share information with service providers that help operate the website (analytics, hosting) or when required by law.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Cookies & Tracking', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'We and our service providers may use cookies and similar tracking technologies to collect usage data. You can control cookies through your browser settings.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Your Choices', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'You can opt out of marketing communications, and you may request access to, correction of, or deletion of your personal information by contacting us at the email address listed on the site.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),

          Text('Contact', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'For privacy inquiries please email: $contactEmail',
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
