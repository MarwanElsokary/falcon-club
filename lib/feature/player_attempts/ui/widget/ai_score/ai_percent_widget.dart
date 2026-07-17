import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class AiPercentWidget extends StatefulWidget {
  const AiPercentWidget({
    super.key,
    required this.percent,
    required this.skill,
  });

  /// تأخذ قيمة من 0 → 10
  final double percent;
  final String skill;

  @override
  State<AiPercentWidget> createState() => _AiPercentWidgetState();
}

class _AiPercentWidgetState extends State<AiPercentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    /// نحول القيمة من (0 → 10) إلى (0 → 1)
    final normalizedPercent = (widget.percent / 10).clamp(0.0, 1.0);

    _animation =
        Tween<double>(begin: 0, end: normalizedPercent).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {});
        });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth / 1,
      child: Column(
        children: [
          Container(
            height: context.displayWidth / 1.4,
            width: context.displayWidth / 1.4,
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: offWhiteClr.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: offWhiteClr.withOpacity(0.2),
                width: 5.w,
              ),
            ),
            child: CustomPaint(
              painter: GradientCirclePainter(
                percent: _animation.value, // النسبة بين 0 → 1
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
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: (widget.percent) < 2.5
                              ? Color(0xFFF7247F)
                              : (widget.percent) < 5
                              ? Color(0xFF94E20C)
                              : (widget.percent) < 7
                              ? Color(0xFF0CE2C6)
                              : Color(0xFF0CE2C6),

                          text: (widget.percent) < 2.5
                              ? 'شد حيلك'
                              : (widget.percent) < 5
                              ? 'آداء متوسط'
                              : (widget.percent) < 7
                              ? 'آداء جيد'
                              : 'آداء ممتاز',
                        ),
                        CenterTextUtils(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text:
                              '${(_animation.value * 10).toStringAsFixed(1)} / 10',
                        ),
                        CenterTextUtils(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: widget.skill,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientCirclePainter extends CustomPainter {
  final double percent; // نسبة 0.0 إلى 1.0
  final double strokeWidth;

  GradientCirclePainter({required this.percent, this.strokeWidth = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

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

    // Base gradient circle
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint1,
    );

    // Overlay gradient circle
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint2,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
