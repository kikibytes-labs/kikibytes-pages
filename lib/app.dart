import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/lucky_hall_bingo_page.dart';
import 'pages/projects_page.dart';
import 'pages/privacy_page.dart';
import 'pages/terms_page.dart';
import 'widgets/navbar.dart';
import 'widgets/footer.dart';

// a RouteObserver is used to keep track of which outer
// MainShell is currently visible so that the navbar highlight can
// be corrected when the user navigates with the browser back button.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class KikiBytesApp extends StatelessWidget {
  const KikiBytesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KikiBytes Labs',
      debugShowCheckedModeBanner: false,
      theme: kikiTheme,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => MainShell(initialRoute: settings.name ?? Routes.home),
          transitionDuration: const Duration(milliseconds: 220),
          reverseTransitionDuration: const Duration(milliseconds: 180),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
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

class _MainShellState extends State<MainShell> with RouteAware {
  final GlobalKey<NavigatorState> _innerNavKey = GlobalKey<NavigatorState>();
  String _currentRoute = Routes.home;
  late final NavigatorObserver _innerObserver;

  @override
  void initState() {
    super.initState();
    _currentRoute = widget.initialRoute;
    _innerObserver = _InnerNavObserver((routeName) {
      if (routeName == _currentRoute) return;
      setState(() => _currentRoute = routeName ?? Routes.home);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // subscribe to route changes so we can restore the correct
    // highlighted tab when this shell reappears after a browser back
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // another MainShell above us was popped, so we're visible again –
    // reset the highlight to whatever our initialRoute was.
    setState(() {
      _currentRoute = widget.initialRoute;
    });
  }

  @override
  void didPush() {
    // when this shell is pushed, make sure the route matches
    setState(() {
      _currentRoute = widget.initialRoute;
    });
  }

  void _handleNavigate(String route) {
    if (route == _currentRoute) return;
    // Do NOT mutate _currentRoute here. Each MainShell owns exactly its
    // initialRoute — changing it would corrupt the highlight when back is pressed.
    final rootNav = Navigator.of(context);
    // avoid rewriting history; let the browser back/forward stack record
    // every navigation action so the native buttons continue to work.
    rootNav.pushNamed(route);
  }

  Route<dynamic> _onGenerateInner(RouteSettings settings) {
    final Widget page;
    if (settings.name == Routes.about) {
      page = AboutPage(onNavigate: _handleNavigate);
    } else if (settings.name == Routes.projects) {
      page = ProjectsPage(onNavigate: _handleNavigate);
    } else if (settings.name == Routes.contact) {
      page = const ContactPage();
    } else if (settings.name == Routes.luckyHallBingo) {
      page = LuckyHallBingoPage(onNavigate: _handleNavigate);
    } else if (settings.name == Routes.privacy) {
      page = PrivacyPage(onNavigate: _handleNavigate);
    } else if (settings.name == Routes.terms) {
      page = TermsPage(onNavigate: _handleNavigate);
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
              observers: [_innerObserver],
            ),
          ),
          Footer(onNavigate: _handleNavigate),
        ],
      ),
    );
  }

}

class _InnerNavObserver extends NavigatorObserver {
  final void Function(String? routeName) onRouteChanged;
  _InnerNavObserver(this.onRouteChanged);

  void _notify(Route<dynamic>? route) {
    try {
      onRouteChanged(route?.settings.name);
    } catch (_) {}
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _notify(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _notify(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notify(newRoute);
  }
}
