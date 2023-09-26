import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr/l10n/l10n.dart';
import 'package:qr/pages/start/start_page.dart';
import 'package:qr/theme/light_theme.dart';
import 'authentication/authservice.dart';
import 'notification/local_notification/notification.dart';
import 'theme/dark_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  await Firebase.initializeApp();
  await LocalNoticeService().setup();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      routes: {
        '/start': (context) => const StartPage(),
      },
      supportedLocales: L10n9.all,
      locale: const Locale('em'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      navigatorKey: navigatorKey,
      title: 'Autumn Teachers Conference',
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      home: AuthService().loginwithApi(),
    );
  }
}
