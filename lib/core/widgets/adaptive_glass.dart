import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Adaptive glass effect wrapper that switches away from heavy shaders on Android.
class AdaptiveGlass extends StatelessWidget {
  const AdaptiveGlass({
    required this.child,
    this.borderRadius = const Radius.circular(20),
    this.settings,
    this.enableClip = true,
    this.enableRepaintBoundary = true,
    this.fallbackBlur,
    super.key,
  });

  final Widget child;
  final Radius borderRadius;
  final LiquidGlassSettings? settings;
  final bool enableClip;
  final bool enableRepaintBoundary;
  final double? fallbackBlur;

  static bool get _shouldUseLiquidGlass {
    if (kIsWeb) {
      return false;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
  }

  LiquidGlassSettings get _effectiveSettings {
    if (settings != null) {
      return settings!;
    }

    final blurValue = fallbackBlur ?? 6.0;

    return LiquidGlassSettings(
      blur: blurValue,
      ambientStrength: 0.6,
      lightAngle: 0.2 * math.pi,
      glassColor: Colors.white.withOpacity(0.1),
      chromaticAberration: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.all(borderRadius);
    final blurValue = settings?.blur ?? fallbackBlur ?? 0;

    Widget composed = child;

    if (_shouldUseLiquidGlass) {
      composed = LiquidGlass(
        settings: _effectiveSettings,
        shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
        glassContainsChild: false,
        child: composed,
      );

      if (enableClip) {
        composed = ClipRRect(
          borderRadius: radius,
          child: composed,
        );
      }
    } else {
      if (enableClip) {
        if (blurValue > 0) {
          composed = ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurValue,
                sigmaY: blurValue,
              ),
              child: composed,
            ),
          );
        } else {
          composed = ClipRRect(
            borderRadius: radius,
            child: composed,
          );
        }
      } else if (blurValue > 0) {
        composed = BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurValue,
            sigmaY: blurValue,
          ),
          child: composed,
        );
      }
    }

    if (enableRepaintBoundary) {
      return RepaintBoundary(child: composed);
    }

    return composed;
  }
}

