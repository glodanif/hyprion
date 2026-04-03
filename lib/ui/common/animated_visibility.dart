import 'package:flutter/material.dart';

/// A widget that animates its child's visibility with both fade and size transitions.
///
/// When [visible] is true, the child fades in and expands.
/// When [visible] is false, the child fades out and collapses.
class AnimatedVisibility extends StatelessWidget {
  /// Whether the child should be visible.
  final bool visible;

  /// The child widget to show or hide.
  final Widget child;

  /// The duration of the animation.
  final Duration duration;

  /// The curve to use for the animation.
  final Curve curve;

  const AnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SizeTransition(sizeFactor: curvedAnimation, child: child),
        );
      },
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}
