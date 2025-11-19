import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? icon;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final List<Color>? gradientColors;
  final Widget? child;
  final ValueChanged<bool>? onHighlightChanged;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.gradientColors,
    this.child,
    this.onHighlightChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          const Color(0xFF667eea),
          const Color(0xFF764ba2),
        ];

    return SizedBox(
      width: width,
      height: height,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.9,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (isLoading || !enabled) ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            onHighlightChanged: enabled ? onHighlightChanged : null,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: colors.first.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else if (icon != null)
                        icon!,
                      if ((icon != null || isLoading) && text.isNotEmpty) const SizedBox(width: 12),
                      if (text.isNotEmpty)
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
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
