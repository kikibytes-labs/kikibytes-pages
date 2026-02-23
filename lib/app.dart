import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'widgets/navbar.dart';
import 'widgets/footer.dart';

class KikiBytesApp extends StatelessWidget {
  const KikiBytesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KikiBytes Labs',
      debugShowCheckedModeBanner: false,
      theme: kikiTheme,
      home: MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<NavigatorState> _innerNavKey = GlobalKey<NavigatorState>();

  void _handleNavigate(String route) {
    if (_innerNavKey.currentState == null) return;
    if (route == Routes.home) {
      _innerNavKey.currentState!.pushNamedAndRemoveUntil(Routes.home, (r) => false);
    } else {
      _innerNavKey.currentState!.pushNamed(route);
    }
  }

  Route<dynamic> _onGenerateInner(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case Routes.about:
        page = const AboutPage();
        break;
      case Routes.contact:
        page = const ContactPage();
        break;
      case Routes.home:
      default:
        page = const HomePage();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Navbar(onNavigate: _handleNavigate),
          Expanded(
            child: Navigator(
              key: _innerNavKey,
              initialRoute: Routes.home,
              onGenerateRoute: _onGenerateInner,
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
