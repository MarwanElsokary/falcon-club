import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../login/cubit/login_cubit.dart';

class ShowPasswordIconWidget extends StatefulWidget {
  const ShowPasswordIconWidget({super.key});

  @override
  State<ShowPasswordIconWidget> createState() => _ShowPasswordIconWidgetState();
}

class _ShowPasswordIconWidgetState extends State<ShowPasswordIconWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isAtStart = true;

  double _frameStart = 0;
  double _frameEnd = 60;
  double _totalFrames = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void _toggleAnimation() {
    if (_totalFrames == 0) return; // تأكد إن اللوتي اتحمّلت

    final double start = _frameStart / _totalFrames;
    final double end = _frameEnd / _totalFrames;

    if (_isAtStart) {
      log('show');
      context.read<LoginCubit>().showPassword.value = false;
      _controller.animateTo(end, duration: const Duration(milliseconds: 500));
    } else {
      log('hide');
      context.read<LoginCubit>().showPassword.value = true;
      _controller.animateTo(start, duration: const Duration(milliseconds: 500));
    }

    _isAtStart = !_isAtStart;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation,
      child: Lottie.asset(
        'assets/lottie/Visible and Invisible.json',
        controller: _controller,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
          _totalFrames = composition.endFrame; // احفظ إجمالي الفريمات
          _controller
            ..value =
                _frameStart /
                _totalFrames // ابدأ من أول فريم
            ..stop(); // توقف في أول فريم
        },
        width: 50.w,
      ),
    );
  }
}
