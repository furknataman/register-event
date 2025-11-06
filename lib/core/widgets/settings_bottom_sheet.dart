import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../animations/spring_animations.dart';

/// iOS 26 Liquid Glass style bottom sheet for settings
/// Used for theme selection, language selection, etc.
Future<T?> showLiquidGlassBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<LiquidGlassOption<T>> options,
  T? currentValue,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    elevation: 0,
    builder: (context) => _LiquidGlassBottomSheet<T>(
      title: title,
      options: options,
      currentValue: currentValue,
    ),
  );
}

class LiquidGlassOption<T> {
  final T value;
  final String label;
  final String? iconPath; // SVG path
  final IconData? iconData; // Material icon
  final String? emoji;

  const LiquidGlassOption({
    required this.value,
    required this.label,
    this.iconPath,
    this.iconData,
    this.emoji,
  });
}

class _LiquidGlassBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<LiquidGlassOption<T>> options;
  final T? currentValue;

  const _LiquidGlassBottomSheet({
    required this.title,
    required this.options,
    this.currentValue,
  });

  @override
  State<_LiquidGlassBottomSheet<T>> createState() => _LiquidGlassBottomSheetState<T>();
}

class _LiquidGlassBottomSheetState<T> extends State<_LiquidGlassBottomSheet<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SpringAnimations.standard,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: SpringAnimations.standardSpring,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: SpringAnimations.gentleSpring,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close([T? value]) async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          elevation: 24,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    bottom: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle indicator
                        const SizedBox(height: 14),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Options
                        ...widget.options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final isSelected = option.value == widget.currentValue;
                          final delay = Duration(milliseconds: 50 + (index * 40));

                          return SpringListItem(
                            index: index,
                            delay: delay,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: LiquidGlassOptionTile<T>(
                                option: option,
                                isSelected: isSelected,
                                onTap: () => _close(option.value),
                              ),
                            ),
                          );
                        }),

                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 16,
                          // SafeArea + 16px, minimal bottom spacing
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single option tile with liquid glass effect
class LiquidGlassOptionTile<T> extends ConsumerStatefulWidget {
  final LiquidGlassOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;

  const LiquidGlassOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  ConsumerState<LiquidGlassOptionTile<T>> createState() => _LiquidGlassOptionTileState<T>();
}

class _LiquidGlassOptionTileState<T> extends ConsumerState<LiquidGlassOptionTile<T>> with SpringButtonMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: (details) {
        onTapUp(details);
        widget.onTap();
      },
      onTapCancel: onTapCancel,
      child: buildPressAnimation(
        child: AnimatedContainer(
          duration: SpringAnimations.fast,
          curve: SpringAnimations.gentleSpring,
          height: 68,
          decoration: widget.isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFFFF6B9D),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667eea).withValues(alpha: 0.7),
                      blurRadius: 20,
                      spreadRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF6B9D).withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
          child: Container(
            margin: widget.isSelected ? const EdgeInsets.all(2.5) : EdgeInsets.zero,
            decoration: widget.isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(13.5),
                    color: Colors.white.withValues(alpha: 0.25),
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  // Icon with scale animation
                  AnimatedScale(
                    scale: widget.isSelected ? 1.05 : 1.0,
                    duration: SpringAnimations.fast,
                    curve: SpringAnimations.gentleSpring,
                    child: widget.option.emoji != null
                        ? Text(
                            widget.option.emoji!,
                            style: const TextStyle(fontSize: 28),
                          )
                        : widget.option.iconPath != null
                            ? SvgPicture.asset(
                                widget.option.iconPath!,
                                width: 26,
                                height: 26,
                                colorFilter: ColorFilter.mode(
                                  widget.isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
                                  BlendMode.srcIn,
                                ),
                              )
                            : widget.option.iconData != null
                                ? Icon(
                                    widget.option.iconData,
                                    size: 26,
                                    color: widget.isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
                                  )
                                : const SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),

                  // Label with shadow
                  Expanded(
                    child: Text(
                      widget.option.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.3,
                        shadows: widget.isSelected
                            ? [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),

                  // Checkmark with strong glow
                  AnimatedScale(
                    scale: widget.isSelected ? 1.0 : 0.0,
                    duration: SpringAnimations.veryFast,
                    curve: SpringAnimations.bouncySpring,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: const Color(0xFF667eea).withValues(alpha: 0.4),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 24,
                        color: Color(0xFF667eea),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern logout confirmation dialog with liquid glass effect
Future<bool?> showLiquidGlassLogoutDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String cancelText,
  required String confirmText,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (context) => _LiquidGlassLogoutDialog(
      title: title,
      message: message,
      cancelText: cancelText,
      confirmText: confirmText,
    ),
  );
}

class _LiquidGlassLogoutDialog extends StatefulWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;

  const _LiquidGlassLogoutDialog({
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
  });

  @override
  State<_LiquidGlassLogoutDialog> createState() => _LiquidGlassLogoutDialogState();
}

class _LiquidGlassLogoutDialogState extends State<_LiquidGlassLogoutDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SpringAnimations.fast,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: SpringAnimations.bouncySpring,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: SpringAnimations.gentleSpring,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close([bool? value]) async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),

                    // Icon with gradient
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFEE5A6F),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/arrow-right-from-bracket.svg',
                          width: 32,
                          height: 32,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Message
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 15,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _DialogButton(
                              text: widget.cancelText,
                              onPressed: () => _close(false),
                              isPrimary: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DialogButton(
                              text: widget.confirmText,
                              onPressed: () => _close(true),
                              isPrimary: true,
                              isDestructive: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;

  const _DialogButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  @override
  ConsumerState<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends ConsumerState<_DialogButton> with SpringButtonMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: (details) {
        onTapUp(details);
        widget.onPressed();
      },
      onTapCancel: onTapCancel,
      child: buildPressAnimation(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: widget.isPrimary && widget.isDestructive
                ? const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                  )
                : null,
            color: widget.isPrimary && !widget.isDestructive
                ? const Color(0xFF667eea)
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isPrimary ? Colors.transparent : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: widget.isPrimary ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
