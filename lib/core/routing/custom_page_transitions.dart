import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../animations/spring_animations.dart';

/// iOS 26 inspired page transitions with spring physics
/// Provides smooth, natural page navigation animations
class CustomPageTransitions {
  CustomPageTransitions._();

  /// Fade transition with spring timing
  /// Used for: Login → Home, Modal overlays
  static CustomTransitionPage fadeTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = SpringAnimations.standard,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: SpringAnimations.gentleSpring,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Fade + Scale transition (subtle zoom)
  /// Used for: Card → Detail pages, Modal dialogs
  static CustomTransitionPage fadeScaleTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = SpringAnimations.standard,
    double scaleBegin = 0.95,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: SpringAnimations.standardSpring,
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        final scaleAnimation = Tween<double>(
          begin: scaleBegin,
          end: 1.0,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Slide transition with spring
  /// Used for: Bottom sheets, Side drawers
  static CustomTransitionPage slideTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = SpringAnimations.standard,
    AxisDirection direction = AxisDirection.up,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: SpringAnimations.standardSpring,
        );

        Offset begin;
        switch (direction) {
          case AxisDirection.up:
            begin = const Offset(0, 0.05);
          case AxisDirection.down:
            begin = const Offset(0, -0.05);
          case AxisDirection.left:
            begin = const Offset(0.05, 0);
          case AxisDirection.right:
            begin = const Offset(-0.05, 0);
        }

        final slideAnimation = Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(curvedAnimation);

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Hero-style shared element transition
  /// Used for: List item → Detail page
  static CustomTransitionPage sharedAxisTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = SpringAnimations.standard,
    SharedAxisTransitionType transitionType =
        SharedAxisTransitionType.scaled,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: transitionType,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// iOS-style modal transition (from bottom with parallax)
  /// Used for: Full-screen modals
  static CustomTransitionPage modalTransition({
    required Widget child,
    required GoRouterState state,
    Duration duration = SpringAnimations.slow,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: SpringAnimations.standardSpring,
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation);

        // Background page subtle parallax
        final backgroundSlide = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -0.03),
        ).animate(curvedAnimation);

        return Stack(
          children: [
            SlideTransition(
              position: backgroundSlide,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
            SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          ],
        );
      },
      transitionDuration: duration,
    );
  }

  /// No transition (instant)
  /// Used for: Tab switches in bottom navigation
  static CustomTransitionPage noTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
      transitionDuration: Duration.zero,
    );
  }
}

/// Shared axis transition types
enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// Internal shared axis transition widget
class _SharedAxisTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType transitionType;
  final Widget child;

  const _SharedAxisTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.transitionType,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: SpringAnimations.standardSpring,
    );

    final curvedSecondaryAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: SpringAnimations.standardSpring,
    );

    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        return _buildHorizontalTransition(
          curvedAnimation,
          curvedSecondaryAnimation,
        );
      case SharedAxisTransitionType.vertical:
        return _buildVerticalTransition(
          curvedAnimation,
          curvedSecondaryAnimation,
        );
      case SharedAxisTransitionType.scaled:
        return _buildScaledTransition(
          curvedAnimation,
          curvedSecondaryAnimation,
        );
    }
  }

  Widget _buildHorizontalTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final primarySlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(animation);

    final primaryFade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    return FadeTransition(
      opacity: primaryFade,
      child: SlideTransition(
        position: primarySlide,
        child: child,
      ),
    );
  }

  Widget _buildVerticalTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final primarySlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(animation);

    final primaryFade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    return FadeTransition(
      opacity: primaryFade,
      child: SlideTransition(
        position: primarySlide,
        child: child,
      ),
    );
  }

  Widget _buildScaledTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final primaryScale = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(animation);

    final primaryFade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    // Outgoing page subtle scale down
    final secondaryScale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(secondaryAnimation);

    return Stack(
      children: [
        // Outgoing page
        if (secondaryAnimation.status != AnimationStatus.dismissed)
          ScaleTransition(
            scale: secondaryScale,
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        // Incoming page
        FadeTransition(
          opacity: primaryFade,
          child: ScaleTransition(
            scale: primaryScale,
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Extension for easy page transition building
extension GoRouterPageTransition on GoRouterState {
  /// Build a fade transition page
  CustomTransitionPage buildFadePage(Widget child) {
    return CustomPageTransitions.fadeTransition(
      child: child,
      state: this,
    );
  }

  /// Build a fade + scale transition page
  CustomTransitionPage buildFadeScalePage(Widget child) {
    return CustomPageTransitions.fadeScaleTransition(
      child: child,
      state: this,
    );
  }

  /// Build a slide transition page
  CustomTransitionPage buildSlidePage(
    Widget child, {
    AxisDirection direction = AxisDirection.up,
  }) {
    return CustomPageTransitions.slideTransition(
      child: child,
      state: this,
      direction: direction,
    );
  }

  /// Build a shared axis transition page
  CustomTransitionPage buildSharedAxisPage(Widget child) {
    return CustomPageTransitions.sharedAxisTransition(
      child: child,
      state: this,
    );
  }

  /// Build a modal transition page
  CustomTransitionPage buildModalPage(Widget child) {
    return CustomPageTransitions.modalTransition(
      child: child,
      state: this,
    );
  }

  /// Build a no transition page
  CustomTransitionPage buildNoTransitionPage(Widget child) {
    return CustomPageTransitions.noTransition(
      child: child,
      state: this,
    );
  }
}
