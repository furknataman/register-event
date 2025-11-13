import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class ResetPasswordLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) {
    if (state != value) {
      state = value;
    }
  }
}

final resetPasswordLoadingProvider =
    NotifierProvider.autoDispose<ResetPasswordLoadingNotifier, bool>(
  ResetPasswordLoadingNotifier.new,
);

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String emailOrPhone;
  final int type;

  const ResetPasswordPage({
    super.key,
    required this.emailOrPhone,
    required this.type,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _isPasswordObscured = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isConfirmPasswordObscured =
      ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);
  final AppLogger _logger = AppLogger();

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isPasswordObscured.dispose();
    _isConfirmPasswordObscured.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  void _validateForm() {
    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    _isFormValid.value = code.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;
  }

  Future<void> _handleResetPassword(BuildContext context) async {
    HapticFeedback.selectionClick();

    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (code.isEmpty || code.length < 4) {
      HapticFeedback.mediumImpact();
      _showErrorMessage(context, 'Lütfen geçerli bir sıfırlama kodu giriniz');
      return;
    }

    if (password.length < 6) {
      HapticFeedback.mediumImpact();
      _showErrorMessage(context, 'Şifre en az 6 karakter olmalıdır');
      return;
    }

    if (password != confirmPassword) {
      HapticFeedback.mediumImpact();
      _showErrorMessage(
          context, AppLocalizations.of(context)!.passwordsMustMatch);
      return;
    }

    ref.read(resetPasswordLoadingProvider.notifier).setLoading(true);

    try {
      final remoteDataSource = ref.read(authRemoteDataSourceProvider);
      await remoteDataSource.resetPassword(
        code: int.parse(code),
        type: widget.type,
        emailOrPhone: widget.emailOrPhone,
        password: password,
        passwordConfirm: confirmPassword,
      );

      if (mounted) {
        HapticFeedback.lightImpact();
        _logger.info('Password reset successfully');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.passwordResetSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Wait for the snackbar to be visible
        await Future.delayed(const Duration(milliseconds: 500));

        // Go back to login page
        if (mounted) {
          context.go(AppRoutes.login);
        }
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.mediumImpact();
        _logger.error('Failed to reset password: $e');
        _showErrorMessage(context, 'Şifre sıfırlanamadı. Lütfen tekrar deneyiniz.');
      }
    } finally {
      if (mounted) {
        ref.read(resetPasswordLoadingProvider.notifier).setLoading(false);
      }
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    _logger.error('Reset password error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(resetPasswordLoadingProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF004B8D),
              Color(0xFF0A1931),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.resetPasswordTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.enterResetCode,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                _LiquidGlassTextField(
                  labelText: AppLocalizations.of(context)!.enterResetCode,
                  iconPath: 'assets/svg/key.svg',
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _isPasswordObscured,
                  builder: (context, isObscured, child) {
                    return _LiquidGlassTextField(
                      labelText: AppLocalizations.of(context)!.newPassword,
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
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _isConfirmPasswordObscured,
                  builder: (context, isObscured, child) {
                    return _LiquidGlassTextField(
                      labelText: AppLocalizations.of(context)!.confirmPassword,
                      iconPath: 'assets/svg/lock.svg',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      isObscured: isObscured,
                      onVisibilityToggle: () {
                        _isConfirmPasswordObscured.value = !isObscured;
                      },
                    );
                  },
                ),
                const SizedBox(height: 40),
                ValueListenableBuilder<bool>(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, child) {
                    return _LiquidGlassButton(
                      label: AppLocalizations.of(context)!.resetPassword,
                      isEnabled: isValid,
                      isLoading: isLoading,
                      onTap: () => _handleResetPassword(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
  final TextInputType? keyboardType;

  const _LiquidGlassTextField({
    required this.labelText,
    this.iconPath,
    this.isPassword = false,
    required this.controller,
    this.isObscured = false,
    this.onVisibilityToggle,
    this.keyboardType,
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
            keyboardType: keyboardType ??
                (isPassword
                    ? TextInputType.visiblePassword
                    : TextInputType.text),
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
