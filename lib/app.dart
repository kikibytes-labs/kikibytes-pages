import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import 'theme.dart';
import 'strings.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/contact_page.dart';
import 'pages/lucky_hall_bingo_page.dart';
import 'pages/projects_page.dart';
import 'pages/privacy_page.dart';
import 'pages/terms_page.dart';
import 'widgets/navbar.dart';
import 'widgets/footer.dart';

/// App entry point; router handles all navigation and browser history.
class KikiBytesApp extends StatelessWidget {
  KikiBytesApp({super.key});

  // helper that wraps a widget in a CustomTransitionPage applying a
  // simple cross-fade. using Flutter's built-in FadeTransition avoids any
  // rendering glitches when widgets overlap during navigation.
  CustomTransitionPage<T> smoothPage<T>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return FadeTransition(opacity: curved, child: child);
      },
    );
  }

  late final GoRouter _router = GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: SelectionArea(
              child: Column(
                children: [
                  const Navbar(),
                  Expanded(child: child),
                  const Footer(),
                ],
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              HomePage(onNavigate: (r) => GoRouter.of(context).go(r)),
            ),
          ),
          GoRoute(
            path: Routes.about,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              AboutPage(onNavigate: (r) => GoRouter.of(context).go(r)),
            ),
          ),
          GoRoute(
            path: Routes.projects,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              ProjectsPage(onNavigate: (r) => GoRouter.of(context).go(r)),
            ),
          ),
          GoRoute(
            path: Routes.contact,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              const ContactPage(),
            ),
          ),
          GoRoute(
            path: Routes.luckyHallBingo,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              LuckyHallBingoPage(onNavigate: (r) => GoRouter.of(context).go(r)),
            ),
          ),
          GoRoute(
            path: Routes.privacy,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              PrivacyPage(onNavigate: (r) => GoRouter.of(context).go(r)),
            ),
          ),
          GoRoute(
            path: Routes.terms,
            pageBuilder: (context, state) => smoothPage(
              context,
              state,
              TermsPage(onNavigate: (r) => GoRouter.of(context).go(r)),
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Strings.homeTitle,
      debugShowCheckedModeBanner: false,
      theme: kikiTheme,
      routerConfig: _router,
    );
  }
}
