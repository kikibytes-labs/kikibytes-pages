import 'package:flutter/material.dart';
import '../routes.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import '../contact_config.dart';

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
            title: 'Privacy Policy',
            ctaText: 'Back to Home',
            assetPath: 'assets/images/illustration.svg',
            onCtaPressed: () => onNavigate(Routes.home),
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
            title: 'Introduction',
            body: 'KikiBytes LLC ("we", "us" or "our") operates the KikiBytes Labs website. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our website or contact us.',
          ),
          _Section(
            title: 'Information We Collect',
            body: 'Contact information you provide when you email us or use the contact form (name, email address, message contents).\n\nUsage data that is automatically collected (IP address, pages visited, browser and device information).',
          ),
          _Section(
            title: 'How We Use Information',
            body: 'We use the information we collect to respond to inquiries, provide and improve our services, analyze site performance, and communicate updates and marketing messages where you have opted in.',
          ),
          _Section(
            title: 'Sharing & Disclosure',
            body: 'We do not sell your personal information. We may share information with service providers that help operate the website (analytics, hosting) or when required by law.',
          ),
          _Section(
            title: 'Cookies & Tracking',
            body: 'We and our service providers may use cookies and similar tracking technologies to collect usage data. You can control cookies through your browser settings.',
          ),
          _Section(
            title: 'Your Choices',
            body: 'You can opt out of marketing communications, and you may request access to, correction of, or deletion of your personal information by contacting us at the email address listed on the site.',
          ),
          _Section(
            title: 'Contact',
            body: 'For privacy inquiries, please email: $contactEmail',
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
