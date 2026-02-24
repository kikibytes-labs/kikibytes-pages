import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/lucky_hall_bingo_page.dart';
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
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MainShell(initialRoute: settings.name ?? Routes.home),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  final String initialRoute;
  const MainShell({super.key, this.initialRoute = Routes.home});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<NavigatorState> _innerNavKey = GlobalKey<NavigatorState>();
  String _currentRoute = Routes.home;

  @override
  void initState() {
    super.initState();
    _currentRoute = widget.initialRoute;
  }

  void _handleNavigate(String route) {
    if (route == _currentRoute) return;
    setState(() => _currentRoute = route);
    final rootNav = Navigator.of(context);
    if (route == Routes.home) {
      rootNav.pushNamedAndRemoveUntil(Routes.home, (r) => false);
    } else {
      rootNav.pushNamed(route);
    }
  }

  Route<dynamic> _onGenerateInner(RouteSettings settings) {
    final Widget page;
    if (settings.name == Routes.about) {
      page = AboutPage(onNavigate: _handleNavigate);
    } else if (settings.name == Routes.contact) {
      page = const ContactPage();
    } else if (settings.name == Routes.luckyHallBingo) {
      page = LuckyHallBingoPage(onNavigate: _handleNavigate);
    } else {
      page = HomePage(onNavigate: _handleNavigate);
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
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
          Navbar(onNavigate: _handleNavigate, currentRoute: _currentRoute),
          Expanded(
            child: Navigator(
              key: _innerNavKey,
              initialRoute: widget.initialRoute,
              onGenerateRoute: _onGenerateInner,
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
