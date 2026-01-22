import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerRadarChart extends StatelessWidget {
  final Map<String, double> incomingSkills; // المهارات القادمة من الباك إند
  final bool isSubscribed;

  const PlayerRadarChart({
    super.key,
    required this.incomingSkills,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    // ترتيب المهارات في الرادار (5 مهارات)
    List<Map<String, dynamic>> radarSkills = [
      {'name': 'السرعة', 'value': 0.0, 'key': 'السرعة'},
      {'name': 'المرونة', 'value': 0.0, 'key': 'المرونة'},
      {'name': 'القوة', 'value': 0.0, 'key': 'القوة'}, // الباك إند يرسل "المرونة"
      {'name': 'المراوغة', 'value': 0.0, 'key': 'المراوغة '}, // الباك إند يرسل "التحكم بالكرة"
      {'name': 'التحكم بالكرة', 'value': 0.0, 'key': 'التحكم بالكرة'},
    ];

    // تعبئة القيم من المهارات القادمة
    for (var radarSkill in radarSkills) {
      String backendKey = radarSkill['key'];

      // البحث عن القيمة في incomingSkills
      if (incomingSkills.containsKey(backendKey)) {
        double value = incomingSkills[backendKey]!;
        // تحويل القيمة إلى مقياس 0-10
        radarSkill['value'] = _normalizeValue(value);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 1,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          tickBorderData: const BorderSide(color: Colors.white24),
          radarBorderData: const BorderSide(color: Colors.white, width: 2),
          gridBorderData: const BorderSide(color: Colors.white24),

          dataSets: [
            RadarDataSet(
              fillColor: Colors.white.withOpacity(0.15),
              borderColor: Colors.white,
              borderWidth: 2,
              entryRadius: 4,
              dataEntries: radarSkills
                  .map((skill) => RadarEntry(value: skill['value']))
                  .toList(),
            ),
          ],

          titleTextStyle: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
          getTitle: (index, angle) {
            if (index >= radarSkills.length) {
              return const RadarChartTitle(text: "");
            }

            var skill = radarSkills[index];
            String skillName = skill['name'];
            double value = skill['value'];
            String backendKey = skill['key'];

            // التحقق إذا كانت المهارة موجودة في البيانات القادمة
            bool skillExists = incomingSkills.containsKey(backendKey);

            // إذا كان المستخدم غير مشترك والمهارة غير موجودة → قفل
            // إذا كانت المهارة موجودة → عرض القيمة حتى لو 0
            if (!isSubscribed && !skillExists) {
              return RadarChartTitle(text: "$skillName\n🔒", angle: 0);
            } else {
              return RadarChartTitle(
                text: "$skillName\n${value.toStringAsFixed(1)}",
                angle: 0,
              );
            }
          },
        ),
      ),
    );
  }

  // تحويل القيمة إلى مقياس 0-10
  double _normalizeValue(double value) {
    if (value >= 0 && value <= 1) {
      value = value * 10;
    }
    if (value > 10) return 10.0;
    if (value < 0) return 0.0;
    return value;
  }
}