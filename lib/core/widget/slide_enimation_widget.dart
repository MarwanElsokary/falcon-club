import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SlideEnimationWidget extends StatelessWidget {
  const SlideEnimationWidget({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
  });
  final int index;
  final Widget child;

  /// How long the entrance runs.
  ///
  /// The 2500ms default suits a list or screen easing in behind other content.
  /// It is far too slow for a dialog, where the buttons spend the whole time
  /// visibly sliding and fading into place and the thing reads as still
  /// arriving. Dialogs pass ~300ms so the surface settles at once.
  ///
  /// (Taps are not blocked by the duration — the content becomes hit-testable
  /// a couple of frames after mount either way. This is about perceived
  /// responsiveness, not a dead input window.)
  ///
  /// Defaults to 2500ms so every existing call site is unchanged.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
        position: index,
        delay: const Duration(milliseconds: 0),
        child: SlideAnimation(
            duration: duration,
            curve: Curves.fastLinearToSlowEaseIn,
            child: FadeInAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: duration,
                child: child)));
  }
}
