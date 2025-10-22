import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../global/svg.dart';
import '../../../../pages/start/widgets/startlogo.dart';
import '../../../../authentication/login_service.dart';
import '../widgets/modern_login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getGoogle = ref.watch<GoogleProvider>(googleConfig);
    
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),
                  const StartPageWidgets(),
                  const Spacer(flex: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      height: 320,
                      child: ModernLoginForm(getGoogle: getGoogle),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}