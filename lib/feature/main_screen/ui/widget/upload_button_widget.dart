import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

class UploadButtonWidget extends StatefulWidget {
  const UploadButtonWidget({super.key, required this.ontap});
  final Function() ontap;

  @override
  State<UploadButtonWidget> createState() => _UploadButtonWidgetState();
}

class _UploadButtonWidgetState extends State<UploadButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _lottieController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    // حركة الجريدينت (الدوران)
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // الكنترولر الخاص بالـ Lottie
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, _) {
        return GestureDetector(
          onTap: () async {
            widget.ontap();
            if (_isPlaying) return;
            setState(() => _isPlaying = true);

            final double start = 44 / _totalFrames;
            final double end = 1.0;

            // المرحلة الأولى: من الفريم 44 إلى النهاية
            await _lottieController.animateTo(
              end,
              duration: Duration(
                milliseconds:
                    (_lottieController.duration!.inMilliseconds * (1 - start))
                        .round(),
              ),
              curve: Curves.easeInOut,
            );

            // المرحلة الثانية: من الفريم 0 إلى 44
            _lottieController.value = 0.0;
            await _lottieController.animateTo(
              start,
              duration: Duration(
                milliseconds:
                    (_lottieController.duration!.inMilliseconds * start)
                        .round(),
              ),
              curve: Curves.easeInOut,
            );

            setState(() => _isPlaying = false);
          },
          child: Container(
            width: 70.w,
            height: 70.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ==== BORDER WITH GRADIENT ====
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      startAngle: 0.0,
                      endAngle: 2 * math.pi,
                      colors: const [
                        Color(0xFF5D2BF4),
                        Color(0xFFF7EBA6),
                        Color(0xFFFFEC6E),
                        Color(0xFFF17EDC),
                        Color(0xFF2BF4DD),
                        Color(0xFF5D2BF4),
                      ],
                      stops: const [0.0, 0.25, 0.45, 0.7, 0.9, 1.0],
                      transform: GradientRotation(
                        _gradientController.value * 2 * math.pi,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svgs/upload_bottom.svg',
                          width: 22.w,
                        ),
                      ),
                    ),
                  ),
                ),

                // ==== LOTTIE ANIMATION ====
                PositionedDirectional(
                  start: 0,
                  end: 1.w,
                  top: 15.w,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/UploadImport.json',
                        width: 24.w,
                        height: 24.w,
                        fit: BoxFit.cover,
                        controller: _lottieController,
                        onLoaded: (composition) {
                          _lottieController.duration = composition.duration;
                          // نبدأ من الفريم 44
                          _lottieController.value = 44 / _totalFrames;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // عدد الفريمات الكلي في اللوتي (تقدر تعدّلها حسب ملفك)
  double get _totalFrames => 100;
}
