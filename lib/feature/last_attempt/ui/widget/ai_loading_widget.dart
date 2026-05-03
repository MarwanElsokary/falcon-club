import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiLoadingWidget extends StatefulWidget {
  const AiLoadingWidget({super.key});

  @override
  State<AiLoadingWidget> createState() => _AiLoadingWidgetState();
}

class _AiLoadingWidgetState extends State<AiLoadingWidget>
    with SingleTickerProviderStateMixin {
  double percent = 0.99; // 70%
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 7),
    );

    _animation =
        Tween<double>(begin: 0, end: percent).animate(
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
      child: CustomPaint(
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

                  CenterTextUtils(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text:
                        ' سوف يتم ارسال اشعار لك عند الانتهاء من تقيم الفيديو',
                  ),
                ],
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
      colors: const [
        Color(0xFF0CE2C6),
        Color(0xFF94E20C),
        Color(0xFFE2BF0C),
        Color(0xFFF7247F),
      ],
      stops: const [0.2251, 0.3384, 0.6601, 0.9223],
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

    final startAngle = -90 * 3.14159 / 180;
    final sweepAngle = 2 * 3.14159 * percent;

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
