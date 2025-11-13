import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';

class LoginLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) {
    if (state != value) {
      state = value;
    }
  }
}

final loginLoadingProvider =
    NotifierProvider.autoDispose<LoginLoadingNotifier, bool>(
  LoginLoadingNotifier.new,
);

class ModernLoginForm extends ConsumerStatefulWidget {
  const ModernLoginForm({super.key});

  @override
  ConsumerState<ModernLoginForm> createState() => _ModernLoginFormState();
}

class _ModernLoginFormState extends ConsumerState<ModernLoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordObscured = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);
  final AppLogger _logger = AppLogger();

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers to validate form
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    // Initial validation
    _validateForm();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isPasswordObscured.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  void _validateForm() {
    final emailText = _emailController.text.trim();
    final passwordText = _passwordController.text;

    _isFormValid.value = emailText.isNotEmpty && passwordText.isNotEmpty;
  }

  Future<void> _handleLogin(BuildContext context) async {
    HapticFeedback.selectionClick();
    // Minimum 3 karakter kontrolü
    if (_emailController.text.length < 3) {
      HapticFeedback.mediumImpact();
      _showErrorMessage(context, 'Email must be at least 3 characters');
      return;
    }

    if (_passwordController.text.length < 3) {
      HapticFeedback.mediumImpact();
      _showErrorMessage(context, 'Password must be at least 3 characters');
      return;
    }

    ref.read(loginLoadingProvider.notifier).setLoading(true);

    try {
      final success = await ref.read(authNotifierProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );

      if (success && mounted) {
        HapticFeedback.lightImpact();
        // Wait a frame for state to propagate
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        context.replace(AppRoutes.home);
      } else if (mounted) {
        HapticFeedback.mediumImpact();
        _showErrorMessage(context, AppLocalizations.of(context)!.loginError);
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.mediumImpact();
        _showErrorMessage(context, AppLocalizations.of(context)!.loginFailed);
      }
    } finally {
      if (mounted) {
        ref.read(loginLoadingProvider.notifier).setLoading(false);
      }
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    // Log error instead of showing SnackBar
    _logger.error('Login error: $message');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginLoadingProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordObscured,
          builder: (context, isObscured, child) {
            return _LiquidGlassTextField(
              labelText: AppLocalizations.of(context)!.email,
              iconPath: 'assets/svg/envelope.svg',
              controller: _emailController,
            );
          },
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordObscured,
          builder: (context, isObscured, child) {
            return _LiquidGlassTextField(
              labelText: AppLocalizations.of(context)!.password,
              iconPath: 'assets/svg/lock.svg',
              isPassword: true,
              controller: _passwordController,
              isObscured: isObscured,
              onVisibilityToggle: () {
                _isPasswordObscured.value = !isObscured;
              },
            );
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              context.push('/forgot-password');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              AppLocalizations.of(context)!.forgotPassword,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: _isFormValid,
          builder: (context, isValid, child) {
            return _LiquidGlassButton(
              label: AppLocalizations.of(context)!.login,
              isEnabled: isValid,
              isLoading: isLoading,
              onTap: () => _handleLogin(context),
            );
          },
        ),
      ],
    );
  }
}

// Liquid Glass TextField Widget
class _LiquidGlassTextField extends StatelessWidget {
  final String? labelText;
  final String? iconPath;
  final bool isPassword;
  final TextEditingController? controller;
  final bool isObscured;
  final VoidCallback? onVisibilityToggle;

  const _LiquidGlassTextField({
    required this.labelText,
    this.iconPath,
    this.isPassword = false,
    required this.controller,
    this.isObscured = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF004B8D),
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: TextField(
            controller: controller,
            keyboardType: isPassword
                ? TextInputType.visiblePassword
                : TextInputType.emailAddress,
            obscureText: isPassword && isObscured,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.9),
                fontSize: 14,
              ),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: SvgPicture.asset(
                        isObscured
                            ? 'assets/svg/eye-slash.svg'
                            : 'assets/svg/eye.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(255, 255, 255, 0.9),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: onVisibilityToggle,
                    )
                  : iconPath != null
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            iconPath!,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              Color.fromRGBO(255, 255, 255, 0.9),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}

// Liquid Glass Button Widget
class _LiquidGlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isEnabled;
  final bool isLoading;

  const _LiquidGlassButton({
    required this.label,
    this.onTap,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    void handleTap() {
      if (!isEnabled || isLoading) {
        return;
      }
      HapticFeedback.selectionClick();
      onTap?.call();
    }

    return GestureDetector(
      onTap: handleTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.2),
                        Color.fromRGBO(255, 255, 255, 0.1),
                      ],
                    )
                  : const LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.05),
                        Color.fromRGBO(255, 255, 255, 0.03),
                      ],
                    ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isEnabled
                    ? const Color(0xFF004B8D)
                    : const Color.fromRGBO(255, 255, 255, 0.1),
                width: 2.0,
              ),
              boxShadow: isEnabled
                  ? const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: isEnabled
                            ? Colors.white
                            : const Color.fromRGBO(255, 255, 255, 0.4),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
