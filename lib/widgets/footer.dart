import 'package:flutter/material.dart';
import 'site_container.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: SiteContainer(
        child: Row(
          children: [
            const Text('© 2024 KikiBytes LLC. All rights reserved.', style: TextStyle(color: Colors.grey)),
            const Spacer(),
            Row(
              children: [
                TextButton(onPressed: () {}, child: const Text('Privacy Policy')),
                const SizedBox(width: 6),
                TextButton(onPressed: () {}, child: const Text('Terms')),
                const SizedBox(width: 10),
                IconButton(onPressed: () {}, icon: const Icon(Icons.facebook, color: Colors.blue)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.email_outlined)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
