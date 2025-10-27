import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import feature pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/events/presentation/pages/event_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
// Import services
import '../../core/services/api/service.dart';
import '../widgets/liquid_bottom_nav.dart';
// Import page transitions
import 'custom_page_transitions.dart';

// Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String scan = '/scan';
  static const String search = '/search';
  static const String event = '/event';
  static const String eventDetail = '/event/:id';
  static const String schedule = '/schedule';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Auth Routes - Fade transition for login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomPageTransitions.fadeTransition(
          child: const LoginPage(),
          state: state,
        ),
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
            path: AppRoutes.scan,
            name: 'scan',
            builder: (context, state) => const ScanPage(),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Event Routes - Fade + Scale transition for detail page
      GoRoute(
        path: '/event/:id',
        name: 'eventDetail',
        pageBuilder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return CustomPageTransitions.fadeScaleTransition(
            child: EventDetailPage(eventId: eventId),
            state: state,
          );
        },
      ),

      // Schedule Route - Slide transition for schedule
      GoRoute(
        path: AppRoutes.schedule,
        name: 'schedule',
        pageBuilder: (context, state) => CustomPageTransitions.slideTransition(
          child: SchedulePage(),
          state: state,
          direction: AxisDirection.up,
        ),
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
class AppNavigationShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppNavigationShell({super.key, required this.child});

  @override
  ConsumerState<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends ConsumerState<AppNavigationShell> {
  double _tabSpacing = 0.0;

  @override
  Widget build(BuildContext context) {
    // Bottom bar reset sinyalini dinle
    ref.listen(resetBottomBarProvider, (previous, next) {
      if (mounted) {
        setState(() => _tabSpacing = 0.0);
      }
    });

    return Scaffold(
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Sadece dikey scroll'u dinle, yatay scroll'u ignore et
          if (notification.metrics.axis == Axis.vertical) {
            final offset = notification.metrics.pixels;
            final newSpacing = offset > 100 ? 150.0 : 0.0;
            if (newSpacing != _tabSpacing) {
              setState(() => _tabSpacing = newSpacing);
            }
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
        context.go(AppRoutes.search);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/scan')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}
