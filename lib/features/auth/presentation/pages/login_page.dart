import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/svg.dart';
import '../../../splash/presentation/widgets/splash_logo.dart';
import '../widgets/modern_login_form.dart';
import '../../../../core/animations/spring_animations.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: Stack(children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: elipse(MediaQuery.of(context).size.width),
          ),
          Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: keyboardHeight > 0 ? 40 : 60),
                  // Logo with subtle spring bounce
                  SpringAnimatedBuilder(
                    duration: SpringAnimations.slow,
                    curve: SpringAnimations.bouncySpring,
                    builder: (context, animation) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: const SplashLogo(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: keyboardHeight > 0 ? 20 : 80),
                  // Form with spring slide up
                  SpringAnimatedBuilder(
                    duration: SpringAnimations.standard,
                    curve: SpringAnimations.standardSpring,
                    builder: (context, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: SizedBox(
                              height: 320,
                              child: ModernLoginForm(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: keyboardHeight > 0 ? 10 : 20),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}