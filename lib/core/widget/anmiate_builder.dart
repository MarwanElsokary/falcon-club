import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimateBuilder extends StatelessWidget {
  final Widget child;
  final int columnCount, position;
  const AnimateBuilder(
      {super.key,
      required this.child,
      required this.columnCount,
      required this.position});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
        columnCount: columnCount,
        position: position,
        duration: const Duration(milliseconds: 375),
        child: ScaleAnimation(child: child));
  }
}
