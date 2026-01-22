import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../training_details/data/model/exercise_details_model.dart';

class SimpleRadarChart extends StatelessWidget {
  final List<Skill> skills;

  const SimpleRadarChart({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return Center(
        child: Text(
          'لا توجد بيانات',
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      );
    }

    // ترتيب المهارات بالترتيب المطلوب للرادار
    List<Skill> orderedSkills = [];

    // السرعة (الأعلى)
    orderedSkills.add(skills.firstWhere(
          (s) => s.skillName == 'السرعة',
      orElse: () => Skill(skillName: 'السرعة', score: 0.0),
    ));

    // القوة (اليمين)
    orderedSkills.add(skills.firstWhere(
          (s) => s.skillName == 'القوة',
      orElse: () => Skill(skillName: 'القوة', score: 0.0),
    ));

    // المراوغة (الأسفل يمين)
    orderedSkills.add(skills.firstWhere(
          (s) => s.skillName == 'المرونة' || s.skillName == 'المرونة',
      orElse: () => Skill(skillName: 'المرونة', score: 0.0),
    ));

    // الالتحام (الأسفل يسار) - غير موجود، نضيفه
    orderedSkills.add(skills.firstWhere(
          (s) => s.skillName == 'المراوغة' || s.skillName == 'المراوغة',
      orElse: () => Skill(skillName: 'المراوغة', score: 0.0),
    ));
    // التحكم (اليسار)
    orderedSkills.add(skills.firstWhere(
          (s) => s.skillName == 'التحكم بالكرة',
      orElse: () => Skill(skillName: 'التحكم بالكرة', score: 0.0),
    ));

    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        tickCount: 6,
        ticksTextStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 9.sp,
        ),
        tickBorderData: const BorderSide(color: Colors.white30, width: 0.5),
        radarBorderData: const BorderSide(color: Colors.white, width: 1.5),
        gridBorderData: const BorderSide(color: Colors.white30, width: 0.5),

        dataSets: [
          RadarDataSet(
            fillColor: Colors.white.withOpacity(0.15),
            borderColor: Colors.white,
            borderWidth: 2,
            entryRadius: 4,
            dataEntries: orderedSkills.map((skill) => RadarEntry(value: skill.score)).toList(),
          ),
        ],

        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        getTitle: (index, angle) {
          if (index >= orderedSkills.length) return const RadarChartTitle(text: "");

          var skill = orderedSkills[index];
          String displayName = skill.skillName;

          // تحويل الأسماء للعرض
          if (displayName == 'التحكم بالكرة') displayName = 'التحكم';

          return RadarChartTitle(
            text: "$displayName\n${skill.score.toStringAsFixed(1)}",
            angle: angle,
          );
        },
      ),
    );
  }
}