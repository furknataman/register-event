import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) {
    if (state != value) {
      state = value;
    }
  }
}

final forgotPasswordLoadingProvider =
    NotifierProvider.autoDispose<ForgotPasswordLoadingNotifier, bool>(
  ForgotPasswordLoadingNotifier.new,
);

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final TextEditingController _emailOrPhoneController =
      TextEditingController();
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);
  final ValueNotifier<int> _resetType = ValueNotifier<int>(1); // 1: email, 2: sms
  final AppLogger _logger = AppLogger();

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _isFormValid.dispose();
    _resetType.dispose();
    super.dispose();
  }

  void _validateForm() {
    final text = _emailOrPhoneController.text.trim();
    _isFormValid.value = text.isNotEmpty;
  }

  Future<void> _handleSendCode(BuildContext context) async {
    HapticFeedback.selectionClick();

    final emailOrPhone = _emailOrPhoneController.text.trim();
    if (emailOrPhone.length < 3) {
      HapticFeedback.mediumImpact();
      _showErrorMessage(context, 'Lütfen geçerli bir e-posta veya telefon giriniz');
      return;
    }

    ref.read(forgotPasswordLoadingProvider.notifier).setLoading(true);

    try {
      final remoteDataSource = ref.read(authRemoteDataSourceProvider);
      await remoteDataSource.sendPasswordResetCode(
        emailOrPhone: emailOrPhone,
        type: _resetType.value,
      );

      if (!mounted) return;

      HapticFeedback.lightImpact();
      _logger.info('Reset code sent successfully');

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.resetCodeSent),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to reset password page with parameters
        context.push(
          AppRoutes.resetPassword,
          extra: {
            'emailOrPhone': emailOrPhone,
            'type': _resetType.value,
          },
        );
      }
    } catch (e) {
      if (!mounted) return;

      HapticFeedback.mediumImpact();
      _logger.error('Failed to send reset code: $e');

      final localizations = AppLocalizations.of(context)!;
      String errorMessage;

      if (e is AuthException) {
        final localizationKey = e.message;

        switch (localizationKey) {
          case 'forgot_password_participant_not_found':
            errorMessage = localizations.forgot_password_participant_not_found;
            break;
          case 'forgot_password_email_not_found':
            errorMessage = localizations.forgot_password_email_not_found;
            break;
          case 'forgot_password_phone_not_found':
            errorMessage = localizations.forgot_password_phone_not_found;
            break;
          case 'forgot_password_invalid_type':
            errorMessage = localizations.forgot_password_invalid_type;
            break;
          default:
            errorMessage = localizationKey;
        }
      } else if (e is NetworkException) {
        errorMessage = localizations.networkError;
      } else {
        errorMessage = localizations.anErrorOccurred;
      }

      if (mounted) {
        _showErrorMessage(context, errorMessage);
      }
    } finally {
      if (mounted) {
        ref.read(forgotPasswordLoadingProvider.notifier).setLoading(false);
      }
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    _logger.error('Forgot password error: $message');
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
    final isLoading = ref.watch(forgotPasswordLoadingProvider);

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
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(context),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.forgotPasswordTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.enterEmailOrPhone,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                ValueListenableBuilder<int>(
                  valueListenable: _resetType,
                  builder: (context, selectedType, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selectResetMethod,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _ResetMethodOption(
                                label: AppLocalizations.of(context)!.resetViaEmail,
                                isSelected: selectedType == 1,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  _resetType.value = 1;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ResetMethodOption(
                                label: AppLocalizations.of(context)!.resetViaSms,
                                isSelected: selectedType == 2,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  _resetType.value = 2;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                _LiquidGlassTextField(
                  labelText: AppLocalizations.of(context)!.enterEmailOrPhone,
                  iconPath: 'assets/svg/envelope.svg',
                  controller: _emailOrPhoneController,
                ),
                const SizedBox(height: 40),
                ValueListenableBuilder<bool>(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, child) {
                    return _LiquidGlassButton(
                      label: AppLocalizations.of(context)!.sendResetCode,
                      isEnabled: isValid,
                      isLoading: isLoading,
                      onTap: () => _handleSendCode(context),
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
  final TextEditingController? controller;

  const _LiquidGlassTextField({
    required this.labelText,
    this.iconPath,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Colors.white;
    final borderColor = isDark ? const Color(0xFF415A77) : const Color(0xFF004B8D);
    final bgOpacity = isDark ? 0.2 : 0.15;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, bgOpacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor,
              width: 2.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: textColor.withValues(alpha: 0.9),
                fontSize: 14,
              ),
              border: InputBorder.none,
              suffixIcon: iconPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        iconPath!,
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          textColor.withValues(alpha: 0.9),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF415A77) : const Color(0xFF004B8D);
    final textColor = Colors.white;

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
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 255, 255, isDark ? 0.25 : 0.2),
                        Color.fromRGBO(255, 255, 255, isDark ? 0.15 : 0.1),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 255, 255, isDark ? 0.08 : 0.05),
                        Color.fromRGBO(255, 255, 255, isDark ? 0.05 : 0.03),
                      ],
                    ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isEnabled
                    ? borderColor
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
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: textColor,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: isEnabled
                            ? textColor
                            : textColor.withValues(alpha: 0.4),
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

// Reset Method Option Widget
class _ResetMethodOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResetMethodOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF415A77) : const Color(0xFF004B8D);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color.fromRGBO(255, 255, 255, isDark ? 0.25 : 0.2)
                  : Color.fromRGBO(255, 255, 255, isDark ? 0.1 : 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? borderColor
                    : Color.fromRGBO(255, 255, 255, isDark ? 0.2 : 0.15),
                width: isSelected ? 2.0 : 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
