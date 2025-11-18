import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import services
import '../../core/services/api/service.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
// Import feature pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/events/presentation/pages/event_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../widgets/liquid_bottom_nav.dart';
// Import page transitions
import 'custom_page_transitions.dart';

// Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String scan = '/scan';
  static const String search = '/search';
  static const String event = '/event';
  static const String eventDetail = '/event/:id';
  static const String schedule = '/schedule';
}

class TabSpacingNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void setSpacing(double value) {
    if (state != value) {
      state = value;
    }
  }

  void reset() {
    setSpacing(0.0);
  }
}

final tabSpacingProvider = NotifierProvider<TabSpacingNotifier, double>(
  TabSpacingNotifier.new,
);

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

      // Forgot Password Route
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => CustomPageTransitions.fadeTransition(
          child: const ForgotPasswordPage(),
          state: state,
        ),
      ),

      // Reset Password Route
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final emailOrPhone = extra?['emailOrPhone'] as String? ?? '';
          final type = extra?['type'] as int? ?? 1;

          return CustomPageTransitions.fadeTransition(
            child: ResetPasswordPage(
              emailOrPhone: emailOrPhone,
              type: type,
            ),
            state: state,
          );
        },
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

      // Event Routes - Material transition for iOS swipe-back
      GoRoute(
        path: '/event/:id',
        name: 'eventDetail',
        pageBuilder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: EventDetailPage(eventId: eventId),
          );
        },
      ),

      // Schedule Route - Slide transition for schedule
      GoRoute(
        path: AppRoutes.schedule,
        name: 'schedule',
        pageBuilder: (context, state) => CustomPageTransitions.sharedAxisTransition(
          child: SchedulePage(),
          state: state,
          transitionType: SharedAxisTransitionType.vertical,
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
  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      resetBottomBarProvider,
      (previous, next) => ref.read(tabSpacingProvider.notifier).reset(),
    );
    final tabSpacing = ref.watch(tabSpacingProvider);
    final currentIndex = _getCurrentIndex(context);

    return WillPopScope(
      onWillPop: () async {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          return true;
        }
        if (currentIndex != 0) {
          ref.read(tabSpacingProvider.notifier).reset();
          router.go(AppRoutes.home);
          return false;
        }
        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Sadece dikey scroll'u dinle, yatay scroll'u ignore et
            if (notification.metrics.axis == Axis.vertical) {
              final offset = notification.metrics.pixels;
              final newSpacing = offset > 100 ? 150.0 : 0.0;
              ref.read(tabSpacingProvider.notifier).setSpacing(newSpacing);
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
                  tabSpacing: tabSpacing,
                  currentIndex: currentIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    final currentIndex = _getCurrentIndex(context);
    if (index == currentIndex) {
      HapticFeedback.selectionClick();
      return;
    }

    HapticFeedback.lightImpact();
    // Reset tab spacing when changing pages
    ref.read(tabSpacingProvider.notifier).reset();

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
