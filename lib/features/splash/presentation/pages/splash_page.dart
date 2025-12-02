import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:autumn_conference/core/utils/svg.dart';
import '../widgets/splash_logo.dart';
import '../widgets/force_update_dialog.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/api/service.dart';
import '../../../../core/services/remote_config/remote_config_service.dart';
import '../../../../core/notifications/local/notification.dart';
import '../../../../core/data/local/token_stroge.dart' as token_storage;
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/domain/providers/notification_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  int _retryCount = 0;
  static const int _maxRetries = 3;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Check for updates first
      final remoteConfigService = ref.read(remoteConfigServiceProvider);
      await remoteConfigService.initialize();
      final updateInfo = await remoteConfigService.checkForUpdate();

      if (!mounted) return;

      // Show force update dialog if needed
      if (updateInfo.forceUpdate) {
        await ForceUpdateDialog.show(
          context,
          storeUrl: updateInfo.storeUrl,
        );
        return; // Dialog won't close, app stays here
      }

      // Wait for auth provider to fully initialize
      final user = await ref.read(authNotifierProvider.future);
      final isAuthenticated = user != null;

      // Show splash for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Refresh badge count and user profile if authenticated
      if (isAuthenticated) {
        // User profile'i yukle
        try {
          ref.invalidate(userProfileProvider);
          await ref.read(userProfileProvider.future);
        } catch (e) {
          debugPrint('Failed to load user profile: $e');
        }

        // Badge count
        try {
          final webService = ref.read(webServiceProvider);
          final response = await webService.getUnreadCount();
          final count = response.unreadCount;
          await LocalNoticeService().updateAppBadge(count);
          ref.invalidate(unreadCountProvider);
        } catch (e) {
          debugPrint('Failed to update badge on splash: $e');
        }
      }

      final route = isAuthenticated ? AppRoutes.home : AppRoutes.login;
      context.go(route);
    } catch (e) {
      debugPrint('Splash error (attempt ${_retryCount + 1}/$_maxRetries): $e');

      if (_retryCount < _maxRetries) {
        _retryCount++;
        // Exponential backoff: 1s, 2s, 3s
        await Future.delayed(Duration(seconds: _retryCount));
        if (!mounted) return;
        return _checkAuthAndNavigate();
      }

      // Max retry asildi
      final token = await token_storage.getToken();
      if (!mounted) return;

      if (token != null) {
        // Token var, hata ekrani goster
        setState(() => _showError = true);
      } else {
        // Token yok, login'e git
        context.go(AppRoutes.login);
      }
    }
  }

  void _retry() {
    setState(() {
      _showError = false;
      _retryCount = 0;
    });
    ref.invalidate(authNotifierProvider);
    ref.invalidate(userProfileProvider);
    _checkAuthAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: elipse(MediaQuery.of(context).size.width),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SplashLogo(),
                  const SizedBox(height: 24),
                  if (_showError) ...[
                    const Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Baglanti hatasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Internet baglantinizi kontrol edin',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tekrar Dene'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ] else
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
