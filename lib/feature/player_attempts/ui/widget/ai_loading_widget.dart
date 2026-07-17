import 'dart:math' as math;

import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The circular "under review" indicator shown while an attempt is being scored.
///
/// The ring sweeps from 0 to [percent] over the review window and the centre
/// shows the matching percentage.
class AiLoadingWidget extends StatefulWidget {
  const AiLoadingWidget({super.key});

  @override
  State<AiLoadingWidget> createState() => _AiLoadingWidgetState();
}

class _AiLoadingWidgetState extends State<AiLoadingWidget>
    with SingleTickerProviderStateMixin {
  /// The ring fills to 99% across the review window (it never claims 100% while
  /// still processing).
  double percent = 0.99;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 7),
    );

    // No `addListener(setState)`: that rebuilt the whole widget every frame for
    // seven minutes. The AnimatedBuilder in `build` scopes each frame's rebuild
    // to just the ring and the percentage text.
    _animation = Tween<double>(begin: 0, end: percent).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.w,
      width: 250.w,
      margin: EdgeInsets.symmetric(vertical: 25.w),
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        color: offWhiteClr.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: offWhiteClr.withOpacity(0.2), width: 5.w),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        // The notification line never changes, so it is built once and handed in
        // as `child` rather than rebuilt on every animation tick.
        child: CenterTextUtils(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: ' سوف يتم ارسال اشعار لك عند الانتهاء من تقيم الفيديو',
        ),
        builder: (context, child) => CustomPaint(
          painter: GradientCirclePainter(
            percent: _animation.value,
            strokeWidth: 15.w,
          ),
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Container(
              decoration: BoxDecoration(
                color: offWhiteClr.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: offWhiteClr.withOpacity(0.2),
                  width: 5.w,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CenterTextUtils(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      text: '${(_animation.value * 100).toInt()}%',
                    ),
                    child!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientCirclePainter extends CustomPainter {
  final double percent; // 0.0 to 1.0
  final double strokeWidth;

  GradientCirclePainter({required this.percent, this.strokeWidth = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base gradient
    final gradient1 = const LinearGradient(
      begin: Alignment.topLeft,
      colors: [
        Color(0xFF0CE2C6),
        Color(0xFF94E20C),
        Color(0xFFE2BF0C),
        Color(0xFFF7247F),
      ],
      stops: [0.2251, 0.3384, 0.6601, 0.9223],
    );

    // Overlay gradient
    final gradient2 = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color.fromARGB(0, 13, 227, 198), Color(0xFF0DE3C6)],
      stops: [0.4959, 0.5949],
    );

    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient1.createShader(rect);

    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient2.createShader(rect);

    final startAngle = -90 * math.pi / 180;
    final sweepAngle = 2 * math.pi * percent;

    // Draw base gradient
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint1,
    );

    // Draw overlay gradient
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
