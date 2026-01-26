import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadarChart extends StatelessWidget {
  final Map<String, double> incomingSkills;
  final bool isSubscribed;

  const CustomRadarChart({
    super.key,
    required this.incomingSkills,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> radarSkills = [
      {'name': 'السرعة', 'value': 0.0, 'key': 'السرعة'},
      {'name': 'المرونة', 'value': 0.0, 'key': 'المرونة'},
      {'name': 'القوة', 'value': 0.0, 'key': 'القوة'},
      {'name': 'المراوغة', 'value': 0.0, 'key': 'المراوغة'},
      {'name': 'التحكم بالكرة', 'value': 0.0, 'key': 'التحكم بالكرة'},
    ];

    for (var radarSkill in radarSkills) {
      String backendKey = radarSkill['key'];
      if (incomingSkills.containsKey(backendKey)) {
        double value = incomingSkills[backendKey]!;
        radarSkill['value'] = value.clamp(0.0, 10.0);
      }
    }

    return SizedBox(
      width: 280.w,
      height: 280.w,
      child: CustomPaint(
        painter: RadarChartPainter(
          skills: radarSkills,
          isSubscribed: isSubscribed,
          incomingSkills: incomingSkills,
        ),
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> skills;
  final bool isSubscribed;
  final Map<String, double> incomingSkills;

  RadarChartPainter({
    required this.skills,
    required this.isSubscribed,
    required this.incomingSkills,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8; // 80% من نصف القطر

    // رسم خطوط الشبكة
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // رسم 5 دوائر متحدة المركز (0, 2.5, 5, 7.5, 10)
    for (int i = 1; i <= 5; i++) {
      double circleRadius = radius * (i / 5);
      canvas.drawCircle(center, circleRadius, gridPaint);
    }

    // رسم محاور الخمسة
    final axisPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.rtl,
    );

    for (int i = 0; i < skills.length; i++) {
      double angle = 2 * 3.14159265359 * i / skills.length;
      Offset endPoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      // رسم المحور
      canvas.drawLine(center, endPoint, axisPaint);

      // وضع نص المهارة
      var skill = skills[i];
      String skillName = skill['name'];
      double value = skill['value'];
      String backendKey = skill['key'];
      bool skillExists = incomingSkills.containsKey(backendKey);

      String displayText;
      if (!isSubscribed && !skillExists) {
        displayText = "$skillName\n🔒";
      } else {
        displayText = "$skillName\n${value.toStringAsFixed(1)}";
      }

      // حساب موقع النص
      double textAngle = angle;
      Offset textOffset = Offset(
        center.dx + (radius + 20) * cos(textAngle),
        center.dy + (radius + 20) * sin(textAngle),
      );

      textPainter.text = TextSpan(
        text: displayText,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      );
      textPainter.layout();

      // حساب مركز النص
      final textCenter = Offset(
        textOffset.dx - textPainter.width / 2,
        textOffset.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textCenter);
    }

    // رسم شكل الرادار (المضلع)
    final radarPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final radarBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    for (int i = 0; i < skills.length; i++) {
      double angle = 2 * 3.14159265359 * i / skills.length;
      var skill = skills[i];
      double value = skill['value'];

      // تحويل القيمة من 0-10 إلى نصف قطر
      double pointRadius = radius * (value / 10);

      Offset point = Offset(
        center.dx + pointRadius * cos(angle),
        center.dy + pointRadius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(path, radarPaint);
    canvas.drawPath(path, radarBorderPaint);

    // رسم النقاط
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < skills.length; i++) {
      double angle = 2 * 3.14159265359 * i / skills.length;
      var skill = skills[i];
      double value = skill['value'];

      double pointRadius = radius * (value / 10);

      Offset point = Offset(
        center.dx + pointRadius * cos(angle),
        center.dy + pointRadius * sin(angle),
      );

      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}