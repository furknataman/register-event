import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/api/service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../../../l10n/locale_notifier.dart';

part 'auth_provider.g.dart';

// Core providers
final loggerProvider = Provider<AppLogger>((ref) => AppLogger());

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio();
  const secureStorage = FlutterSecureStorage();
  final logger = Logger();
  return ApiClient(dio, secureStorage, logger);
});

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    // Get current user on startup
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.getCurrentUser();

    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.login(email, password);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) async {
        state = AsyncValue.data(user);

        try {
          await ref.read(localeProvider.notifier).syncLanguageFromServer();
        } catch (e) {
          final logger = ref.read(loggerProvider);
          logger.error('Failed to sync language after login: $e');
        }

        try {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            final deviceInfo = DeviceInfoPlugin();
            String deviceType;
            String deviceInfoStr;

            if (Platform.isIOS) {
              final iosInfo = await deviceInfo.iosInfo;
              deviceType = 'ios';
              deviceInfoStr = '${iosInfo.name} - ${iosInfo.systemVersion} - ${iosInfo.model}';
            } else if (Platform.isAndroid) {
              final androidInfo = await deviceInfo.androidInfo;
              deviceType = 'android';
              deviceInfoStr = '${androidInfo.brand} ${androidInfo.model} - Android ${androidInfo.version.release}';
            } else {
              deviceType = 'unknown';
              deviceInfoStr = 'Unknown Device';
            }

            final webService = ref.read(webServiceProvider);
            await webService.registerFcmToken(fcmToken, deviceType, deviceInfoStr);
          }
        } catch (e) {
          final logger = ref.read(loggerProvider);
          logger.error('Failed to register FCM token after login: $e');
        }

        return true;
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? school,
    String? branch,
  }) async {
    state = const AsyncValue.loading();
    
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
      school: school,
      branch: branch,
    );
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.logout();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshToken() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.refreshToken();
  }
}

// Provider for checking if user is authenticated
@Riverpod(keepAlive: true)
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
}

// Auth DataSource providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final logger = ref.watch(loggerProvider);
  return AuthRemoteDataSourceImpl(apiClient, logger);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource, localDataSource);
});

// Export authProvider as authNotifierProvider for backward compatibility
const authNotifierProvider = authProvider;