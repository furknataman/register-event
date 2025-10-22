// import 'dart:ui'; // no longer needed after custom liquid nav

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// Import feature pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/events/presentation/pages/event_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import '../../pages/daily_plan/daily_plan.dart';
import '../../pages/settings/settings_page.dart';
// Import existing pages temporarily
import '../../pages/start/start_page.dart';
import '../widgets/liquid_bottom_nav.dart';

// Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String scan = '/scan';
  static const String event = '/event';
  static const String eventDetail = '/event/:id';
  static const String settings = '/settings';
  static const String dailyPlan = '/daily-plan';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash/Start Route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const StartPage(),
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Main App Routes with Shell Navigation
      ShellRoute(
        builder: (context, state, child) {
          return AppNavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.scan,
            name: 'scan',
            builder: (context, state) => const ScanPage(),
          ),
        ],
      ),

      // Event Routes
      GoRoute(
        path: '/event/:id',
        name: 'eventDetail',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailPage(eventId: eventId);
        },
      ),

      // Settings Routes
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // Daily Plan Route
      GoRoute(
        path: AppRoutes.dailyPlan,
        name: 'dailyPlan',
        builder: (context, state) => DailyPlanPage(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.matchedLocation}" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Navigation Shell for bottom navigation
class AppNavigationShell extends StatefulWidget {
  final Widget child;

  const AppNavigationShell({super.key, required this.child});

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  double _tabSpacing = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final offset = notification.metrics.pixels;
          final newSpacing = offset > 100 ? 150.0 : 0.0;
          if (newSpacing != _tabSpacing) {
            setState(() => _tabSpacing = newSpacing);
          }
          return false;
        },
        child: Stack(
          children: [
            // Main content
            Positioned.fill(child: widget.child),
            // Floating liquid bar like the demo
            Align(
              alignment: Alignment.bottomCenter,
              child: LiquidBottomNav(
                onTap: (i) => _onTap(context, i),
                tabSpacing: _tabSpacing,
                currentIndex: _getCurrentIndex(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // Reset tab spacing when changing pages
    setState(() => _tabSpacing = 0.0);

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.scan);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
    }
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/scan')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
}
