import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/dependency_injection/injection.dart';
import 'core/notifications/local/notification.dart';
import 'core/notifications/push/push_notification.dart';
import 'core/routing/app_router.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_mode.dart';
import 'core/utils/logger.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'l10n/locale_notifier.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late final ProviderContainer globalContainer;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Set up preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Handle splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize Firebase
  await Firebase.initializeApp();
  await LocalNoticeService().setup();
  await configureFirebaseMessaging();

  // Setup notifications
  FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // Initialize logger
  final logger = getIt<AppLogger>();
  logger.logAppEvent('App Started', {'timestamp': DateTime.now().toIso8601String()});

  // Create global provider container for FCM handlers
  globalContainer = ProviderContainer();

  runApp(UncontrolledProviderScope(
    container: globalContainer,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(themeModeProvider);
    final localeAsync = ref.watch(localeProvider);

    // Show loading screen while theme and locale are loading
    if (themeModeAsync.isLoading || localeAsync.isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final themeMode = themeModeAsync.value ?? ThemeMode.system;
    final locale = localeAsync.value ?? const Locale('tr');

    return MaterialApp.router(
      // Router configuration
      routerConfig: router,

      // Localization
      locale: locale,
      supportedLocales: L10n9.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // App configuration
      title: '18. IB Day - Better Together',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
    );
  }
}
