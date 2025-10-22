import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/dependency_injection/injection.dart';
import 'core/routing/app_router.dart';
import 'core/utils/logger.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'notification/local_notification/notification.dart';
import 'notification/push_notification/push_notification.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

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
  setFiraBase();

  // Setup notifications
  FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await LocalNoticeService().setup();

  // Initialize logger
  final logger = getIt<AppLogger>();
  logger.logAppEvent('App Started', {'timestamp': DateTime.now().toIso8601String()});

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      // Router configuration
      routerConfig: router,

      // Localization
      supportedLocales: L10n9.all,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale?.languageCode == 'tr') {
          return const Locale('tr', '');
        } else {
          return const Locale('en', '');
        }
      },
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
      themeMode: ThemeMode.system,
    );
  }
}
