import 'package:get_it/get_it.dart';

import '../utils/logger.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core - Logger
  getIt.registerLazySingleton<AppLogger>(() => AppLogger());

  // Note: Auth and Event repositories are provided via Riverpod providers
  // See: auth_provider.dart and event_provider.dart
}