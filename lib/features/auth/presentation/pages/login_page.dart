import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/svg.dart';
import '../../../splash/presentation/widgets/splash_logo.dart';
import '../../../../core/auth/services/login_service.dart';
import '../widgets/modern_login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getGoogle = ref.watch<GoogleProvider>(googleConfig);
    
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
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
                  const SplashLogo(),
                  SizedBox(height: keyboardHeight > 0 ? 20 : 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      height: 320,
                      child: ModernLoginForm(getGoogle: getGoogle),
                    ),
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