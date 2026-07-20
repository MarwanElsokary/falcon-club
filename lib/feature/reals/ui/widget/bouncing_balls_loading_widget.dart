import 'dart:math';

import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReelsRefreshLoadingWidget extends StatefulWidget {
  const ReelsRefreshLoadingWidget({super.key});

  @override
  State<ReelsRefreshLoadingWidget> createState() =>
      _ReelsRefreshLoadingWidgetState();
}

class _ReelsRefreshLoadingWidgetState extends State<ReelsRefreshLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const double _minOpacity = 0.35;

  // مقاس اللوجو الموحّد (الصندوق والصورة لازم يتطابقوا فى المقاس).
  static const double _size = 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1700,
      ), // أسرع شوية من قبل (كانت 1000ms)
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size.w,
      height: _size.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final angle = t * 2 * pi;

          final wave = (sin(t * 2 * pi) + 1) / 4;
          final opacity = _minOpacity + (1 - _minOpacity) * wave;

          return Opacity(
            opacity: opacity,
            child: Transform.rotate(angle: angle, child: child),
          );
        },
        child: SvgPicture.asset(
          'assets/svgs/pajamas_retry.svg',
          width: _size.w,
          height: _size.h,
          fit: BoxFit.contain,
          color: mainColor,
        ),
      ),
    );
  }
}
