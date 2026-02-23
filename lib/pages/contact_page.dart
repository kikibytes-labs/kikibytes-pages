import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../widgets/hero_banner.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SiteScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroBanner(
            title: 'Contact Us',
            subtitle: "Get in touch with us, we'd love to hear from you!",
            ctaText: 'Get in Touch',
            assetPath: 'assets/images/illustration.svg',
          ),

          const SizedBox(height: 20),
          Text('Get in Touch', style: theme.textTheme.headlineMedium),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text('Email:'),
                      subtitle: Text('contact@kikibytes.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.blue),
                      title: Text('Phone:'),
                      subtitle: Text('(123) 456-7890'),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.red),
                      title: Text('Address:'),
                      subtitle: Text('123 Indie Dev Lane, Gameville, CA 90210'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(width: 260, child: SvgPicture.asset('assets/images/illustration.svg'))
            ],
          ),

          const SizedBox(height: 20),
          Text('Contact Form', style: theme.textTheme.headlineMedium),
          const Divider(),
          const SizedBox(height: 8),
          _contactForm(),
        ],
      ),
    );
  }

  Widget _contactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(decoration: const InputDecoration(labelText: 'Your Name')),
        const SizedBox(height: 8),
        TextField(decoration: const InputDecoration(labelText: 'Your Email')),
        const SizedBox(height: 8),
        TextField(decoration: const InputDecoration(labelText: 'Subject')),
        const SizedBox(height: 8),
        TextField(decoration: const InputDecoration(labelText: 'Message'), maxLines: 5),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () {}, child: const Text('Send Message')),
      ],
    );
  }
}
