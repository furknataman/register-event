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
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/domain/providers/notification_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
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

      // Refresh badge count if user is authenticated
      if (isAuthenticated) {
        try {
          // Fetch unread count from API
          final webService = ref.read(webServiceProvider);
          final response = await webService.getUnreadCount();
          final count = response.unreadCount;

          // Update app badge
          await LocalNoticeService().updateAppBadge(count);

          // Invalidate provider to refresh bell icon badge
          ref.invalidate(unreadCountProvider);
        } catch (e) {
          debugPrint('Failed to update badge on splash: $e');
        }
      }

      final route = isAuthenticated ? AppRoutes.home : AppRoutes.login;
      context.go(route);
    } catch (e) {
      // If there's an error, go to login
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
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
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SplashLogo(),
                  SizedBox(height: 24),
                  CircularProgressIndicator(
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
