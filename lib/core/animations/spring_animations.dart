import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// iOS 26 inspired spring animation utilities
/// Provides physics-based, natural feeling animations with optimal performance
class SpringAnimations {
  SpringAnimations._();

  // iOS 26 Spring Curves - Natural, subtle, performant

  /// Gentle spring for subtle UI elements (buttons, icons)
  /// Damping: 0.85 (low bounce), Duration: ~280ms
  static const Curve gentleSpring = Curves.easeOutCubic;

  /// Standard spring for most transitions
  /// Damping: 0.75 (minimal bounce), Duration: ~320ms
  static const Curve standardSpring = Curves.easeOutQuart;

  /// Bouncy spring for playful interactions
  /// Damping: 0.6 (light bounce), Duration: ~380ms
  static Curve get bouncySpring => Curves.elasticOut;

  /// Smooth spring for page transitions
  /// Damping: 0.9 (no bounce), Duration: ~300ms
  static const Curve smoothSpring = Curves.easeInOutCubic;

  // Duration constants - iOS 26 balanced timing
  static const Duration veryFast = Duration(milliseconds: 200);
  static const Duration fast = Duration(milliseconds: 280);
  static const Duration standard = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 380);
  static const Duration verySlow = Duration(milliseconds: 450);

  /// Creates a spring simulation with iOS 26 physics parameters
  static SpringDescription createSpringDescription({
    double mass = 1.0,
    double stiffness = 180.0, // iOS 26 default
    double damping = 0.75, // Minimal bounce
  }) {
    return SpringDescription.withDampingRatio(
      mass: mass,
      stiffness: stiffness,
      ratio: damping,
    );
  }

  /// Fade in animation with spring timing
  static Animation<double> fadeIn(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: gentleSpring),
    );
  }

  /// Fade out animation with spring timing
  static Animation<double> fadeOut(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: controller, curve: gentleSpring),
    );
  }

  /// Scale animation with spring (for buttons, cards)
  static Animation<double> scale({
    required AnimationController controller,
    double begin = 0.95,
    double end = 1.0,
    Curve curve = standardSpring,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Slide animation with spring
  static Animation<Offset> slide({
    required AnimationController controller,
    Offset begin = const Offset(0, 0.05),
    Offset end = Offset.zero,
    Curve curve = standardSpring,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Combined fade + scale animation (common pattern)
  static ({Animation<double> fade, Animation<double> scale}) fadeAndScale({
    required AnimationController controller,
    double scaleBegin = 0.95,
    double scaleEnd = 1.0,
  }) {
    return (
      fade: fadeIn(controller),
      scale: scale(
        controller: controller,
        begin: scaleBegin,
        end: scaleEnd,
      ),
    );
  }
}

/// Animated widget wrapper with spring physics
/// Automatically handles controller lifecycle
class SpringAnimatedBuilder extends StatefulWidget {
  final Widget Function(BuildContext, Animation<double>) builder;
  final Duration duration;
  final Curve curve;
  final bool autoStart;
  final VoidCallback? onComplete;

  const SpringAnimatedBuilder({
    required this.builder,
    this.duration = SpringAnimations.standard,
    this.curve = SpringAnimations.standardSpring,
    this.autoStart = true,
    this.onComplete,
    super.key,
  });

  @override
  State<SpringAnimatedBuilder> createState() => _SpringAnimatedBuilderState();
}

class _SpringAnimatedBuilderState extends State<SpringAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.onComplete != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete!();
        }
      });
    }

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => widget.builder(context, _animation),
    );
  }
}

/// Staggered animation helper for lists
/// Creates cascading entrance animations
class StaggeredAnimation {
  final int itemCount;
  final Duration totalDuration;
  final Duration staggerDelay;

  StaggeredAnimation({
    required this.itemCount,
    this.totalDuration = const Duration(milliseconds: 800),
    this.staggerDelay = const Duration(milliseconds: 80),
  });

  /// Get animation delay for item at index
  Duration getDelay(int index) {
    final maxDelay = itemCount * staggerDelay.inMilliseconds;
    final adjustedDelay =
        (index * staggerDelay.inMilliseconds).clamp(0, maxDelay).toInt();
    return Duration(milliseconds: adjustedDelay);
  }

  /// Get animation interval for item at index (0.0 to 1.0)
  Interval getInterval(int index, AnimationController controller) {
    final delay = getDelay(index).inMilliseconds;
    final duration = totalDuration.inMilliseconds;
    final start = (delay / duration).clamp(0.0, 1.0);
    final end = ((delay + SpringAnimations.standard.inMilliseconds) / duration)
        .clamp(0.0, 1.0);

    return Interval(start, end, curve: SpringAnimations.standardSpring);
  }
}

/// Button press animation mixin
/// Provides scale feedback on tap
class SpringButtonPressedNotifier extends Notifier<bool> {
  SpringButtonPressedNotifier(this.buttonKey);

  final int buttonKey;

  @override
  bool build() => false;

  void setPressed(bool value) {
    if (state != value) {
      state = value;
    }
  }
}

final _springButtonPressedProvider =
    NotifierProvider.family.autoDispose<SpringButtonPressedNotifier, bool, int>(
  SpringButtonPressedNotifier.new,
);

mixin SpringButtonMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final int _buttonKey = hashCode;

  void onTapDown(TapDownDetails details) {
    ref
        .read(_springButtonPressedProvider(_buttonKey).notifier)
        .setPressed(true);
  }

  void onTapUp(TapUpDetails details) {
    ref
        .read(_springButtonPressedProvider(_buttonKey).notifier)
        .setPressed(false);
  }

  void onTapCancel() {
    ref
        .read(_springButtonPressedProvider(_buttonKey).notifier)
        .setPressed(false);
  }

  double get pressedScale => 0.95;

  Widget buildPressAnimation({required Widget child}) {
    final isPressed = ref.watch(_springButtonPressedProvider(_buttonKey));
    return AnimatedScale(
      scale: isPressed ? pressedScale : 1.0,
      duration: SpringAnimations.fast,
      curve: SpringAnimations.gentleSpring,
      child: child,
    );
  }
}

/// Shake animation for errors
class ShakeAnimation {
  static void shake(AnimationController controller) {
    controller.forward(from: 0.0);
  }

  static Animation<double> createShakeTween(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }
}

/// Animated list item wrapper with spring entrance
class SpringListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const SpringListItem({
    required this.child,
    required this.index,
    this.delay = Duration.zero,
    super.key,
  });

  @override
  State<SpringListItem> createState() => _SpringListItemState();
}

class _SpringListItemState extends State<SpringListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SpringAnimations.standard,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: SpringAnimations.gentleSpring),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: SpringAnimations.standardSpring),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
