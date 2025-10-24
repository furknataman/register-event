import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/auth/services/login_service.dart';
import '../../../../l10n/app_localizations.dart';

class ModernLoginForm extends ConsumerStatefulWidget {
  final GoogleProvider getGoogle;

  const ModernLoginForm({
    super.key,
    required this.getGoogle,
  });

  @override
  ConsumerState<ModernLoginForm> createState() => _ModernLoginFormState();
}

class _ModernLoginFormState extends ConsumerState<ModernLoginForm> {
  final ValueNotifier<bool> _isPasswordObscured = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers to validate form
    widget.getGoogle.controllerEmail.addListener(_validateForm);
    widget.getGoogle.controllerPassword.addListener(_validateForm);
    // Initial validation
    _validateForm();
  }

  void _validateForm() {
    final emailText = widget.getGoogle.controllerEmail.text.trim();
    final passwordText = widget.getGoogle.controllerPassword.text;
    
    _isFormValid.value = emailText.isNotEmpty && passwordText.isNotEmpty;
  }

  Future<void> _handleLogin(BuildContext context) async {
    // Minimum 3 karakter kontrolü
    if (widget.getGoogle.controllerEmail.text.length < 3) {
      _showErrorMessage(context, 'Email must be at least 3 characters');
      return;
    }
    
    if (widget.getGoogle.controllerPassword.text.length < 3) {
      _showErrorMessage(context, 'Password must be at least 3 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref.read(authNotifierProvider.notifier).login(
        widget.getGoogle.controllerEmail.text.trim(),
        widget.getGoogle.controllerPassword.text,
      );

      if (success && mounted) {
        // Wait a frame for state to propagate
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        context.replace(AppRoutes.home);
      } else if (mounted) {
        _showErrorMessage(context, AppLocalizations.of(context)!.loginError);
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(context, 'Login failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordObscured,
          builder: (context, isObscured, child) {
            return _LiquidGlassTextField(
              labelText: AppLocalizations.of(context)!.email,
              iconPath: 'assets/svg/envelope.svg',
              controller: widget.getGoogle.controllerEmail,
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
              controller: widget.getGoogle.controllerPassword,
              isObscured: isObscured,
              onVisibilityToggle: () {
                _isPasswordObscured.value = !isObscured;
              },
            );
          },
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(
          valueListenable: _isFormValid,
          builder: (context, isValid, child) {
            return _LiquidGlassButton(
              label: AppLocalizations.of(context)!.login,
              isEnabled: isValid,
              isLoading: _isLoading,
              onTap: () => _handleLogin(context),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Remove listeners
    widget.getGoogle.controllerEmail.removeListener(_validateForm);
    widget.getGoogle.controllerPassword.removeListener(_validateForm);

    // Dispose ValueNotifiers
    _isPasswordObscured.dispose();
    _isFormValid.dispose();
    super.dispose();
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
            keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
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
    return GestureDetector(
      onTap: isEnabled && !isLoading ? onTap : null,
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