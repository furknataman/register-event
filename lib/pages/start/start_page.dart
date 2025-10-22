import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:autumn_conference/global/svg.dart';
import 'package:autumn_conference/pages/start/widgets/startlogo.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class StartPage extends ConsumerStatefulWidget {
  const StartPage({super.key});

  @override
  ConsumerState<StartPage> createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for auth provider to fully initialize
    try {
      final user = await ref.read(authNotifierProvider.future);
      final isAuthenticated = user != null;

      // Show splash for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

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
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
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
                  StartPageWidgets(),
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
